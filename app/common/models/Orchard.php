<?php

namespace Dhc\Models;

class Orchard extends BaseModel{
	public $landUpInfo;

	public function initialize(){
		$this->setSource("dhc_orchard_config");
	}
		//材料类型
	public function getDuiType(){
		return [
			"0"=>"钻石",
			"1"=>"木材",
			"2"=>"石材",
			"3"=>"钢材",
		];
	}
		//材料类型
	public function getDuiTitle(){
		return [
			"0"=>"diamonds",
			"1"=>"wood",
			"2"=>"stone",
			"3"=>"steel",
		];
	}
		//材料类型
	public function getDuiDepict(){
		return [
			"0"=>"钻石",
			"1"=>"辛苦砍伐的木材，是建造房屋的必要材料。",
			"2"=>"精心打造的石材，是建造房屋的重要材料。",
			"3"=>"精工炼制的钢材，是建造房屋的贵重材料。",
		];
	}
	//神像类型
	public function getStatueType(){
		return [
			"1"=>"弑草之神",
			"2"=>"屠虫之神",
			"3"=>"雨露之神",
			"4"=>"丰收之神",
		];
	}
	//土地信息类型
	public function getLandType(){
		$data = array(
			"1"=>"普通土地",
			"2"=>"红土地",
			"3"=>"黑土地",
			"4"=>"金土地",
		);
		if(USER_TYPE == "duojin"){
			$data[5] = "紫土地";
//			$data[6] = "蓝土地";
		}
		if (USER_TYPE == 'chuangjin'|| USER_TYPE == 'nong'){
			$data[5] = "紫土地";
			$data[6] = "蓝土地";
		}
	
		return $data;
	}
	//土地信息描述
	public function getLandDepict(){
		if (USER_TYPE == 'huangjin'){
			$data = array(
				"1"=>"最不值钱的土地。",
				"2"=>"改良过的土地，可以种植4种不同的作物，能种出黄瓜、白菜、葡萄、哈密瓜这四种常见作物。",
				"3"=>"少见的肥沃土地，可以产出多种不同的作物，能种出黄瓜、白菜、葡萄、哈密瓜、柚子、樱桃这六种常见作物。",
				"4"=>"神秘的金土地，可以种出具有神奇功能的水晶花，不仅能种出六种常见作物，所有作物(专属果实需达到指定级数)。",
			);
		}else{
			$data = array(
				"1"=>"最不值钱的土地。",
				"2"=>"少有的土地，能种出萝卜、苹果、辣椒、西瓜这四种常见作物。",
				"3"=>"珍贵的土地，能种出萝卜、苹果、辣椒、西瓜、南瓜、草莓这六种常见作物。",
				"4"=>"罕见的土地，不仅能种出六种常见作物，还能种出神秘作物玫瑰。",
			);
		}
		if(USER_TYPE == "duojin" ){
			$data[5] = "新增的紫土地";
//			$data[6] = "新增的蓝土地";
		}
		if (USER_TYPE =='chuangjin' || USER_TYPE == 'nong'){
			$data[5] = "新增的紫土地";
			$data[6] = "新增的蓝土地";
		}
	
		return $data;
	}
	//背景类型
	function getBackgroundType(){
		return [
			"1"=>"初始背景",
			"2"=>"田园风格",
			"3"=>"城市风光",
			"4"=>"沙滩风光",
		];
	}
	//管理员操作信息
	function getAdminType(){
		$data = array(
			"diamonds"=>"金币",
			"wood"=>"木材",
			"stone"=>"石材",
			"steel"=>"钢材",
			"choe"=>"铜锄头",
			"shoe"=>"银锄头",
			"cchest"=>"铜宝箱",
			"schest"=>"银宝箱",
			"gchest"=>"金宝箱",
			"dchest"=>"钻石宝箱",
			"cfert"=>"化肥",
			"wcan"=>"洒水壶",
			"hcide"=>"除草剂",
			"icide"=>"除虫剂",
			"emerald"=>"绿宝石",
			"purplegem"=>"紫宝石",
			"sapphire"=>"蓝宝石",
			"topaz"=>"黄宝石",
            'redcard'=>'红土地卡',
            'blackcard'=>'黑土地卡',
            'goldcard'=>'金土地卡'
		);
		if(USER_TYPE == "huangjin"){
			$data["diamonds"] = "水晶";
		}
		return $data;
	}
	//7级土地红以上修改概率
	function getSuperInfo(){
		return array(2,3,4,5,6,7,8,9,10,11,12);
	}

	/**
	 * 获取不同类型土地单块价格
	 * @param $landUpInfo
	 * @return array
	 */
	public function getLandPrice($landUpInfo) {
		$landUpInfo = json_decode($landUpInfo, true);
		$data = [];
		foreach ($landUpInfo as $key=>$cost){
			$data[$key]['price'] = 0;
			foreach ($cost as $item){
				if(empty($item['pid'])){
					$data[$key]['price'] += sprintf('%.4f',$item['num'] / 100);
				}else{
					$price = Dailydate::findFirst([
						'conditions'	=> "sid = '{$item['pid']}'",
						'columns'		=> 'OpeningPrice',
						'order'			=> 'id DESC'
					]);
					$data[$key]['price'] += $price['OpeningPrice'] * $item['num'];
				}
			}
		}
		return $data;
	}
}
