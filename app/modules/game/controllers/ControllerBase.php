<?php

namespace Dhc\Modules\Game\Controllers;

use Dhc\Models\Order;
use Dhc\Models\User;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardLogs;
use Dhc\Models\Orchard;
use Dhc\Models\OrchardDog;
use Dhc\Models\OrchardLand;
use Dhc\Models\OrchardGoods;
use Dhc\Models\OrchardOrder;
use Dhc\Models\UserProduct;
use Dhc\Models\OrchardStatue;
use Dhc\Models\OrchardSign;
use Dhc\Models\OrchardBackground;
use Dhc\Models\OrchardDoubleEffect;
use Dhc\Models\OrchardHailFellow;
use Dhc\Models\OrchardPackage;
use Dhc\Models\OrchardSteal;
use Dhc\Models\OrchardDowngrade;
use Dhc\Models\Product;
use Dhc\Models\UserCost;
use Dhc\Models\UserLog;
use Dhc\Models\TradeLogs;
use Phalcon\Mvc\Controller;

date_default_timezone_set('Asia/Shanghai');
class ControllerBase extends Controller
{
	public $userid = 0;
	public $mobile = "";
	public $user = array();
	public $seedId = 1;
	public $seedNums = 100;
	public $roseId = 80011;
	public $kuguaId = 80010;
	public $kuguazhiId = 17;
	public $limitRoseNums = array(
		"limit"=>5,//金岛
		"random"=>array(1,2),//金岛产生玫瑰种子随机量
	);
	public $choeId = 2;
	public $shoeId = 3;

	// TODO 短信不能写死
	public $sendMessage ="";
	public $zuanshiTitle = "金币";

	public function initialize() {
	}

	public function ajaxResponse($data = '', $msg = '', $code = '0') {
		$response = [
			'data' => $data,
			'msg' => $msg,
			'code' => $code,
			"sysTime" => TIMESTAMP
		];
		echo json_encode($response, JSON_UNESCAPED_UNICODE);
		exit;
	}

	public function createUrl($segment = 'index/index', $params = array()) {
		$url = "/" . trim($segment, '/') . "/";
		if (!empty($params)) {
			$queryString = http_build_query($params, '', '&');
			$url .= $queryString;
		}
		return $url;
	}

	public function createToken($uid, $timestamp) {
		$user = new User();
		$salt = $user->findFirst(
			array(
				'conditions' => "id = $uid",
				'columns' => 'salt'
			)
		);
		$userSalt = $salt->salt;
		$cipherText = $this->encrypt($uid . $timestamp . $userSalt, 'E', 'dj');
		$token = base64_encode($uid . '_' . $timestamp . '_' . $cipherText);
		return $token;
	}

	public function checkToken() {
		global $_W;
		if(USER_TYPE == "huangjin"){
			$this->zuanshiTitle = "水晶";
			$this->roseXinTitle = "水晶之心";
			$this->roseTitle = "水晶花";
		}else{
			$this->zuanshiTitle = "金币";
			$this->roseXinTitle = "玫瑰之心";
			$this->roseTitle = "玫瑰";
		}
		//测试数据
		if ($this->request->getPost("debug") == true) {
			$this->userid = 702;
			$this->mobile = "18749320615";
			return true;
		}
//		if(!empty($this->request->getPost("token"))){
//			$token = $this->request->getPost("token");
//		}else{
			$token = @$_SERVER['HTTP_TOKEN'];
			$tokenWeb = @$this->request->getPost("token")?@$this->request->getPost("token"):@$this->request->get("token");
			if (empty($token) && empty($tokenWeb)) {
				$this->ajaxResponse("", "您需要重新登录！", 403);
			}
			if(!empty($tokenWeb)){
				list($uid, $time,$code) = explode("_",base64_decode($tokenWeb));
				$token = base64_encode($tokenWeb."_".$uid);
			}
//		}
		$token = base64_decode($token);
		list($authcode, $uid) = explode("_", $token);
		if (empty($token) || empty($authcode) || empty($uid)) {
			$this->ajaxResponse("", "您需要重新登录！", 403);
		}
		$user = new User();
		$resAuthcode = $user->findFirst(
			array(
				'conditions' => "id = $uid",
				'columns' => 'user,token,status'
			)
		);
		$resAuthcode = $this->object2array($resAuthcode);
		if (!empty($resAuthcode) && $resAuthcode["token"] === $authcode) {
			if ($resAuthcode["status"] == 9) {
				$this->ajaxResponse("", "此账号已停用，请登录！", 403);
			} else {
				$this->userid = $uid;
				$this->mobile = $resAuthcode["user"];
				return true;
			}
		} else {
			$this->ajaxResponse("", "您需要重新登录！", 403);
		}
	}

	protected function encrypt($string, $operation, $key = '') {
		$key = md5($key);
		$key_length = strlen($key);
		$string = $operation == 'D' ? base64_decode($string) : substr(md5($string . $key), 0, 8) . $string;
		$string_length = strlen($string);
		$rndkey = $box = array();
		$result = '';
		for ($i = 0; $i <= 255; $i++) {
			$rndkey[$i] = ord($key[$i % $key_length]);
			$box[$i] = $i;
		}
		for ($j = $i = 0; $i < 256; $i++) {
			$j = ($j + $box[$i] + $rndkey[$i]) % 256;
			$tmp = $box[$i];
			$box[$i] = $box[$j];
			$box[$j] = $tmp;
		}
		for ($a = $j = $i = 0; $i < $string_length; $i++) {
			$a = ($a + 1) % 256;
			$j = ($j + $box[$a]) % 256;
			$tmp = $box[$a];
			$box[$a] = $box[$j];
			$box[$j] = $tmp;
			$result .= chr(ord($string[$i]) ^ ($box[($box[$a] + $box[$j]) % 256]));
		}
		if ($operation == 'D') {
			if (substr($result, 0, 8) == substr(md5(substr($result, 8) . $key), 0, 8)) {
				return substr($result, 8);
			} else {
				return '';
			}
		} else {
			return str_replace('=', '', base64_encode($result));
		}
	}

	public function create_salt($length = '') {
		$chars = '0123456789';
		$salt = '';
		for ($i = 0; $i < $length; $i++) {
			$salt .= $chars[mt_rand(0, strlen($chars) - 1)];
		}
		return $salt;
	}

	function object2array(&$object) {
		$object = json_decode(json_encode($object), true);
		return $object;
	}

	public function getSqlError($flag, $obj) {
		if ($flag == false) {
			foreach ($obj->getMessages() as $message) {
				echo $message . '<br>';
			}
			die;
		}
	}

	//更新用户数据
	function updateUser($uid, $title = "", $nums = "", $type = "add") {
		if (empty($uid)) {
			$uid = $this->userid;
		}
		$user = new OrchardUser();
		$user = $user->findFirst("uid='{$uid}'");
		if (empty($user)) {
			return false;
		}
		if ($type == "add") {
			$user->$title += $nums;
		} else {
			$user->$title -= $nums;
		}
		$user->updatetime = TIMESTAMP;
		return $user->update();
	}

	//查找果园会员信息
	function selectUser($uid = "", $type = "user") {
		if (empty($uid)) {
			$uid = $this->userid;
		}
		if (empty($uid)) {
			return false;
//			$this->ajaxResponse('', "请登录","403");
		}
		$user = new OrchardUser();
		$user = $user->findFirst("uid='{$uid}'");
		$user = $this->object2array($user);
		if (empty($user)) {
			return false;
//			$this->ajaxResponse('', "用户尚未创建角色，请创建","9");
		}
		if ($type == "user") {
			return array(
				"uid" => $user["uid"],
				"mobile" => $user["mobile"],
				"userName" => $user["nickname"],
				"diamonds" => $user["diamonds"],
				"level" => $user["grade"]
			);
		} elseif ($type == 'dogfood') {
			return array(
				"uid" => $user["uid"],
				"mobile" => $user["mobile"],
				"dogFood1" => $user["dogFood1"],
				"dogFood2" => $user["dogFood2"]
			);
		} elseif ($type == "houseInfo") {
			return array(
				"uid" => $user["uid"],
				"mobile" => $user["mobile"],
				"diamonds" => $user["diamonds"],
				"grade" => $user["grade"],
				"wood" => $user["wood"],
				"stone" => $user["stone"],
				"steel" => $user["steel"],
				"kuguazhi"=>$user["kuguazhi"],
			);
		} elseif ($type == "statueInfo") {
			return array(
				"1" => array(
					"title" => "绿宝石",
					"nums" => $user["emerald"],
					"mark" => "emerald",
					"mobile" => $user["mobile"],
				),
				"2" => array(
					"title" => "紫宝石",
					"nums" => $user["purplegem"],
					"mark" => "purplegem",
					"mobile" => $user["mobile"],
				),
				"3" => array(
					"title" => "蓝宝石",
					"nums" => $user["sapphire"],
					"mark" => "sapphire",
					"mobile" => $user["mobile"],
				),
				"4" => array(
					"title" => "黄宝石",
					"nums" => $user["topaz"],
					"mark" => "topaz",
					"mobile" => $user["mobile"],
				)
			);
		} elseif ($type == "exchange") {
			return array(
				"1" => array(
					"title" => "木材",
					"mark" => "wood",
					"mobile" => $user["mobile"],
				),
				"2" => array(
					"title" => "石材",
					"mark" => "stone",
					"mobile" => $user["mobile"],
				),
				"3" => array(
					"title" => "钢材",
					"mark" => "steel",
					"mobile" => $user["mobile"],
				)
			);
		} elseif ($type == "index") {
			return array(
			    "mobile"=>$user['mobile'],
				"houseLv" => $user["grade"],
				"skinId" => $user["skin"],
				"avatar" => $user["avatar"],
				"userId" => $user["uid"],
				"wood" => $user["wood"],
				"steel" => $user["steel"],
				"stone" => $user["stone"],
				"diamond" => $user["diamonds"],
				"nickName" => $user["nickname"],
				"amount" => $this->selectUserInfo($this->userid, "coing"),
			);
		} elseif ($type == 'all') {
			return $user;
		} elseif (!empty($type)) {
			return $user[$type];
		}
	}

