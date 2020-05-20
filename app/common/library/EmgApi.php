<?php
/**
 * @author 河南鼎汉软件科技
 * @copyright Copyright (c) 2017 HNDH Software Technology Co., Ltd.
 * createtime: 2017/10/27 19:17
 */

namespace Dhc\Library;

use Dhc\Models\Orchard;
//$test = new EmgApi();
//$data = [
//	'userCode' => '10000',
//	'username' => 'z',
//	'userPhone' => '13027778335',
//	'parentCode' => '10000',
//	'password' => md5('zhang'),
//	'realname' => 'zhang',
//	'idcard' => '1234567890',
//];
//echo $test->register($data);
class EmgApi
{
	private $base_url;
	private $appkey;
	private $appSecret;

	public function __construct(){

		$config = new Orchard();
		$config = $config->findFirst("id=1")->toArray();
		$emg = json_decode($config["EMG"],true);
		if(!empty($emg)){
			$this->base_url = $emg["httpUrl"];
			$this->appkey = $emg["appkey"];
			$this->appSecret = $emg["appSecret"];
		}
//		$this->base_url = 'http://test.emghk.net/Api/';
//		$this->appkey = 'EMG201710181607';
//		$this->appSecret = '56ADF02D86494B40A0E44C757D4E228E';
	}
	//获取注册编号
	public function getUserCode(){
		$info = [
			'appkey' => $this->appkey,
			'appSecret' => $this->appSecret,
		];
		return  $this->http_get('User/GetUserCode', $info);
	}
	//注册
	public function register($data)
	{
		$info = [
			'appkey' => $this->appkey,
			'appSecret' => $this->appSecret,
			'userCode' => $data['userCode'],
			'userName' => $data['username'],
			'userPhone' => $data['userPhone'],
			'parentCode' => $data['parentCode'],
			'managerCode' => $data['managerCode'],
			'regUserCode' => $data['regUserCode'],
			'payPassword' => $data['payPassword'],
			'idcard' => $data['idcard'],
			'password' => $data['password'],
		];
		return  $this->http_get('User/UserReg', $info);
	}
	//获取登录
	public function getLogin($data){
		$info = [
			'appkey' => $this->appkey,
			'appSecret' => $this->appSecret,
			'userCode' => $data['userCode'],
			'password' => $data['password'],
		];
//		print_r($info);
		return $this->http_get('User/UserLogin', $info);
	}
	//外部连接
	public function returnUrl($data){
		$info = [
			'appkey' => $this->appkey,
			'appSecret' => $this->appSecret,
			'userCode' => $data['userCode'],
			'password' => $data['password'],
			"returnUrl"=>$data["returnUrl"],
		];

		return $this->base_url . "User/ThirdPartyLogin" . '?' .http_build_query($info) ;
	}
	//获取用户信息
	public function getUserInfo($data){
		$info = [
			'appkey' => $this->appkey,
			'appSecret' => $this->appSecret,
			'userCode' => $data['userCode'],
			'password' => $data['password'],
		];
//		print_r($info);
		return $this->http_get('User/GetUserInfo', $info);
	}
	//用户账户金额查询
	public function getBalance($data){
		$info = [
			'appkey' => $this->appkey,
			'appSecret' => $this->appSecret,
			'userCode' => $data['userCode'],
			'password' => md5($data['password']),
		];
		return $this->http_get('User/UserAccountQuery', $info);
	}
	//六、	调用用户账户金额支付
	public function  pay($data){
		$info = [
			'appkey' => $this->appkey,
			'appSecret' => $this->appSecret,
			'userCode' => $data['userCode'],
			'password' => md5($data['password']),
			'accountID' => $data['accountID'],
			'amount' => $data['amount'],
		];
		return $this->http_get('User/PayForApp', $info);
	}
	public function http_get($url, $params)
	{
		$url = $this->base_url . $url . '?' .http_build_query($params) ;
//		echo $url;
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_HEADER, 0);
		$output = curl_exec($ch);
		curl_close($ch);
		return $output;
	}
}
