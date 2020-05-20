<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Library\IDCardApi;
use Dhc\Library\Sms;
use Dhc\Library\EmgApi;
use Dhc\Models\Config;
use Dhc\Models\TelMessage;
use Dhc\Models\User;
use Dhc\Models\UserLog;
use Dhc\Models\OrchardUser;

use Phalcon\Http\Response;

class AuthController extends ControllerBase{
	public function loginAction() {
		if ($this->request->isPost()) {
			$orchardStatus = $this->getConfig("status");
			if($orchardStatus ==0){
				$this->ajaxResponse('', '游戏升级维护中，请耐心等待！', '1');
			}
			$user = $this->request->getPost("username");
			if (USER_TYPE != 'nong' && USER_TYPE != "EMG"){
				if (strlen($user) != 11) {
					$this->ajaxResponse('', '请输入十一位手机号', '1');
				}
			}
			$pass = $this->request->getPost('password');
			$userlogin = new User();
			if(USER_TYPE == "EMG"){
				$EMG = $this->getConfig("EMG");
				if(!empty($EMG["appkey"]) && !empty($EMG["appSecret"]) && !empty($EMG["httpUrl"])){
					$result = $userlogin->findFirst("userCode = '{$user}' ORDER BY id desc");
					if($result){
						$user = $result->user;
					}
				}
			}
			$result1 = $userlogin->findFirst("user = '{$user}' ORDER BY id desc");
			if (!$result1) {
				$this->ajaxResponse('', $user . '用户不存在，请与管理员联系', '1');
			}
			if($result1->status ==0){
				$this->ajaxResponse('', $user . '该账号已被禁用，请与管理员联系', '1');
			}
			$salt = $result1->salt;
			$password = sha1($salt . $pass);
			if ($password !== $result1->password) {
				$this->ajaxResponse('', '密码错误', '1');
			}

			if ($result1) {
				$uid =$result1->id;
				$user = new User();
				$salt = $user->findFirst("id = $uid");
				$token = $this->createToken($uid,TIMESTAMP);
				$data["userInfo"] = array(
					'uid'=>$uid,
					'token'=>base64_encode($token.'_'.$uid)
				);
				$salt->token = $token;
				$relation = $salt->superior;
				$salt->update();
				if($this->request->getPost('isUsername') || $this->request->getPost('isPassword')){
					$cookie = array(
						"isUsername"=>$this->request->getPost('isUsername'),
						"isPassword"=>$this->request->getPost('isPassword'),
					);
					if($this->request->getPost('isUsername')){
						$cookie["username"] = $this->request->getPost('username');
					}
					if($this->request->getPost('isPassword')){
						$cookie["password"] = $this->request->getPost('password');
					}
					$loginInfo = base64_encode(json_encode($cookie));
					$this->session->set('loginInfo', $loginInfo);
				}else{
					$this->session->set('loginInfo', "");
				}
				$userInfo = new OrchardUser();
				$userInfo = $userInfo->findFirst("uid='{$uid}'");
				if(!empty($userInfo)){
					$data["needCreate"] = "0";
					$data["frist"] = 0;
					if($userInfo->status !=1){
						$this->ajaxResponse("", '登录失败,请联系游戏管理员核实该账号！', '0');
					}
				}else{
					$data["needCreate"] = "1";
					$data["frist"] = 1;
				}
				$data["indemnify"] = 0;//是否有补偿
				$data["need_sign"] = 0;//是否需要签到
				$data["gift_package"] = 0;//是否有礼物包可领取
				$data["new_package"] = 0;//是否有新手礼包可领取
//				if($relation != 0 && $relation != "" && !empty($relation)){
//					$package = $this->getConfig("package");
//					$this->saveUserPackage(array("uid"=>$uid,"types"=>"reg","info"=>json_encode($package)));
//				}
				$gift_package = $this->saveUserPackage(array("uid"=>$uid,"types"=>"reg"));
				if(!empty($gift_package) && $gift_package["status"] ==0){
					$data["gift_package"] = 1;
				}
				$indemnify = $this->getConfig("indemnify");
				if(($indemnify["status"] ==1)){
					//补偿大礼包 添加
					$flag = $this->saveUserPackage(array("uid"=>$uid,"types"=>"give","info"=>  json_encode($indemnify)));
					//补偿大礼包 获取
					$flag = $this->saveUserPackage(array("uid"=>$uid,"types"=>"give"));
					if($flag == false || $flag["status"] == 0){
						$data["indemnify"] = 1;
					}
				}
				//是否需要签到
				$signOk = $this->checkSignInfo($uid);
				if($signOk){
					$data["need_sign"] = 1;
				}
				//新手礼包
				$newGiftPack = $this->getConfig("newGiftPack");
				if(!empty($newGiftPack) && $newGiftPack["starttime"]>0 && $salt != false){
					if($newGiftPack["status"] ==1 && $newGiftPack["starttime"]<$salt->createTime){
						$this->saveUserPackage(array("uid"=>$uid,"types"=>"newGiftPack","info"=>json_encode($newGiftPack)));
					}
					$new_package = $this->saveUserPackage(array("uid"=>$uid,"types"=>"newGiftPack"));
					if(!empty($new_package) && $new_package["status"] ==0){
						$data["new_package"] = 1;
					}
				}
				if(USER_TYPE == "jindao"){
					$this->olineUser($uid);
				}
				$this->ajaxResponse($data, '登录成功', '0');
			}
		}
	}
	public function logInfoAction(){
        $username = $this->request->getPost("username");
        $user = new User();
        $userInfo = $user->findFirst("user = '$username' ORDER BY id desc");
        if(!$userInfo){
            $this->ajaxResponse(array("exist"=>0), $username . '用户不存在，请与管理员联系', '1');
        }
        else {
            $userInfo->authEndTime = TIMESTAMP + 120;
            $flag=$userInfo->update();
            if(!$flag){
                $this->ajaxResponse(array("exist"=>1), "记录登录状态失败！",1);
            }
            $this->ajaxResponse("", '操作成功', '0');
        }
    }
	public function loginPluginAction(){
        $orchardStatus = $this->getConfig("status");
        if($orchardStatus ==0){
            $this->ajaxResponse('', '游戏升级维护中，请耐心等待！', '1');
        }
        $user = $this->request->getPost("username");
        //$user=dechex($user)*10/5;
        $user=hexdec($user)*5/10;
        //$this->ajaxResponse('', $user , '1');
        $userlogin = new User();
        $result1 = $userlogin->findFirst("user = '{$user}' ORDER BY id desc");
        if (!$result1) {
            $this->ajaxResponse('', $user . '用户不存在，请与管理员联系', '1');
        }
        if($result1->status ==0){
            $this->ajaxResponse('', $user . '该账号已被禁用，请与管理员联系', '1');
        }
        if($result1->authEndTime<TIMESTAMP){
            $this->ajaxResponse('', $user . '登录已失效，请重试', '1');
        }
        if ($result1) {
            $uid =$result1->id;
            $user = new User();
            $salt = $user->findFirst("id = $uid");
            $token = $this->createToken($uid,TIMESTAMP);
            $data["userInfo"] = array(
                'uid'=>$uid,
                'token'=>base64_encode($token.'_'.$uid)
            );
            $salt->token = $token;
            $relation = $salt->superior;
            $salt->update();
            if($this->request->getPost('isUsername') || $this->request->getPost('isPassword')){
                $cookie = array(
                    "isUsername"=>$this->request->getPost('isUsername'),
                    "isPassword"=>$this->request->getPost('isPassword'),
                );
                if($this->request->getPost('isUsername')){
                    $cookie["username"] = $this->request->getPost('username');
                }
                if($this->request->getPost('isPassword')){
                    $cookie["password"] = $this->request->getPost('password');
                }
                $loginInfo = base64_encode(json_encode($cookie));
                $this->session->set('loginInfo', $loginInfo);
            }else{
                $this->session->set('loginInfo', "");
            }
            $userInfo = new OrchardUser();
            $userInfo = $userInfo->findFirst("uid='{$uid}'");
            if(!empty($userInfo)){
                $data["needCreate"] = "0";
                $data["frist"] = 0;
                if($userInfo->status !=1){
                    $this->ajaxResponse("", '登录失败,请联系游戏管理员核实该账号！', '0');
                }
            }else{
                $data["needCreate"] = "1";
                $data["frist"] = 1;
            }
            $data["indemnify"] = 0;//是否有补偿
            $data["need_sign"] = 0;//是否需要签到
            $data["gift_package"] = 0;//是否有礼物包可领取
            $data["new_package"] = 0;//是否有新手礼包可领取
            $gift_package = $this->saveUserPackage(array("uid"=>$uid,"types"=>"reg"));
            if(!empty($gift_package) && $gift_package["status"] ==0){
                $data["gift_package"] = 1;
            }
            $indemnify = $this->getConfig("indemnify");
            if(($indemnify["status"] ==1)){
                //补偿大礼包 添加
                $flag = $this->saveUserPackage(array("uid"=>$uid,"types"=>"give","info"=>  json_encode($indemnify)));
                //补偿大礼包 获取
                $flag = $this->saveUserPackage(array("uid"=>$uid,"types"=>"give"));
                if($flag == false || $flag["status"] == 0){
                    $data["indemnify"] = 1;
                }
            }
            //是否需要签到
            $signOk = $this->checkSignInfo($uid);
            if($signOk){
                $data["need_sign"] = 1;
            }
            //新手礼包
            $newGiftPack = $this->getConfig("newGiftPack");
            if(!empty($newGiftPack) && $newGiftPack["starttime"]>0 && $salt != false){
                if($newGiftPack["status"] ==1 && $newGiftPack["starttime"]<$salt->createTime){
                    $this->saveUserPackage(array("uid"=>$uid,"types"=>"newGiftPack","info"=>json_encode($newGiftPack)));
                }
                $new_package = $this->saveUserPackage(array("uid"=>$uid,"types"=>"newGiftPack"));
                if(!empty($new_package) && $new_package["status"] ==0){
                    $data["new_package"] = 1;
                }
            }
            if(USER_TYPE == "jindao"){
                $this->olineUser($uid);
            }
            $this->ajaxResponse($data, '登录成功', '0');
        }
    }
    public function regPluginAction(){
        if ($this->request->isPost()) {
            $user = new User();
            $username= $this->request->getPost("username");
            $password =  $this->request->getPost("password");
            $salt = $this->create_salt(6);
            $userpassword = sha1($salt . $password);
            $user->user = $username;
            $user->salt = $salt;
            $user->password = $userpassword;
            $user->createTime = TIMESTAMP;
            $user->lasttime = TIMESTAMP;
            $user->token = TIMESTAMP;
            $this->db->begin();
            $result = $user->save();
            if (!$result) {
                $this->db->rollback();
                $this->ajaxResponse("", '注册失败', '1');
            } else {
                $this->db->commit();
                $this->ajaxResponse("", '注册成功', '0');
            }
        }
    }
	public function registerAction(){
		if ($this->request->isPost()) {
			$username= $this->request->getPost("username");
			if (USER_TYPE != 'nong'){
				if (strlen($username) != 11) {
					$this->ajaxResponse('', '请输入十一位手机号', '1');
				}
				//真实姓名
				$realname = $this->request->getPost("realname");
				if(empty($realname)){
					$this->ajaxResponse('', '真实姓名不可为空', '1');
				}
			}else{
				$usernameResult = $this->checkUserName($username);
				if ($usernameResult == false){
					$this->ajaxResponse('error','注册失败，请输入正确的帐号进行注册,用户帐号不可包含汉字');
				}
			}
			//用户信息读取
			$user = new User();
			$result1 = $user->findFirst("user = '$username' ORDER BY id desc");
			if ($result1) {
				$this->ajaxResponse('', $username . '该用户已存在!无法注册', '1');
			}
			//身份证号
			$idcard = $this->request->getPost("idCard");
			if(empty($idcard) && USER_TYPE !='hnf'){
				$this->ajaxResponse('', '请输入正确的身份证号码', '1');
			}

			// @zl 添加身份证实名认证
			$idCardApi = new IDCardApi($realname, $idcard);
			if (!$idCardApi->check()) {
				//$this->ajaxResponse('', '姓名和身份证不匹配，请重新填写！', '1');
			}

			//两次密码
			$password =  $this->request->getPost("password");
			$repassword =  $this->request->getPost("rePassword");
			if(empty($password) || empty($repassword)){
				$this->ajaxResponse("", "密码不可为空!",1);
			}
			if($password != $repassword){
				$this->ajaxResponse("", "两次密码输入不一致!",1);
			}
			//图片验证码
			$code = $this->request->getPost('verifyCode');
			if(!empty($code)){
				$check = new UtilController();
				$result =  $check->checkVerify($code);
				if ($result == false){
					$this->ajaxResponse('','验证码错误','1');
				}
			}else{
				$this->ajaxResponse('','验证码不可为空','1');
			}
			//短信
			$telMessage = new TelMessage();
			$salt = $this->create_salt(6);
			if($this->request->getPost('type') == "verifycode"){
				$mess = $telMessage->findFirst("mobile='{$username}' ORDER BY id desc");
				if(!empty($mess)){
					if(TIMESTAMP - $mess->sendTime < 60){
						$this->ajaxResponse(TIMESTAMP-$mess->sendTime,'两次短信需要间隔60秒，请耐心等待',1);
					}
				}
				if (USER_TYPE == 'duojin'){
					$config = $this->getOpenMessage();
					if ($config == false){
						$this->ajaxResponse('error','短信发送失败，请联系管理员','1');
					}
				}else{
					$configs = Config::findFirst("key= 'message'");
					if (empty($configs)){
						$this->ajaxResponse('error','短信发送失败，请联系管理员','1');
					}
					$config = unserialize($configs->value);
				}
				if ($config['type'] == 'message'){
					$message = new MessageController();
					if (USER_TYPE == 'huangjin'){
						$content  ="尊敬的黄金农场用户您好，您的验证码是".$salt."，请不要向他人泄露验证码，如有问题请致电400-968-5668";
					}else{
						$content = "尊敬的用户：您的验证码为：".$salt."。如非本人操作，请勿泄露与他人。";
					}
					$re = $message->sendAction($username, $content);
				}elseif ($config['type'] == 'jh'){
					$re = Sms::send($username,['code'=>$salt],$config);
				}
				if($re == false){
					$this->ajaxResponse('','短信发送失败请重试！','1');
				}else{
					if ($config['type'] == 'message'){
						$telMessage->mobile = $username;
						$telMessage->sendTime = TIMESTAMP;
						$telMessage->code = $salt;
						$telMessage->info = $content;
						$telMessage->status =1;
						$telMessage->save();
					}elseif ($config['type'] == 'jh'){
						$telMessage->mobile = $username;
						$telMessage->sendTime = TIMESTAMP;
						$telMessage->code = $salt;
						$telMessage->info = 'jh短信发送'.$salt;
						$telMessage->status =1;
						$telMessage->save();
					}
					$this->ajaxResponse('60','短信已发送，请输入后提交！',0);
				}
				exit;
			}
			//验证码验证
			if (USER_TYPE != 'nong'){
				$tmessage = $telMessage->findFirst("mobile = '$username' and code = '{$this->request->getPost('smsCode')}'");
				if (!$tmessage) {
					$this->ajaxResponse('', '手机验证码填写错误', '1');
				}
			}
			$spread = $this->request->getPost("spread");
			if($spread>0){
				$spreadUser = $user->findFirst("id = '$spread' or user='$spread'");
				if(empty($spreadUser)){
					$this->ajaxResponse("", "推荐人信息不存在或已被禁用!",1);
				}
                $spread=$spreadUser->id;
				$user->superior = $spread."-".$spreadUser->superior;
			}
			$userpassword = sha1($salt . $password);
            $user->user = $username;
			if (USER_TYPE != 'nong'){
				$user->nickname = $user->realname  = $realname;
			}
			$user->idcard = $idcard;
			$user->salt = $salt;
			$user->password = $userpassword;
			$user->createTime = TIMESTAMP;
			$user->lasttime = TIMESTAMP;
			$user->token = TIMESTAMP;
			$this->db->begin();
			$result = $user->save();
			if (!$result) {
				$this->db->rollback();
				$this->ajaxResponse("", '注册失败', '1');
			}else{
//				$user = new User();
//				$result = $user->findFirst("user = '$username' and status = 1 ORDER BY id desc");
//				$uid = $result->id;
				$package = $this->getConfig("package");
                if($package["status"] ==1 && $spread>0){
				//if(($package["status"] ==1 && $spread>0) || ($package["status"] ==0 && empty($spread))){
					//注册赠送大礼包
					$this->saveUserPackage(array("uid"=>$spread,"types"=>"reg","info"=>  json_encode($package)));
				}
				$this->db->commit();
				$this->ajaxResponse("", '注册成功', '0');
			}
		}
	}
	public function editAction(){
        if ($this->request->isPost()) {
            $username=$this->request->getPost("username");
            $userid=$this->request->getPost("uid");
            if (strlen($username) != 11) {
                $this->ajaxResponse('', '手机号码不正确', '1');
            }
            if($userid<1){
                $this->ajaxResponse('', '玩家ID不存在，请重新登录', '1');
            }
            $this->userid=$userid;
            $user = new User();
            $userInfo = $user->findFirst("user = '$username' and id = '$userid' and status = 1 ORDER BY id desc");
            if (!$userInfo){
                $this->ajaxResponse('', $username . '该用户不存在无法修改资料', '1');
            }

            $ouser=new OrchardUser();
            $ouserInfo=$ouser->findFirst("uid='$userid'");
            if(!$ouserInfo){
                $this->ajaxResponse('', $username . '该游戏账号不存在无法修改资料', '1');
            }
            $userpassword=$userInfo->password;
            //两次密码  修改密码时
            $password =  $this->request->getPost("password");
            $repassword =  $this->request->getPost("rePassword");
            if(!empty($password) && !empty($repassword)){
                if($password != $repassword){
                    $this->ajaxResponse("", "两次密码输入不一致!",1);
                }
                $userpassword = sha1($userInfo->salt. $password);
            }
            //游戏昵称
            $nickname = $this->request->getPost("nickname");
            if(empty($nickname)){
                $this->ajaxResponse('', '游戏昵称不可为空', '1');
            }
            //图片验证码
            $code = $this->request->getPost('verifyCode');
            if(!empty($code)){
                $check = new UtilController();
                $result =  $check->checkVerify($code);
                if ($result == false){
                    $this->ajaxResponse('','验证码错误','1');
                }
            }else{
                $this->ajaxResponse('','验证码不可为空','1');
            }
            $userInfo->password = $userpassword;
            $ouserInfo->nickname=$nickname;
            $this->db->begin();
            $flag=$userInfo->update();
            $flag1=$ouserInfo->update();
            if($flag==false||$flag1==false){
                $this->db->rollback();
                $this->ajaxResponse('', "修改资料失败,请重试！",1);
            }
            $this->db->commit();
            $userInfo = $this->selectUser($userid, "index");
            if(!empty($userInfo)){
                $data["user"] = $userInfo;
            }
            $this->ajaxResponse($data, '资料修改成功！,重新登录后生效', '0');
        }
    }
	//忘记密码修改
	public function forgetAction(){
		if ($this->request->isPost()) {
			$username = $this->request->getPost("username");
			if (strlen($username) != 11) {
				$this->ajaxResponse('', '请输入十一位手机号', '1');
			}
			//用户信息读取
			$user = new User();
			$userInfo = $user->findFirst("user = '$username' and status = 1 ORDER BY id desc");
			if (!$userInfo){
				$this->ajaxResponse('', $username . '该用户不存在无法找回密码', '1');
			}
			//图片验证码
			$code = $this->request->getPost('verifyCode');
			if(!empty($code)){
				$check = new UtilController();
				$result =  $check->checkVerify($code);
				if ($result == false){
					$this->ajaxResponse('','验证码错误','1');
				}
			}else{
				$this->ajaxResponse('','验证码不可为空','1');
			}
			//短信
			$telMessage = new TelMessage();
			$salt = $this->create_salt(6);
			if($this->request->getPost('type') == "verifycode"){
				$mess = $telMessage->findFirst("mobile='{$username}' ORDER BY id desc");
				if(!empty($mess)){
					if(TIMESTAMP - $mess->sendTime < 60){
						$this->ajaxResponse(TIMESTAMP-$mess->sendTime,'两次短信需要间隔60秒，请耐心等待',1);
					}
				}
				if (USER_TYPE == 'duojin'){
					$config = $this->getOpenMessage();
					if ($config == false){
						$this->ajaxResponse('error','短信发送失败，请联系管理员','1');
					}
				}else{
					$configs = Config::findFirst("key= 'message'");
					if (empty($configs)){
						$this->ajaxResponse('error','短信发送失败，请联系管理员','1');
					}
					$config = unserialize($configs->value);
				}
				if ($config['type'] == 'message'){
					$message = new MessageController();
					if (USER_TYPE == 'huangjin'){
						$content  ="尊敬的黄金农场用户您好，您的验证码是".$salt."，请不要向他人泄露验证码，如有问题请致电400-968-5668";
					}else{
						$content = "尊敬的用户：您的验证码为：".$salt."。如非本人操作，请勿泄露与他人。";
					}
					$re = $message->sendAction($username, $content);
				}elseif ($config['type'] == 'jh'){
					$re = Sms::send($username,['code'=>$salt],$config);
				}

				// TODO 测试结束后修改

				if($re == false){
					$this->ajaxResponse('','短信发送失败请重试！','1');
				}else{
					if ($config['type'] == 'message'){
						$telMessage->mobile = $username;
						$telMessage->sendTime = TIMESTAMP;
						$telMessage->code = $salt;
						$telMessage->info = $content;
						$telMessage->status =1;
						$telMessage->save();
					}elseif ($config['type'] == 'jh'){
						$telMessage->mobile = $username;
						$telMessage->sendTime = TIMESTAMP;
						$telMessage->code = $salt;
						$telMessage->info = 'jh短信发送'.$salt;
						$telMessage->status =1;
						$telMessage->save();
					}
					$this->ajaxResponse('60','短信发送已发送，请输入后提交！',0);
				}
				exit;
			}
			//验证码验证
			$tmessage = $telMessage->findFirst("mobile = '$username' and code = '{$this->request->getPost('smsCode')}'");
			if (!$tmessage) {
				$this->ajaxResponse('', '手机验证码填写错误', '1');
			}
			$password = $this->request->getPost("password");
			$repassword = $this->request->getPost("rePassword");
			if(empty($password) || empty($password)){
				$this->ajaxResponse('', '登录密码不可能空', '1');
			}
			if($password != $repassword){
				$this->ajaxResponse('', '两次面输入不一致', '1');
			}
			$userInfo->password = sha1($userInfo->salt.$password);
			$re = $userInfo->update();
			if($re == false){
				$this->ajaxResponse('', '密码修改失败，请重试', '1');
			}else{
				$this->ajaxResponse('', '密码修改成功', '0');
			}
		}
	}
	//获取登陆记住信息
	public function getLoginInfoAction(){
		if(empty($this->session->get('loginInfo'))){
			$this->ajaxResponse("", "无记住信息!",1);
		}
		$loginInfo = json_decode(base64_decode($this->session->get('loginInfo')),true);
		$this->ajaxResponse($loginInfo, "记住信息返回成功，页面请赋值显示!",0);
	}


	//获取启用的短信接口
	public function getOpenMessage(){
		$config = Config::find("key = 'jh' OR key = 'message'");
		if (empty($config)){
			return false;
		}
		foreach ($config as $key=>$value){
			$data[] = unserialize($value->value);
		}
		foreach ($data as $k=>$v){
			if ($v['status'] == 1){
				$info = $data[$k];
				return $info;
			}
		}
		return false;
	}
	public function checkUserName($str){
		if (preg_match("/([\x81-\xfe][\x40-\xfe])/", $str, $match)) {
			return false;
		} else {
			return true;
		}
	}
}