	//系统会员账号信息
	function selectUserInfo($uid, $type = "") {
		if (empty($uid)) {
			$this->ajaxResponse('', "玩家ID不能为空", 1);
		}
		$user = new User();
		$user = $user->findFirst("id='{$uid}'");
		$user = $this->object2array($user);
		if (!empty($type)) {
			return $user[$type];
		} else {
			return $user;
		}
	}

	//时间倒计时
	function time2second($seconds) {
		$seconds = (int)$seconds;
		$format_time = explode(' ', gmstrftime('%d %H %M %S', $seconds));
		$time = "";
		if ($format_time[0] - 1 > 0) {
			$time .= floor($seconds / (24 * 3600)) . "天";
		}

		if ($format_time[1] > 0) {
			$time .= intval($format_time[1]) . "时";
		}
		if ($format_time[2] > 0) {
			$time .= intval($format_time[2]) . "分";
		}
		if ($format_time[3] > 0) {
			$time .= intval($format_time[3]) . "秒";
		}
		return $time;
	}

	//操作日志记录
	function saveOrchardLogs($data = array()) {
		$logs = new OrchardLogs();
		if (empty($data["uid"])) {
			$data["uid"] = $this->userid;
		}
		$logs->uid = $data["uid"];
		if (!empty($data["disUid"])) {
			$logs->disUid = $data["disUid"];
		}
		if (isset($data["landId"]) && $data["landId"] !== "") {
			$logs->landId = $data["landId"];
		}
		$logs->mobile = $data["mobile"];
		$logs->types = $data["types"];
		$logs->nums = $data["nums"];
		$logs->msg = $data["msg"];
		if (!empty($data["dataInfo"])) {
			$logs->dataInfo = $data["dataInfo"];
		}
		$logs->createtime = TIMESTAMP;
		$logs->status = !empty($data["status"])?$data["status"]:1;
		return $logs->save();
	}

	//参数配置信息返回
	function getConfig($type = "", $true = "") {
		$config = new Orchard();
		$config = $config->findFirst("id=1");
		$config = $this->object2array($config);
		if(@in_array($type,array("status"))){
			return $config["status"];
		}
		if (!empty($config[$type])) {
			if ($true == "true") {
				return array_values(json_decode($config[$type], true));
			} else {
				return json_decode($config[$type], true);
			}
		}
		return $config;
	}

	//错误返回
	function error($errno, $message = '') {
		return array(
			'errno' => $errno,
			'message' => $message,
		);
	}

	//错误检测
	function is_error($data) {
		if (empty($data) || !is_array($data) || !array_key_exists('errno', $data) || (array_key_exists('errno', $data) && $data['errno'] == 0)) {
			return false;
		} else {
			return true;
		}
	}

	//查看会员果园果实数量
	function getUserProductInfo($keyfield = "sid", $goodsId = "") {
		$product = new UserProduct();
		if (!empty($goodsId)) {
			$condition = " AND sid='{$goodsId}'";
		} else {
			$condition = "";
		}
		$list = $product->find([
			'conditions' => "uid='{$this->userid}'" . $condition,
			'order' => 'id DESC'
		]);
		$list = $this->object2array($list);
		if (!empty($list)) {
			foreach ($list as $key => &$value) {
				$goods = new Product();
				$goodsInfo = $goods->findFirst(array(
					'conditions' => "id = {$value['sid']} ",
					'columns' => 'title'
				));
				if (!empty($goodsInfo->title)) {
					$value["goodsName"] = $goodsInfo->title;
				} else {
					$value["goodsName"] = "";
				}
			}
		}
		$list = $this->getArrayKey($list, $keyfield);
		if ($goodsId > 0 && !empty($list[$goodsId])) {
			return $list[$goodsId];
		} else {
			return $list;
		}
	}

	//数组调整key值
	function getArrayKey($list, $keyfield = "") {
		if (!empty($list)) {
			$rs = array();
			foreach ($list as $key => $value) {
				if (isset($value[$keyfield])) {
					$rs[$value[$keyfield]] = $value;
				} else {
					$rs[] = $value;
				}
			}
			$list = $rs;
		}
		return $list;
	}

	//一对一属性表
	function onoInfo() {
		return array(
			"11" => "seed",//普通种子
			"24" => "choe",//铜锄头
			"34" => "shoe",//银锄头
			"43" => "cchest",//铜宝箱
			"53" => "schest",//银宝箱
			"63" => "gchest",//金宝箱
			"73" => "dchest",//{$this->zuanshiTitle}宝箱
			"85" => "dog",//宠物
			"96" => "cfert",//化肥
			"107" => "wcan",//洒水壶
			"118" => "hcide",//除草剂
			"129" => "icide",//除虫剂
			"1310" => "emerald",//绿宝石
			"1411" => "purplegem",//紫宝石
			"1512" => "sapphire",//蓝宝石
			"1613" => "topaz",//黄宝石
			"1714" => "kuguazhi",//苦瓜汁
            "1815"=>"redcard",//红土地卡
            "1915"=>"blackcard",//黑土地卡
            "2015"=>"goldcard",//金土地卡
		);
	}

	//一对一属性表
	function onoTitleInfo($type = "") {
		if ($type == 1) {
			return array(
				"普通种子" => "seed",
				"铜锄头" => "choe",
				"银锄头" => "shoe",
				"铜宝箱" => "cchest",
				"银宝箱" => "schest",
				"金宝箱" => "gchest",
				"钻石宝箱" => "dchest",
				"化肥" => "cfert",
				"洒水壶" => "wcan",
				"除草剂" => "hcide",
				"除虫剂" => "icide",
				"绿宝石" => "emerald",
				"紫宝石" => "purplegem",
				"蓝宝石" => "sapphire",
				"黄宝石" => "topaz",
                "红土地卡"=>"redcard",//红土地卡
                "黑土地卡"=>"blackcard",//黑土地卡
                "金土地卡"=>"goldcard",//金土地卡
				"{$this->roseXinTitle}"=>"roseSeed"
			);
		} else {
			return array(
				"seed" => "普通种子",
				"choe" => "铜锄头",
				"shoe" => "银锄头",
				"cchest" => "铜宝箱",
				"schest" => "银宝箱",
				"gchest" => "金宝箱",
				"dchest" => "钻石宝箱",
				"cfert" => "化肥",
				"wcan" => "洒水壶",
				"hcide" => "除草剂",
				"icide" => "除虫剂",
				"emerald" => "绿宝石",
				"purplegem" => "紫宝石",
				"sapphire" => "蓝宝石",
				"topaz" => "黄宝石",
				"redcard"=>"红土地卡",
				"blackcard"=>"黑土地卡",
				"goldcard"=>"金土地卡",
				"diamonds"=>"{$this->zuanshiTitle}"
			);
		}
	}

	//种子信息更新记录
	function saveProduct($goodsId, $nums, $type = "add") {
		if ($goodsId <= 0 || $nums <= 0) {
			return false;
		}
		$product = new UserProduct();
		$item = $product->findFirst("uid='{$this->userid}' AND sid='{$goodsId}'");
		if ($item) {
			if ($type == "add") {
				$item->number += $nums;
			} elseif ($type == "ded") {
				$item->number -= $nums;
				if ($item->number < 0) {
					return false;
				}
			} else {
				return false;
			}
			$item->updatetime = TIMESTAMP;
			$flag = $item->update();
		} else {
			$product->uid = $this->userid;
			$product->sid = $goodsId;
			if ($type == "add") {
				$product->number = $nums;
			} else {
				return false;
			}
			$product->createtime = $product->updatetime = TIMESTAMP;
			$flag = $product->save();
		}
		return $flag;
	}

	//土地新增 添加 普通土地
	function addLand() {
		$this->user = $this->selectUser($this->userid);
		$land = new OrchardLand();
		$maxLandId = $land->findFirst(
			array(
				"conditions" => "uid='{$this->userid}'",
				"columns" => "landId",
				"order" => "landId desc"
			));
		$maxLand = $this->object2array($maxLandId);
		$maxLandId = $maxLand["landId"];
		if (empty($maxLandId)) {
			if (empty($maxLand)) {
				$landId = 0;
			} else {
				$landId = 1;
			}
		} elseif ($maxLandId < count($this->config) + 1) {
			$landId = $maxLandId + 1;
		} else {
			return false;
		}
		$land->uid = $this->userid;
		$land->mobile = $this->user["mobile"];
		$land->nickname = $this->user["userName"];
		$land->landLevel = 1;
		$land->landId = $landId;
		$land->landStatus = 0;
		$land->createtime = $land->updatetime = $land->optime = TIMESTAMP;
		return $land->save();
	}

	//神像信息
	function selectStatueInfo() {
		$config = $this->getConfig("statueInfo");
		$statue = new OrchardStatue();
		$list = $statue->find("uid='{$this->userid}'");
		$list = $this->object2array($list);
		$list = $this->getArrayKey($list, "model");
		$statueInfo = $this->selectUser($this->userid, "statueInfo");
		$data = array();
		if (!empty($config)) {
			foreach ($config as $key => $value) {
				$info = array(
					"name" => $value["tName"],
					"depict" => $value["depict"],
					"status" => 0,
					"vaidtime" => 0,
					"timeInfo" => ""
				);
				if (!empty($list[$statueInfo[$key]["mark"]]) && $list[$statueInfo[$key]["mark"]]["lasttime"] > TIMESTAMP) {
					$info["status"] = 1;
					$info["vaidtime"] = $list[$statueInfo[$key]["mark"]]["lasttime"];
					$info["timeInfo"] = $this->time2second($list[$statueInfo[$key]["mark"]]["lasttime"] - TIMESTAMP);
				}
				$data[$key] = $info;
			}
		}
		return $data;
	}

	//单一商品信息
	function getOneProductInfo($id) {
		$product = new Product();
		$product = $product->findFirst("id='{$id}'");
		return $this->object2array($product);
	}

	//单一道具信息
	function getOneOrchardGoodsInfo($id = "", $type = "") {
		$goods = new OrchardGoods();
		$condition = "";
		if ($id > 0) {
			$condition = "tId='{$id}'";
		}
		if ($type > 0) {
			$condition = "type='{$type}'";
		}
		$goods = $goods->findFirst($condition);
		return $this->object2array($goods);
	}

