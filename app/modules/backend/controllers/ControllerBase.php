<?php

namespace Dhc\Modules\Backend\Controllers;

use Dhc\Models\Admin;
use Dhc\Models\Config;
use Dhc\Models\OperatorLog;
use Dhc\Models\OrchardLogs;
use Dhc\Models\OrchardUser;
use Dhc\Models\TradeLogs;
use Dhc\Models\User;
use Phalcon\Cli\TaskInterface;
use Phalcon\Mvc\Controller;

class ControllerBase extends Controller
{
	public function initialize() {
		$this->view->setVar('apppath', APP_ADMIN_PATH);
		$this->view->setVar('user_type',USER_TYPE);
		$action = $this->dispatcher->getActionName();
		if ($action === 'login') {
			$this->view->pick('index/login');
		} elseif ($action !== 'auth') {
			$this->checkLogin();
		}
		$configinfo = Config::findFirst("key='web'");
		if ($configinfo){
			$data = unserialize($configinfo->value);
			$this->view->setVar('webinfo',$data);
		}
		$copyright = Config::findFirst("key='copyright'");
		if ($configinfo){
			$data = unserialize($copyright->value);
			$this->view->setVar('copyright',$data);
		}
		$this->view->cache(false);
	}

	public function ajaxResponse($data = '', $msg = '', $code = '0') {
		$response = [
			'data' => $data,
			'msg' => $msg,
			'code' => $code
		];
		echo json_encode($response, JSON_UNESCAPED_UNICODE);
		exit;
	}

