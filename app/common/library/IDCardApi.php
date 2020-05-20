<?php
/**
 * @author 河南鼎汉软件科技
 * @copyright Copyright (c) 2017 HNDH Software Technology Co., Ltd.
 * createtime: 2017/10/20 16:57
 */

namespace Dhc\Library;

class IDCardApi
{
	const API_URL = "http://op.juhe.cn/idcard/query";
	const API_KEY = "888cd257639cc4af4dd4997c565aee44";
	const IDCARD_RULE = '/\d{17}[0-9Xx]|\d{15}/';
	private $realname;
	private $idcard;

	public function __construct($realname, $idcard)
	{
		$this->realname = $realname;
		$this->idcard = $idcard;
	}


	/**
	 * 检查结果
	 * @return bool
	 */
	public function check()
	{
		if (empty($this->realname)) {
			return false;
		}
		if (empty($this->idcard)) {
			return false;
		}
		if (!preg_match(self::IDCARD_RULE, $this->idcard)) {
			return false;
		}
		$params = [
			"idcard" => $this->idcard,
			"realname" => $this->realname,
			"key" => self::API_KEY,
		];
		$paramStr = http_build_query($params);
		$content = $this->httpCurl(self::API_URL, $paramStr);
		$result = json_decode($content, true);

		if (empty($result) || $result['error_code'] != '0') {
			return false;
		}
		if ($result['result']['res'] == '1') {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 请求接口返回内容
	 * @param  string $url [请求的URL地址]
	 * @param bool|string $params [请求的参数]
	 * @param int $isPost [是否采用POST形式]
	 * @return string
	 */
	private function httpCurl($url, $params = false, $isPost = 0)
	{
		$ch = curl_init();

		curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
		curl_setopt($ch, CURLOPT_USERAGENT, 'JuheData');
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 60);
		curl_setopt($ch, CURLOPT_TIMEOUT, 60);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
		if ($isPost) {
			curl_setopt($ch, CURLOPT_POST, true);
			curl_setopt($ch, CURLOPT_POSTFIELDS, $params);
			curl_setopt($ch, CURLOPT_URL, $url);
		} else {
			if ($params) {
				curl_setopt($ch, CURLOPT_URL, $url . '?' . $params);
			} else {
				curl_setopt($ch, CURLOPT_URL, $url);
			}
		}
		$response = curl_exec($ch);
		if ($response === FALSE) {
			return false;
		}
		curl_close($ch);
		return $response;
	}

}