	//更新土地上时间状态
	function updateLandTime($land, $product, $statueInfo, $dogInfo) {
		if (empty($land)) {
			return false;
		}
		$orchardLand = new OrchardLand();
		$landStatus = $orchardLand->getLandStatus();
		$land["addtime"] = 0;
		if (@in_array($land["landStatus"], array(0, 9))) {
			if ($dogInfo["sowingTime"] > TIMESTAMP && $land["landStatus"] == 0) {
				$flag = $this->addSeed($land["landId"]);
				if ($flag != false) {
					$land["landStatus"] = $land["wcan"] = $land["hcide"] = $land["icide"] = 1;
					$land["goodsId"] = $this->seedId;
					$land["goodsNums"] = "种子";
				}
			}
			return false;
		}
		if (!empty($product)) {
			$land["infotime"] = array($product["seedTime"] * 3600, $product["sproutingTime"] * 3600, $product["growTime"] * 3600);
		} else {
			$land["infotime"] = array(0, 0, 0);
		}
		$infotime = array();
		$land["fertilize"] = json_decode($land["fertilize"], true);
		if(!empty($land["fertilize"]) && @is_array($land["fertilize"])){
			foreach ($land["fertilize"] as $k => $val) {
				if(isset($val["addtime"])){
					$land["addtime"] += $val["addtime"];
				}
			}
		}
		if (isset($land["fertilize"][1]) && isset($land["fertilize"][1]["effect"])) {
			if ($land["fertilize"][1]["addtime"] >= $land["infotime"][0]) {
				$infotime[0] = $land["infotime"][0] - $land["fertilize"][1]["addtime"];
			} else {
				$infotime[0] = $land["infotime"][0] - $land["fertilize"][1]["addtime"];
			}
		}else{
			$infotime[0] = $land["infotime"][0];
		}
		if (isset($land["fertilize"][2]) && isset($land["fertilize"][2]["effect"])) {
			if ($land["fertilize"][2]["addtime"] >= $land["infotime"][1]) {
				$infotime[1] = $land["infotime"][1] - $land["fertilize"][2]["addtime"];
			} else {
				$infotime[1] = $land["infotime"][1] - $land["fertilize"][2]["addtime"];
			}
		}else{
			$infotime[1] = $land["infotime"][1];
		}
		if (isset($land["fertilize"][3]) && isset($land["fertilize"][3]["effect"])) {
			if ($land["fertilize"][3]["addtime"] >= $land["infotime"][2]) {
				$infotime[2] = $land["infotime"][2] - $land["fertilize"][3]["addtime"];
			} else {
				$infotime[2] = $land["infotime"][2] - $land["fertilize"][3]["addtime"];
			}
		}else{
			$infotime[2] = $land["infotime"][2];
		}
		$this->db->begin();
		$this->db->query("SELECT * FROM `dhc_orchard_land` WHERE uid='{$this->userid}' AND landId='{$land['landId']}'  AND landStatus=".$land["landStatus"] ." FOR UPDATE")->fetch();
		$landInfo = $orchardLand->findFirst("uid='{$this->userid}' AND landId='{$land['landId']}'");
		if($landInfo == false){
			return false;
		}elseif($landInfo->goodsId != $land["goodsId"]){
			$land["goodsId"] = $landInfo->goodsId;
			$land["goodsName"] = $landInfo->goodsName;
			$land["landStatus"] = $landInfo->landStatus;
			$land["wcan"] = $landInfo->wcan;
			$land["hcide"] = $landInfo->hcide;
			$land["icide"] = $landInfo->icide;
			$product = $this->getOneProductInfo($land["goodsId"]);
			$land["infotime"][1] = $infotime[1] = $product["sproutingTime"] * 3600;
			$land["infotime"][2] = $infotime[2] = $product["growTime"] * 3600;
		}
		if (TIMESTAMP - $land["seedtime"] >= $infotime[0] && $landInfo->landStatus == 1 && @in_array($landInfo->goodsId,array($this->seedId,$this->roseId))) {
			//种子成熟，初始化结什么果 进入发芽期
			$randomInfo = $this->randomOrchardFruit($land);
			//$this->logsInfo("随机果实",array("land"=>$land,"random"=>$randomInfo,"createtime"=>$this->getMillisecond()));
			if ($randomInfo == false) {
				$this->db->rollback();
				return false;
			}
			$land["goodsId"] = $randomInfo["goodsId"];
			$land["goodsName"] = $randomInfo["goodsName"];
			$land["infotime"][1] = $infotime[1] = $randomInfo["sproutingTime"] * 3600;
			$land["infotime"][2] = $infotime[2] = $randomInfo["growTime"] * 3600;
			$landInfo->goodsId = $land["goodsId"];
			$landInfo->goodsName = $land["goodsName"];
			$land["landStatus"] = 2;
			$land["wcan"] += 1;
			$land["hcide"] += 1;
			$land["icide"] += 1;
		}
		if (TIMESTAMP - $land["seedtime"] >= $infotime[0] + $infotime[1] && $land["landStatus"] == 2) {
			//种子已发芽 进入 成长期
			$land["landStatus"] = 3;
			$land["wcan"] += 1;
			$land["hcide"] += 1;
			$land["icide"] += 1;
		}
		if (TIMESTAMP - $land["seedtime"] >= $infotime[0] + $infotime[1] + $infotime[2] && $land["landStatus"] == 3) {
			//种子已成熟 进入 成熟期
			$land["landStatus"] = 4;
			$land["wcan"] += 1;
			$land["hcide"] += 1;
			$land["icide"] += 1;
			$land["goodsNums"] = $this->getOrchardLandFruitNums($land, $statueInfo);
			$landInfo->goodsNums = $land["goodsNums"];
		}
		if (TIMESTAMP - $land["seedtime"] >= $infotime[0] + $infotime[1] + $infotime[2] + 7 * 24 * 3600 && $land["landStatus"] == 4) {
			$land["landStatus"] = 5;
			$land["wcan"] += 1;
			$land["hcide"] += 1;
			$land["icide"] += 1;
		}
		$landInfo->landStatus = $land["landStatus"];
		$landInfo->wcan = $land["wcan"];
		$landInfo->hcide = $land["hcide"];
		$landInfo->icide = $land["icide"];
		$landInfo->optime = TIMESTAMP;
		$flag = $landInfo->update();
		if ($flag == false) {
			return $land;
		}
		if ($dogInfo["harvestTime"] > TIMESTAMP && $land["landStatus"] == 4) {
			$flag = $this->saveFruit($land["landId"]);
			if ($flag != false && $flag["errno"] != 1) {
				$flag = $this->plowing("choe", $land["landId"], $this->choeId);
				if ($this->is_error($flag) || $flag == false) {
					$flag = $this->plowing("shoe", $land["landId"], $this->shoeId);
				}
				if($flag != false){
					$land["landStatus"] = 0;
				}
			}
		}
		if ($dogInfo["sowingTime"] > TIMESTAMP && $land["landStatus"] == 0) {
			$flag = $this->addSeed($land["landId"]);
			if ($flag != false && $flag["errno"] != 1) {
				$land["landStatus"] = $land["wcan"] = $land["hcide"] = $land["icide"] = 1;
				$land["goodsId"] = $this->seedId;
				$land["goodsNums"] = "种子";
			}
		}
		$this->db->commit();
		return $land;
	}

	//随机产生果实
	function randomOrchardFruit($land) {
		if($land["goodsNums"] !=1){
			$landInfo = $this->getConfig("landInfo");
			if (empty($landInfo[$land['landLevel']])) {
				return false;
			}
			//金岛信息 玫瑰超限
			if(USER_TYPE == "jindao"){
				$isDayRose = $this->getRoseDayNums();
			}else{
				$isDayRose = false;
			}
			$usergrade = $this->selectUser($this->userid, "grade");
			if ($usergrade > 1) {
				if (empty($landInfo[$usergrade][$land['landLevel']])) {
					$landInfo[$usergrade][$land['landLevel']] = $landInfo[$land['landLevel']];
				}
				$land = $this->get_rand($landInfo[$usergrade][$land['landLevel']],$isDayRose);
			} else {
				$land = $this->get_rand($landInfo[$land['landLevel']],$isDayRose);
			}
		}else{
			$land["id"] = $land["goodsId"];
		}
		if ($land["id"] > 0) {
			$product = $this->getOneProductInfo($land["id"]);
			$land["goodsId"] = $land["id"];
			$land["goodsName"] = $product["title"];
			$land["sproutingTime"] = $product["sproutingTime"];
			$land["growTime"] = $product["growTime"];
		}
		return $land;
	}
	//获取玫瑰当日产出数量
	function getRoseDayNums(){
		//收获的玫瑰种子
		if($this->limitRoseNums['limit']<=0){
			return false;
		}
		$roseNums1 = $roseNums2 = $roseNums = 0;
		$starttime = strtotime(date('Y-m-d', time()));
		$logs = new OrchardLogs();
		$logsInfo = $logs->findFirst(
			array(
				'conditions' => "types='addgoods' AND msg like '%收获{$this->roseTitle}%' AND dataInfo !=1 AND createtime>=".$starttime,
				'columns' => 'count(id)',
			)
		);
		$roseNums1 = $this->object2array($logsInfo);
		$roseNums1 = $roseNums1[0];
		$orchardLand = new OrchardLand();
		$orchardLandInfo = $orchardLand->find("goodsId='{$this->roseId}' AND landStatus not in(0,5) AND seedtime>=".$starttime);
		$orchardLandInfo = $this->object2array($orchardLandInfo);
		if(!empty($orchardLandInfo)){
			foreach ($orchardLandInfo as $k=>$v){
				$roseSeed = $logs->findFirst("uid='{$v['uid']}' AND landId='{$v['landId']}' AND types='dedroseseed' AND nums='-1' AND createtime=".$v['seedtime']);
				if(empty($roseSeed)){
					$roseNums2 += 1;
				}
			}
		}
		$roseNums = $roseNums1 + $roseNums2;
		if($roseNums >= $this->limitRoseNums['limit']){
			return true;
		}else{
			return false;
		}
	}
	//果实参数数量-产生多少果实
	function getOrchardLandFruitNums($land, $statueInfo) {
		if ($land["goodsNums"] == 1) {
			return $land["goodsNums"];
		}
		$landLevel= intval($land['landLevel'])-1;
		//金岛玫瑰种子变化
		if(USER_TYPE == "jindao" && $land['goodsId'] == $this->roseId && $this->limitRoseNums['random'][0]>0 && $this->limitRoseNums['random'][1]>0 && $this->limitRoseNums['random'][0] <$this->limitRoseNums['random'][1]){
			return rand($this->limitRoseNums['random'][0],$this->limitRoseNums['random'][1]);
		}
		$config = $this->getConfig("landFruit");
		$config=$config["num"][$landLevel];
		if ($land["wcan"] != 4 || $land["hcide"] != 4 || $land["icide"] != 4) {
			if ($statueInfo["4"]['status'] == 1) {
				return $config["med"];
			}
			if ($land["wcan"] != 4 && $config["med"] - $config["min"] > 1) {
				$config["med"] -= 1;
			}
			if ($land["hcide"] != 4 && $config["med"] - $config["min"] > 1) {
				$config["med"] -= 1;
			}
			if ($land["icide"] != 4 && $config["med"] - $config["min"] > 1) {
				$config["med"] -= 1;
			}
			$nums = rand($config["min"], $config["med"]);
		} else {
			if ($statueInfo["4"]['status'] == 1) {
				return $config["max"];
			}
			$nums = rand($config["min"], ($config["max"] - rand(0, intval($config["max"] - $config['min']) / 4)));
		}
		$userBei = $this->getUserDouble();
		return intval($nums * $userBei);
	}