	/**
	 * 显示信息
	 * @param mixed $message 信息内容
	 * @param string $redirect 跳转链接
	 * @param string $type 信息级别 'success', 'info', 'warning', 'error'
	 */
	public function message($message, $redirect = '', $type = '') {
		//  刷新请求
		if ($redirect == 'refresh') {
			$redirect = $_SERVER["REQUEST_URI"];
		}
		if ($redirect == 'referer') {
			$redirect = !empty($this->request->get('referer')) ? $this->request->get('referer') : (isset($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : '');
		}
		if ($this->request->isAjax() || $type == 'ajax') {
			$data = array();
			$data['message'] = $message;
			$data['redirect'] = $redirect;
			$data['type'] = $type;
			exit(json_encode($data));
		}
		if (empty($message) && !empty($redirect)) {
			header('location: ' . $redirect);
		}
		$type = in_array($type, array('success', 'info', 'warning', 'error')) ? $type : 'info';
		if ($type == "error") $type = "danger";
		$this->view->setVar("data", ['message' => $message, 'redirect' => $redirect, 'type' => $type]);
		$this->view->pick("common/message");
	}

	public function createUrl($segment = 'index/index', $params = array()) {
		$url = "/" . trim($segment, '/') . "/";
		if (!empty($params)) {
			$queryString = http_build_query($params, '', '&');
			$url .= $queryString;
		}
		return $url;
	}

	public function checkToken($token) {
		$token = base64_decode($token);
		$token = explode('_', $token);
		$uid = $token[0];
		$user = new User();
		$salt = $user->findFirst(
			array(
				'conditions' => "id = $uid",
				'columns' => 'token'
			)
		);
		if ($token === $salt->token) {
			return true;
		} else {
			return false;
		}
	}

	public function checkLogin() {
		$id = $this->session->get('operate');
		$username = Admin::findFirst("id = '$id'");
		if (!empty($username->user)) {
			$this->view->setVar('admin', $username->user);
		}
		if (!empty($id)) {
			$allowList = $this->is_allow($id);
//			$allowList[] = 'index';
//			$controllerName =  $this->dispatcher->getControllerName();
//			echo '<pre>';
//			var_dump($controllerName,$allowList);die;
//			if (!in_array($controllerName,$allowList)){
//				exit("<script>alert('非法请求');window.location.href='" . APP_ADMIN_PATH . "/index/login'</script>");
//			}
			if ($allowList) {
				foreach ($allowList as $value) {
					$this->view->setVar($value, $value);
				}
			}
			$this->view->setVar('login', 'login');
		} else {
			exit("<script>window.location.href='" . APP_ADMIN_PATH . "/index/login'</script>");
		}
	}

	public function create_salt($length = '') {
		$chars = '0123456789';
		$salt = '';
		for ($i = 0; $i < $length; $i++) {
			$salt .= $chars[mt_rand(0, strlen($chars) - 1)];
		}
		return $salt;
	}

	public function getResouce() {
		return array(
			'1' => 'article',
			'2' => 'config',
			'3' => 'jurisdiction',
			'4' => 'product',
			'5' => 'orchard',
			'6' => 'user',
			'7' => 'warehouse',
			'8' => 'userwithdraw',
			'9'	=>	'spread',
			'10'=>	'core',
		);
	}

	public function is_allow($id) {
		$userJurisdiction = Admin::findFirst(
			array(
				'conditions' => "id = $id",
				'columns' => 'jurisdiction'
			)
		);
		if ($userJurisdiction) {
			$userJurisdictionList = explode('-', $userJurisdiction->jurisdiction);
		} else {
			return false;
		}
		$resouce = $this->getResouce();
		foreach ($userJurisdictionList as $value) {
			if (!empty($value)) {
				$allowList[] = $resouce[$value];
			}
		}
		return $allowList;
	}

	public function getConfig(){
		$configInfo = Config::findFirst("key='web'");
		if (!empty($configInfo)){
			return unserialize($configInfo->value);
		}
	}

	//对象转数据
	public function object2array(&$object) {
		$object = json_decode(json_encode($object), true);
		return $object;
	}
	//检查是否为渠道代理
	public function checkchannel($uid){
		$userInfo = User::findFirst("id =$uid");
		if ($userInfo->	channelRebate>0){
			return true;
		}else{
			return false;
		}
	}
	public function createOrderNumber($uid,$type){
		return $orderNumber = $type.date("YmdHis",TIMESTAMP).str_pad($uid,'6','0',STR_PAD_LEFT);
	}
	//生成产品操作日志
	public function userAddProduct($data){
		$uid = $data['uid'];
		$operator = $this->session->get('operate');
		$createtime  =TIMESTAMP;
		$title = $data['title'];
		$operatorLog =  new OperatorLog();
		$operatorLog->uid = $uid;
		$operatorLog->title = $title;
		$operatorLog->operator = $operator;
		$operatorLog->createtime = $createtime;
		$result = $operatorLog->save();
		if (!$result){
			foreach ($operatorLog->getMessages() as $message){
				echo $message;
			}die;
		}
		if ($data['num']<0){
			$type = 'dedproduct';
		}else{
			$type = 'addproduct';
		}
		$this->saveTradeLogs(['uid'=>$uid,'num'=>abs($data['num']),'log'=>$operator."操作产品".$data['sid']."数量".$data['num'],'type'=>$type]);
		return $result;
	}
	/**
	 * 获取数据库异常信息
	 * @param $flag
	 * @param $obj
	 * @return string
	 */
	protected function getSqlError($flag, $obj){
		$message = "";
		if($flag == false){
			foreach ($obj->getMessages() as $msg) {
				$message .= $msg . '<br>';
			}
			return $message;
		}
	}

	/**
	 * 生成随机字符串
	 * @param int $length 字符串长度
	 * @param bool $numeric 是否纯数字
	 * @return string
	 */
	public function random($length, $numeric = FALSE) {
		$seed = base_convert(md5(microtime() . $_SERVER['DOCUMENT_ROOT']), 16, $numeric ? 10 : 35);
		$seed = $numeric ? (str_replace('0', '', $seed) . '012340567890') : ($seed . 'zZ' . strtoupper($seed));
		if ($numeric) {
			$hash = '';
		} else {
			$hash = chr(rand(1, 26) + rand(0, 1) * 32 + 64);
			$length--;
		}
		$max = strlen($seed) - 1;
		for ($i = 0; $i < $length; $i++) {
			$hash .= $seed{mt_rand(0, $max)};
		}
		return $hash;
	}


	public function saveTradeLogs($data = array()){
		$logs = new TradeLogs();
		$logs->uid = $data["uid"];
		$logs->mobile = $this->getMoblie($data["uid"]);
		$logs->num = $data["num"];
		$logs->logs = $data["log"];
		$logs->type = $data["type"];
		$logs->createtime = TIMESTAMP;
		$logs->status = 1;
		$result =  $logs->save();
		return $result;
	}
	public function getMoblie($uid){
		$userinfo = User::findFirst("id = $uid");
//		echo '<pre>';
//		var_dump($uid);die;
		if ($userinfo){
			$mobile = $userinfo->user;
		}else{
			$mobile = '';
		}
		return $mobile;
	}

	public function getArray($arr)
    {
      foreach ($arr as $key=>&$value){
          foreach ($value as $k=>$v){
              if (is_numeric($k)){
                  unset($value[$k]);
              }
          }
      }
      return $arr;
    }
//获得推荐上级id
	public function getTeacher($uid){
		$user =User::findFirst("id = $uid");
		$teacher = $user->superior;
		$teacherId = explode('-',$teacher);
		$teacherId =$teacherId[0];
		return $teacherId;

	}

	//生成会员操作日志
	public function SaveOrchardLogs($data){
		$operateId = $this->session->get('operate');
		$orchad = new OrchardLogs();
		$orchad->uid = $data['uid'];
		$orchad->mobile = $this->getMoblie($data['uid']);

		$orchad->disUid = $operateId;
		$orchad->landId = '';
		$orchad->types  = 'adminupdate';
		$orchad->nums = $data['num'];
		$orchad->msg = $data['msg'];
		$orchadInfo = OrchardUser::findFirst("uid =  $orchad->uid");
		$orchad->dataInfo = serialize($orchadInfo);
		$orchad->createtime = TIMESTAMP;
		$orchad->status = 1 ;
		$result = $orchad->save();
		if (empty($result)){
			echo $this->getSqlError($result,$orchad);
			die;
		}
		return $result;

	}
}
