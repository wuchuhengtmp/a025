<?php
namespace Dhc\Library;

class Native {
	private $data;
	private $response;
	public function __construct($data){
		$this->data = $data;
	}
	public function pay(){
		$this->data['key_sign'] = $this->getSign();
		$this->response = json_decode($this->payRequest(),true);
		return $this->response['qr_code'];
	}
	private function payRequest(){
		$url = "http://pay.lcsw.cn/lcsw/pay/100/prepay";
		$data_string = json_encode($this->data);
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
		$initData = $this->initData();
		if ($initData){
			$param = "pay_ver={$this->data['pay_ver']}";
			$param .= "&pay_type={$this->data['pay_type']}";
			$param .= "&service_id={$this->data['service_id']}";
			$param .= "&merchant_no={$this->data['merchant_no']}";
			$param .= "&terminal_id={$this->data['terminal_id']}";
			$param .= "&terminal_trace={$this->data['terminal_trace']}";
			$param .= "&terminal_time={$this->data['terminal_time']}";
			$param .= "&total_fee={$this->data['total_fee']}";
			$param .= "&access_token={$this->data['access_token']}";
			unset($this->data['access_token']);
			return $sign = strtoupper(md5($param));
		} else {
			exit("<script>alert(".$initData['message'].");</script>");
		}
	}
	private function checkSign(){
		$param = '';
		foreach ($this->response as $key=>$val){
			if ($key == 'key_sign'){
				continue;
			}
			$param  .= '&' . $key . '=' . $val;
		}
			if ($this->response['key_sign'] == md5($param)){
				return true;
			}else{
				return false;
			}

	}
	/**
	 * 初始化并检查数据
	 * @return array|bool
	*/
	private function initData(){
		if (empty($this->data)){
			$this->ajaxResponse('error','支付参数错误，请联系管理员','1');
//			exit("<script>alert('接口数据错误请检查 ');history.go(-1);</script>");
		}
		if (empty($this->data['pay_ver'])){
			$this->data['pay_ver'] = '100';
		}
		//请求类型，“010”微信，“020”支付宝，“060”qq钱包
		$payCode = ['wechat'=>'010','alipay'=>'020','qq'=>'060'];
		if (!empty($payCode[$this->data["pay_type"]])){
			$this->data["pay_type"] = $payCode[$this->data["pay_type"]];
		}else{
			$this->data["pay_type"] = '010';
		}
		if (empty($this->data['service_id'])){
			$this->data['service_id'] = '011';
		}
		if (empty($this->data['merchant_no'])){
			$this->ajaxResponse('error','支付参数错误，请联系管理员：原因【商务号不能为空】','1');
//			exit("<script>alert('接口数据错误，商务号不能为空');history.go(-1);</script>");商务号不能为空
		}
		if (empty($this->data['terminal_id'])){
			$this->ajaxResponse('error','支付参数错误，请联系管理员：原因【终端号不能为空】','1');
//			exit("<script>alert('接口数据错误，终端号不能为空');history.go(-1);</script>");
		}
		if (empty($this->data['terminal_time'])){
			$this->data['terminal_time'] = date("YmdHis",TIMESTAMP);
		}
		if (empty($this->data['total_fee'])|| !is_numeric($this->data['total_fee'])|| $this->data['total_fee']<=0){
			$this->ajaxResponse('error','支付参数错误，请联系管理员：原因【订单金额有误】','1');
//			exit("<script>alert('接口数据错误，订单金额有误');history.go(-1);</script>");
		}
		if (empty($this->data['access_token'])){
			$this->ajaxResponse('error','支付参数错误，请联系管理员：原因【密匙错误】','1');
//			exit("<script>alert('接口请求数据错误，密匙错误');history.go(-1);</script>");
		}
		return true;
	}

	public function getSigns(){
		$data = $this->data;
		if ($data){
			$pram = 'pay_ver = '.$this->data['pay_ver'];
			$pram .='&pay_type='.$this->data['pay_type'];
			$pram .='&service_id'.$this->data['service_id'];
			$pram .='&merchant_no'.$this->data['merchant_no'];
			$pram .='&terminal_trace'.$this->data['terminal_trace'];
			$pram .='&operator_id'.$this->data['operator_id'];
			$pram .='&total_fee'.$this->data['total_fee'];
			$pram .='&order_body'.$this->data['order_body'];
			$pram .='&notify_url'.$this->data['notify_url'];
			$pram .='&attach'.$this->data['attach'];
			$data['key_sign'] = md5($pram.'&'.$data['access_token']);

		}
		return $data;
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
}