	//概率果实产生
	function get_rand($proArr,$isDayRose = false) {
		$result = array();
		foreach ($proArr as $key => $val) {
			if($isDayRose == true && $val['id'] == $this->roseId){
				//玫瑰果实产出已超
				continue;
			}
			$arr[$key] = $val['chance'];
		}
		// 概率数组的总概率
		$proSum = array_sum($arr);
		if($proSum<=0){
			return $proArr[0];
		}
		asort($arr);
		// 概率数组循环
		foreach ($arr as $k => $v) {
			$randNum = mt_rand(1, $proSum);
			if ($randNum <= $v) {
				$result = $proArr[$k];
				break;
			} else {
				$proSum -= $v;
			}
		}
		return $result;
	}


	//土地播种
	function addSeed($landId) {
		//参数信息
		$config = $this->getConfig("landFruit");
		if ($config["seed"] <= 0) {
			return $this->error(1, "暂时无法播种");
		}
		$landInfo = $this->getLandInfo($landId);
		if (empty($landInfo)) {
			return $this->error(1, "土地信息获取失败，无法播种");
		}
		if (!@in_array($landInfo["landStatus"], array(0, 9))) {
			return $this->error(1, "暂时无法播种");;
		}
		if (@in_array($landInfo["plowing"], array(9))) {
			return $this->error(1, "该土地已被冻结，暂无法播种！");;
		}
		//种子信息
		$product = $this->getUserProductInfo("sid", $this->seedId);
		if (empty($product) || $product["number"] <= 0 || $product["number"] < $config["seed"]) {
			return $this->error(-1, "暂无更多种子，请购买后播种！");
		}
		//扣除种子更新日志
		$flag = $this->saveProduct($this->seedId, $config["seed"], "ded");
		if ($flag == false) {
			return $this->error(1, "种子扣除失败，播种失败！");
		}
		$flag = $this->saveOrchardLogs(array("mobile" => $this->mobile, "landId" => $landId, "types" => "dedseed", "nums" => -$config["seed"], "msg" => "【{$landId}号土地】播种扣除种子" . $config["seed"] . "个"));
		if ($flag == false) {
			return $this->error(1, "种子扣除日志更新失败，播种失败！");
		}
		//获取种子信息
		$roseInfo = $this->getSeedInfo("种子", $this->seedId);
		if ($roseInfo == false) {
			return $this->error(1, "{$this->roseTitle}信息获取失败，请重试！");
		}
		$land = new OrchardLand();
		$land = $land->findFirst("uid='{$this->userid}' AND landId='{$landId}'");
		if ($land == false) {
			return $this->error(1, "土地信息获取失败！");
		}
		$land->goodsId = $roseInfo["id"];
		$land->goodsName = $roseInfo["title"];
		$land->goodsNums = $config["seed"];
		$land->fertilize = $land->plowing = 0;
		$land->landStatus = $land->wcan = $land->hcide = $land->icide = 1;
		$land->optime = $land->seedtime = TIMESTAMP;
		$flag = $land->update();
		if ($flag == false) {
			return $this->error(1, "种子播种操作失败！！");
		}
		return true;
	}

	//果实收获信息
	function saveFruit($landId = "") {
		$goodsNums = 0;
		if ($this->request->isPost()) {
			$land = new OrchardLand();
			$list = $land->find("uid='{$this->userid}' AND landStatus=4");
			$list = $this->object2array($list);
			if (empty($list)) {
				return $this->error(1, "暂时没有可收获的果实");
			}
			foreach ($list as $key => $value) {
				if (isset($landId) && $landId !== '' && $landId != $value['landId']) {
					continue;
				}
				$land = new OrchardLand();
				$land = $land->findFirst("uid='{$this->userid}' AND landStatus=4 AND landId='{$value['landId']}'");
				if ($land == false) {
					return $this->error(1, "土地果实信息获取失败");
				}
				if (@in_array($land->plowing, array(9))) {
					return $this->error(1, "该土地已被冻结，暂无法收获！");
				}
				if($land->goodsNums>0) {//偷光无法收获的问题
					$flag = $this->saveProduct($land->goodsId, $land->goodsNums);
					if ($flag == false) {
						return $this->error(1, "{$land->goodsName}收获失败");
					}
					$data = array("mobile" => $land->mobile, "types" => "addgoods", "landId" => $land->goodsId, "nums" => $land->goodsNums, "landId" => $land->landId, "msg" => "【{$land->landId}】号土地收获{$land->goodsName}{$land->goodsNums}颗");
					if($land->goodsId == $this->roseId && $land->goodsNums ==1){
						$logs = new OrchardLogs();
						$logsInfo = $logs->findFirst("uid='{$this->userid}' AND types='dedroseseed' AND landId='{$land->landId}' AND nums='-1' AND status=1 ORDER BY id desc");
						if(!empty($logsInfo) && $logsInfo->createtime == $land->seedtime){
							$data["dataInfo"] = 1;
						}
					}
					$flag = $this->saveOrchardLogs($data);
					if ($flag == false) {
						return $this->error(1, "{$land->goodsName}更新日志失败");
					}

				}
				$land->landStatus = $land->fertilize = $land->wcan = $land->hcide = $land->icide = 5;
				$land->updatetime = $land->optime = TIMESTAMP;
				$flag = $land->update();
				if ($flag == false) {
					return $this->error(1, "【{$land->landId}】号土地更新失败!");
				}
				$goodsNums += $land->goodsNums;
			}
		}
		return $goodsNums;
	}

	//土地翻地
	function plowing($mark, $landId, $tId) {
		if ($tId > 0) {
			$markInfo = array("2" => array("mark" => "choe"), "3" => array("mark" => "shoe"));
			$mark = $markInfo[$tId]["mark"];
		} elseif (!empty($mark)) {
			$markInfo = array("choe" => array("tId" => "2"), "shoe" => array("tId" => "3"));
			$tId = $markInfo[$mark]["tId"];
		}
		$land = new OrchardLand();
		$land = $land->findFirst("uid='{$this->userid}' AND landId='{$landId}'");
		if ($land == false) {
			return $this->error(1, "翻地失败，土地信息获取失败！！");
		}
		if ($land ->goodsId <= 0) {
			return $this->error(1, "翻地失败，暂时无法翻地！！");
		}
//		if(!@in_array($land->landStatus,array(1,2,3,5))){
//			return true;
//		}
		$land->plowing += 1;
		$land->goodsId = $land->goodsNums = 0;
		$land->goodsName = "无";
		$land->landStatus = $land->fertilize = $land->wcan = $land->hcide = $land->icide = 0;
		$land->optime = TIMESTAMP;
		$flag = $land->update();
		if ($flag == false) {
			return $this->error(1, "翻地失败！");
		}
		$user = new OrchardUser();
		$user = $user->findFirst("uid='{$this->userid}'");
		if (!empty($mark) && !empty($tId)) {
			if ($user->$mark <= 0) {
				return $this->error(1, "道具数量不足！！");
			}
			$goods = new OrchardGoods();
			$goods = $goods->findFirst("tId={$tId}");
			if ($goods == false) {
				return $this->error(1, "道具信息获取失败！！");
			}
			$user->$mark -= 1;
			$user->updatetime = TIMESTAMP;
			$flag = $user->update();
			if ($flag == false) {
				return $this->error(1, "道具更新失败！！");
			}
			$flag = $this->saveOrchardLogs(array("mobile" => $user->mobile, "landId" => $landId, "types" => "ded" . $mark, "nums" => -1, "msg" => "翻地扣除" . $goods->tName . "1个"));
			if ($flag == false) {
				return $this->error(1, "道具使用日志更新失败！！");
			}
			$flag = $this->saveProduct($this->seedId, $goods->seedUser);
			if ($flag == false) {
				return $this->error(1, "更新用户赠送种子数量失败！！");
			}
			$flag = $this->saveOrchardLogs(array("mobile" => $user->mobile, "landId" => $landId, "types" => "addseed", "nums" => $goods->seedUser, "msg" => "使用" . $goods->tName . "翻地赠送种子" . $goods->seedUser . "颗"));
			if ($flag == false) {
				return $this->error(1, "更新用户赠送种子数量失败！！");
			}
			//赠送平台忽略不计
			if($goods->seedShop>0){
				$flag = $this->updateConfigTotal(array("mobile" => $user->mobile, "landId" => $landId, "types" => "addFruitTotal", "nums" => $goods->seedShop,"status"=>2, "msg" => "使用" . $goods->tName . "翻地返回平台种子" . $goods->seedShop . "颗"));
				if($flag == false){
					return $this->error(1, "返回平台种子操作日志失败！！");
				}
			}
			return "获得" . $goods->seedUser . "颗种子";
		} else {
			return " ";
		}
	}

	//宠物信息
	function getDogInfo() {
		$dog = new OrchardDog();
		$dog = $dog->findFirst("uid='{$this->userid}' AND status=1 AND isDel=0");
		return $this->object2array($dog);
	}

