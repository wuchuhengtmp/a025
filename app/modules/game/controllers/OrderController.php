<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\Config;
use Dhc\Models\Orchard;
use Dhc\Models\OrchardOrder;
use Dhc\Models\OrchardGoods;
use Dhc\Models\OrchardUser;
use Dhc\Models\Product;
use Dhc\Models\TradeLogs;
use Dhc\Models\User;
use Dhc\Models\UserProduct;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;
use Dhc\Modules\Game\DogController as ControllersBase;
use Phalcon\Http\Response;

class OrderController extends ControllerBase{
	public $psize = 6;
	public function initialize() {
		$this->checkToken();
		$this->diamonds = $this->selectUser($this->userid, "diamonds");
		$this->onoInfo = $this->onoInfo();
	}
	//支付订单扣{$this->zuanshiTitle}
	function payAction(){
		if($this->request->isPost()){
			$this->db->begin();
			$tId = $this->request->getPost("tId");
			if($tId<=0){
				$this->db->rollback();
				$this->ajaxResponse('', "购买商品失败，请重新点击购买",1);
			}
			$goodsInfo = $this->getGoodsInfo($tId);
			$goodsNums = max(1,$this->request->getPost("nums"));
			if($goodsInfo["type"] ==1){
				$fruitPrice = $this->getfruitNewPrice();
				if($fruitPrice>0){
					$goodsInfo["price"] = $fruitPrice*100;
				}
			}
			if($goodsInfo["price"]*$goodsInfo["pack"]*$goodsNums>$this->diamonds){
				$this->db->rollback();
				$this->ajaxResponse('', "{$this->zuanshiTitle}不足，请兑换后再进行购买",1);
			}

			$user = new \Dhc\Models\OrchardUser();
			$user = $user->findFirst("uid='{$this->userid}' AND diamonds='{$this->diamonds}'");
			if($user == false){
				$this->db->rollback();
				$this->ajaxResponse('', "用户信息异常，请重试！",1);
			}
			if($goodsInfo["reclaimLimit"]>0 && $user->grade<$goodsInfo["reclaimLimit"]){
				$this->db->rollback();
				$this->ajaxResponse('', "用户等级不足无法购买！",1);
			}

			$user->diamonds -= $goodsInfo["price"]*$goodsInfo["pack"]*$goodsNums;
			$flag = $this->saveOrchardLogs(array("mobile"=>$user->mobile,"types"=>"deddiamonds","nums"=> -$goodsInfo["price"]*$goodsInfo["pack"]*$goodsNums,"msg"=>"商城购买".$goodsInfo["tName"]."*".($goodsInfo["pack"]*$goodsNums)."扣除{$this->zuanshiTitle}".($goodsInfo["price"]*$goodsInfo["pack"]*$goodsNums)));
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse('', "购买订单扣除金币日志更新失败！！",1);
			}
			if($goodsInfo["type"] != 5){
				if($goodsInfo["type"] ==1){
					$total = $this->getFruitTotalNums();
					if($total[1] - $goodsInfo["pack"]*$goodsNums<0){
						$this->db->rollback();
						$this->ajaxResponse('', "库存不足无法购买！！",1);
					}
					$flag = $this->getFruitTotalNums("save",$goodsInfo["pack"]*$goodsNums);
					if($flag == false){
						$this->db->rollback();
						$this->ajaxResponse('', "库存数据更新失败！！",1);
					}
				}
				$model = $this->onoInfo[$goodsInfo["tId"].$goodsInfo["type"]];
				$flag = $this->saveOrchardLogs(array("mobile"=>$user->mobile,"types"=>"add".$model,"nums"=>$goodsInfo["pack"]*$goodsNums,"msg"=>"商城扣除{$this->zuanshiTitle}".($goodsInfo["price"]*$goodsInfo["pack"]*$goodsNums)."购买".$goodsInfo["tName"]."*".($goodsInfo["pack"]*$goodsNums)));
				if($flag == false){
					$this->db->rollback();
					$this->ajaxResponse('', "购买订单增加道具日志更新失败！！",1);
				}
				if($goodsInfo["type"] !=1){
					$user->$model += $goodsInfo["pack"]*$goodsNums;
				}
			}
			$user->updatetime = TIMESTAMP;
			$flag = $user->update();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse('', "用户{$this->zuanshiTitle}支付失败，请联系管理员核实此订单！",1);
			}
			$order = new OrchardOrder();
			$order->uid = $this->userid;
			$order->nickname = $user->nickname;
			$order->mobile = $user->mobile;
			$order->goodsId = $tId;
			$order->goodsName = $goodsInfo["tName"];
			$order->types = $this->onoInfo[$goodsInfo['tId'].$goodsInfo['type']];
			$order->coing = $goodsInfo["price"]*$goodsInfo["pack"]*$goodsNums;
			$order->fruit = $goodsInfo["pack"]*$goodsNums;
			$order->payStatus =1;
			$order->payTime = $order->createtime = TIMESTAMP;
			$order->orderId =0;
			$flag = $order->save();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse('', "用户{$this->zuanshiTitle}购买商品订单更新失败，请重试！",1);
			}
			$newId = $order->id;
			if(strlen($newId) < 5){
				$newsId = str_pad($newId, 5, "0", STR_PAD_LEFT);
			}else{
				$newsId = substr($newId, "-5");
			}
			$order->orderId = "Orchard".date("mdHi").$newsId;
			$flag = $order->update();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse('', "用户购买订单信息更新失败，请重试！",1);
			}
			if($goodsInfo["type"] ==5){
				$dog = new DogController();
				$flag = $dog->addDog($goodsInfo['tId']);
				if($this->is_error($flag) || $flag == false){
					$this->db->rollback();
					$this->ajaxResponse('', "购买失败！{$flag['message']}",1);
				}
			}elseif($goodsInfo["type"] ==1){
				$flag = $this->saveProduct($goodsInfo["tId"],$goodsInfo["pack"]*$goodsNums);
				if($this->is_error($flag) || $flag == false){
					$this->db->rollback();
					$this->ajaxResponse('', "购买失败！{$flag['message']}",1);
				}
			}
			$this->db->commit();
			$this->ajaxResponse(array("diamonds"=>$user->diamonds), "购买成功！",0);
		}
		$this->ajaxResponse('', "购买订单提交中",0);
	}
	//商品信息
	function getGoodsInfo($tId){
		$goods = new OrchardGoods();
		$goodsInfo = $goods->findFirst("tId='{$tId}' AND status=1");
		if($goodsInfo == false){
			$this->ajaxResponse('', "商品信息获取失败",1);
		}
		return $this->object2array($goodsInfo);
	}
	//商城订单记录
	function listAction(){
		$logs = new OrchardOrder();
		$pindex = max(1,$this->request->getPost("page"));
		$lists = $logs->find(array(
					'conditions'	=>	"uid = $this->userid AND payStatus=1 ",
					'columns'		=>	'orderId,types,createtime,coing,fruit',
					'order'			=>	"payTime desc"
				));
		$paginator = new PaginatorModel(array("data"	=> $lists,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$list = $this->object2array($page);
		$onoTitle = $this->onoTitleInfo();
		if(!empty($list["items"])){
			foreach ($list["items"] as &$value) {
				$value["info"] = "消费".$value["coing"]."{$this->zuanshiTitle}获得".$onoTitle[$value['types']].$value["fruit"]."个";
				$value["time"] = date("Y-m-d H:i:s",$value["createtime"]);
			}
		}
		$data['list'] = $list["items"];
		$data['curPage'] = $list["current"];
		$data['totalPage'] = $list["total_pages"];
		$this->ajaxResponse($data, "订单记录列表",0);
	}

	//果实兑换水晶
	public function changeCrystalAction(){
		$op = $this->request->getPost('op');
		$config = Config::findFirst("key = 'crystal'");
		if ($op == 'exchange'){
			if (empty($config)){
				$this->ajaxResponse('error','操作失败，该功能尚未开通','1');
			}
			$value = unserialize($config->value);
			if (empty($value)){
				$this->ajaxResponse('error','操作失败，管理员尚未设置套餐','1');
			}
			$info = $value['crystal'];
			$status = $info['status'] ? $info['status'] : 1;
			if ($status >1){
				$this->ajaxResponse('error','抱歉，当日水晶兑换已经结束','1');
			}
			$this->db->begin();
			if (!empty($info)){
				//扣除产品1
				$re1 = $this->dedProduct($info['pid1'],$this->userid,$info['num1']);
				//扣除产品2
				$re2 = $this->dedProduct($info['pid2'],$this->userid,$info['num2']);
				//扣除产品3
				$re3 = $this->dedProduct($info['pid3'],$this->userid,$info['num3']);
				//增加钻石
				$re4 = $this->addDiamond($this->userid,$info['crystal']);
			}
			//TODO:如果某一个扣除失败会报错
			$dis = OrchardUser::findFirst("uid = $this->userid");
			$diamonds = $dis->diamonds ? $dis->diamonds : 0;
			if (@$re1&&@$re2&&@$re3&&@$re4){
				$this->db->commit();
				$this->ajaxResponse("$diamonds",'兑换成功，水晶已经添加到您的账户,请注意查收','0');
			}else{
				$this->db->rollback();
				$this->ajaxResponse('error','产品不足','1');
			}
		}elseif ($op == 'info'){
			if (empty($config)){
				$this->ajaxResponse('error','该功能尚未开通','1');
			}
			$data = unserialize($config->value);
			$info['data']=[
				[
					'sid'=>$data['crystal']['pid1'],
					'num'=>$data['crystal']['num1'],
				],
				[
					'sid'=>$data['crystal']['pid2'],
					'num'=>$data['crystal']['num2']
				],
				[
					'sid'=>$data['crystal']['pid3'],
					'num'=>$data['crystal']['num3']
				],
			];
			$info['desc']=$data['crystal']['crystal'];
			$this->ajaxResponse($info,'请求成功，套餐设置参数返回','0');
		}
	}
	//检查用户产品信息是否充足
	public function dedProduct($sid,$uid,$num){
		$sql = "SELECT `number` FROM `dhc_user_product` WHERE uid = '{$uid}' AND sid ='{$sid}' FOR UPDATE ";
		$nums = $this->db->query($sql)->fetch();
		if (empty($nums)){
			$this->db->rollback();
			return false;
		}
		$userProductNumber = UserProduct::findFirst("uid = '{$uid}' AND sid = '{$sid}' AND number = ".$nums['number']);
		if (empty($userProductNumber)||$userProductNumber->number<$num){
			$this->db->rollback();
			$this->ajaxResponse('',"产品不足",'1');
		}
		$num1 = $userProductNumber->number;
		$userProductNumber->number -= $num;
		$userProductNumber->updatatime = TIMESTAMP;
		$mobile = $this->getUserMobile();
		$productName = $this->getProductName($sid);
		$re = $userProductNumber->update();
		if (!empty($re)){
			$this->saveOrchardLogs(["uid"=>$this->userid,'mobile'=>$mobile,'types'=>'dedgoods','msg'=>"原有产品{$num1}".'兑换水晶扣除'.$productName.$num."颗为".$userProductNumber->number,'nums'=>$num]);
			return true;
		}else{
			return false;
		}
	}
	public function addDiamond($uid,$num){
		$sql = "SELECT * FROM `dhc_orchard_user` WHERE uid = '{$uid}' FOR UPDATE ";
		$nums = $this->db->query($sql)->fetch();
		$userDiamond = OrchardUser::findFirst("uid = '{$uid}' AND diamonds = ".$nums['diamonds']);
		if (empty($userDiamond)){
			$this->db->rollback();
			return false;
		}
		$mobile = $this->getUserMobile();
		$userDiamond->diamonds += $num ;
		$re = $userDiamond->update();
		if (!empty($re)){
			$this->saveOrchardLogs(["uid"=>$this->userid,'mobile'=>$mobile,'types'=>'adddiamonds','msg'=>"用户现有水晶".$nums['diamonds'].'兑换水晶增加水晶'.$num."颗"."后为$userDiamond->diamonds",'nums'=>$num]);
		}
		return $re;
	}
	private function getUserMobile(){
		$item = User::findFirst("id = '{$this->userid}'");
		return $item->user;
	}
	private function getProductName($sid){
		$product = Product::findFirst("id = '{$sid}'");
		return $product->title;
	}

}
