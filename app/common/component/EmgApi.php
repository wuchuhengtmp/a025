<?php
/**
 * @author 河南鼎汉软件科技
 * @copyright Copyright (c) 2017 HNDH Software Technology Co., Ltd.
 * createtime: 2017/10/27 19:17
 */

namespace Taojin\common\component;

//use Dhc\Models\Orchard;
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
		if(empty($emg)){
			$this->base_url = $emg["httpUrl"];
			$this->appkey = $emg["appkey"];
			$this->appSecret = $emg["appSecret"];
		}
//		$this->base_url = 'http://test.emghk.net/Api/';
//		$this->appkey = 'EMG201710181607';
//		$this->appSecret = '56ADF02D86494B40A0E44C757D4E228E';
	}
	public function register($data)
	{
		$result = $this->http_get('User/UserReg', [
			'appkey' => $this->appkey,
			'appSecret' => $this->appSecret,
			'userCode' => $data['userCode'],
			'username' => $data['username'],
			'userPhone' => $data['userPhone'],
			'parentCode' => $data['parentCode'],
			'password' => $data['password'],
			'realname' => $data['realname'],
			'idcard' => $data['idcard'],
		]);
		return $result;
	}

	public function http_get($url, $params)
	{
		$url = $this->base_url . $url . '?' .http_build_query($params) ;
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_HEADER, 0);
		$output = curl_exec($ch);
		curl_close($ch);
		return $output;
	}
}