	//背景信息更新
	function saveUserBackground($backId = "1") {
		$orchard = new Orchard();
		$backgroundType = $orchard->getBackgroundType();
		$background = new OrchardBackground();
		$item = $background->findFirst("uid='{$this->userid}' AND backId='{$backId}'");
		if ($item == false) {
			$background->uid = $this->userid;
			$background->backId = $backId;
			$background->backName = $backgroundType[$backId];
			if ($backId == 1) {
				$background->status = 1;
			} else {
				$background->status = 0;
			}
			$background->createtime = $background->updatetime = TIMESTAMP;
			$flag = $background->save();
		} else {
			$list = $background->find("uid='{$this->userid}'");
			if (!empty($list)) {
				foreach ($list as $key => $value) {
					$back = new OrchardBackground();
					$back = $back->findFirst("uid='{$this->userid}' AND id='{$value->id}'");
					$back->status = 0;
					$back->updatetime = TIMESTAMP;
					$flag = $back->update();
					if ($flag == false) {
						return false;
					}
				}
			}
			$item->status = 1;
			$item->updatetime = TIMESTAMP;
			$flag = $item->update();
		}
		return $flag;
	}

	//宝箱果实收益倍数更新
	function saveDoubleEffect($data) {
		$doubleEffect = new OrchardDoubleEffect();
		$doubleEffect->uid = $this->userid;
		$doubleEffect->types = $data["types"];
		$doubleEffect->mark = $data["mark"];
		$doubleEffect->nums = $data["nums"];
		$doubleEffect->msg = $data["msg"];
		$doubleEffect->status = 1;
		$doubleEffect->createtime = TIMESTAMP;
		$doubleEffect->lasttime = 1 * 3600 + TIMESTAMP;
		return $doubleEffect->save();
	}

	//宝箱开启效果返回
	function selectDouble($time) {
		$condition = "";
		if($time>0){
			$condition = " AND createtime >".$time;
		}
		$doubleEffect = new OrchardDoubleEffect();
		$list = $doubleEffect->find("status=1 $condition ORDER BY id desc");
		$list = $this->object2array($list);
		$data = array("msgList"=>"");
		if (!empty($list)) {
			foreach ($list as $key => $value) {
				if($value['lasttime']<= time()){
					$double = new OrchardDoubleEffect();
					$item = $double->findFirst("id='{$value['id']}'");
					$item->status = 2;
					$item->updatetime = TIMESTAMP;
					$item->update();
				}
//				if($value["uid"]>0){
//					$nickname = $this->selectUser($value['uid'], "nickname");
//				}else{
//					$nickname = "系统";
//				}
				if(strpos($value["msg"],"金币") !== false){
					$subType = 7;
				}else{
					$subType = 0;
				}
				$t=1;
				if($value["types"]==99)
                {
                    $t=2;
                }
                else if ($value["types"]==100)
                {
                    $t=3;
                }
				$data[] = array(
					"msg"=>$value["msg"],
					"type"=>$t,
					"subType"=>$subType
				);

			}
			$data["msgList"] = $data;
		}
		return $data;
	}

	//宝箱效果倍数 收益
	function getUserDouble() {
		$doubleEffect = new OrchardDoubleEffect();
		$data = $doubleEffect->findFirst("uid='{$this->userid}' AND types='3' AND lasttime>" . TIMESTAMP . " ORDER BY nums desc");
		if ($data == false) {
			return 1;
		}
		return $data->nums;
	}

	//宠物信息
	function dogInfo() {
		$dog = new OrchardDog();
		$dogInfo = $dog->findFirst("uid={$this->userid}  AND status=1 AND isDel=0 order by id desc");
		$dogInfo = $this->object2array($dogInfo);
		if (empty($dogInfo)) {
			return false;
		}
		$config = $this->getConfig("dogInfo");
		if($dogInfo["dogLevel"]>=10){
			$config["experience"][$dogInfo["dogLevel"]] = 0;
		}
		$data = array(
			"id" => $dogInfo["id"],
			"dogName" => $dogInfo["dogName"],
			"dogLevel" => $dogInfo["dogLevel"],
			"experience" => $dogInfo["experience"],
			"experienceUlimit" => $config["experience"][$dogInfo["dogLevel"]],
			"power" => $dogInfo["power"],
			"powerUlimit" => $dogInfo["powerUlimit"],
			"otherInfo" => json_decode($dogInfo["otherInfo"], true),
			"score" => $dogInfo["score"],
			"speed" => $dogInfo["speed"],
			"harvestTime" => $dogInfo["harvestTime"] > time() ? $this->time2second($dogInfo["harvestTime"] - time()) : "",
			"sowingTime" => $dogInfo["sowingTime"] > time() ? $this->time2second($dogInfo["sowingTime"] - time()) : "",
		);
		return $data;
	}
	//获取土地信息
	function getLandInfo($landId = "", $index = "") {
		$land = new OrchardLand();
		$condition = "";
		if ($landId !== "") {
			$condition = " AND landId='{$landId}'";
		}
		$landInfo = $land->find("uid='{$this->userid}' $condition AND landLevel>0 GROUP BY landId");
		$landInfo = $this->object2array($landInfo);
		$list = $this->getArrayKey($landInfo, "landId");
		if ($index == "index") {
			$list = $this->getLandDetail($list);
		}
		if (isset($list[$landId]) && $landId !== "") {
			return $list[$landId];
		} else {
			return $list;
		}
	}

	//土地详细信息获取
	function getLandDetail($list) {
		if (empty($list)) {
			return $list;
		}
		$data = array();
		//神像信息
		$statueInfo = $this->selectStatueInfo();
		//宠物信息
		$dogInfo = $this->getDogInfo();
		foreach ($list as $key => $value) {
			//倒计时计算
			$value["infotime"] = array(0, 0, 0);
			$product = $this->getOneProductInfo($value["goodsId"]);
			$timeInfo = $this->updateLandTime($value, $product, $statueInfo, $dogInfo);
			if ($timeInfo != false) {
				$value = $timeInfo;
			}else{
				unset($list[$key]);
			}
			if(!isset($value["addtime"])){
				$value["addtime"] = 0;
			}
			//状态更新
			if ($statueInfo[1]["status"] != 1) {
				$hcide = $this->checkLandInfo($value["landId"], "hcide");
				if ($hcide) {
					$value["hcide"] = $value["landStatus"] - 1;
				}
			}
			if ($statueInfo[2]["status"] != 1) {
				$icide = $this->checkLandInfo($value["landId"], "icide");
				if ($icide) {
					$value["icide"] = $value["landStatus"] - 1;
				}
			}
			if ($statueInfo[3]["status"] != 1) {
				$wcan = $this->checkLandInfo($value["landId"], "wcan");
				if ($wcan) {
					$value["wcan"] = $value["landStatus"] - 1;
				}
			}
//			if($value["wcan"] != $value["landStatus"] && $value["landStatus"]<5){
//				$value["wcanInfo"] = "需浇水";
//			}
//			if($value["hcide"] != $value["landStatus"] && $value["landStatus"]<5){
//				$value["hcideInfo"] = "需除草";
//			}
//			if($value["icide"] != $value["landStatus"] && $value["landStatus"]<5){
//				$value["icideInfo"] = "需除虫";
//			}
			unset($value["id"], $value["uid"], $value["nickname"], $value["mobile"], $value["createtime"], $value["updatetime"], $value["optime"]);
			$info = array(
				"a" => $value["goodsId"],
				"b" => 1,
				"f" => 0,//草
				"g" => 0,//虫
				"h" => 1,//水
				"j" => $value["landLevel"] - 1,
				"o" => $value["landStatus"] - 1,
				"q" => $value["seedtime"] - $value["addtime"],
				"z" => 0,
				"n" => $value["goodsName"],
				"y" => $value["infotime"],
			);
			if ($value["goodsId"] <= 0) {//无种子
				$info["b"] = $info["o"] = $info["h"] = 0;
				$info["s"] = "-1";
				unset($info["z"], $info["n"], $info["y"]);
			}
			if ($value["landStatus"] == 5 || $value["landStatus"] == 0) {//作物死亡
				$info["b"] = 7;
				$info["s"] = $info["o"] = "0";
			}
			if ($value["icide"] != $value["landStatus"] && $value["landStatus"] < 5) {
				$info["g"] = 1;
			}
			if ($value["hcide"] != $value["landStatus"] && $value["landStatus"] < 5) {
				$info["f"] = 1;
			}
			if ($value["wcan"] != $value["landStatus"] && $value["landStatus"] < 5) {
				$info["h"] = 0;
			}
			if(!empty($value["fertilize"])){
				if(!empty($value["fertilize"][$value["landStatus"]])){
					$info["z"] =1;
				}
			}
			$data[$key] = $info;
		}
		return $data;
	}

	//土地上状态情况
	function checkLandInfo($landId, $model) {
		$land = new OrchardLand();
		$land = $land->findFirst("uid='{$this->userid}' AND landId='{$landId}'");
		if ($land->landStatus != $land->$model || @in_array($land->landStatus,array(0,9,5))) {
			return false;
		}
		$logs = new OrchardLogs();
		$logs = $logs->findFirst("uid='{$this->userid}' AND landId='{$landId}' AND types='ded{$model}' order by id desc");
		$isUpdate = 0;
		if ($logs == false) {
			if(USER_TYPE == "jindao" && rand(1, 100) <= 5 ){
				$isUpdate = 1;
			}else if(TIMESTAMP - $land->createtime > 24 * 3600 && rand(1, 1000) == 1 && USER_TYPE != "jindao"){
				$isUpdate = 1;
			}
		} else {
			if(USER_TYPE == "jindao" && rand(1, 100) <= 5 && $logs->landId != $land->landId) {
				$isUpdate = 1;
			}else if ($logs->landId != $land->landId && TIMESTAMP - $logs->createtime > 24 * 2 * 3600 && rand(1, 10000) == 1 && USER_TYPE != "jindao") {
				$isUpdate = 1;
			}
		}
		if ($isUpdate == 1) {
			$land->$model = $land->landStatus - 1;
			$land->optime = TIMESTAMP;
			$flag = $land->update();
			if ($flag != false) {
				return true;
			}
		}
		return false;
	}

