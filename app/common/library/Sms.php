<?php
namespace Dhc\Library;

use Dhc\Models\Config;
use Dhc\Models\TelMessage;
use Phalcon\Di\Injectable;
use Phalcon\Exception;

class Sms extends Injectable{
	protected static $url = 'http://v.juhe.cn/sms/send';
	protected static $mobile = '';
	public static function send($mobile,$content,$info){
		$r1 = Sms::setMobile($mobile);
		if (empty($r1)){
			throw new Exception('操作失败，手机号码未正确填写');
		}
		if (empty($content)){
			throw new Exception('操作失败，请填写正确的验证码');
		}
		$contents = '';
		foreach ($content as $key=>$value){
			$contents .= '#'.$key.'#='.$value;
		}
		$result = Sms::curlHttp($contents,$info);
		if ($result){
			return Sms::log($mobile,$content['code']);
		}
	}
	public static function log($mobile,$content){
		$log = new TelMessage();
		$log->mobile = $mobile;
		$log->sendTime = TIMESTAMP;
		$log->code = $content;
		$log->status = 1;
		$result = $log->save();
		if (empty($result)){
			throw new Exception('操作失败，验证记录保存失败');
		}
		return $result;
	}
	public static function curlHttp($content,$info){
		$url = $info['url'];
		$key = $info['key'];
		$data = [
			'mobile'	=>	Sms::$mobile,
			'key'		=>	$key,
			'tpl_id'	=>	$info['tpl_id'],
			'tpl_value'	=>	$content,
			'dtype'	=>	''
		];
//		$data = [
//			'mobile'	=>	'13140410750',
//			'key'		=>	'8294eaadf023b9bc40ae7a30ee9cffd3',
//			'tpl_id'	=>	'38400',
//			'content'	=>	$content,
//			'dtype'	=>	''
//		];
		$pram = Sms::getParm($data);
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_HEADER, 0);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_URL, $url.$pram);
		$result = curl_exec($ch);
		$res = json_decode($result);
		if ($res->error_code === 0){
			return true;
		}else{
			return false;
		}

	}
	public static function getParm($data){
		if (empty($data['mobile'])){
			throw new  Exception('发送失败,手机号为空');
		}
		if (empty($data['tpl_value'])){
			throw new Exception('发送失败，内容为空');
		}
		if (empty($data['key'])){
			throw new  Exception('发送失败，请联系管理员');
		}
		$pram = '?mobile='.$data['mobile'].'&tpl_id='.$data['tpl_id'].'&tpl_value='.urlencode($data['tpl_value']).'&dtype='.$data['dtype'].'&key='.$data['key'];
		return $pram;
	}
	public static function setMobile($mobile){
		$isMatched = preg_match('/^0?(13|14|15|17|18)[0-9]{9}$/', $mobile, $matches);
		if ($isMatched) {
			Sms::$mobile = $mobile;
			return $isMatched;
		} else {
			return false;
		}
	}


}
