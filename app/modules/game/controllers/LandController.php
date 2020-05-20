<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\Config;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardLand;
use Dhc\Models\OrchardGoods;
use Dhc\Models\OrchardLogs;
use Dhc\Models\Product;
use Phalcon\Http\Response;

class LandController extends ControllerBase{
	public function initialize() {
		$this->checkToken();
	}
	//土地信息返回
	public function indexAction() {
		$landInfo = $this->getLandInfo("","index");
		$this->ajaxResponse(array("farmItem"=>$landInfo), "土地信息返回", 0);
	}
	//土地单一信息返回
	public function getLandInfoAction(){
		$landId = $this->request->getPost("landId");
		$landInfo = $this->getLandInfo($landId,"index");
		$this->ajaxResponse(array("farmItem"=>$landInfo,"landId"=>$landId), "土地信息返回", 0);
	}
	//土地播种方法
	function addSeedAction(){
		if (USER_TYPE == 'yansheng'){
			$orchard = Config::findFirst("key = 'productConfig'");
			if (!empty($orchard)){
				$info = unserialize($orchard->value);
				if ($info['orchardStatus'] > 1){
					$this->ajaxResponse('','暂未开启土地种植，请等待',1);
				}
			}
		}
		if($this->request->isPost()){
			//参数信息
			$this->db->begin();
			$landId = $this->request->getPost("landId");
			$flag = $this->addSeed($landId);
			if($this->is_error($flag) || $flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "播种失败!{$flag['message']}", $flag["errno"]);
			}
			$this->db->commit();
			$this->ajaxResponse(array("landId"=>$landId,"farmItem"=>$this->getLandInfo($landId,"index")), "种子播种成功！", 0);
		}
		$this->ajaxResponse("", "种子播种通讯正常！", 1);
	}

	//土地施肥
	function fertilizeAction(){
		if($this->request->isPost()){
			$this->db->begin();
			$landId = $this->request->getPost("landId");
			$flag = $this->saveFertilize();
			if($flag == false || $this->is_error($flag)){
				$this->db->rollback();
				$this->ajaxResponse("", "土地施肥失败！{$flag['message']}", 1);
			}
			$this->db->commit();
			$this->ajaxResponse(array("landId"=>$landId,"farmItem"=>$this->getLandInfo($landId,"index")), "土地施肥成功！", 0);
		}
		$this->ajaxResponse("", "土地施肥通讯正常！", 1);
	}
	//土地收获
	function getFruitAction(){
		if($this->request->isPost()){
			$this->db->begin();
			$landId = $this->request->getPost("landId");
			$flag = $this->saveFruit($landId);
			if($flag === false || $this->is_error($flag)){
				$this->db->rollback();
				$this->ajaxResponse("", "果实收获失败！{$flag['message']}", 1);
			}elseif($flag == false){
				$flag = "0";
			}
			$this->db->commit();
			$this->ajaxResponse(array("landId"=>$landId,"farmItem"=>$this->getLandInfo($landId,"index"),"output"=>$flag), "果实收获成功！", 0);
		}
		$this->ajaxResponse("", "果实收获中！", 1);
	}

	//土地施肥
	function saveFertilize(){
		if($this->request->isPost()){
			$landId = $this->request->getPost("landId");
			if($landId <0){
				return $this->error(1,"施肥失败，土地信息不存在!");
			}
			$land = new OrchardLand();
			$land = $land->findFirst("uid='{$this->userid}' AND landId='{$landId}'");
			if($land == false){
				return $this->error(1,"施肥失败，土地信息不存在!!");
			}
			if(!@in_array($land->landStatus,array(1,2,3))){
				return $this->error(1,"暂时无法施肥！");
			}
			$cfert = $this->selectUser($this->userid,"cfert");
			if($cfert <=0){
				return $this->error(1,"施肥失败，化肥数量不足!");
			}

			// 先判断是否试过肥料
			if(empty($land->fertilize)){
				$data = "";
			}else{
				$data = json_decode($land->fertilize,true);
			}
			if(!empty($data[$land->landStatus])){
				return $this->error(1,"已经施肥，无需重复操作!");
			}
			// 再更新化肥
			$flag = $this->updateUser($this->userid, "cfert", 1,"ded");
			if($flag == false){
				return $this->error(1,"施肥失败，化肥数量更新失败!");
			}
			$goods = $this->getOneOrchardGoodsInfo("","6");
			$flag = $this->saveOrchardLogs(array("mobile"=>$land->mobile,"types"=>"dedcfert","nums"=>-1,"msg"=>"【{$landId}】号土地施肥扣除{$goods['tName']}1袋"));
			if($flag == false){
				return $this->error(1,"施肥失败，化肥数量日志更新失败!");
			}
			// 最后更新土地
			$data[$land->landStatus] = array(
				"effect"=>$goods["effect"],
				"createtime"=>TIMESTAMP
			);
			$product = $this->getOneProductInfo($land->goodsId);
			$landIinfotime = array($product["seedTime"] * 3600, $product["sproutingTime"] * 3600, $product["growTime"] * 3600);
			$addtime = 0;
			if(@in_array($land->landStatus,array(1))){
				$addtime = $landIinfotime[0] - (TIMESTAMP - $land->seedtime);
				$addtime = min($addtime,$landIinfotime[0]);
			}elseif(@in_array($land->landStatus,array(2))){
				if(!isset($data[1]["addtime"])){
					$data[1]["addtime"] = 0;
				}
				$addtime = $landIinfotime[1] - (TIMESTAMP - ($land->seedtime + $landIinfotime[0]-$data[1]["addtime"]));
				$addtime = min($addtime,$landIinfotime[1]);
			}elseif(@in_array($land->landStatus,array(3))){
				if(!isset($data[1]["addtime"])){
					$data[1]["addtime"] = 0;
				}
				if(!isset($data[2]["addtime"])){
					$data[2]["addtime"] = 0;
				}
				$addtime = $landIinfotime[2] - (TIMESTAMP - ($land->seedtime + $landIinfotime[0]-$data[1]["addtime"] +$landIinfotime[1]-$data[2]["addtime"]));
				$addtime = min($addtime,$landIinfotime[2]);//修复化肥时间错误闪动
			}
			if($addtime < $goods["effect"]){
				$data[$land->landStatus]["addtime"] = $addtime;
			}else{
				$data[$land->landStatus]["addtime"] = $goods["effect"];
			}
//			if(@in_array($land->landStatus,array(1,2,3))){
//				$addtime = 0;
//				foreach ($landIinfotime as $key => $value) {
//					if($land->landStatus > $key+1){
//						$addtime += $value;
//					}
//				}
//				$addtime = $landIinfotime[$land->landStatus -1] - (TIMESTAMP - $land->seedtime + $addtime);
//				if($addtime < $goods["effect"]){
//					$data[$land->landStatus]["addtime"] = $addtime;
//				}else{
//					$data[$land->landStatus]["addtime"] = $goods["effect"];
//				}
//			}
			$land->fertilize = json_encode($data);
			$land->optime = TIMESTAMP;
			$flag = $land->update();
			if($flag == false){
				return $this->error(1,"施肥失败，土地更新错误!");
			}
			return true;
		}
		return false;
	}
	//土地翻地操作
	function plowingAction(){
		if($this->request->isPost()){
			$this->db->begin();
			$mark = $this->request->getPost("mark");
			$landId = $this->request->getPost("landId");
			if($landId <0){
				$this->db->rollback();
				$this->ajaxResponse("", "翻地失败，土地信息获取失败！", 1);
			}
			$tId = $this->request->getPost("tId");
			$flag = $this->plowing($mark,$landId,$tId);
			if($this->is_error($flag) || $flag === false){
				$this->db->rollback();
				$farmItem = $this->getLandInfo($landId,"index");
				$this->ajaxResponse(array("landId"=>$landId,"farmItem"=>$farmItem), "翻地失败！{$flag['message']}！", 1);
			}
			$farmItem = $this->getLandInfo($landId,"index");
			//赠送黄宝石
			$topaz = $this->sendtopaz($tId);
			//宠物信息
			$dogInfo = $this->getDogInfo();
			if ($dogInfo["sowingTime"] > TIMESTAMP) {
				$flags = $this->addSeed($landId);
				if ($flags != false) {
					$farmItem = $this->getLandInfo($landId,"index");
				}
			}
			if($flag == " "){
				$flag = "";
			}
			$this->db->commit();
			$this->ajaxResponse(array("landId"=>$landId,"farmItem"=>$farmItem,"baoshi"=>$topaz["num"]>0?$topaz["num"]:0), "土地翻地成功{$flag}{$topaz['message']}！", 0);
		}
	}

	//土地操作
	function landOpAction(){
		if($this->request->isPost()){
			$dataInfo = array(
				"wcan"=>"浇水",
				"hcide"=>"除草",
				"icide"=>"除虫"
			);
			$this->db->begin();
			$landId = $this->request->getPost("landId");
			if($landId <0){
				$this->db->rollback();
				$this->ajaxResponse("", "土地信息获取失败，请重试！", 1);
			}
			$onoTitleInfo = $this->onoTitleInfo();
			$mark = $this->request->getPost("mark");
			if(empty($mark)){
				$this->db->rollback();
				$this->ajaxResponse("", "操作失败，信息获取失败！", 1);
			}
			if(!@in_array($mark,array("wcan","hcide","icide"))){
				$this->db->rollback();
				$this->ajaxResponse("", "{$dataInfo[$mark]}操作失败，请重试！", 1);
			}
			$land = new OrchardLand();
			$land = $land->findFirst("uid='{$this->userid}' AND landId='{$landId}'");
			if($land == false){
				$this->db->rollback();
				$this->ajaxResponse("", "操作失败，土地信息获取失败！！", 1);
			}
			if($land->$mark == $land->landStatus){
				$this->db->rollback();
				$this->ajaxResponse("", "暂时不用{$dataInfo[$mark]}！", 1);
			}
			$markNums = $this->selectUser($this->userid, $mark);
			if($markNums<=0){
				$this->db->rollback();
				$this->ajaxResponse("", "{$dataInfo[$mark]}操作失败，{$onoTitleInfo[$mark]}数量不足！", 1);
			}
			$land->$mark = $land->landStatus;
			$land->optime = TIMESTAMP;
			$flag = $land->update();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$dataInfo[$mark]}更新失败，{$onoTitleInfo[$mark]}使用失败！", 1);
			}
			$user = new OrchardUser();
			$user = $user->findFirst("uid='{$this->userid}' AND $mark ='{$markNums}'");
			if($user == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$onoTitleInfo[$mark]}信息获取失败！", 1);
			}
			$user->$mark -= 1;
			$user->updatetime = TIMESTAMP;
			$flag = $user->update();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$onoTitleInfo[$mark]}信息更新失败！", 1);
			}
			$flag = $this->saveOrchardLogs(array("mobile"=>$user->mobile,"types"=>"ded".$mark,"nums"=>-1,"landId"=>$landId,"msg"=>"【{$landId}】号土地{$dataInfo[$mark]}使用{$onoTitleInfo[$mark]}1个"));
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$onoTitleInfo[$mark]}操作日志更新失败！", 1);
			}
			$this->db->commit();
			$this->ajaxResponse(array("landId"=>$landId,"farmItem"=>$this->getLandInfo($landId,"index")), "{$dataInfo[$mark]}成功!", 0);
		}
	}
	//{$this->roseXinTitle}种植
	function addRoseAction(){
		if($this->request->isPost()){
			$this->db->begin();
			$landId = $this->request->getPost("landId");
			$landInfo = $this->getLandInfo($landId);
			if($landId == "" || empty($landInfo)){
				$this->db->rollback();
				$this->ajaxResponse("", "土地信息获取失败，无法播种", 1);
			}
			if(!@in_array($landInfo["landStatus"],array(1))){
				$this->db->rollback();
				$this->ajaxResponse("", "{$this->roseXinTitle}只可以在种子阶段可以播种", 1);
			}
			if($landInfo["landLevel"] <4){
				$this->db->rollback();
				$this->ajaxResponse("", "{$this->roseXinTitle}只可以在金土地或更高级土地上播种", 1);
			}
			if($landInfo["goodsNums"] ==1){
				$this->db->rollback();
				$this->ajaxResponse("", "已播种{$this->roseXinTitle}，无需重复播种！", 1);
			}
			//更新{$this->roseXinTitle}种子
			$user = new OrchardUser();
			$user = $user->findFirst("uid='{$this->userid}'");
			if($user == false || $user->roseSeed <=0){
				$this->db->rollback();
				$this->ajaxResponse("", "{$this->roseTitle}种子不足，无法播种", 1);
			}
			$user->roseSeed -=1;
			$user->optime = $user->seedtime = TIMESTAMP;
			$flag = $user->update();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$this->roseTitle}种子扣除失败，请重试！", 1);
			}
			//{$this->roseXinTitle}种子日志
			$flag = $this->saveOrchardLogs(array("mobile"=>$user->mobile,"landId"=>$landId,"types"=>"dedroseseed","nums"=>-1,"msg"=>"播种{$this->roseXinTitle}扣除1颗"));
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$this->roseTitle}种子扣除日志更新失败，请重试！", 1);
			}
			//获取{$this->roseTitle}信息
			$roseInfo =  $this->getSeedInfo("",$this->roseId);
			if($roseInfo == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$this->roseTitle}信息获取失败，请重试！", 1);
			}
			//土地信息更新
			$land = new OrchardLand();
			$land = $land->findFirst("uid='{$this->userid}' AND landId='{$landId}'");
			if($land == false){
				$this->db->rollback();
				$this->ajaxResponse("", "土地信息获取失败，请重试！", 1);
			}
			$land->goodsId = $roseInfo["id"];
			$land->goodsName = $roseInfo["title"];
			$land->goodsNums = 1;
			$land->fertilization = $land->plowing = 0;
			$land->wcan = $land->hcide = $land->icide = 1;
			$land->optime = $land->seedtime = TIMESTAMP;
			$flag = $land->update();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$this->roseXinTitle}播种失败，请重试！", 1);
			}
			$this->db->commit();
			$this->ajaxResponse("", "{$this->roseXinTitle}播种成功！", 0);
		}
		$this->ajaxResponse("", "{$this->roseXinTitle}播种通讯正常！", 0);
	}
	//好友互偷
	function friendsStealAction(){
		//自己等级
		$this->db->begin();
		$flag = $this->friendsSteal();
		if($flag == false || $this->is_error($flag)){
			if($this->is_error($flag)){
				$this->db->rollback();
			}else{
				$this->db->commit();
			}
			$this->ajaxResponse("", "偷取失败！{$flag['message']}", 1);
		}
		$this->db->commit();
		if($flag["message"] == ""){
			$this->ajaxResponse(['dog'=>$this->dogInfo()], "偷取成功！然而并没有获得更多！", 0);
		}else{
			$this->ajaxResponse(['dog'=>$this->dogInfo()], "偷取成功！获得{$flag['message']}", 0);
		}
	}
}
