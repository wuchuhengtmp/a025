<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\OrchardDog;
use Dhc\Models\Orchard;
use Dhc\Models\OrchardGoods;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardLogs;
use Phalcon\Http\Response;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
class DogController extends ControllerBase{
	public $config = array();

	public function initialize() {
		$this->checkToken();
		$this->config = $this->getConfig("dogInfo");
	}
	//宠物信息列表返回
	public function indexAction(){
		$listDog = $this->checkDog();
//		if($listDog == false){
//			$this->ajaxResponse("", "用户尚未宠物，请领取宠物!", 1);
//		}
//		$data = array();
//		foreach ($listDog as $key => $value) {
//			$data[] = array(
//				"id"=>$value["id"],
//				"dogName"=>$value["dogName"],
//				"dogLevel"=>$value["dogLevel"],
//				"experience"=>$value["experience"],
//				"experienceUlimit"=>$this->config["experience"][$value["dogLevel"]],
//				"power"=>$value["power"],
//				"powerUlimit"=>$value["powerUlimit"],
//				"otherInfo"=>json_decode($value["otherInfo"],true),
//				"score"=>$value["score"]
//			);
//		}
		$data = $this->dogListInfo();
		if(empty($data)){
			$this->ajaxResponse("", "用户尚未领取宠物，请领取宠物!", 1);
		}
		//当前宠物信息
		$curentDog = $this->dogInfo();
		//狗粮信息
		$dogfood = $this->selectUser($this->userid,"dogfood");
		$dataInfo = array(
			"list"=>$data,
			"current"=>$curentDog["id"]>0?$curentDog["id"]:0,
			"food"=>array(
				array(
					"foodId"=>1,
					"foodType"=>10,
					"foodNum"=>  $dogfood["dogFood1"],
					),
				array(
					"foodId"=>2,
					"foodType"=>10,
					"foodNum"=>  $dogfood["dogFood2"],
					),
			)
		);
		$this->ajaxResponse($dataInfo, "用户宠物列表及属性返回!", 0);
	}
	public function getDogSkillInfoAction(){
		$data = $this->getDogSkillInfo();
		if($data == false){
			$this->ajaxResponse("", "宠物技能信息获取失败!!", 1);
		}
		$this->ajaxResponse($data, "宠物技能信息返回成功!!", 0);
	}
	public function getDogSkillInfo(){
		$dog = new OrchardDog();
		$dogInfo = $dog->findFirst("uid={$this->userid}  AND status=1 AND isDel=0 order by id desc");
		$dogInfo = $this->object2array($dogInfo);
		if (empty($dogInfo)) {
			return false;
		}
		$config = $this->getConfig("dogInfo");
		$harvest = array(
			"leftTime"=>$dogInfo["harvestTime"] > time() ? $dogInfo["harvestTime"] - time() : 0,
			"paused"=>false
		);
		if($dogInfo["harvestTime"] ==0){
			$data1 = $this->autoLogsAction("autoHarvest",$dogInfo["id"]);
			if($this->is_error($data1)){
			}elseif($data1["type"] ==2 && $data1["time"]>0){
				$harvest["leftTime"] = $data1["time"];
				$harvest["paused"] = true;
			}
		}
		$planting = array(
			"leftTime"=>$dogInfo["sowingTime"] > time() ? $dogInfo["sowingTime"] - time() : 0,
			"paused"=>false
		);
		if($dogInfo["sowingTime"] ==0){
			$data2 = $this->autoLogsAction("autoSow",$dogInfo["id"]);
			if($this->is_error($data2)){
			}elseif($data2["type"] ==2 && $data2["time"]>0){
				$planting["leftTime"] = $data2["time"];
				$planting["paused"] = true;
			}
		}
		$data = array("skillInfo"=>array(
			"harvest"=>array(
				"canUse"=>$dogInfo["harvestTime"] > time()?false:true,
				"leftTime"=>$harvest["leftTime"],
				"maxTime"=>($config["skill"][1]+($dogInfo["dogLevel"]-1)*$config["skill"][3])*3600,
				"paused"=>$harvest["paused"]
			),
			"planting"=>array(
				"canUse"=>$dogInfo["sowingTime"] > time()?false:true,
				"leftTime"=>$planting["leftTime"],
				"maxTime"=>($config["skill"][2]+($dogInfo["dogLevel"]-1)*$config["skill"][3])*3600,
				"paused"=>$planting["paused"]
			),
			"roseHeart"=>array(
				"canUse"=>$dogInfo["speed"]>=$config["skill"][0]?true:false,
				"num"=>0,
				"point"=>$dogInfo["speed"],
				"pointMax"=>$config["skill"][0],
			),
		));
		return $data;
	}
	//宠物信息
	public function dogInfoAction(){
		$data = $this->dogInfo();
		if(empty($data)){
			$this->ajaxResponse("", "宠物信息不存在!!", 1);
		}
		$this->ajaxResponse($data, "宠物信息返回成功!!", 0);
	}

