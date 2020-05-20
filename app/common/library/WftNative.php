<?php
namespace Dhc\Library;

class WftNative {
	private $data;
	private $response;
	private $program;
	public function __construct($data){;
		$this->data =$this->initData($data);
	}
	public function pay(){
		$this->program['sign'] = $this->getSign();
		$this->response = $this->xml2array($this->payRequest());
		if (!empty($this->response['code_url'])){
			return $this->response['code_url'];
		}else{
			return false;
		}
	}
	private function payRequest(){
		$url = "https://pay.swiftpass.cn/pay/gateway";
		$data_string = $this->toXml(($this->program));
		$ch = curl_init($url);
		//设置请求为post
		curl_setopt($ch,CURLOPT_POST,1);
		//设置请求的变量
		curl_setopt($ch,CURLOPT_POSTFIELDS,$data_string);
		//设置响应返回数据 可省略
		//设置json请求
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
		curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			'Content-Type: application/json; charset=utf-8',
			'Content-Length: ' . strlen($data_string)
		));
		//设置相应头信息
		curl_setopt($ch,CURLOPT_HEADER,0);
		//设置超时
		curl_setopt($ch,CURLOPT_CONNECTTIMEOUT,30);
		curl_setopt($ch,CURLOPT_TIMEOUT,30);
		//执行
		$output = curl_exec($ch);
		//关闭释放内存
		curl_close($ch);
		return $output;
	}
	private function getSign(){
		$initData = $this->program;
		if ($initData){
			$signPars = "";
			ksort($initData);
			foreach($initData as $k => $v) {
				if("" != $v && "sign" != $k) {
					$signPars .= $k . "=" . $v . "&";
				}
			}
			$signPars .= 'key='.$initData['sign'];
			$sign = strtoupper(md5($signPars));

			return $sign;
		} else {
			exit($initData['message']);
		}
	}
//	private function checkSign(){
//		$param = '';
//		foreach ($this->response as $key=>$val){
//			if ($key == 'key_sign'){
//				continue;
//			}
//			$param  .= '&' . $key . '=' . $val;
//		}
//			if ($this->response['key_sign'] == md5($param)){
//				return true;
//			}else{
//				return false;
//			}
//
//	}
	/**
	 * 初始化并检查数据
	 * @return array|bool
	*/
	private function initData($data){
		if (empty($data)){
			$this->ajaxResponse('error','支付参数错误，请联系管理员2','1');
		}
		//请求类型，“010”微信，“020”支付宝，“060”qq钱包
		$payCode = ['wechat'=>'pay.weixin.native','alipay'=>'pay.alipay.native','qq'=>'pay.tenpay.wappay'];
		if (!empty($payCode[$data["pay_type"]])){//获取支付类型
			$this->program["service"] = $payCode[$data["pay_type"]];
		}else{
			$this->program["service"] = 'pay.weixin.native';
		}
		if (!empty($data['order_body'])){
			$this->program['body'] = $data['order_body'];
		}
		if (empty($data['merchant_no'])){//获取支付商户号
			$this->ajaxResponse('error','支付参数错误，请联系管理员：原因【商户号不能为空】','1');
		}else{
			$this->program['mch_id'] = $data['merchant_no'];
//			$this->program['mch_id'] = '7551000001';
		}
		$this->program['nonce_str'] = mt_rand(TIMESTAMP,TIMESTAMP+$this->rand(1,10000));
		if (empty($data['terminal_trace'])){//获取支付订单号
			$this->ajaxResponse('error','支付参数错误，请联系管理员：原因【订单号为空】','1');
		}else{
			$this->program['out_trade_no'] = $data['terminal_trace'];
		}
		$this->program['mch_create_ip'] = $_SERVER["REMOTE_ADDR"];
		if (empty($data['total_fee'])|| !is_numeric($data['total_fee'])|| $data['total_fee']<=0){//获取支付金额
			$this->ajaxResponse('error','支付参数错误，请联系管理员：原因【订单金额有误】','1');
		}else{
//			$this->program['total_fee'] = 1;
			$this->program['total_fee'] = $data['total_fee'];
		}
		if (!empty($data['terminal_time'])){//获取支付开始时间
			$this->program['time_start'] = $data['terminal_time'];
		}else{
			$this->program['time_start'] = $data("YmdHis",TIMESTAMP);
		}
		if (empty($data['access_token'])){
			$this->ajaxResponse('error','支付参数错误，请联系管理员：原因【签名错误】','1');
		}else{
			$this->program['sign'] = $data['access_token'];
//			$this->program['sign'] = '9d101c97133837e13dde2d32a5054abb';
		}

		if (!empty($data['notify_url'])){
			$this->program['notify_url'] = $data['notify_url'];
		}else{
			$this->ajaxResponse('error','支付参数错误，请联系管理员：原因【回调地址错误】','1');
		}
		return true;
	}

	public function ajaxResponse($data = '', $msg = '', $code = '0'){
		$response = [
			'data'  => $data,
			'msg'   => $msg,
			'code'  => $code
		];
		echo json_encode($response,JSON_UNESCAPED_UNICODE);
		exit;
	}
	public static function toXml($array){
		$xml = '<xml>';
		forEach($array as $k=>$v){
			$xml.='<'.$k.'><![CDATA['.$v.']]></'.$k.'>';
		}
		$xml.='</xml>';
		return $xml;
	}
	protected function rand($min, $max) {
		mt_srand((double) microtime() * 1000000);
		return mt_rand($min, $max);
	}
	function xml2array($xml) {
		if (empty($xml)) {
			return array();
		}
		$result = array();
		$xmlobj = simplexml_load_string($xml, 'SimpleXMLElement', LIBXML_NOCDATA);
		if($xmlobj instanceof $xmlobj) {
			$result = json_decode(json_encode($xmlobj), true);
			if (is_array($result)) {
				return $result;
			} else {
				return array();
			}
		} else {
			return $result;
		}
	}
}
