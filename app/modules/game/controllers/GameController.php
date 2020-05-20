<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\OrchardGoods;
use Phalcon\Http\Response;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
class GameController extends ControllerBase{
	public function initialize() {
		$this->checkToken();
	}
	/**
	 * 获取游戏道具商品
	 */
	public function getToolsAction() {
		$orchardGoods = new OrchardGoods();
		$goodsList = $orchardGoods->find(
			array(
				'conditions' => "status=1 AND isDel=0",
				'columns'=>'tId,type,tName,price,depict,cost,pack,buyOut,effect,reclaimLimit,seedUser,seedShop',
				'order'	=> ' type asc,price asc,tId asc'
			));
		$goodsList = $this->object2array($goodsList);
		$data = array();
		if(!empty($goodsList)){
			foreach ($goodsList as $key => $value) {
				if($value["price"] - intval($value["price"]) == 0){
					$value["price"] = intval($value["price"]);
				}
				if($value["type"] ==1){
					unset($value["reclaimLimit"],$value["cost"],$value["seedUser"],$value["seedShop"],$value["effect"]);
					$value["type"] = 4;
					$total = $this->getFruitTotalNums();
					$value["total"] =$total[1];
					$price = $this->getfruitNewPrice();//种子最新价格根据大盘交易更新
					if($price>0){
						$value["price"] = $price*100;
					}
					$data["tools"][0][] = $value;
				}elseif($value["type"] == 5){
					unset($value["cost"],$value["buyOut"],$value["pack"],$value["seedUser"],$value["seedShop"],$value["effect"]);
					$value["type"] = 6;
					$data["tools"][3][] = $value;
				}elseif($value["type"] == 3){
					unset($value["reclaimLimit"],$value["buyOut"],$value["pack"],$value["seedUser"],$value["seedShop"],$value["effect"]);
					$value["type"] = 4;
					$value["cost"] = json_decode($value["cost"], true);
					$data["tools"][2][] = $value;
				}elseif(@in_array($value['type'],array(4,6,7,8,9,10,11,12,15)) || (USER_TYPE == "yansheng" && @in_array($value['type'],array(14)))|| (USER_TYPE == 'chuangjin' && @in_array($value['type'],array(13)))){
					if(@in_array($value["type"],array(4))){
						unset($value["cost"],$value["effect"],$value["buyOut"]);
					}else{
						unset($value["reclaimLimit"],$value["cost"],$value["pack"],$value["buyOut"],$value["seedUser"],$value["seedShop"]);
					}
					if(@in_array($value["type"],array(10,11,12,13,14))){
						$value["type"] = 3;
					}else{
						$value["type"] = 4;
					}
					$data["tools"][1][] = $value;
				}
			}
		}
        if(empty($data["tools"][2])){
            $data["tools"][2]=array();
        }
		$data = array_merge($data["tools"][0],$data["tools"][1],$data["tools"][2],$data["tools"][3]);
//		$total = $this->getFruitTotalNums();
//		$data["total"] =$total[1];
		$this->ajaxResponse($data, "游戏道具信息返回",0);
	}
}
