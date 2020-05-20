<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\OrchardUser;
use Dhc\Models\User;
use Dhc\Models\OrchardHailFellow;

class HomeController extends ControllerBase{
	private $isOtherPlay = false;
	public function initialize() {
		$this->checkToken();
		$this->user = $this->selectUser($this->userid);
		//进入另一个用户
		$ownerId = $this->request->getPost("ownerId");
		if($ownerId>0){
			$this->isOtherPlay = true;
			$this->userid = $ownerId;
		}
	}
	public function IndexAction(){
		if(empty($this->user)){
			$this->ajaxResponse('', "用户尚未创建角色，请创建","9");
		}
//		$data = array();
//		$article = new Article();
//		$article = $article->findFirst("cid=2 AND createTime< ".(TIMESTAMP-3600*12)."ORDER BY id desc");
//		$article = $this->object2array($article);
//		if(!empty($article)){
//			$data["articleInfo"] = array(
//				"title"=>$article["title"],
//				"url"=>"",
//			);
//		}
		$userInfo = $this->selectUser($this->userid, "index");
		if(!empty($userInfo)){
			$data["user"] = $userInfo;
		}
//		//宠物信息
//		$dogInfo = $this->dogListInfo();
//		if(empty($dogInfo)){
//			$data["dog"] = "";
//		}else{
//			$data["dog"] = $dogInfo;
//		}
		//神像信息
		$data["joss"] = $this->selectStatueInfo();
		//开启宝箱信息
//		$data["double"] = $this->selectDouble();

		//土地信息
		$data["farm"] = $this->getLandInfo("", "index");

		if($this->isOtherPlay){
			$data["dog"] = $this->checkDog("default");
		}else{
			//仓库信息
			$tool[0] = $this->getProduct();//种子信息
			$tool[1] = $this->getDui();//材料
			$tool[2] = $this->gemstone();//宝石
			$tool[3] = $this->getprop();//道具
			$tool[4] = $this->getSkin();//皮肤
			$data["tool"] = array_merge($tool[0], $tool[1], $tool[2], $tool[3], $tool[4]);
		}
//		$this->packageInfo();
		//检测房屋是否掉级
		//$this->checkHouseOutOf($userInfo);
		$this->ajaxResponse($data, "登陆成功 欢迎回来！！！", 0);
	}
	//初始会员创建 土地一块 房屋一级 赠送一百种子
	public function createRoleAction(){
		if(!empty($this->user)){
			$this->ajaxResponse('', "用户角色已存在，暂无法创建","1");
		}
		if($this->request->isPost()){
			$this->db->begin();//开启事物
			$orchardUser = new OrchardUser();
			$orchardUser->uid = $this->userid;
			$data = $this->request->getPost();
			if(empty($data["nickname"])){
				$this->db->rollback();
				$this->ajaxResponse('', "请填写用户昵称","1");
			}
			$result1 = User::findFirst("nickname = '{$data['nickname']}'");
			if ($result1) {
				$this->ajaxResponse('', '昵称已存在，请重选选取或自定义', '1');
			}
			$orchardUser->nickname = $data["nickname"];
			if(empty($data["avatarId"])){
				$this->db->rollback();
				$this->ajaxResponse('', "请选择用户头像","1");
			}
			$user = new User();
			$user = $user->findFirst("id='{$this->userid}'");
			if(empty($user->user)){
				$this->db->rollback();
				$this->ajaxResponse('', "用户信息未获取到请重试","1");
			}
			$orchardUser->mobile = $user->user;
			$orchardUser->avatar = max(1,$data["avatarId"]);
			$orchardUser->createtime = $orchardUser->updatetime = TIMESTAMP;
			$orchardUser->status = 1;
			$flag = $orchardUser->save();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse('', "会员创建失败，请重试","1");
			}
			$flag = $this->addLand();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse('', "土地开启失败，请重试","1");
			}
//			$flag = $this->saveProduct($this->seedId, $this->seedNums);
//			if($flag == false){
//				$this->db->rollback();
//				$this->ajaxResponse('', "赠送种子失败!","1");
//			}
//			$flag = $this->saveOrchardLogs(array("mobile"=>$this->mobile,"types"=>"addseed","nums"=>$this->seedNums,"msg"=>"首次进入游戏赠送种子".$this->seedNums."颗"));
			$flag = $this->saveUserBackground();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse('', "初始化背景失败!","1");
			}
            $userModel=new OrchardUser();
            $lists = $userModel->find("uid!='".$this->userid."'");
            $hailarray=array();
            if(count($lists)<10){
                $flag=$this->createHails($lists);
            }
            else{
                while (count($hailarray)<10){
                    $rn=rand(0,count($lists)-1);
                    if(!in_array($rn,$hailarray))
                    {
                        array_push($hailarray,$rn);
                    }
                }
                $hailList=array();
                foreach ($hailarray as $value)
                {
                    array_push($hailList,$lists[$value]);
                }
                $flag=$this->createHails($hailList);
            }
            if($flag==false){
                $this->db->rollback();
                $this->ajaxResponse('', "初始化好友失败!","1");
            }

			$this->db->commit();
			$this->ajaxResponse('', "会员创建成功",0);
		}
		$this->ajaxResponse('', "会员创建中",0);
	}
	//分配好友
    function createHails($list){
	    $res=true;
        foreach ($list as $value){
            $hailFellow = new OrchardHailFellow();
            $hailFellow->uid = $this->userid;
            $hailFellow->huid = $value->uid;
            $hailFellow->mobile = $value->mobile;
            $hailFellow->nickname = $value->nickname;
            $hailFellow->isAdd = 1;
            $hailFellow->status = 1;
            $hailFellow->createtime = $hailFellow->updatetime = TIMESTAMP;
            $flag = $hailFellow->save();
            if($flag==false){
                $res=false;
                break;
            }
            $hailFellow1 = new OrchardHailFellow();
            $itemData = $this->selectUser($this->userid);
            $hailFellow1->uid = $value->uid;
            $hailFellow1->huid = $this->userid;
            $hailFellow1->mobile = $itemData["mobile"];
            $hailFellow1->nickname = $itemData["userName"];
            $hailFellow1->isAdd = 0;
            $hailFellow1->status = 1;
            $hailFellow1->createtime = $hailFellow1->updatetime = TIMESTAMP;
            $flag = $hailFellow1->save();
            if($flag==false){
                $res=false;
                break;
            }
        }
        return $res;
    }
	//礼包点击领取
	function packageInfoAction(){
		$types = $this->request->getPost("types");
		if(!@in_array($types,array("reg","give","newGiftPack"))){
			$this->ajaxResponse('', "礼包不存在",1);
		}
		$dataTitle = array("reg"=>"新用户","give"=>"更新","newGiftPack"=>"新手礼包");
//		$types = "reg";
		$row = $this->saveUserPackage(array("uid"=>$this->userid,"types"=>$types));
		if(empty($row)){
			$this->ajaxResponse('', "礼包不存在",1);
		}
		if($row["status"] != 0){
			$this->ajaxResponse('', "礼包已被领取",1);
		}
		$flag = $this->saveUserPackage(array("types"=>"ok","id"=>$row["id"]));
		if($flag == false){
			$this->ajaxResponse('', "礼包领取失败",1);
		}
		$this->db->begin();
		$info = json_decode($row["info"],true);
		if(empty($info)){
			$this->db->commit();
			$this->ajaxResponse('', "礼包领取成功！",1);
		}
		$onoTitleInfo = $this->onoTitleInfo();
		$str = "恭喜获得";
		foreach ($info as $key => $value) {
			if(@in_array($key,array("info","status","starttime"))){
				continue;
			}
			if($value>0){
				if($key == "seed"){
					$flag = $this->saveProduct($this->seedId, $value);
					if($flag == false){
						$this->db->rollback();
						$this->ajaxResponse('', "赠送{$onoTitleInfo[$key]}失败!","1");
					}
					$flag = $this->saveOrchardLogs(array("mobile"=>$this->mobile,"types"=>"addseed","nums"=>$value,"msg"=>$dataTitle[$types]."礼包获得".$onoTitleInfo[$key]."*".$value));
					if($flag == false){
						$this->db->rollback();
						$this->ajaxResponse('', "赠送{$onoTitleInfo[$key]}失败!","1");
					}
					$str .=$onoTitleInfo[$key].$value."颗";
				}else{
					//用户道具信息更新
					$user = new OrchardUser();
					$user = $user->findFirst("uid='{$this->userid}'");
					$user->$key += $value;
					$user->updatetime =TIMESTAMP;
					$flag = $user->update();
					if($flag == false){
						$this->db->rollback();
						$this->ajaxResponse("", "赠送{$onoTitleInfo[$key]}失败!","1");
					}
					//更新用户狗粮日志
					$flag = $this->saveOrchardLogs(array("mobile"=>$user->mobile,"nums"=>$value,"types"=>"add".$key,"msg"=>$dataTitle[$types]."礼包获得".$onoTitleInfo[$key]."*".$value));
					if($flag == false){
						$this->db->rollback();
						$this->ajaxResponse("", "更新{$onoTitleInfo[$key]}失败日志操作失败，请重试！！",1);
					}
					$str .=$onoTitleInfo[$key].$value."颗";
				}
			}
		}
		if($types == "reg"){
			$user = new User();
			$user = $user->findFirst("id='{$this->userid}'");
			if($user->trade_limit_level < 4){
				$user->trade_limit_level =4;
				$flag = $user->update();
				if($flag == false){
					$this->db->rollback();
					$this->ajaxResponse("", "更新失败，请重试！！",1);
				}
			}
		}
		$this->db->commit();
		$userInfo = $this->selectUser($this->userid, "index");
		$data["userInfo"] = $userInfo;
		$data["info"] = $str;
		$this->ajaxResponse($data["userInfo"], "礼包领取成功!".$str,"0");
	}
}
