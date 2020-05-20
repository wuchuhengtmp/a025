<?php
/**
 * Created by PhpStorm.
 * User: XingBin
 * Date: 2017/7/26
 * Time: 19:45
 */
namespace Dhc\Library;
use Dhc\Models\DistributionList;
use Dhc\Models\Recharge;
use Dhc\Models\TradeLogs;
use Dhc\Models\User;
use Dhc\Models\UserConfig;
use Phalcon\Di\Injectable;
use Dhc\Models\UserCost;

class YpayResult extends Injectable{
	private $logName = 'BANK_HTML.log';
	private $payData = '';
	public function __construct($data){
		$this->payData = $data;
	}

	public function start(){
		if (!empty($this->payData['r6_Order'])){
			$result = $this->CheckHmac($this->payData);
			if (!empty($result)){
				return $this->handleShopOrder();
			}else{
				return false;
			}
		}
	}

	private function handleShopOrder(){
		$orderid = $this->payData['r6_Order'];
		$this->db->begin();
		$recharge = Recharge::findFirst("orderNumber = '$orderid'");
		$uid = $recharge->uid;
		$this->number = $recharge->number;
		if ($recharge){
			if ($recharge->payStatus == 2){
				$recharge->payStatus = 1;
			}else{
				$this->db->rollback();
				return false;
			}
			$result = $recharge->update();
			if ($result){
				$userinfo  =User::findFirst("id = $uid");
				$userinfo->coing += $recharge->number;
				$userinfoResult =$userinfo->update();
				$this->saveTradeLogs(array("uid"=>$uid,'num'=>$recharge->number,'type'=>'addcoing','log'=>$recharge->payType.'金币充值'.$recharge->number));
				if ($userinfoResult){
					$userCost = new UserCost();
					$userCost->uid = $uid;
					$userCost->sum = $recharge->number;
					$userCost->orderNumber = $recharge->orderNumber;
					$userCost->createtime = TIMESTAMP;
					$userCost->endtime = TIMESTAMP;
					$userCost->status = '1';
					$userCost->type = '用户充值';
					$userCostResult = $userCost->save();
				}
			}
			if ($result&&$userCostResult){
				$this->db->commit();
				$userCost = Recharge::find(['conditions'=>"uid = $uid AND payStatus = 1"]);
				if (count($userCost) <= 1){
					$s = $this->teacherAddGold($uid);
					if ($s){$this->PayLog('上级添加成功');}else{$this->PayLog('失败');}
				}
				return true;
			}else{
				$this->db->rollback();
				return false;
			}
		}else{
			return false;
		}
	}
	public function teacherAddGold($uid){
		$userInfo = User::findFirst("id = $uid");
		$teachers = explode('-',$userInfo->superior);
		if (!empty($teachers[0])){
//			$this->PayLog($teachers[0]);
			$teacherInfo = User::findFirst("id = $teachers[0]");
			if ($teacherInfo){
				$flag = false;
				 $this->db->begin();
				$teacherInfo->coing += 2 ;
				$this->saveTradeLogs(array("uid"=>$teachers[0],'num'=>2,'type'=>'addcoing','log'=>'下级首充赠送金币2'));
				$result = $teacherInfo->update();
				if ($result){
					$userCost = new UserCost();
					$userCost->orderNumber = $this->createOrderNumber($teacherInfo->id,'SC');
					$userCost->uid = $teacherInfo->id;
					$userCost->createtime = TIMESTAMP;
					$userCost->endtime = TIMESTAMP;
					$userCost->sum = 2;
					$userCost->charge = '0';
					$userCost->status = 1;
					$userCost->type = '首充奖励';
					$userCostResult = $userCost->save();
					$this->saveFirst(array('uid'=>$teacherInfo->id,'cUid'=>$uid));
					if (!$userCostResult){
						foreach ($userCost->getMessages() as $message){
							$this->PayLog($message);
						}
					}else{
						$flag = true;
						$this->PayLog("上级添加保存成功");
					}
				}
			}
			if ($flag){
				$this->db->commit();
				return true;
			}else{
				$this->db->rollback();
				return false;
			}

		}
	}
	//添加首充
	public function saveFirst($data){
		$dis =  new DistributionList();
		$dis->uid = $data['uid'];
		$dis->cUid = $data['cUid'];
		$dis->level = 1;
		$dis->gold = $this->number;
		$dis->type = 3;
		$dis->disType = 'common';
		$dis->rebate = 0;
		$dis->amount = 2;
		$dis->effectTime = TIMESTAMP;
		$dis->createTime = TIMESTAMP;
		$dis->updateTime = TIMESTAMP;
		$dis->status = 1;
		$dis->log = '首充奖励';
		return $dis->save();
	}

	/**
	 * 日志记录函数
	 * @param max $message 日志内容，建议为数组包含操作函数和原因
	 * @param string $level 日志重要程度
	 */
	public function PayLog($message , $level = "info") {
		$file = WEB_PATH . '/logs/';
		if(!file_exists($file)){
			@mkdir($file);
		}
		$filename = $file . date('Ymd') . '.txt';
		$content = date('Y-m-d H:i:s') . " {$level} :\n------------\n";
		if (is_string($message)) {
			$content .= "String:$message";
		}
		if (is_object($message)) {
			$content .= "Object:\n" . var_export($message, TRUE) . "\n";
		}
		if (is_array($message)) {
			$content .= "Array:\n";
			foreach ($message as $key => $value) {
				$content .= sprintf("%s : %s ;\n", $key, $value);
			}
		}
		$content .= "\n";
		$fp = fopen($filename, 'a+');
		fwrite($fp, $content);
		fclose($fp);
	}
	public function createOrderNumber($uid,$type){
		return $orderNumber = $type.date("YmdHis",TIMESTAMP).str_pad($uid,'6','0',STR_PAD_LEFT);
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
		if ($userinfo){
			$mobile = $userinfo->user;
		}else{
			$mobile = '';
		}
		return $mobile;
	}
	//签名校验
	function CheckHmac($data)
	{
		if($this->payData['hmac']==$this->getCallbackHmacString($data))
			return true;
		else
			return false;
	}

	//获取返回的参数
	public function getCallbackHmacString($data)
	{
		#取得加密前的字符串
		$sbOld = "";
		#加入商家ID
		$sbOld = $sbOld.$data['p1_MerId'];
		#加入消息类型
		$sbOld = $sbOld.$data['r0_Cmd'];
		#加入业务返回码
		$sbOld = $sbOld.$data['r1_Code'];
		#加入交易ID
		$sbOld = $sbOld.$data['r2_TrxId'];
		#加入交易金额
		$sbOld = $sbOld.$data['r3_Amt'];
		#加入货币单位
		$sbOld = $sbOld.$data['r4_Cur'];
		#加入产品Id
		$sbOld = $sbOld.$data['r5_Pid'];
		#加入订单ID
		$sbOld = $sbOld.$data['r6_Order'];
		#加入用户ID
		$sbOld = $sbOld.$data['r7_Uid'];
		#加入商家扩展信息
		$sbOld = $sbOld.$data['r8_MP'];
		#加入交易结果返回类型
		$sbOld = $sbOld.$data['r9_BType'];
		$userConfig = UserConfig::findFirst("payType =  'YB'");
		$this->logstr($data['r6_Order'],$sbOld,$this->HmacMd5($sbOld,$userConfig->access_token));
		return $this->HmacMd5($sbOld,$userConfig->access_token);

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

}
