<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\Orchard;
use Dhc\Models\OrchardGoods;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardStatue;
use Dhc\Models\Product;
use Dhc\Models\UserProduct;
use Phalcon\Http\Response;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

class GiftController extends ControllerBase{
	public function initialize() {
		$this->checkToken();
	}
	/**
	 * 获取gift
	 */
	public function getListAction() {
		$data['gift'][0] = $this->getGift1();//获取 材料兑换信息
		$data['gift'][1] = $this->getGift2();//获取神像兑换信息
		$data['gift'][2] = $this->getGift3();//获取 风格兑换信息
		$data['gift'][3] = $this->getGift4();//获取狗粮兑换信息
		$data = array_merge($data["gift"][0],$data["gift"][1],$data["gift"][2],$data["gift"][3]);
		$this->ajaxResponse($data, "礼物兑换列表",0);
	}
	//获取 材料兑换信息
	public function getGift1(){
		$orchard = new Orchard();
		$getDuiType = $orchard->getDuiType();
		$getDuiDepict = $orchard->getDuiDepict();
		$duiInfo = $this->getConfig("duiInfo");
		$data = array();
		$dataInfo = $this->getUserProductInfo("sid");
		if(!empty($duiInfo)){
			foreach ($duiInfo as $key => $value) {
				$cost = [];
				foreach ($value as $k => $val) {
					//关联产品读取
					$product = new Product();
					$productInfo = $product->findFirst("id={$val['pid']}");
					$productInfo = $this->object2array($productInfo);
					$cost[] = array(
						"tId"=>$val["pid"],
						"tName"=>$productInfo["title"],
						"depict"=>$productInfo["depict"],
						"type"=>1,
						"price"=>$val["num"],
						"num"=>!empty($dataInfo[$val["pid"]])?$dataInfo[$val["pid"]]["number"]:"0"
					);
				}
				$data[] = array(
					"tId"=>$key,
					"tName"=>$getDuiType[$key],
					"depict"=>$getDuiDepict[$key],
					"type"=>2,
					"cost"=>$cost
				);
			}
		}
		return $data;
	}
	//获取神像兑换信息
	public function getGift2(){
		$orchard = new Orchard();
		$statueInfo = $this->getConfig("statueInfo");
		$data = array();
		$dataInfo = $this->selectUser($this->userid, "statueInfo");
		foreach ($statueInfo as $key => $value) {
			$cost = array();
			//关联产品读取
			$OrchardGoods = new OrchardGoods();
			$goodsInfo = $OrchardGoods->findFirst("tId={$value['tId']}");
			$goodsInfo = $this->object2array($goodsInfo);
			if(!empty($goodsInfo)){
				$cost[] = array(
					"tId"=>$value["tId"],
					"tName"=>$goodsInfo["tName"],
					"depict"=>$goodsInfo["depict"],
					"type"=>3,
					"price"=>$value["price"],
					"num"=>$dataInfo[$key]["nums"],
				);
			}
			$data[] = array(
				"tId"=>$key,
				"tName"=>$value["tName"],
				"depict"=>$value["depict"],
				"type"=>5,
				"cost"=>$cost
			);
		}
		return $data;
	}
	//获取 风格兑换信息
	public function getGift3(){
		$orchard = new Orchard();
		$backgroundType = $orchard->getBackgroundType();
		$data = array();
		$background = $this->getConfig("background");
		$diamonds = $this->selectUser($this->userid, "diamonds");
		$dataInfo = $this->getUserProductInfo("sid");
		if(!empty($background)){
			foreach ($background as $key => $value) {
				$goods = array();
				foreach ($value as $k => $val) {
					//关联产品读取
					if(!empty($val['pid'])){
						$product = new Product();
						$productInfo = $product->findFirst("id={$val['pid']}");
						$productInfo = $this->object2array($productInfo);
						if(!empty($productInfo)){
							$goods[] = array(
								"tId"=>$val["pid"],
								"tName"=>$productInfo["title"],
								"depict"=>$productInfo["depict"],
								"type"=>1,
								"price"=>$val["num"],
								"num"=>!empty($dataInfo[$val["pid"]])?$dataInfo[$val["pid"]]["number"]:"0"
							);
						}
					}else{
						$goods[] = array(
							"tId"=>"999",
							"tName"=>"{$this->zuanshiTitle}",
							"depict"=>"可用来购买商城中的物品，也可兑换背景，升级房屋和土地",
							"type"=>999,
							"price"=>$val["num"],
							"num"=>!empty($diamonds)?$diamonds:"0"
						);
					}
				}
				$cost = array(
					"tId"=>$key,
					"tName"=>$backgroundType[$key],
					"depict"=>"",
					"type"=>7,
					"cost"=>$goods,
				);
				$data[] = $cost;
			}
		}
		return $data;
	}
	//获取狗粮兑换信息
	public function getGift4(){
		$orchard = new Orchard();
		$dogInfo = $this->getConfig("dogInfo");
		$data = array();
		$dataInfo = $this->getUserProductInfo("sid");
		foreach($dogInfo["info"] as $key=>$value){
			$cost = array();
			//关联产品读取
			$product = new Product();
			$productInfo = $product->findFirst("id={$value['pid']}");
			$productInfo = $this->object2array($productInfo);
			if(!empty($productInfo)){
				$cost[] = array(
					"tId"=>$value["pid"],
					"tName"=>$productInfo["title"],
					"depict"=>$productInfo["depict"],
					"type"=>1,
					"stock"=>1,
					"price"=>$value["num"],
					"num"=>!empty($dataInfo[$value["pid"]])?$dataInfo[$value["pid"]]["number"]:"0"
				);
			}
			$data[] = array(
				"tId"=>$key,
				"tName"=>$value["tName"],
				"depict"=>$value["depict"],
				"type"=>10,
				"cost"=>$cost
			);
		}
		return $data;
	}
	//材料兑换 1 //神像兑换 2 //狗粮兑换 4
	public function exchangeAction(){
		if($this->request->isPost()){
			$data = $this->request->getPost();
			if(empty($data["type"])){
				$this->ajaxResponse("", "具体兑换信息异常，无法兑换！",1);
			}
			if($data["type"] ==2){
				$this->duiInfo();
			}elseif($data["type"] ==5){
				$this->statueInfo();
			}elseif($data["type"] ==7){
				$this->backgroundInfo();
			}elseif($data["type"] ==10){
				$this->dogInfo();
			}else{
				$this->ajaxResponse("", "兑换失败！",1);
			}
		}
	}
	//材料管理兑换
	public function duiInfo(){
		$this->db->begin();
		if($this->request->getPost("type") != 2){
			$this->db->rollback();
			$this->ajaxResponse("", "兑换失败！",1);
		}
		$config = $this->getConfig("duiInfo");
		$duiId = $this->request->getPost("id");//材料ID
		$userInfo = $this->selectUser($this->userid,"exchange");
		$dataInfo = $this->getUserProductInfo("sid");
		if(empty($dataInfo) || empty($config[$duiId]) || empty($userInfo[$duiId])){
			$this->db->rollback();
			$this->ajaxResponse("", "材料信息不足无法兑换！",1);
		}
		if($duiId<=0 || $duiId>3){
			$this->db->rollback();
			$this->ajaxResponse("", "材料信息不存在兑换失败！",1);
		}
		$duiNum = max(1,$this->request->getPost("nums"));
		$data = array();
		foreach ($config[$duiId] as $key => $value) {
			if(empty($dataInfo[$value['pid']]) || $value["num"]*$duiNum >$dataInfo[$value['pid']]["number"]){
				$this->db->rollback();
				$this->ajaxResponse("", "材料信息不足兑换失败！",1);
			}
			$data[$value["pid"]] = array(
				"num"=>$value["num"]*$duiNum,
				"duiNum"=>$duiNum,
				"pid"=>$value["pid"],
				"goodsName"=>$dataInfo[$value["pid"]]["goodsName"]
			);
		}
		//操作用户道具
		$user = new OrchardUser();
		$user = $user->findFirst("uid='{$this->userid}'");
		$model = $userInfo[$duiId]["mark"];
		$user->$model += $duiNum;
		$flag = $user->update();
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "{$userInfo[$duiId]["title"]}材料信息更新失败！",1);
		}
		foreach ($data as $key => $value) {
			//更新道具日志
			$flag = $this->saveOrchardLogs(array("mobile"=>$userInfo[$duiId]["mobile"],"types"=>"add".$userInfo[$duiId]["mark"],"nums"=>$duiNum,"msg"=>"兑换中心兑换".$userInfo[$duiId]["title"]."*".$duiNum."扣除".$value["goodsName"].$value["num"]."颗"));
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$userInfo[$duiId]["title"]}材料信息日志更新失败！",1);
			}
			//操作用户果实
			$product = new UserProduct();
			$product = $product->findFirst("uid='{$this->userid}' AND sid='{$value['pid']}'");
			$product->number -= $value["num"];
			$flag = $product->update();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$value["goodsName"]}扣除信息更新失败！",1);
			}
			//更新果实日志
			$flag = $this->saveOrchardLogs(array("mobile"=>$userInfo[$duiId]["mobile"],"types"=>"dedgoods","landId"=>$value["pid"],"nums"=>-$value["num"],"msg"=>"兑换中心扣除".$value["goodsName"].$value["num"]."颗兑换".$userInfo[$duiId]["title"]."*".$duiNum));
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$value["goodsName"]}扣除信息日志更新失败！",1);
			}
		}
		$this->db->commit();
		$this->ajaxResponse("", "{$userInfo[$duiId]["title"]}兑换成功！",0);
	}
	//神像管理兑换操作
	public function statueInfo(){
		$this->db->begin();
		if($this->request->getPost("type") != 5){
			$this->db->rollback();
			$this->ajaxResponse("", "兑换失败！",1);
		}
		$config = $this->getConfig("statueInfo");
		$dataInfo = $this->selectUser($this->userid, "statueInfo");
		$statueId = $this->request->getPost("id");//神像ID
		if($statueId<=0 || $statueId>count($config)){
			$this->db->rollback();
			$this->ajaxResponse("", "神像信息不存在兑换失败！",1);
		}
		$duiNum = max(1,$this->request->getPost("nums"));
		if($duiNum*$config[$statueId]["price"]>$dataInfo[$statueId]["nums"]){
			$this->db->rollback();
			$this->ajaxResponse("", "{$dataInfo[$statueId]["title"]}材料不足暂无法进行兑换！",1);
		}
		$user = new OrchardUser();
		$user = $user->findFirst("uid='{$this->userid}'");
		$model = $dataInfo[$statueId]["mark"];
		$user->$model -= intval($duiNum*$config[$statueId]["price"]);
		$user->updatetime = TIMESTAMP;
		$flag = $user->update();
		$this->getSqlError($flag, $user);
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "{$dataInfo[$statueId]["title"]}材料操作更新失败,请重试！",1);
		}
		$flag = $this->saveOrchardLogs(array("mobile"=>$dataInfo[$statueId]["mobile"],"types"=>"ded".$dataInfo[$statueId]["mark"],"nums"=>-$duiNum*$config[$statueId]["price"],"msg"=>"兑换".$config[$statueId]["tName"]."*".$duiNum."扣除".$dataInfo[$statueId]["title"].($duiNum*$config[$statueId]["price"])."颗"));
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "{$dataInfo[$statueId]["title"]}材料更新日志失败,请重试！",1);
		}
		$statue = new OrchardStatue();
		$item = $statue ->findFirst("uid='{$this->userid}' AND model='{$dataInfo[$statueId]["mark"]}'");
		if($item != false){
			$item->nums += $duiNum;
			if($item->lasttime>=time()){
				//尚未过期，又购买
				$item->lasttime += $duiNum*$config[$statueId]["time"]*3600;
			}else{
				$item->lasttime = TIMESTAMP + $duiNum*$config[$statueId]["time"]*3600;
			}
			$item->updatetime = TIMESTAMP;
			$flag = $item->update();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$config[$statueId]["tName"]}更新失败,请重试！",1);
			}
		}else{
			$statue->uid = $this->userid;
			$statue->model = $dataInfo[$statueId]["mark"];
			$statue->statueName = $config[$statueId]["tName"];
			$statue->nums = $duiNum;
			$statue->createtime = $statue->updatetime = TIMESTAMP;
			$statue->lasttime = time()+$duiNum*$config[$statueId]["time"]*3600;
			$flag = $statue->save();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$config[$statueId]["tName"]}添加失败,请重试！",1);
			}
		}
		$this->db->commit();
		$data["joss"] = $this->selectStatueInfo();
		$this->ajaxResponse($data, "{$config[$statueId]["tName"]}更新成功！",0);
	}
	//游戏背景兑换
	public function backgroundInfo(){
		$orchard = new Orchard();
		$backgroundType = $orchard->getBackgroundType();
		$this->db->begin();
		if($this->request->getPost("type") != 7){
			$this->db->rollback();
			$this->ajaxResponse("", "兑换失败！",1);
		}
		$bId = $this->request->getPost("id");//背景ID 2 3 4
		$config = $this->getConfig("background");
		if($bId<=0 || empty($config[$bId])){
			$this->db->rollback();
			$this->ajaxResponse("", "兑换失败！",1);
		}
		$dataInfo = $this->getUserProductInfo("sid");
		foreach ($config[$bId] as $key => $value) {
			if(!empty($value['pid'])){
				$product = $this->getOneProductInfo($value["pid"]);
				if(empty($dataInfo[$value["pid"]])|| $dataInfo[$value["pid"]]["number"]<$value["num"]){
					$this->db->rollback();
					$this->ajaxResponse("", "兑换{$backgroundType[$bId]}背景兑换失败！{$product['title']}数量不足",1);
				}
				$flag = $this->saveProduct($value["pid"], $value["num"],"ded");
				if($flag == false){
					$this->db->rollback();
					$this->ajaxResponse("", "兑换{$backgroundType[$bId]}背景兑换失败！{$product['title']}更新失败",1);
				}
				$flag1 = $this->saveOrchardLogs(array("mobile"=>$this->mobile,"types"=>"dedgoods","landId"=>$value["pid"],"nums"=>-$value["num"],"msg"=>"兑换{$backgroundType[$bId]}背景扣除".$product['title'].$value["num"]."颗"));
				if($flag1 == false){
					$this->db->rollback();
					$this->ajaxResponse("", "兑换{$backgroundType[$bId]}背景兑换失败！{$product['title']}更新日志失败",1);
				}
			}else{
				$diamonds = $this->selectUser($this->userid, "diamonds");
				if($diamonds<$value["num"]){
					$this->db->rollback();
					$this->ajaxResponse("", "兑换{$backgroundType[$bId]}背景兑换失败！{$this->zuanshiTitle}不足",1);
				}
				$flag = $this->updateUser($this->userid, "diamonds", $value["num"],"ded");
				if($flag == false){
					$this->db->rollback();
					$this->ajaxResponse("", "兑换{$backgroundType[$bId]}背景兑换失败！{$this->zuanshiTitle}更新不足",1);
				}
				$flag1 =$this->saveOrchardLogs(array("mobile"=>$this->mobile,"types"=>"deddiamonds","nums"=>-$value["num"],"msg"=>"兑换{$backgroundType[$bId]}背景扣除{$this->zuanshiTitle}".$value["num"]));
				if($flag1 == false){
					$this->db->rollback();
					$this->ajaxResponse("", "兑换{$backgroundType[$bId]}背景兑换失败！{$this->zuanshiTitle}更新日志失败",1);
				}
			}
		}
		$flag = $this->saveUserBackground($bId);
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "兑换{$backgroundType[$bId]}背景失败！",1);
		}
		$this->db->commit();
		$this->ajaxResponse("", "兑换{$backgroundType[$bId]}背景兑换成功！",0);
	}
	//狗粮管理兑换
	public function dogInfo(){
		$this->db->begin();
		if($this->request->getPost("type") != 10){
			$this->db->rollback();
			$this->ajaxResponse("", "兑换失败！",1);
		}
		$config = $this->getConfig("dogInfo");
		$duiId = $this->request->getPost("id");//狗粮ID
		$dataInfo = $this->getUserProductInfo("sid");
		if($duiId<=0 || empty($config["info"][$duiId])){
			$this->db->rollback();
			$this->ajaxResponse("", "暂无法兑换该材料！",1);
		}
		//兑换数量默认1及验证
		$duiNum = max(1,$this->request->getPost("nums"));
		if(empty($dataInfo[$config["info"][$duiId]["pid"]]) || $duiNum*$config["info"][$duiId]["num"]>$dataInfo[$config["info"][$duiId]["pid"]]["number"]){
			$this->db->rollback();
			$this->ajaxResponse("", "{$dataInfo[$config["info"][$duiId]["pid"]]["goodsName"]}材料不足，暂无法兑换{$config["info"][$duiId]["tName"]}！",1);
		}
		//用户狗粮信息更新
		$user = new OrchardUser();
		$user = $user->findFirst("uid='{$this->userid}'");
		$model = "dogFood".$duiId;
		$user->$model += $duiNum;
		$user->updatetime =TIMESTAMP;
		$flag = $user->update();
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "兑换{$config["info"][$duiId]["tName"]}操作失败，请重试！！",1);
		}
		//更新用户狗粮日志
		$flag = $this->saveOrchardLogs(array("mobile"=>$user->mobile,"nums"=>$duiNum,"types"=>"add".$model,"msg"=>"兑换{$config["info"][$duiId]["tName"]}*{$duiNum}扣除{$dataInfo[$config["info"][$duiId]["pid"]]["goodsName"]}".($duiNum*$config["info"][$duiId]["num"])."颗"));
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "更新{$config["info"][$duiId]["tName"]}日志操作失败，请重试！！",1);
		}
		//操作商品扣除
		$flag = $this->saveProduct($config["info"][$duiId]["pid"], $duiNum*$config["info"][$duiId]["num"], "ded");
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "更新{$dataInfo[$config["info"][$duiId]["pid"]]["goodsName"]}操作失败，请重试！！",1);
		}
		//更新商品操作日志
		$flag = $this->saveOrchardLogs(array("mobile"=>$user->mobile,"nums"=>-$duiNum*$config["info"][$duiId]["num"],"types"=>"dedgoods","landId"=>$config["info"][$duiId]["pid"],"msg"=>"扣除{$dataInfo[$config["info"][$duiId]["pid"]]["goodsName"]}".($duiNum*$config["info"][$duiId]["num"])."颗兑换{$config["info"][$duiId]["tName"]}*{$duiNum}"));
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "更新{$dataInfo[$config["info"][$duiId]["pid"]]["goodsName"]}日志操作失败，请重试！！",1);
		}
		$this->db->commit();
		$this->ajaxResponse("", "兑换{$config["info"][$duiId]["tName"]}*{$duiNum}操作成功！！！",0);
	}
}