	//宠物列表信返回
	function dogListInfo() {
		$listDog = $this->checkDog();
		$config = $this->getConfig("dogInfo");
		$data = array();
		if (!empty($listDog)) {
			foreach ($listDog as $key => $value) {
				if($value["dogLevel"]>=10){
					$config["experience"][$value["dogLevel"]] = 0;
				}
				$data[] = array(
					"id" => $value["id"],
					"dogName" => $value["dogName"],
					"dogLevel" => $value["dogLevel"],
					"experience" => $value["experience"],
					"experienceUlimit" => $config["experience"][$value["dogLevel"]],
					"power" => $value["power"],
					"powerUlimit" => $value["powerUlimit"],
					"otherInfo" => json_decode($value["otherInfo"], true),
					"score" => $value["score"],
					"status" => $value["status"]
				);
			}
		}
		return $data;
	}

	//检测用户是否有宠物
	public function checkDog($type = '') {
		$dog = new OrchardDog();
		if ($type == "default") {
			$listDog = $dog->findFirst("uid={$this->userid} AND isDel=0 AND status=1");
			if(!empty($listDog->otherInfo)){
				$listDog->otherInfo = json_decode($listDog->otherInfo, true);
			}
		} else {
			$listDog = $dog->find("uid={$this->userid} AND isDel=0 ORDER BY status asc");
			if(!empty($listDog)){//宠物每小时消耗体力更新
				foreach ($listDog as $key => $dog) {
					if($dog->updatetime < time()-3600 && $dog->status ==1){
						$config = $this->getConfig("dogInfo");
						$size = intval((time()-$dog->updatetime)/3600);
						$dogInfo = $dog->findFirst("uid={$this->userid} AND isDel=0 AND status=1");
						$dogInfo->power -= $config["power"][3]*$size;
						if($dogInfo->power<=0){
							$dogInfo->power = 0;
						}
						$dogInfo->updatetime = TIMESTAMP;
						$dogInfo->update();
					}
				}
			}

		}
		$listDog = $this->object2array($listDog);
		if (!empty($listDog)) {
			return $listDog;
		} else {
			return false;
		}
	}

	//赠送黄宝石
	function sendtopaz($tId) {
		if(empty($tId)){
			return false;
		}
		$goods = new OrchardGoods();
		$goods = $goods->findFirst("tId={$tId}");
		if ($goods == false) {
			return false;
		}
		$goods = $this->object2array($goods);
		$chance = json_decode($goods["chanceInfo"],true);
		$mt = rand(1, 10000);
		if ($mt > $chance["count"]["size"]) {
			return false;
		}
		$title = $this->onoTitleInfo();
		$baoshiInfo = $this->get_rand($chance["baoshi"]);
		$model = $baoshiInfo["mark"];
		$flag = $this->saveOrchardLogs(array("mobile" => $this->mobile, "types" => "add".$model, "nums" => "1", "msg" => "运气不错赠送".$title[$model]."1颗"));
		if ($flag == false) {
			return false;
		}
		$user = new OrchardUser();
		$user = $user->findFirst("uid='{$this->userid}'");
		$user->$model += 1;
		$user->updatetime = TIMESTAMP;
		$flag = $user->update();
		if ($flag == false) {
			return false;
		}
		$array = array("emerald"=>"13","purplegem"=>"14","sapphire"=>"15","topaz"=>"16");
		return ["num"=>$array[$model],"message"=>"意外获得{$title[$model]}1颗"];
	}

	//道具信息
	function getprop() {
		$goods = new OrchardGoods();
		$list = $goods->find("type !=5 AND type<10 OR type =14 or type=15")->toArray();
		$onoTitleInfo = $this->onoTitleInfo(1);
		$userInfo = $this->selectUser($this->userid, "all");
		$config = $this->getConfig("dogInfo");
		$data = array();
		if (!empty($list)) {
			foreach ($list as $key => $value) {
				$info = array(
					"type" => 4,
					"tName" => $value["tName"],
					"depict" => $value["depict"],
					"num" => 0
				);
				if ($value["type"] == 3) {
					$info["costs"] = json_decode($value["cost"], true);
				}
				if ($value["type"] == 1) {
					$product = new UserProduct();
					$product = $product->findFirst("uid='{$this->userid}' AND sid='{$value["tId"]}'");
					if ($product) {
						$info["num"] = $product->number;
					}
					$info["cId"] = $value["tId"];
				} else {
					$info["num"] = $userInfo[$onoTitleInfo[$value["tName"]]];
					$info["mark"] = $onoTitleInfo[$value["tName"]];
					$info["cId"] = $value["tId"];
				}
				$data[] = $info;
			}
		}
		$data[] = array(
			"type"=>4,
			"tName"=>"{$this->roseXinTitle}",
			"depict"=>"可进行种植{$this->roseTitle}",
			"num"=>$userInfo[$onoTitleInfo[$this->roseXinTitle]],
			"mark"=>$onoTitleInfo[$this->roseXinTitle],
			"cId"=>99,
		);
		foreach ($config["info"] as $key => $value) {
			$data[] = array(
				"type" => 10,
				"tName" => $value["tName"],
				"depict" => $value["depict"],
				"num" => $userInfo["dogFood" . $key],
				"cId" => $key,
			);
		}
		return $data;
	}

	//宝石信息
	function gemstone() {
		$statueInfo = $this->getConfig("statueInfo");
		$dataInfo = $this->selectUser($this->userid, "statueInfo");
		$data = array();
		if (!empty($statueInfo)) {
			foreach ($statueInfo as $key => $value) {
				$product = new OrchardGoods();
				$product = $product->findFirst("tId='{$value["tId"]}'");
				$data[] = array(
					"type" => 3,
					"tName" => $dataInfo[$key]["title"],
					"cId" => $product->tId,
					"num" => $dataInfo[$key]["nums"],
					"depict" => $product->depict
				);
			}
		}
		return $data;
	}

	//材料信息
	function getDui() {
		$dataInfo = $this->selectUser($this->userid, "houseInfo");
		$info = $this->selectUser($this->userid, "exchange");
		$config = $this->getConfig("duiInfo");
		$orchard = new Orchard();
		$getDuiDepict = $orchard->getDuiDepict();
		$data = array();
		if (!empty($config)) {
			foreach ($config as $key => $value) {
				$data[] = array(
					"type" => 2,
					"tName" => $info[$key]["title"],
					"num" => $dataInfo[$info[$key]['mark']],
					"depict" => $getDuiDepict[$key],
					"cId" => $key,
				);
			}
		}
		return $data;
	}

	//商品信息
	function getProduct() {
		$product = $this->getUserProductInfo("sid");
		if (!empty($product)) {
			$data = array();
			foreach ($product as $key => $value) {
				if ($value["sid"] == $this->seedId) {
					continue;
				}
				$product = new Product();
				$product = $product->findFirst("id='{$value['sid']}'");
				if ($product != false) {
					$data[] = array(
						"type" => 1,
						"tName" => $product->title,
						"num" => $value["number"],
						"depict" => $product->depict,
						"startPrice"=>$product->startprice,
						"cId" => $value["sid"]
					);
				} else {
					$data[] = array(
						"type" => 1,
						"tName" => "",
						"num" => $value["number"],
						"cId" => $value["sid"],
                        "startPrice"=>0,
						"depict" => ""
					);
				}

			}
			$product = $data;
		}
		return $product;
	}

	//获取{$this->roseTitle}商品信息
	function getSeedInfo($keywords, $goodsId = "") {
		$product = new Product();
		if ($goodsId > 0) {
			$condition = " id='{$goodsId}'";
		} else {
			$condition = "title like '%{$keywords}%'";
		}
		$product = $product->findFirst($condition);
		return $this->object2array($product);
	}

	//获取皮肤信息
	function getSkin() {
		$background = new OrchardBackground();
		$skinData = $background->find("uid='{$this->userid}' order by status desc,updatetime desc");
		$skinData = $this->object2array($skinData);
		$data = [];
		if (!empty($skinData)) {
			foreach ($skinData as $key => $value) {
				$data[] = array(
					"type" => 7,
					"tName" => $value['backName'],
					"cId" => $value['backId'],
					"num" => 1,
					"depict" => ''
				);
			}
		}
		return $data;
	}
	//更新大礼包信息
	function saveUserPackage($data){
		$package = new OrchardPackage();
		if($data["types"] == "reg" && !empty($data["uid"])){
			$row = $package->findFirst(" uid='{$data['uid']}' AND types='reg' ");
			$row = $this->object2array($row);
			if(!empty($row)){
				return $row;
			}
		}elseif($data["types"] == 'give' && !empty($data["uid"])) {
			$starttime = strtotime(date('Y-m-d', time()));
			$row = $package->findFirst(" uid='{$data['uid']}' AND types='give' AND createtime>={$starttime} ORDER BY id desc ");
			$row = $this->object2array($row);
			if (!empty($row)) {
				return $row;
			}
		}elseif($data["types"] == "newGiftPack" && !empty($data['uid'])){
			$row = $package->findFirst(" uid='{$data['uid']}' AND types='newGiftPack'");
			$row = $this->object2array($row);
			if(!empty($row)){
				return $row;
			}
		}elseif($data["types"] == 'ok' && !empty($data["id"])){
			$row = $package->findFirst(" id='{$data['id']}' AND uid='{$this->userid}' AND status=0");
			$row->status =1;
			$row->updatetime = TIMESTAMP;
			$flag = $row->update();
			return $flag;
			$this->getSqlError($flag, $row);
		}
		if(!empty($data["info"])){
			$package->uid = $data["uid"];
			$package->types = $data["types"];
			$package->info = $data["info"];
			$package->createtime = $package->updatetime = TIMESTAMP;
			$flag = $package->save();
			return $flag;
			$this->getSqlError($flag, $package);
		}
		return false;
	}
	//检测签到信息
	function checkSignInfo($uid){
		$config = $this->getConfig("sign");
		if($config["status"] == 0){
			return false;
		}
		$starttime = strtotime(date('Y-m-d', time()));
		$sign = new OrchardSign();
		$signList = $sign->find("uid='{$uid}' AND createtime>=".$starttime);
		$signList = $this->object2array($signList);
		if(count($signList)>=$config["daySize"]){
			return false;
		}
		return true;
	}

