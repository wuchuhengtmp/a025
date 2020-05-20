<?php
/**
 * Created by PhpStorm.
 * User: XingBin
 * Date: 2017/7/26
 * Time: 16:16
 */
namespace Dhc\Library;
use Dhc\Models\UserConfig;
use Phalcon\Di\Injectable;

class YBNative extends Injectable{
	private  $p1_MerId			= "";																										#测试使用
	private  $merchantKey		= "";		#测试使用
	private  $logName			= "BANK_HTML.log";
	private  $p9_SAF			= "1";
	private  $p0_Cmd			= 'Buy';
	private  $pr_NeedResponse	= '1';
	private  $programe;
	private  $p4_Cur			= 'CNY';
	public function __construct($data){
		//$p2_Order,$p3_Amt,$p4_Cur,$p5_Pid,$p6_Pcat,$p7_Pdesc,$p8_Url,$pa_MP,$pd_FrpId,$pr_NeedResponse
		$userConfig = UserConfig::findFirst("payType  =   'YB' AND status = 1");
		if (empty($userConfig->merchant_no)||empty($userConfig->access_token)||empty($userConfig)){
			$this->ajaxResponse('','操作失败，请联系管理员','1');
		}
		$this->p1_MerId = $userConfig->merchant_no;
		$this->merchantKey = $userConfig->access_token;
		$data['p0_Cmd'] = $this->p0_Cmd;
		$data['p1_MerId'] = $this->p1_MerId;
		$data['p4_Cur'] = $this->p4_Cur;
		$data['p9_SAF'] = $this->p9_SAF;
		$data['pr_NeedResponse'] = $this->pr_NeedResponse;
		$data['hmac'] = $this->getReqHmacString($data);
//		$result = $this->payRequest($data);
		$this->data = $data;
	}
	public function getReqHmacString($data)
	{
		#进行签名处理，一定按照文档中标明的签名顺序进行
		$sbOld = "";
		#加入业务类型
		$sbOld = $sbOld.$data['p0_Cmd'];
		#加入商户编号
		$sbOld = $sbOld.$data['p1_MerId'];
		#加入商户订单号
		$sbOld = $sbOld.$data['p2_Order'];
		#加入支付金额
		$sbOld = $sbOld.$data['p3_Amt'];
		#加入交易币种
		$sbOld = $sbOld.$data['p4_Cur'];
		#加入商品名称
		$sbOld = $sbOld.$data['p5_Pid'];
		#加入商品分类
		$sbOld = $sbOld.$data['p6_Pcat'];
		#加入商品描述
		$sbOld = $sbOld.$data['p7_Pdesc'];
		#加入商户接收支付成功数据的地址
		$sbOld = $sbOld.$data['p8_Url'];
		#加入送货地址标识
		$sbOld = $sbOld.$data['p9_SAF'];
		#加入商户扩展信息
		$sbOld = $sbOld.$data['pa_MP'];
		#加入支付通道编码
		$sbOld = $sbOld.$data['pd_FrpId'];
		#加入是否需要应答机制
		$sbOld = $sbOld.$this->pr_NeedResponse;
		$this->logstr($data['p2_Order'],$sbOld,$this->HmacMd5($sbOld,$this->merchantKey));
		return $this->HmacMd5($sbOld,$this->merchantKey);
	}




#

	public function CheckHmac($r0_Cmd,$r1_Code,$r2_TrxId,$r3_Amt,$r4_Cur,$r5_Pid,$r6_Order,$r7_Uid,$r8_MP,$r9_BType,$hmac)
	{
		if($hmac==getCallbackHmacString($r0_Cmd,$r1_Code,$r2_TrxId,$r3_Amt,$r4_Cur,$r5_Pid,$r6_Order,$r7_Uid,$r8_MP,$r9_BType))
			return true;
		else
			return false;
	}


	public function HmacMd5($data,$key)
	{
// RFC 2104 HMAC implementation for php.
// Creates an md5 HMAC.
// Eliminates the need to install mhash to compute a HMAC
// Hacked by Lance Rushing(NOTE: Hacked means written)

//需要配置环境支持iconv，否则中文参数不能正常处理
		$key = iconv("GB2312","UTF-8",$key);
		$data = iconv("GB2312","UTF-8",$data);

		$b = 64; // byte length for md5
		if (strlen($key) > $b) {
			$key = pack("H*",md5($key));
		}
		$key = str_pad($key, $b, chr(0x00));
		$ipad = str_pad('', $b, chr(0x36));
		$opad = str_pad('', $b, chr(0x5c));
		$k_ipad = $key ^ $ipad ;
		$k_opad = $key ^ $opad;
		return md5($k_opad . pack("H*",md5($k_ipad . $data)));
	}

	public function logstr($orderid,$str,$hmac)
	{
		$james=fopen($this->logName,"a+");
		fwrite($james,"\r\n".date("Y-m-d H:i:s")."|orderid[".$orderid."]|str[".$str."]|hmac[".$hmac."]");
		fclose($james);
	}
	//发送请求
	public function payRequest(){
		$data= $this->data;
		$data['url'] = "http://api.101ka.com/GateWay/Bank/Default.aspx";
		$data['format']= 'json';
//		$result =  $this->request($data);
//		return $result;die;
		$ch = curl_init($data['url']);
		//设置请求为post
		curl_setopt($ch,CURLOPT_POST,1);
		//设置请求的变量
		curl_setopt($ch,CURLOPT_POSTFIELDS,$data);
		//设置响应返回数据 可省略
		//设置json请求
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
		//设置相应头信息
		curl_setopt($ch,CURLOPT_HEADER,1);
		//设置重定向
		curl_setopt($ch,CURLOPT_FOLLOWLOCATION,true);
		//设置超时
		curl_setopt($ch,CURLOPT_CONNECTTIMEOUT,30);
		curl_setopt($ch,CURLOPT_TIMEOUT,30);
		//执行
		$output = curl_exec($ch);
		//关闭释放内存
		$url  =$this->getErweima($output);
		$data = json_decode($url);
		return $data->img;
	}

	public function getUrl($str){
		$preg='/\{ .*\}/';
		$str = $str;
		preg_match_all($preg,$str,$match);//在$str中搜索匹配所有符合$preg加入$match中
		for($i=0;$i<count($match[1]);$i++)//逐个输出超链接地址
		{
			return $match[1][$i];
		}
	}
	public function getErweima($str){
		$preg = '/\{[^{}]+\}/';
		$str = $str;
		preg_match($preg,$str,$strs);
		return $strs[0];
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


	//取得返回串中的所有参数
	public function getCallBackValue(&$data)
	{
		$r0_Cmd	= $data['r0_Cmd'];
		$r1_Code	= $data['r1_Code'];
		$r2_TrxId	= $data['r2_TrxId'];
		$r3_Amt		= $data['r3_Amt'];
		$r4_Cur		= $data['r4_Cur'];
		$r5_Pid		= $data['r5_Pid'];
		$r6_Order	= $data['r6_Order'];
		$r7_Uid		= $data['r7_Uid'];
		$r8_MP		= $data['r8_MP'];
		$r9_BType	= $data['r9_BType'];
		$hmac			= $data['hmac'];
		return null;
	}

}
