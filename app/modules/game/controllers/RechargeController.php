<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Library\Distribution;
use Dhc\Library\EmgApi;
use Dhc\Models\User;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardLogs;
use Phalcon\Exception;
use Phalcon\Http\Response;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;


class RechargeController extends ControllerBase{
	public $psize = 6;
	public function initialize() {
		$this->checkToken();
		$this->coing = $this->selectUserInfo($this->userid, "coing");
		$this->goods = $this->getConfig("recharge",true);
	}
	//返回用户充值参数
	public function getInfoAction(){
		// 用户余额
		$data = array(
			"coing"=>$this->coing,
			"goods"=>$this->goods
		);
		if(USER_TYPE == "EMG"){
//			$EMG = new EmgApi();
//			$user = new user();
//			$userInfo = $user->findFirst("id='{$this->userid}'")->toArray();
//			$balance = json_decode($EMG->getBalance(array("userCode"=>$userInfo['userCode'],"password"=>$this->request->getPost("password"))),true);
//			if(!empty($balance["dataList"])){
//				$data["coing"] = $balance["dataList"][6]["Banlance"];
//			}
		}
//		$this->payRebate();
//		try{
//			$dis = new Distribution($this->userid, 1000 , 1, "{$this->zuanshiTitle}充值");
//			$dis->start();
//		}catch (Exception $e){
//			$this->db->rollback();
//			$this->ajaxResponse('','推广费用计算失败，请审核：' . $e->getMessage(),'1');
//		}
		$this->ajaxResponse($data, "充值信息",0);
	}
	//用金币兑换钻石
	public function payDiamondsAction(){
		if($this->request->isPost()){
			$this->goods = $this->getConfig("recharge");
			$this->db->begin();
			$id = $this->request->getPost("id");
			if($id<=0 || empty($this->goods[$id]) || $this->goods[$id]["money"]<=0 || $this->goods[$id]["diamonds"]<=0){
				$this->db->rollback();
				$this->ajaxResponse("", "{$this->zuanshiTitle}兑换参数异常无法进行兑换！",1);
			}
			if(USER_TYPE == "EMG"){
				$EMG = new EmgApi();
				$user = new User();
				$user = $user->findFirst("id={$this->userid} ");
				if ($user == false) {
					$this->db->rollback();
					$this->ajaxResponse("", "用户信息获取失败，兑换失败！", 1);
				}
				$re = json_decode($EMG->pay(array(
					"userCode"=>$user->userCode,
					"password"=> $this->request->getPost("password"),
					"accountID"=>6,
					"amount"=>$this->goods[$id]['money'],
				)),true);
				if($re["Code"]  != 1){
					$this->db->rollback();
					$this->ajaxResponse("", "金额支付失败再进行{$this->zuanshiTitle}兑换操作[{$re['Message']}]！", 1);
				}
			}else {
				if ($this->coing < $this->goods[$id]['money']) {
					$this->db->rollback();
					$this->ajaxResponse("", "金币不足请先充值金币后再进行{$this->zuanshiTitle}兑换操作！", 1);
				}
				$user = new User();
				$user = $user->findFirst("id={$this->userid} AND coing={$this->coing}");
				if ($user == false) {
					$this->db->rollback();
					$this->ajaxResponse("", "用户信息获取失败，兑换失败！", 1);
				}
				$user->coing -= $this->goods[$id]["money"];
				$flag1 = $this->saveOrchardLogs(array("mobile" => $user->user, "types" => "dedcoing", "msg" => "果园兑换{$this->zuanshiTitle}" . $this->goods[$id]["diamonds"] . "扣除金币" . $this->goods[$id]["money"], "nums" => -$this->goods[$id]["money"], "dataInfo" => json_encode(array("goods" => $this->goods, "id" => $id))));
				$flag = $user->update();
				if ($flag == false || $flag1 == false) {
					$this->db->rollback();
					$this->ajaxResponse("", "用户金额扣除操作失败,请重试！", 1);
				}
			}
			$orchardUser = new OrchardUser();
			$orchardUser = $orchardUser->findFirst("uid='{$this->userid}' AND status=1");
			if($orchardUser == false){
				$this->db->rollback();
				$this->ajaxResponse("", "用户暂无法进行操作！",1);
			}
			$orchardUser->diamonds += intval($this->goods[$id]["diamonds"]);
			if($this->goods[$id]["give"]>0){
				$orchardUser->diamonds += intval($this->goods[$id]["give"]);
			}
			$orchardUser->optime = TIMESTAMP;
			$flag1 = $this->saveOrchardLogs(array("mobile"=>$orchardUser->mobile,"types"=>"adddiamonds","msg"=>"果园扣除金币".$this->goods[$id]["money"]."兑换{$this->zuanshiTitle}".$this->goods[$id]["diamonds"],"nums"=>$this->goods[$id]["diamonds"],"dataInfo"=>  json_encode(array("goods"=>$this->goods,"id"=>$id))));
			if($this->goods[$id]["give"]>0){
				$flag2 = $this->saveOrchardLogs(array("mobile"=>$orchardUser->mobile,"types"=>"adddiamonds","msg"=>"果园扣除金币".$this->goods[$id]["money"]."赠送{$this->zuanshiTitle}".$this->goods[$id]["give"],"nums"=>$this->goods[$id]["give"],"dataInfo"=>  json_encode(array("goods"=>$this->goods,"id"=>$id))));
			}else{
				$flag2 = true;
			}

			// 分销处理 zl
			try{
				$dis = new Distribution($this->userid, $this->goods[$id]["money"] , 1, "{$this->zuanshiTitle}充值");
				$dis->start();
			}catch (Exception $e){
				$this->db->rollback();
				$this->ajaxResponse('','推广费用计算失败，请审核：' . $e->getMessage(),'1');
			}
//			//充值返佣金币
//			$flag3 = $this->payRebate($this->goods[$id]["money"]);
			//果园兑换日志大盘显示
			$flag = $this->saveOrchardCost($this->goods[$id]["money"]);
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "日志更新失败,请重试！",1);
			}
			//金币操作日志
			$flag =$this->saveTradeLogs($this->goods[$id]["money"]);
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "日志更新失败,请重试！",1);
			}
			$flag = $orchardUser->update();
			if($flag == false || $flag1 == false || $flag2 == false){
				$this->db->rollback();
				$this->ajaxResponse("", "果园用户{$this->zuanshiTitle}更新操作失败,请重试！",1);
			}
			$this->db->commit();

			$this->ajaxResponse(array("diamonds"=>$orchardUser->diamonds,"coing"=>$user->coing), "{$this->zuanshiTitle}兑换成功！",0);
		}
	}
	//金币记录
	public function coingListAction(){
		$logs = new OrchardLogs();
		$pindex = max(1,$this->request->getPost("page"));
		$logsList = $logs->find(
			array(
				'conditions' => " uid='{$this->userid}' AND types LIKE '%coing%'",
				'columns'=>'mobile,msg,createtime,nums',
				'order'	=> ' createtime desc,id desc'
			));
		if($logsList == false){
			$this->ajaxResponse("", "果园金币操作记录返回为空！",1);
		}
		$paginator = new PaginatorModel(array("data"	=> $logsList,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$list = $this->object2array($page);
		if(!empty($list["items"])){
			foreach ($list["items"] as &$value) {
				$value["time"] = date("m-d H:i",$value["createtime"]);
			}
		}
		$data['list'] = $list["items"];
		$data['curPage'] = $list["current"];
		$data['totalPage'] = $list["total_pages"];
		$this->ajaxResponse($data, "果园金币操作记录返回为空！",1);
	}
	//{$this->zuanshiTitle}记录
	public function diamondsListAction(){
		$logs = new OrchardLogs();
		$pindex = max(1,$this->request->getPost("page"));
		$logsList = $logs->find(
			array(
				'conditions' => " uid='{$this->userid}' AND types LIKE '%diamond%'",
				'columns'=>'mobile,msg,createtime,nums',
				'order'	=> ' createtime desc,id desc'
			));
		if($logsList == false){
			$this->ajaxResponse("", "果园{$this->zuanshiTitle}操作记录返回为空！",1);
		}
		$paginator = new PaginatorModel(array("data"	=> $logsList,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$list = $this->object2array($page);
		if(!empty($list["items"])){
			foreach ($list["items"] as &$value) {
				$value["time"] = date("m-d H:i",$value["createtime"]);
			}
		}
		$data['list'] = $list["items"];
		$data['curPage'] = $list["current"];
		$data['totalPage'] = $list["total_pages"];
		$this->ajaxResponse($data, "果园{$this->zuanshiTitle}操作记录返回为空！",1);
	}
	//充值返佣金额
	function payRebate($price = ""){
		$rebate = $this->getConfig("rebate");
		if(empty($rebate) || $price<=0){
			return true;
		}
		$relation = $this->selectUserInfo($this->userid, "superior");
		$relation = explode("-", $relation);
		if($relation[0]<=0){
			return true;
		}
		foreach ($relation as $key => $value) {
			$level = $key+1;
			if($value<=0 || empty($rebate[$level]["num"])){
				continue;
			}
			$coing = $price*$rebate[$level]["num"]*0.01;
			if($coing<=0){
				continue;
			}
			$user = new User();
			$user = $user->findFirst("id='{$value}'");
			if($user == false){
				continue;
			}
			$user->coing += $coing;
			$user->updatetime = TIMESTAMP;
			$flag = $user->update();
			if($flag == false){
				return false;
			}
			$flag = $this->saveOrchardLogs(array("uid"=>$value,"mobile"=>$user->user,"types"=>"addcoing","disUid"=>$this->userid,"msg"=>"下级兑换{$this->zuanshiTitle}扣除金币".$price."奖励给您".$coing."金币","nums"=>$coing,"dataInfo"=>   json_encode(array("coing"=>$coing,"price"=>$price))));
			if($flag == false){
				return false;
			}
		}
		return true;
	}
}