	//好友互偷信息
	function friendsSteal(){
		//自己等级
		$userGrade = $this->selectUser($this->userid, "grade");
		//自己可偷取的果实类型
		$stealInfo = $this->getConfig("steal");
		if($stealInfo["status"] != 1){
			$this->error(1, "好友偷取功能尚未开启");
		}

		$userStealGoods = $this->getStealInfo($stealInfo,$userGrade);
		if($userStealGoods == false){
			$this->error(1, "无更多可偷取果实");
		}
		$dogInfo = $this->checkDog("default");
		if(empty($dogInfo)){
			return $this->error(1, "宠物信息获取失败");
		}
		//宠物信息是否满足
		if($dogInfo["power"] < $stealInfo["error"]["power"] || $dogInfo["power"] < $stealInfo["success"]["power"]){
			return $this->error(1, "宠物体力不足无法偷取好友果实");
		}
		$userId = $this->userid;
		//进入另一个用户
		$ownerId = $this->request->getPost("ownerId");
		if($ownerId<=0 || empty($ownerId)){
			return $this->error(1, "未进入好友系统，无法偷取");
		}
		//查找此会员与自己的关系
		$falg = $this->checkFriend($ownerId);
		if($falg == false){
			return $this->error(1, "好友关系尚不存在，请重试！");
		}
		//是否可以偷取
		$checkInfo = $this->checkStealInfo($stealInfo,$userId,$ownerId);
		if($this->is_error($checkInfo)){
			return $this->error(1, $checkInfo["message"]);
		}
		$this->userid = $ownerId;
		//好友宠物获取
		$ownerDogInfo = $this->checkDog("default");
		$dogStatus = $this->checkFriendDog($dogInfo,$ownerDogInfo);
		if($dogStatus == true){
			$dogStatus =1;
			$chance = $stealInfo["chance"][0] + $stealInfo["chance"][1];
		}else{
			$dogStatus =0;
			$chance = $stealInfo["chance"][0] - $stealInfo["chance"][2];
		}

		$mt = rand(1, 100);
		if($mt>$chance || $chance<=0){
			//偷取概率性失败
			//宠物体力扣除
			$flag = $this->stealDogPower($dogInfo,"error",$stealInfo);
			if($flag == false){
				return $this->error(1,"宠物体力更新失败！");
			}
			//对方宠物经验更新
			$flag = $this->stealDogExperience($ownerDogInfo,$stealInfo);
			if($flag == false){
				return $this->error(1,"被偷好友宠物经验更新失败！");
			}
			//记录更新
			$flag = $this->saveSteal(array("uid"=>$userId,"huid"=>$ownerId,"dogInfo"=>array($dogInfo,$ownerDogInfo),"dogStatus"=>  $dogStatus,"chance"=>$chance,"mt"=>$mt,"landInfo"=>"0"));
			if($flag == false){
				return $this->error(1,"偷取记录更新失败！");
			}
			$flag = $this->saveOrchardLogs(array("uid"=>$userId,"mobile"=>$dogInfo["mobile"],"disUid"=>$ownerId,"types"=>"hail_steal","nums"=>0,"msg"=>"偷取好友果实偷取失败，宠物扣除体力".$stealInfo["error"]["power"]));
			if($flag == false){
				return $this->error(1,"偷取日志记录更新失败！");
			}
			$flag = $this->saveOrchardLogs(array("uid"=>$ownerId,"mobile"=>$ownerDogInfo["mobile"],"disUid"=>$userId,"types"=>"hail_steal","nums"=>0,"msg"=>"被好友偷取时防御成功，宠物增加经验".$stealInfo["error"]["experience"]));
			if($flag == false){
				return $this->error(1,"偷取好友日志记录更新失败！");
			}
			return false;
		}

		//宠物体力扣除
		$flag = $this->stealDogPower($dogInfo,"success",$stealInfo);
		if($flag == false){
			return $this->error(1,"宠物体力更新失败！");
		}
		//好友土地信息
		$landInfo = $this->getLandInfo();
		$this->userid = $userId;
		$data = $info = array();
		$dataStr = "";
		if(!empty($landInfo)){
			foreach ($landInfo as $key => $value) {
				if($value["landStatus"] !=4 || $value["goodsNums"]<=2 || $value["goodsId"]<=0){
					continue;
				}
				$goodsNums = rand(intval($stealInfo["success"]["min"]),intval($stealInfo["success"]["max"]));
				if($goodsNums>$value["goodsNums"]){
					$goodsNums = $value["goodsNums"];
				}
				$land = new OrchardLand();
				$land = $land->findFirst("id='{$value["id"]}' ");
				$land->goodsNums -= $goodsNums;
				$land->optime = TIMESTAMP;
				$flag = $land->update();
				if($flag == false){
					return $this->error(1,"土地信息更新失败！");
				}
				$flag = $this->saveProduct($value["goodsId"], $goodsNums);
				if($flag == false){
					return $this->error(1,"商品信息更新失败！！");
				}
				$flag = $this->saveOrchardLogs(array("uid"=>$userId,"disUid"=>$ownerId,"mobile"=>$dogInfo["mobile"],"types"=>"addGoods","landId"=>$value["goodsId"],"nums"=>$goodsNums,"msg"=>"偷取好友".$value["goodsName"].$goodsNums));
				if($flag == false){
					return $this->error(1,"商品信息日志更新失败！！");
				}
				$data[$value["landId"]] = array(
					"landId"=>$value["landId"],
					"goodsName"=>$value["goodsName"],
					"goodsNums"=>$value["goodsNums"],
					"nums"=>$goodsNums
				);
				$dataStr .= $value["goodsName"].$goodsNums;
			}
		}
		if(empty($dataStr)){
			$info = array(",然而什么也没获得",",然而并没有失去什么");
		}else{
			$info = array(",获得".$dataStr,",失去".$dataStr);
		}
		//记录更新
		$flag = $this->saveSteal(array("uid"=>$userId,"huid"=>$ownerId,"dogInfo"=>array($dogInfo,$ownerDogInfo),"dogStatus"=>  $dogStatus,"chance"=>$chance,"mt"=>$mt,"landInfo"=>$data));
		if($flag == false){
			return $this->error(1,"偷取记录更新失败！");
		}
		$flag = $this->saveOrchardLogs(array("uid"=>$userId,"mobile"=>$dogInfo["mobile"],"disUid"=>$ownerId,"types"=>"hail_steal","nums"=>0,"msg"=>"偷取好友果实偷取成功".$info[0]));
		if($flag == false){
			return $this->error(1,"偷取日志记录更新失败！");
		}
		$flag = $this->saveOrchardLogs(array("uid"=>$ownerId,"mobile"=>$ownerDogInfo["mobile"],"disUid"=>$userId,"types"=>"hail_steal","nums"=>0,"msg"=>"被好友偷取时防御失败".$info[1]));
		if($flag == false){
			return $this->error(1,"偷取好友日志记录更新失败！");
		}
		return ["message"=>$dataStr];
//		print_r($landInfo);
	}
	//类型果实获取
	function getStealInfo($stealInfo,$userGrade){
		if(!empty($stealInfo["goods"])){
			krsort($stealInfo["goods"]);
			foreach ($stealInfo["goods"] as $key => $value) {
				if($userGrade>=$key){
					return $value;
				}
			}
		}
		return false;
	}
	//验证会员与自己的关系
	function checkFriend($ownerId){
		$hailFellow = new OrchardHailFellow();
		$hail = $hailFellow->findFirst("uid='{$this->userid}' AND huid='{$ownerId}' AND status=1 AND isDel=0");
		if($hail == false){
			return false;
		}
		return true;
	}
	//验证双方宠物信息是否成功
	function checkFriendDog($dogInfo,$ownerDogInfo){
		if(empty($ownerDogInfo)){
			return true;
		}
		if($dogInfo["dogLevel"]>=$ownerDogInfo["dogLevel"] && $dogInfo["otherInfo"]["attack"]["min"]>=$ownerDogInfo["otherInfo"]["defense"]["min"] && $dogInfo["otherInfo"]["attack"]["max"]>=$ownerDogInfo["otherInfo"]["defense"]["max"]){
			return true;
		}
		return false;
	}
	//checkStealInfo
	function checkStealInfo($config,$uid,$huid){
		$steal = new OrchardSteal();
		$starttime = strtotime(date('Y-m-d', time()));
		$num = $steal->find("uid='{$uid}' AND huid='{$huid}' AND createtime>=".$starttime);
		$arr = $this->object2array($num);
		if(count($arr)>=$config["dayInfo"][1] && $config["dayInfo"][1]>0){
			return $this->error(1,"当日偷取好友次数超限！");
		}
		$nums = $steal->find("huid='{$huid}' AND createtime>=".$starttime);
		$data = $this->object2array($nums);
		if(count($data)>=$config["dayInfo"][2] && $config["dayInfo"][2]>0){
			return $this->error(1,"当日好友被偷次数超限！");
		}
		return true;
	}
	//好友偷取日志记录
	function saveSteal($data){
		$steal = new OrchardSteal();
		$steal->uid = $data["uid"];
		$steal->huid = $data["huid"];
		$steal->dogInfo = json_encode($data["dogInfo"]);
		$steal->dogStatus = $data["dogStatus"] == false?0:1;
		$steal->chance = $data["chance"];
		$steal->mt = $data["mt"];
		$steal->landInfo = json_encode($data["landInfo"],JSON_UNESCAPED_UNICODE);
		$steal->createtime = TIMESTAMP;
		return $steal->save();
	}
	//偷取时宠物体力更新
	function stealDogPower($dogInfo,$type,$config){
		$dog = new OrchardDog();
		$dog = $dog->findFirst("id='{$dogInfo['id']}'");
		$dog->optime = TIMESTAMP;
		$dog->power -= $config[$type]["power"];
		if($dog->power <0){
			$dog->power = 0;
		}
		return $dog->update();
	}
	//偷取时用户经验增加
	function stealDogExperience($dogInfo,$config){
		$dog = new OrchardDog();
		$dog = $dog->findFirst("id='{$dogInfo['id']}'");
		$dog->experience += $config["error"]["experience"];
		$dogConfig = $this->getConfig("dogInfo");
		if(!empty($dogConfig["experience"][$dogInfo['dogLevel']]) && $dog->experience>=$dogConfig["experience"][$dogInfo['dogLevel']] &&  $dogConfig["experience"][$dogInfo['dogLevel']]>0){
			$userGrade = $this->selectUser($dogInfo["uid"], "grade");
			if($dogInfo['dogLevel']+3>$userGrade){
				$dog->experience = $dogConfig["experience"][$dogInfo['dogLevel']];
			}else{
				$dog->experience = 0;
				$dog->dogLevel +=1;
				$dog->powerUlimit += $dogConfig["power"][2] + rand(1, 10)*10;
				$otherInfo = $this->upgradeOthderInfo(json_decode($dog->otherInfo,true),$dogInfo['dogLevel']);
				$dog->score = $this->countScore($otherInfo, $dogInfo['id'],$dogInfo['dogLevel']);
				$dog->otherInfo = json_encode($otherInfo);
			}
		}
		return $dog->update();
	}