	//狗粮信息
	public function getDogFoodAction(){
		$data = $this->selectUser($this->userid,"dogfood");
		$this->ajaxResponse($data, "宠物狗粮信息数据返回成功!!", 0);
	}
	//喂狗粮增加属性
	public function feedDogFoodAction(){
		if($this->request->isPost()){
			$data = $this->selectUser($this->userid,"dogfood");
			$this->db->begin();
			$flag = true;
			$user = OrchardUser::findFirst("uid='{$this->userid}'");
			$goodsNum = max(1,$this->request->getPost("nums"));
			if($goodsNum%$this->config["num"] != 0){
				$this->db->rollback();
				$this->ajaxResponse("", "数量不足无法喂食,每次喂食{$this->config['num']}份狗粮!!", 1);
			}
			$goodsNum = intval($goodsNum/$this->config["num"]);
			if($this->request->getPost("type") == '2' && $data["dogFood2"] - ($this->config["num"]*$goodsNum)>=0){
				$user->dogFood2 = $data["dogFood2"]-($this->config["num"]*$goodsNum);
			}elseif($this->request->getPost("type") == '1' && $data["dogFood1"] - ($this->config["num"]*$goodsNum)>=0){
				$user->dogFood1 = $data["dogFood1"]-($this->config["num"]*$goodsNum);
			}else{
				$this->db->rollback();
				$this->ajaxResponse("", "宠物狗粮不足或操作失败!!", 1);
			}
			$user->updatetime = TIMESTAMP;
			$flag = $user->update();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "宠物喂食操作失败!!!", 1);
			}
			$flag = $this->saveOrchardLogs(array("uid"=>$this->userid,"mobile"=>$user->mobile,"types"=>"deddogfood".$this->request->getPost("type"),"nums"=>-($this->config["num"]*$goodsNum),"msg"=>"喂食宠物扣除狗粮".($this->config["num"]*$goodsNum)."袋"));
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "宠物喂食更新日志失败!!", 1);
			}
			$flag = $this->saveDogInfo($goodsNum);
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "宠物属性更新失败!!", 1);
			}
			$this->db->commit();
			$this->ajaxResponse(['dog'=>$this->dogInfo(),"roseheart"=>$flag['speed']], "宠物喂食操作成功!!", 0);
		}
	}
	//宠物训练 操作
	public function trainDogAction(){
		$this->db->begin();
		$dog = new OrchardDog();
		$dogInfo = $dog->findFirst("uid={$this->userid} AND status=1 AND isDel=0 order by id desc");
		if($dogInfo == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物信息获取失败!!!", 1);
		}
		if($dogInfo->power < $this->config["power"][3]){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物体力不足!!!", 1);
		}
		$dogInfo->power -= $this->config["power"][3];
		if($dogInfo->power<=0){
			$dogInfo->power = 0;
		}
		$dogInfo->optime = TIMESTAMP;
		$flag = $dogInfo->update();
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物体力更新失败!!!", 1);
		}
		$otherInfo = $this->upgradeOthderInfo(json_decode($dogInfo->otherInfo,true));
		$flag = $this->saveOrchardLogs(array("uid"=>$this->userid,"mobile"=>$dogInfo->mobile,"types"=>"powerInfo","nums"=>-$this->config["power"][0],"msg"=>"宠物训练扣除体力".$this->config["power"][0]."点","dataInfo"=>  json_encode(array("otherInfo"=>$otherInfo,"dogId"=>$dogInfo->id))));
		if($otherInfo == false || $flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物体力更新失败!!!", 1);
		}
		$this->db->commit();
		$dogInfo->otherInfo = json_decode($dogInfo->otherInfo, true);
		$otherInfo['hp'] = $dogInfo->powerUlimit+$otherInfo["isUpPower"];
		$data = [
			'dog' => $this->dogInfo(),
			'newAttrs' => $otherInfo,
			'shouldConfirm' => true,
		];
		$this->ajaxResponse($data, "宠物训练数据返回成功!!!", 0);
	}
	//宠物训练 操作确认 取消直接关闭
	public function trainDogOkAction(){
		$this->db->begin();
		$logs = new OrchardLogs();
		$logsInfo = $logs->findFirst("uid={$this->userid} AND types='powerInfo' AND dataInfo !='' AND status=1 order by id desc");
		$otherInfo = json_decode($logsInfo->dataInfo,true);
		if(empty($otherInfo["dogId"])){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物属性更新失败!!!", 1);
		}
		$dog = new OrchardDog();
		$dog = $dog->findFirst("id='{$otherInfo['dogId']}' AND uid='{$this->userid}'");
		if($dog == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物属性更新失败!!", 1);
		}
		$dog->powerUlimit += $otherInfo["otherInfo"]["isUpPower"];
		unset($otherInfo["otherInfo"]["isUpPower"]);
		$dog->otherInfo = json_encode($otherInfo["otherInfo"]);
		$dog->optime = TIMESTAMP;
		$dog->score = $this->countScore($otherInfo["otherInfo"], $dog->id,$dog->dogLevel);
		$flag = $dog->update();
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物属性更新失败!", 1);
		}
		$this->db->commit();
		$data = [
			'dog' => $this->dogInfo(),
		];
		$this->ajaxResponse($data, "宠物属性更新成功!", 0);
	}
	//更新宠物属性
	public function saveDogInfo($goodsNum =1){
		$mt = rand(1,3);
		$speed = 0;
		$dog = new OrchardDog();
		$dogInfo = $dog->findFirst("uid={$this->userid} AND status=1 AND isDel=0 order by id desc");
		if(!empty($this->config["experience"][$dogInfo->dogLevel]) && $this->config["experience"][$dogInfo->dogLevel]>0){
			$dogInfo->experience += 1*$goodsNum;
		}
		if($mt==1){
			$otherInfo = json_decode($dogInfo->otherInfo,true);
			$otherInfo["lucky"] += $this->config["lucky"][2]*$goodsNum;
			$dogInfo->score = $this->countScore($otherInfo, $dogInfo->id,$dogInfo->dogLevel);
			$dogInfo->otherInfo = json_encode($otherInfo);
		}
		$this->config["skill"][4] = $this->config["skill"][4]<=0?1:intval($this->config["skill"][4]);
		$this->config["skill"][5] = $this->config["skill"][5]<=0?1:intval($this->config["skill"][5]);
		$dogInfo->speed += rand($this->config["skill"][4], $this->config["skill"][5])*$goodsNum;
		if($dogInfo->speed >= $this->config['skill'][0]){
			$dogInfo->speed = 0;
			$user = new OrchardUser();
			$user = $user->findFirst("uid='{$this->userid}' order by id desc");
			$user->roseSeed +=1;
			$flag = $user->update();
			if($flag == false){
				return false;
			}
			$flag = $this->saveOrchardLogs(array("uid"=>$this->userid,"mobile"=>$dogInfo->mobile,"types"=>"giverose","nums"=>1,"msg"=>"喂食宠物{$this->roseTitle}值满".$this->config["skill"][0]."获得{$this->roseTitle}种子1枚"));
			if($flag == false){
				return false;
			}
			$speed =1;
		}
		if(!empty($this->config["experience"][$dogInfo->dogLevel]) && $dogInfo->experience>=$this->config["experience"][$dogInfo->dogLevel] &&  $this->config["experience"][$dogInfo->dogLevel]>0){
			$userGrade = $this->selectUser($this->userid, "grade");
			if($dogInfo->dogLevel+3>$userGrade){
				$dogInfo->experience = $this->config["experience"][$dogInfo->dogLevel];
			}else{
				//检测 用户喂食升级几级
				$dogData = $this->saveDogLevle($dogInfo,$this->config["experience"]);
				$dogInfo->experience = $dogData["experience"];
				$dogInfo->dogLevel +=$dogData["level"];
				$dogInfo->powerUlimit += $this->config["power"][2]*$dogData["level"] + rand(1, 10)*10*$dogData["level"];
				$otherInfo = $this->upgradeOthderInfo(json_decode($dogInfo->otherInfo,true),$dogInfo->dogLevel);
				$dogInfo->score = $this->countScore($otherInfo, $dogInfo->id,$dogInfo->dogLevel);
				$dogInfo->otherInfo = json_encode($otherInfo);
			}
		}
		$dogInfo->power += $this->config["power"][0]*$goodsNum;
		if($dogInfo->power >= $dogInfo->powerUlimit){
			$dogInfo->power = $dogInfo->powerUlimit;
		}
		$dogInfo->optime = TIMESTAMP;
		$flag =  $dogInfo->update();
		if($flag == false){
			return false;
		}
		return array("speed"=>$speed);
	}
	//喂食跨级升级
	public function saveDogLevle($dogInfo,$config){
		$data = array(
			"level"=>1,
			"experience"=>0
		);
		if(USER_TYPE == "huangjin"){
			$data["level"] = 0;
			$level = $dogInfo->dogLevel;
			foreach ($config as $key => $value) {
				if($key>=$level && $dogInfo->experience>= $value){
					$dogInfo->experience -= $value;
					$data["experience"]  = $dogInfo->experience;
					$level += 1;
					$data["level"] +=1;
				}elseif($dogInfo->experience<$value){
					break;
				}
			}
			if($level>=10){
				$data["experience"] = 0;
			}
		}
		return $data;
	}
	//{$this->roseXinTitle} 获取
	public function getRoseAction(){
		$this->db->begin();
		$dog = new OrchardDog();
		$dogInfo = $dog->findFirst("uid={$this->userid} AND status=1 AND isDel=0 order by id desc");
		if($dogInfo->speed< $this->config['skill'][0]){
			$this->db->rollback();
			$this->ajaxResponse("", "{$this->roseXinTitle}领取失败!", 1);
		}
		$dogInfo->speed = 0;
		$dogInfo->optime = TIMESTAMP;
		$flag = $dogInfo->update();
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物信息更新失败!", 1);
		}
		$user = new OrchardUser();
		$user = $user->findFirst("uid='{$this->userid}' order by id desc");
		$user->roseSeed +=1;
		$user->updatetime = TIMESTAMP;
		$flag = $user->update();
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "{$this->roseXinTitle}更新失败!", 1);
		}
		$flag = $this->saveOrchardLogs(array("uid"=>$this->userid,"mobile"=>$user->mobile,"types"=>"giverose","nums"=>1,"msg"=>"喂食宠物{$this->roseTitle}值满".$this->config["skill"][0]."获得{$this->roseXinTitle}1枚"));
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "{$this->roseXinTitle}记录更新失败!", 1);
		}
		$this->db->commit();
		$this->ajaxResponse("", "{$this->roseXinTitle}获取成功!", 0);
	}
	//添加宠物
	public function addDogAction(){
		$this->db->begin();
		$re = $this->addDog();
		if($this->is_error($re) || $re == false){
			$this->db->rollback();
			$this->ajaxResponse("", "添加失败!{$re["message"]}", 1);
		}
		$this->db->commit();
		$this->ajaxResponse("", "宠物信息更新成功", 0);
	}
	//添加宠物 系统赠送或商场购买兑换添加
	public function addDog($tId = ""){
		$goodsId =$tId;
		$config = $this->config;
		if(empty($config)){
			$config = $this->getConfig("dogInfo");
		}
		$dogName = $this->request->getPost("dogName")?$this->request->getPost("dogName"):"松狮";
		if(empty($dogName) && empty($goodsId)){
			return $this->error(1,"请先添加宠物昵称!");
		}
		$uplimit = $config["uplimit"];
		if(!empty($goodsId)){
			$config = $this->getDogGoodsInfo($goodsId);
			$dogName = $this->getDogGoodsInfo($goodsId,"tName");
		}else{
			$goodsId = 0;
		}
		if(empty($config)){
			return $this->error(1,"宠物添加失败!");
		}
		if(empty($this->userid)){
			$this->checkToken();
		}
		$userInfo = $this->selectUser($this->userid);
		$dog = new OrchardDog();
		if($goodsId == 0){
			$item = $dog->findFirst("uid='{$this->userid}' AND goodsId='{$goodsId}' AND status=1 AND isDel=0");
			if(!empty($item)){
				return $this->error(1,"宠物已存在!");
			}
		}
		if($uplimit>0){
			$dogList = $dog->find("uid= '{$this->userid}' AND isDel=0");
			$dogList = $this->object2array($dogList);
			if(count($dogList)>=$uplimit){
				return $this->error(1,"用户宠物数量超出限制!");
			}
		}
		$dog->uid = $this->userid;
		$dog->nickname = $userInfo["userName"];
		$dog->mobile = $userInfo["mobile"];
		if(!empty($goodsId)){
			$dog->goodsId = $goodsId;
		}
		$dog->dogName = $dogName;
		$dog->powerUlimit = $config["power"][1];
		$dog->status =0;
		if(!empty($goodsId)){
			$other = array(
				"lucky"=>$config["lucky"][1]+  rand(0, $config["lucky"][1]),
				"attack"=>array(
					"min"=>$config["attack"][1]["min"]+  rand(0, $config["attack"][1]["max"]-$config["attack"][1]["min"]),
					"max"=>$config["attack"][1]["max"]+  rand(0, $config["attack"][1]["max"]),
				),
				"defense"=>array(
					"min"=>$config["defense"][1]["min"]+  rand(0, $config["defense"][1]["max"]-$config["defense"][1]["min"]),
					"max"=>$config["defense"][1]["max"]+  rand(0, $config["defense"][1]["max"]),
				),
				"speed"=>array(
					"min"=>$config["speed"][1]["min"]+  rand(0, $config["speed"][1]["max"]-$config["speed"][1]["min"]),
					"max"=>$config["speed"][1]["max"]+  rand(0, $config["speed"][1]["max"]),
				),
			);
		}else{
			$other = array(
				"lucky"=>$config["lucky"][1],
				"attack"=>$config["attack"][1],
				"defense"=>$config["defense"][1],
				"speed"=>$config["speed"][1],
			);
		}
		$dog->otherInfo = json_encode($other);
		$dog->createtime = $dog->updatetime = $dog->optime = TIMESTAMP;
		$dog->score = $this->countScore($other);
		$flag = $dog->save();
		if($flag == false){
			return $this->error(1,"宠物更新失败!");
		}
		return true;
	}
	//选中 宠物 进行 选中 或 删除  id type
	public function dogSelectAction(){
		if ($this->request->isPost()) {
			$id = $this->request->getPost("id");
			if($id<=0){
				$this->ajaxResponse("", "选择宠物失败!", 1);
			}
			$this->db->begin();
			$dog = new OrchardDog();
			$item = $dog->findFirst("id='{$id}' AND uid={$this->userid} AND isDel=0");
			$item = $this->object2array($item);
			if(empty($item)){
				$this->db->rollback();
				$this->ajaxResponse("", "当前宠物不存在，无法选择!", 1);
			}
			if($this->request->getPost("type") == 'select'){
				$flag = $this->dogStatus($id);
				$msg = "放出";
			}elseif($this->request->getPost("type") == 'delete'){
				$flag = $this->dogDelete($id);
				$msg = "放弃";
			}else{
				$this->db->rollback();
				$this->ajaxResponse("", "当前操作不支持！!", 1);
			}
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", $msg."宠物失败!", 1);
			}else{
				$this->db->commit();
				$this->ajaxResponse("", $msg."宠物成功!", 0);
			}
		}
	}
	//选中 宠物执行方法
	public function dogStatus($id){
		$dog = new OrchardDog();
		$listDog = $dog->find("uid={$this->userid} AND isDel=0");
		$listDog = $this->object2array($listDog);
		if(!empty($listDog)){
			foreach ($listDog as $value) {
				$dog = new OrchardDog();
				$item = $dog->findFirst("id={$value['id']}");
				if($item->id == $id){
					$item->status = 1;
				}else{
					$item->status = 0;
				}
				$item->optime = $item->updatetime = TIMESTAMP;
				$flag = $item->update();
				if($flag == false){
					return false;
				}
			}
		}
		return true;
	}
	//删除 宠物执行方法
	public function dogDelete($id){
		$dog = new OrchardDog();
		$listDog = $dog->findFirst("id='{$id}' AND uid={$this->userid} AND isDel=0");
		if(empty($listDog)){
			return false;
		}
		$listDog->isDel = 1;
		$listDog->optime = $listDog->updatetime =  TIMESTAMP;
		$flag = $listDog->update();
		if($flag == false){
			return false;
		}
		return true;
	}



	//获取宠物商品信息
	public function getDogGoodsInfo($goodsId,$type = ""){
		$goods = new OrchardGoods();
		$goods = $goods->findFirst("tId={$goodsId}");
		if(empty($goods)){
			return false;
		}
		$goods = $this->object2array($goods);
		if(!empty($type)){
			return $goods[$type];
		}else{
			return json_decode($goods["chanceInfo"],true);
		}
	}
	//开启自动收获
	function autoHarvestAction(){
		$updatetime = strtotime(date("Y-m-d",time()));
		$dog = $this->checkDog("default");
		$this->db->begin();
		$dog = new OrchardDog();
		$dog = $dog->findFirst("uid='{$this->userid}' AND status=1 AND isDel=0");
		if($dog == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物信息获取失败!", 1);
		}
		$data = $this->autoLogsAction("autoHarvest",$dog->id);
		if($this->is_error($data)){
			$this->db->rollback();
			$this->ajaxResponse("", $data["message"], 1);
		}
		$config = $this->getConfig("dogInfo");
		$types = $this->request->getPost("types");
		if(USER_TYPE == 'huangjin' && $types != "stop" && $dog->harvestTime>$updatetime){
			$logs = new OrchardLogs();
			$logsInfo = $logs->findFirst("uid='{$this->userid}' AND landId='{$dog->id}' AND types='autoHarvest' AND nums=1 ORDER BY id desc");
			if(!empty($logsInfo) && $logsInfo->createtime+24*3600>=TIMESTAMP){
				$this->db->rollback();
				$this->ajaxResponse("", "宠物冷却时间尚未到期!", 1);
			}
		}elseif($dog->harvestTime>$updatetime && $types != "stop" && USER_TYPE != 'huangjin' && USER_TYPE != "jindao"){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物今日不可开启自动收获功能!", 1);
		}
		$harvestTime = 0;
		if($types == "stop" && $dog->harvestTime> 0){
			$harvestTime = $dog->harvestTime - TIMESTAMP;
			$dog->harvestTime = 0;
			$txt = "暂停";
		}else{
			$starttime = strtotime(date('Y-m-d', time()));
			if($data["time"]>0 && $data["optime"]> $starttime){
				if(time() >$data["time"] +  $data["optime"]){
					$harvestTime = ($config["skill"][1]+($dog->dogLevel-1)*$config["skill"][3])*3600;
					$dog->harvestTime = TIMESTAMP + ($config["skill"][1]+($dog->dogLevel-1)*$config["skill"][3])*3600;
					$data["type"] =1;
				}else{
					$harvestTime = $data["time"];
					$dog->harvestTime = TIMESTAMP + $data["time"];
				}
				$txt = "重启";
			}elseif($types != "stop"){
				$harvestTime = ($config["skill"][1]+($dog->dogLevel-1)*$config["skill"][3])*3600;
				$dog->harvestTime = TIMESTAMP + ($config["skill"][1]+($dog->dogLevel-1)*$config["skill"][3])*3600;
				$data["type"] =1;
				$txt = "开启";
			}
		}
		if(!@in_array($txt,array("暂停","重启","开启"))){
			$this->db->rollback();
			$this->ajaxResponse("", "未知操作!", 1);
		}
		if($dog->power < 10 && USER_TYPE != "haonongfu"){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物体力不足，无法{$txt}!", 1);
		}
		$dog->optime = TIMESTAMP;
		$flag = $dog->update();
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物自动收获功能开启失败，请重试!", 1);
		}
		$flag = $this->saveOrchardLogs(
			array("uid"=>  $this->userid,
				"mobile"=>$dog->mobile,
				"landId"=>$dog->id,
				"types"=>"autoHarvest",
				"dataInfo"=>json_encode(array("time"=>$harvestTime,"optime"=>$dog->optime)),"nums"=>$data["type"],"msg"=>"宠物自动收获功能{$txt}操作成功"));
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物自动收获功能操作日志更新失败，请重试!", 1);
		}
		$this->db->commit();
		$data = $this->getDogSkillInfo();
		$this->ajaxResponse($data, "宠物成功{$txt}自动收获功能!", 0);
	}
	//日志记录暂停开启重启
	function autoLogsAction($types,$dogId){
		if(!@in_array($types,array("autoHarvest","autoSow"))){
			return $this->error(1,"操作异常，请联系管理员");
		}
		$logs = new OrchardLogs();
		$logsInfo = $logs->findFirst("uid='{$this->userid}' AND landId='{$dogId}' AND types='{$types}' ORDER BY id desc");
		if(empty($logsInfo) || $logsInfo == false){
			return array("type"=>1,"msg"=>"可开启","time"=>0,"createtime"=>0);
		}
		$dataInfo = json_decode($logsInfo->dataInfo,true);
		if($dataInfo["time"]>0){
			return array("type"=>2,"msg"=>"可开启","time"=>$dataInfo["time"],"optime"=>$dataInfo["optime"]);
		}
		return true;
	}
	//开启自动播种
	function autoSowAction(){
		$updatetime = strtotime(date("Y-m-d",time()));
		$dog = $this->checkDog("default");
		$this->db->begin();
		$dog = new OrchardDog();
		$dog = $dog->findFirst("uid='{$this->userid}' AND status=1 AND isDel=0");
		if($dog == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物信息获取失败!", 1);
		}
		$data = $this->autoLogsAction("autoSow",$dog->id);
		if($this->is_error($data)){
			$this->db->rollback();
			$this->ajaxResponse("", $data["message"], 1);
		}
		$config = $this->getConfig("dogInfo");
		$types = $this->request->getPost("types");
//		if($dog->sowingTime>$updatetime && $types != "stop" && USER_TYPE != 'huangjin'){
//			$this->db->rollback();
//			$this->ajaxResponse("", "宠物今日不可开启自动播种功能!", 1);
//		}
		if(USER_TYPE == 'huangjin' && $types != "stop" && $dog->sowingTime>$updatetime){
			$logs = new OrchardLogs();
			$logsInfo = $logs->findFirst("uid='{$this->userid}' AND landId='{$dog->id}' AND types='autoSow' AND nums=1 ORDER BY id desc");
			if(!empty($logsInfo) && $logsInfo->createtime+24*3600>=TIMESTAMP){
				$this->db->rollback();
				$this->ajaxResponse("", "宠物冷却时间尚未到期!", 1);
			}
		}elseif($dog->sowingTime>$updatetime && $types != "stop" && USER_TYPE != 'huangjin' && USER_TYPE != "jindao"){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物今日不可开启自动收获功能!", 1);
		}
		$sowingTime = 0;
		if($types == "stop" && $dog->sowingTime>0){
			$sowingTime = $dog->sowingTime - TIMESTAMP;
			$dog->sowingTime = 0;
			$txt = "暂停";
		}else{
			$starttime = strtotime(date('Y-m-d', time()));
			if($data["time"]>0 && $data["optime"]> $starttime){
				if(time() >$data["time"] +  $data["optime"]){
					$sowingTime = ($config["skill"][1]+($dog->dogLevel-1)*$config["skill"][3])*3600;
					$dog->sowingTime = TIMESTAMP + ($config["skill"][1]+($dog->dogLevel-1)*$config["skill"][3])*3600;
					$data["type"] =1;
				}else{
					$sowingTime = $data["time"];
					$dog->sowingTime = TIMESTAMP + $data["time"];
				}
				$txt = "重启";
			}elseif($types != "stop"){
				$sowingTime = ($config["skill"][1]+($dog->dogLevel-1)*$config["skill"][3])*3600;
				$dog->sowingTime = TIMESTAMP + ($config["skill"][1]+($dog->dogLevel-1)*$config["skill"][3])*3600;
				$data["type"] =1;
				$txt = "开启";
			}
		}
		if(!@in_array($txt,array("暂停","重启","开启"))){
			$this->db->rollback();
			$this->ajaxResponse("", "未知操作!", 1);
		}
		if($dog->power < 10 && USER_TYPE != "haonongfu"){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物体力不足，无法{$txt}!", 1);
		}
		$dog->optime = TIMESTAMP;
		$flag = $dog->update();
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物自动播种功能{$txt}失败，请重试!", 1);
		}
		$flag = $this->saveOrchardLogs(array("uid"=>  $this->userid,"mobile"=>$dog->mobile,"landId"=>$dog->id,"types"=>"autoSow","dataInfo"=>json_encode(array("time"=>$sowingTime,"optime"=>$dog->optime)),"nums"=>$data["type"],"msg"=>"宠物自动播种功能{$txt}操作成功"));
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "宠物自动播种功能操作日志更新失败，请重试!", 1);
		}
		$this->db->commit();
		$data = $this->getDogSkillInfo();
		$this->ajaxResponse($data, "宠物成功{$txt}自动播种功能!", 0);
	}
}