	//移动
	//宠物升级或训练 属性增加
	function upgradeOthderInfo($othderInfo,$dogLevel = ""){
		$config = $this->getConfig("dogInfo");
		if($dogLevel>0){
			$mt = 1;
		}else{
			$mt = rand(1,2);
		}
		$size = rand(0, 3);
		$othderInfo["isUpPower"] = 0;
		if($mt ==1 && !empty($config)){
			$sizeInfo = array("attack","defense","speed","");
			foreach ($othderInfo as $key => &$value) {
				if(@in_array($key,array("attack","defense","speed"))){
					if($key == $sizeInfo[$size]){
						if($value["max"]<=$value["min"]){
							$value["min"] += $config[$key][2]["min"]+  max(0, $config[$key][2]["max"]-$config[$key][2]["min"]);
						}else{
							$value["min"] += $config[$key][2]["min"]+  max(0, $config[$key][2]["min"]);
						}
						$value["max"] += $config[$key][2]["max"]+  max(0, $config[$key][2]["max"]);
					}
				}elseif(@in_array($key,array("lucky"))){
					if(date("s")%2 == 0){
						$value += $config[$key][2];
					}elseif(date("s")%1 == 0){
						$othderInfo["isUpPower"] = rand($config["powerUlimit"][2]["min"], $config["powerUlimit"][2]["max"]);
					}
				}
			}
		}
		return $othderInfo;
	}

	//转移
	//计算宠物评分
	public function countScore($data = "",$dogId = "",$dogLevel = 1){
		$dog = new OrchardDog();
		$score = 0;
		if($dogId>0){
			$item = $dog->findFirst("id='{$dogId}' AND uid='{$this->userid}'");
			$dogInfo = $this->object2array($item);
			if($dogLevel>0){
				$dogInfo["dogLevel"] = intval($dogLevel);
			}
			$data = json_decode($dogInfo['otherInfo'],true);
		}else{
			$dogInfo = array("dogLevel"=>$dogLevel);
		}
		if(empty($data)){
			return $score;
		}
		foreach ($data as $key => $value) {
			if(@in_array($key,array("attack","defense","speed"))){
				$score += ($value["min"]+$value["max"])*$dogInfo["dogLevel"];
			}else{
				$score += $value*$dogInfo["dogLevel"]*10;
			}
		}
		return $score;
	}
	//种子库存
	function getFruitTotalNums($type = "",$nums = ""){
		$total = $this->getConfig("total");
		if(@is_array($total)){
			$total = $total["total"];
		}
		if($type == "save" && $nums>0){
			$config = new Orchard();
			$config = $config->findFirst("id=1");
			$config->total -= $nums;
			if($config->total<=0){
				$config->total = 0;
			}
			$config->updatetime = TIMESTAMP;
			return $config->update();
		}
//		$order = new OrchardOrder();
//		$list = $order->findFirst(
//				array(
//					'conditions' => "types='seed' AND payStatus=1",
//					'columns' => 'sum(fruit)'
//				)
//			);
//		$data = $this->object2array($list);
//		if(!empty($data)){
//			$total -= $data[0];
//		}
		if($total>=10000){
			return array(sprintf("%.2f",$total/10000)."万",$total);
		}elseif($total>0){
			return array($total,$total);
		}else{
			return array(0,0);
		}
	}
	//获取大盘数据最新价格 金币价格
	public function getfruitNewPrice(){
		$order = Order::findFirst(
			[
				'conditions'=>"sid = 1 AND status = 1 AND dealnum>0",
				'order'		 =>'endtime DESC',
				'limit'		 =>'1'
			]
		);
		if($order == false){
			return false;
		}
		return $order->dealprice;
	}
	//金币日志
	public function saveOrchardCost($nums = ""){
		if($nums<=0){
			return false;
		}
		$usercost = new UserCost();
		$usercost->uid = $this->userid;
		$usercost->sum = $nums;//金币数量
		$usercost->orderNumber = $this->createOrderNumber();
		$usercost->createtime = TIMESTAMP;
		$usercost->endtime = TIMESTAMP;
		$usercost->charge = 0;
		$usercost->status = 1;
		$usercost->type = "兑换{$this->zuanshiTitle}";
		return $usercost->save();
	}
	public function createOrderNumber(){
		return $orderNumber = "Dui".date("YmdHis",TIMESTAMP).str_pad($this->userid,'6','0',STR_PAD_LEFT);
	}
	//金币日志
	public function saveTradeLogs($nums = ""){
		$logs = new TradeLogs();
		$logs->uid = $this->userid;
		$logs->mobile = $this->mobile;
		$logs->num = $nums;
		$logs->logs = "用户兑换{$this->zuanshiTitle}扣除".$nums."金币";
		$logs->type = "dedcoing";
		$logs->createtime = TIMESTAMP;
		$logs->status = 1;
		$result =  $logs->save();
		return $result;
	}
	//平台增加种子记录
	function updateConfigTotal($data = ""){
		if($data["nums"]<=0){
			return false;
		}
		$config = new Orchard();
		$config = $config->findFirst("id=1");
		$config->total += $data["nums"];
		$config->updatetime = TIMESTAMP;
		$flag = $config->update();
		if($flag == false){
			return false;
		}
		return  $this->saveOrchardLogs($data);
	}
		/**
	 * 日志记录函数
	 * @param max $message 日志内容，建议为数组包含操作函数和原因
	 * @param string $level 日志重要程度
	 */
	public function logsInfo($level = "info",$message) {
		$file = WEB_PATH . '/logs/';
		if(!file_exists($file)){
			@mkdir($file);
		}
		$filename = $file ."orchard". date('Ymd') . '.txt';
		$content = date('Y-m-d H:i:s') . " {$level} :\n------------\n";
		if (is_string($message)) {
			$content .= "String:$message";
		}
		if (is_object($message)) {
			$content .= "Object:\n" . var_export($message, TRUE) . "\n";
		}
		if (is_array($message)) {
			$content .= "Array:\n" . var_export($message, TRUE) . "\n";
		}
		$content .= "\n";
		$fp = fopen($filename, 'a+');
		fwrite($fp, $content);
		fclose($fp);
	}
	//毫秒时间
	function getMillisecond() {
		list($s1, $s2) = explode(' ', microtime());
		return (float)sprintf('%.0f', (floatval($s1) + floatval($s2)) * 1000);
	}
	//同步用户在线时间
	public function olineUser($uid){
		$user = User::findFirst("id = '$uid'");
		$info = json_encode($user->toArray());
		$userInfo = UserLog::findFirst("uid = '{$uid}'");
		if (empty($userInfo)){
			$userInfo = new UserLog();
			$userInfo->uid = $uid;
			$userInfo->user = $user->user;
			$userInfo->ip = $this->request->getClientAddress();
			$userInfo->logintime = TIMESTAMP;
			$userInfo->info = $info;
			$result = $userInfo->save();
		}else{
			if($userInfo->logintime +120 > TIMESTAMP){
				return true;
			}
			$userInfo->logintime = TIMESTAMP;
			$userInfo->info = $info;
			$result = $userInfo->update();
		}
		return $result;
	}
	//检测房屋是否掉级
	public function checkHouseOutOf($userInfo){
		$downgrade = $this->getConfig("downgrade");
		if($downgrade["status"] != 1 || $userInfo["houseLv"]<$downgrade["grade"] || $userInfo["houseLv"]<=$downgrade["land"][$userInfo["houseLv"]]['grade']){
			return true;
		}
		//开始检测
		$logs = new OrchardLand();
		$item = $logs->findFirst("uid='{$this->userid}' AND landId =".($userInfo["houseLv"]-1));
		if($item == false){
			return false;
		}
		$down = new OrchardDowngrade();
		$downInfo = $down->findFirst("uid='{$this->userid}' ORDER BY id desc");
		if($downInfo != false && $downInfo->createtime > $item->createtime){
			$item->createtime = $downInfo->createtime;
		}
		if($item->createtime<1509033600){
			$item->createtime = 1509033600;
		}
		$upDays = (TIMESTAMP-$item->createtime)/(24*3600);
		if($upDays<$downgrade["land"][$userInfo["houseLv"]]["day"] && $downgrade["land"][$userInfo["houseLv"]]["day"]>0){
			return true;
		}
		$this->db->begin();
		//会员房屋更新
		$rea = $this->updateUser($this->userid,"grade",$userInfo["houseLv"]-$downgrade["land"][$userInfo["houseLv"]]['grade'],"ded");
		//会员土地更新
		$reb = $this->db->query("DELETE FROM `dhc_orchard_land` WHERE uid='{$this->userid}' AND landId>='{$downgrade["land"][$userInfo["houseLv"]]['grade']}'");
		//掉级日志记录
		$rec = $this->saveDowngrade(array("uid"=>$this->userid,"houseLv"=>$userInfo["houseLv"],"grade"=>$downgrade["land"][$userInfo["houseLv"]]['grade'],"htime"=>$item->createtime,"info"=>json_encode($downgrade),"status"=>1));
		if($rea == false || $reb == false || $rec == false){
			$this->db->rollback();
			return false;
		}
		$this->db->commit();
		$this->userid = 0 ;
		$this->ajaxResponse("", "因房屋长期未进行升级，房屋被强制降级，请重新登录后查看！",1);
		return true;
	}
	//掉级日志更新
	function saveDowngrade($data){
		$downgrade = new OrchardDowngrade();
		$item = $downgrade->findFirst("uid='{$data['uid']}' AND houseLv='{$data['houseLv']}' AND grade='{$data['grade']}' AND htime='{$data['htime']}'");
		if(!empty($item)){
			return false;
		}
		$downgrade->uid = $data["uid"];
		$downgrade->houseLv = $data["houseLv"];
		$downgrade->grade = $data["grade"];
		$downgrade->htime = $data["htime"];
		$downgrade->info = $data["info"];
		$downgrade->status = $data["status"];
		$downgrade->createtime = TIMESTAMP;
		return $downgrade->save();
	}
}
