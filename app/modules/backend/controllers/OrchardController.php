<?php
namespace Dhc\Modules\Backend\Controllers;
use Dhc\Models\Config;
use Dhc\Models\OrchardDowngrade;
use Dhc\Models\User;
use Dhc\Models\Orchard;
use Dhc\Models\OrchardGoods;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardLogs;
use Dhc\Models\OrchardOrder;
use Dhc\Models\OrchardLand;
use Dhc\Models\OrchardDog;
use Dhc\Models\OrchardHailFellow;
use Dhc\Models\OrchardDoubleEffect;
use Dhc\Models\Product;
use MongoDB\BSON\Timestamp;
use Phalcon\Http\Response;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;
class OrchardController extends ControllerBase{
	public $op ="";
	public $model = "orchard";
	public $psize = 15;
	public $app_admin_path ="";
	public function configAction(){
		$orchard = new Orchard();
		$this->op = $this->request->get('op')? $this->request->get('op'):'post';
		$this->view->setVar('op',$this->op);
		//关联产品读取
		$product = new Product();
		$product = $product->find(array(
			"conditions"=>"status=1 AND id !=1",
			"order"=>"id asc",
		));
		$this->view->setVar('product',$product);
		$duiType = $this->getDuiType();
		$this->view->setVar('duiType',$duiType);
		$this->view->setVar('hostType',USER_TYPE);
		$item  = $orchard->findFirst("id= 1");
		if($this->op =="post"){
			if ($this->request->getPost()){
				$data = $this->request->getPost();
				if($data["id"] >0){
					$item->title =  $data['title'];
					$item->status = $data['status']>0?"1":"0";
					$item->total = $data["total"];
					$item->upGrade = $data['upGrade']>0?$data['upGrade']:"1";
					$item->updatetime=  TIMESTAMP;
					$item->id = 1;
					$item->msgprice=intval($data["msgprice"]);
                    $item->transferfee=round(floatval($data["transferfee"]),2);
					$flag = $item->update();
				}else{
					$orchard->title =  $data['title'];
					$orchard->status = $data['status']>0?"1":"0";
					$orchard->total =  $data['total']>0?$data['total']:0;
					$orchard->upGrade = $data['upGrade']>0?$data['upGrade']:"1";
					$orchard->updatetime=  TIMESTAMP;
					$orchard->createtime =TIMESTAMP;
                    $item->msgprice=intval($data["msgprice"]);
                    $item->transferfee=round(floatval($data["transferfee"]),2);
					$flag = $orchard->save();
				}
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif($this->op == 'usertype'){
			$this->userType = json_decode($item->userType,true);
			$this->view->setVar('userType',$this->userType);
		}elseif($this->op == 'landInfo'){
			$this->landInfo = json_decode($item->landInfo,true);
			$this->landFruit = json_decode($item->landFruit,true);
			$this->landUpInfo = json_decode($item->landUpInfo,true);
			$landType = $orchard->getLandType();
			$this->view->setVar('landInfo',$this->landInfo);
			$this->view->setVar('landType',$landType);
			$this->view->setVar('landFruit',$this->landFruit);
			$this->view->setVar('landUpInfo',$this->landUpInfo);
			$landSuper = $orchard->getSuperInfo();
			$this->view->setVar('landSuper',$landSuper);

			if ($this->request->getPost()){
				$item->landInfo = !empty($this->request->getPost("landInfo"))?json_encode($this->request->getPost("landInfo"),JSON_UNESCAPED_UNICODE):"0";
				$item->landFruit = !empty($this->request->getPost("landFruit"))?json_encode($this->request->getPost("landFruit"),JSON_UNESCAPED_UNICODE):"0";
				$item->landUpInfo = !empty($this->request->getPost("landUpInfo"))?json_encode($this->request->getPost("landUpInfo"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>//alert('更新失败!');//window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif($this->op == 'duiset'){
			$this->duiInfo = json_decode($item->duiInfo,true);
			$this->view->setVar('duiInfo',$this->duiInfo);
			if ($this->request->getPost()){
				$item->duiInfo = !empty($this->request->getPost("duiInfo"))?json_encode($this->request->getPost("duiInfo"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif($this->op == "house"){
			$this->houseInfo = json_decode($item->houseInfo,true);
			$this->view->setVar('houseInfo',$this->houseInfo);
			if ($this->request->getPost()){
				$item->houseInfo = !empty($this->request->getPost("houseInfo"))?json_encode($this->request->getPost("houseInfo"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif($this->op == 'dogInfo'){
			$this->dogInfo = json_decode($item->dogInfo,true);
			$this->view->setVar('dogInfo',$this->dogInfo);
			if ($this->request->getPost()){
				$item->dogInfo = !empty($this->request->getPost("dogInfo"))?json_encode($this->request->getPost("dogInfo"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif($this->op == 'statueInfo'){
			$this->statueType = $this->getStatueType();
			$this->view->setVar('statueType',$this->statueType);
			$this->statueInfo = json_decode($item->statueInfo,true);
			$this->view->setVar('statueInfo',$this->statueInfo);
			$OrchardGoods = new OrchardGoods();
			$goods = $OrchardGoods->find(" type in (10,11,12,13)");
			$this->view->setVar('goods',$goods);
			if ($this->request->getPost()){
				$item->statueInfo = !empty($this->request->getPost("statueInfo"))?json_encode($this->request->getPost("statueInfo"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif($this->op == 'recharge'){
			$this->recharge = json_decode($item->recharge,true);
			$this->view->setVar('recharge',$this->recharge);
			$this->rebate = json_decode($item->rebate,true);
			$this->view->setVar('rebate',$this->rebate);
			if ($this->request->getPost()){
				$item->recharge = !empty($this->request->getPost("recharge"))?json_encode($this->request->getPost("recharge"),JSON_UNESCAPED_UNICODE):"0";
				$item->rebate = !empty($this->request->getPost("rebate"))?json_encode($this->request->getPost("rebate"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif($this->op == 'background'){
			$backgroundType = $this->getBackgroundType();
			$this->view->setVar('backgroundType',$backgroundType);
			$this->background = json_decode($item->background,true);
			$this->view->setVar('background',$this->background);
			if ($this->request->getPost()){
				$item->background = !empty($this->request->getPost("background"))?json_encode($this->request->getPost("background"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif($this->op == 'package'){
			$tableType = $orchard->getAdminType();
			$this->view->setVar('tableType',$tableType);
			$this->package = json_decode($item->package,true);
			$this->view->setVar('package',$this->package);
			$this->indemnify = json_decode($item->indemnify,true);
			$this->view->setVar('indemnify',$this->indemnify);
			$this->newGiftPack = json_decode($item->newGiftPack,true);
			$this->view->setVar('newGiftPack',$this->newGiftPack);
			if ($this->request->getPost()){
				$item->package = !empty($this->request->getPost("package"))?json_encode($this->request->getPost("package"),JSON_UNESCAPED_UNICODE):"0";
				$item->indemnify = !empty($this->request->getPost("indemnify"))?json_encode($this->request->getPost("indemnify"),JSON_UNESCAPED_UNICODE):"0";
				$item->newGiftPack = !empty($this->request->getPost("newGiftPack"))?json_encode($this->request->getPost("newGiftPack"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif($this->op == 'sign'){
			$tableType = $orchard->getAdminType();
			$this->view->setVar('tableType',$tableType);
			$this->sign = json_decode($item->sign,true);
			$this->view->setVar('sign',$this->sign);
			if ($this->request->getPost()){
				$item->sign = !empty($this->request->getPost("sign"))?json_encode($this->request->getPost("sign"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif($this->op == 'steal'){
			$userType = array(1,4,6,7,8,9,10,11,12);
			$this->view->setVar('userType',$userType);
			$this->steal = json_decode($item->steal,true);
			$this->view->setVar('steal',$this->steal);
			if ($this->request->getPost()){
				$item->steal = !empty($this->request->getPost("steal"))?json_encode($this->request->getPost("steal"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}elseif ($this->op == 'crystal'){
			if (USER_TYPE == 'huangjin'){
				if ($this->request->isPost()){
					if (!empty($this->request->getPost())){
						$data = $this->request->getPost();
						$config = Config::findFirst("key = 'crystal'");
						if (empty($config)){
							$config = new  Config();
							$config->key = 'crystal';
							$config->value = serialize($data);
							$result = $config->save();
						}else{
							$config->value = serialize($data);
							$result = $config->update();
						}
						if (empty($result)){
							exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
						}else{
							exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
						}
					}
				}else{
					$config = Config::findFirst("key = 'crystal'");
					if (!empty($config)){
						$crystal = unserialize($config->value);
					}
				}
			}else{
				exit("<script>alert('操作失败!');window.location.href=window.location.href;</script>");
			}
			$this->view->setVar('crystal',$crystal['crystal']);
		}
		elseif($this->op == "downgrade"){
			$this->downgrade = json_decode($item->downgrade,true);
			if(empty($this->downgrade)){
				$this->downgrade["grade"] = 0;
				$this->downgrade["land"] = array(2=>array(),3=>array(),4=>array(),5=>array(),6=>array(),7=>array(),8=>array(),9=>array(),10=>array(),11=>array());
				$this->downgrade["double"] = 0;
				$this->downgrade["status"] = 0;
			}
			$this->view->setVar('downgrade',$this->downgrade);
			if ($this->request->getPost()){
				$item->downgrade = !empty($this->request->getPost("downgrade"))?json_encode($this->request->getPost("downgrade"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}
		elseif($this->op == "EMG"){
			$this->EMG = json_decode($item->EMG,true);
			$this->view->setVar('EMG',$this->EMG);
			if ($this->request->getPost()){
				$item->EMG = !empty($this->request->getPost("EMG"))?json_encode($this->request->getPost("EMG"),JSON_UNESCAPED_UNICODE):"0";
				$flag = $item->update();
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href=window.location.href;</script>");
				}
			}
		}
		$this->view->setVar('item',$item);
		$this->view->pick('orchard/config');
	}

	public function goodsAction(){
		//分页数据

		$pindex = max(1, $this->request->get('page'));
		$this->op =  $this->request->get('op')? $this->request->get('op'):'display';
		$this->view->setVar('op',$this->op);
		$this->tName = $this->request->get('tName')? $this->request->get('tName'):'';
		$this->type = $this->request->get('type')? $this->request->get('type'):'';
		$this->status = $this->request->get('status') ==1 || $this->request->get('status') =='' ? '1':'0';
		$condition = " isDel=0  ";
		//关联产品读取
		$product = new Product();
		$product = $product->find("status=1 AND id !=1");

		$goods = new OrchardGoods();
		$tId = $this->request->get("tId");
		if($tId){
			$item  = $goods->findFirst("tId= $tId");
			if(!empty($item->cost)){
				$item->cost = json_decode($item->cost,true);
				$this->view->setVar('cost',$item->cost);
			}
			if(!empty($item->chanceInfo)){
				$item->chanceInfo = json_decode($item->chanceInfo,true);
				$this->view->setVar('chanceInfo',$item->chanceInfo);
			}
		}else{
			if(!empty($this->tName)){
				$condition .= " AND (tName like '%{$this->tName}%' OR depick like '%{$this->tName}%' OR price like '%{$this->tName}%')";
			}
			if(!empty($this->type)){
				$condition .= " AND type ={$this->type}";
			}
		}
		$toolType = $this->getToolType();
		if($this->op == 'post'){
//			var_dump($item);exit;
			if ($this->request->isPost()){
				$data = $this->request->getPost();
				$goods->type = $data["type"];
				$goods->tName = $data["tName"];
				$goods->depict = $data["depict"];
				$goods->price = $data["price"];
				$goods->effect = $data["effect"];
				$goods->updatetime = TIMESTAMP;
				$goods->createtime = $item->createtime>0?$item->createtime:TIMESTAMP;
				$goods->status = $data['status']>0?"1":"0";
				$goods->isDel = 0;
				$goods->pack = $data["pack"]>0?$data["pack"]:0;
				$goods->buyOut = $data["buyOut"]>0?$data["buyOut"]:0;
				foreach ($data["cost"] as $key=>$val){
					if($val[1] <= 0){
						unset($data["cost"][$key]);
					}
				}
				$goods->cost = !empty($data["cost"])?json_encode($data["cost"]):"0";
				$goods->reclaimLimit = $data['reclaimLimit']>0?$data["reclaimLimit"]:"0";
				$goods->seedUser = $data['seedUser']>0?$data["seedUser"]:"0";
				$goods->seedShop = $data['seedShop']>0?$data["seedShop"]:"0";
				$goods->chanceInfo =  !empty($data["chanceInfo"])?json_encode($data["chanceInfo"],JSON_UNESCAPED_UNICODE):"0";
				if($data["tId"]){
					$goods->tId = $data["tId"];
					$flag = $goods->update();
					$this->getError($flag, $goods);
				}else{
					$flag = $goods->save();
				}
				if($flag == false){
					exit("<script>alert('更新失败!');window.location.href='".$this->app_admin_path."/admin/orchard/goods?op=display&page=".$pindex."';</script>");
				}else{
					exit("<script>alert('更新成功!');window.location.href='".$this->app_admin_path."/admin/orchard/goods?op=display&page=".$pindex."';</script>");
				}
			}
		}

		$goodsList =  $goods->find(array(
				'conditions' =>$condition,
				'order'		 =>'updatetime DESC'
			));
		$paginator = new PaginatorModel(array("data"	=> $goodsList,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$this->view->setVar('tId',$tId);
		$this->view->setVar('goodsList',$page);
		$this->view->setVar('item',$item);
		$this->view->setVar('toolType',$toolType);
		$this->view->setVar('tName',$this->tName);
		$this->view->setVar('type',$this->type);
		$this->view->setVar('status',$this->status);
		$this->view->setVar('product',$product);
		$this->view->pick('orchard/goods');
	}
	public function logsAction(){

		//分页数据
		$pindex = max(1, $this->request->get('page'));
		$this->op =  $this->request->get('op')? $this->request->get('op'):'display';
		$this->view->setVar('op',$this->op);
		$this->keywords = $this->request->get('keywords')? $this->request->get('keywords'):'';
		$this->types = $this->request->get('types')? $this->request->get('types'):'';
		$this->status = $this->request->get('status')? $this->request->get('status'):'';
		$condition = " `status` >=0 ";
		if(!empty($this->keywords)){
			$condition .= " AND (msg like '%{$this->keywords}%' OR uid like '%{$this->keywords}%' OR nums like '%{$this->keywords}%')";
		}
		if(!empty($this->types)){
			$condition .= " AND types ='{$this->types}'";
		}
		if(!empty($this->status)){
			$condition .= " AND status ='{$this->status}'";
		}
		if (!empty($this->request->get('time'))) {
			$time = $this->request->get('time');
			$starttime =  strtotime(date($time['start'],time()));
			$endtime =  strtotime(date($time['end'],time()))+86399;
			$condition .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
		}else{
			$starttime = strtotime(date("Y-m-d 00:00:00",time()));
			$endtime = strtotime(date("Y-m-d 23:59:59",time()));
			$condition .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
		}
		if($this->op == 'display'){
			$pageoffet = (($pindex-1)*$this->psize);
			$sql = "SELECT * FROM `dhc_orchard_logs` WHERE $condition  ORDER BY createtime DESC LIMIT $pageoffet,$this->psize ";
			$list = $this->db->query($sql)->fetchAll();
			$sql1 = "SELECT COUNT(id) as numbers FROM `dhc_orchard_logs` WHERE $condition";
			$total_num = $this->db->query($sql1)->fetch();
			$sql2 = "SELECT SUM(nums) as nums FROM `dhc_orchard_logs` WHERE $condition";
			$total_nums = $this->db->query($sql2)->fetch();
			$logsType = $this->getLogsType();
            $lists['total_pages'] = ceil($total_num['numbers']/$this->psize);
            $lists['next'] = min($pindex+1,$lists['total_pages']);
            $lists['before'] = max($pindex-1,1);
            $lists['last'] =   max($lists['total_pages'],0);
            $lists['current'] = max(intval($pindex),1);
            $lists['list'] = $list;
			$this->view->setVar('types',$this->types);
			$this->view->setVar('logsType',$logsType);
			$this->view->setVar('logsList',$lists);
			$this->view->setVar('total_nums',$total_nums['nums']);
		}elseif($this->op == 'list'){
			$pageoffet = (($pindex-1)*$this->psize);
			$sql = "SELECT * FROM dhc_orchard_double_effect WHERE $condition  ORDER BY id DESC LIMIT $pageoffet,$this->psize ";
			$list = $this->db->query($sql)->fetchAll();
			$sql1 = "SELECT COUNT(id) as numbers FROM dhc_orchard_double_effect WHERE $condition";
			$total_num = $this->db->query($sql1)->fetch();
			$logsType = array(
				""=>"全部",
				"4" => "铜宝箱",
				"5" => "银宝箱",
				"6" => "金宝箱",
				"7" => "钻石宝箱",
				"99"=>"系统消息"
			);
			$lists['total_pages'] = ceil($total_num['numbers']/$this->psize);
			$lists['next'] = min($pindex+1,$lists['total_pages']);
			$lists['before'] = max($pindex-1,1);
			$lists['last'] =   max($lists['total_pages'],0);
			$lists['current'] = max(intval($pindex),1);
			$lists['list'] = $list;
			$this->view->setVar('logsType',$logsType);
			$this->view->setVar('logsList',$lists);
		}elseif($this->op == 'post'){
			$logs = new OrchardDoubleEffect();
			if($this->request->getPost()){
				$data = $this->request->getPost("msg");
				$logs->uid = 0;
				$logs->types = 99;
				$logs->mark = "system";
				$logs->msg = $data;
				$logs->status = 1;
				$logs->createtime = TIMESTAMP;
				$logs->lasttime = 24*3600 + TIMESTAMP;
				$flag = $logs->save();
				if($flag == false){
					exit("<script>alert('系统消息发布失败!');window.location.href=window.location.href;</script>");
				}else{
					exit("<script>alert('系统消息发布成功!');window.location.href= window.location.href;</script>");
				}
			}
		}elseif($this->op == 'status'){
			$logs = new OrchardDoubleEffect();
			$id = $this->request->get("id");
			$item = $logs->findFirst("id='{$id}'");
			if(empty($item)){
				$flag = false;
			}else{
				if($item->status == 1){
					$item->status = 2;
				}else{
					$item->status = 1;
				}
				$flag = $item->update();
			}
			if($flag == false){
				exit("<script>alert('更新失败!');window.location.href='/admin/orchard/logs?op=list';</script>");
			}else{
				exit("<script>alert('更新成功!');window.location.href='/admin/orchard/logs?op=list';</script>");
			}
		}elseif($this->op == 'downgrade'){
			if(!empty($this->keywords)){
				$condition = " ( uid like '%{$this->keywords}%' OR grade like '%{$this->keywords}%' OR houseLv like '%{$this->keywords}%')";
			}
			$pageoffet = (($pindex-1)*$this->psize);
			$sql = "SELECT * FROM `dhc_orchard_downgrade` WHERE $condition  ORDER BY id DESC LIMIT $pageoffet,$this->psize ";
			$list = $this->db->query($sql)->fetchAll();
			$sql1 = "SELECT COUNT(id) as numbers FROM `dhc_orchard_downgrade` WHERE $condition";
			$total_num = $this->db->query($sql1)->fetch();
			$lists['total_pages'] = ceil($total_num['numbers']/$this->psize);
			$lists['next'] = min($pindex+1,$lists['total_pages']);
			$lists['before'] = max($pindex-1,1);
			$lists['last'] =   max($lists['total_pages'],0);
			$lists['current'] = max(intval($pindex),1);
			$lists['list'] = $list;
			$this->view->setVar('List',$lists);

		}
		$this->view->setVar('types',$this->types);
		$this->view->setVar('keywords',$this->keywords);
		$this->view->setVar('status',$this->status);
		$this->view->setVar('starttime',date("Y-m-d",$starttime));
		$this->view->setVar('endtime',date("Y-m-d",$endtime));
		$this->view->pick('orchard/logs');
	}
	public function orderAction(){
		$order = new OrchardOrder();
		//分页数据
		$pindex = max(1, $this->request->get('page'));
		$this->op =  $this->request->get('op')? $this->request->get('op'):'display';
		$this->view->setVar('op',$this->op);
		$this->keywords = $this->request->get('keywords')? $this->request->get('keywords'):'';
		$this->payStatus = $this->request->get('payStatus')? $this->request->get('payStatus'):'0';
		$this->types = $this->request->get('types')? $this->request->get('types'):'seed';
		$condition = " id >0 ";
		if(!empty($this->keywords)){
			$condition .= " AND (nickname like '%{$this->keywords}%' OR uid like '%{$this->keywords}%' OR mobile like '%{$this->keywords}%' OR coing like '%{$this->keywords}%' OR fruit like '%{$this->keywords}%')";
		}
		if(@in_array($this->payStatus,array(1,0))){
			$condition .= " AND payStatus ='{$this->payStatus}'";
		}
		if(!empty($this->types)){
			$condition .= " AND types ='{$this->types}'";
		}
		if (!empty($this->request->get('time'))) {
			$time = $this->request->get('time');
			$starttime =  strtotime(date($time['start'],time()));
			$endtime =  strtotime(date($time['end'],time()))+86399;
			$condition .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
		}else{
			$starttime = strtotime(date("Y-m-1 00:00:00",time()));
			$endtime = strtotime(date("Y-m-d 23:59:59",time()));
			$condition .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
		}
		$orderList =  $order->find(array(
				'conditions' =>$condition,
				'order'		 =>'id DESC'
			));
		$paginator = new PaginatorModel(array("data"	=> $orderList,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$this->view->setVar('orderList',$page);
		$this->view->setVar('payStatus',$this->payStatus);
		$this->view->setVar('keywords',$this->keywords);
		$this->view->setVar('types',$this->types);
		$orderType = $order->getOrderType();
		$this->view->setVar('orderType',$orderType);
		$this->view->setVar('starttime',date("Y-m-d",$starttime));
		$this->view->setVar('endtime',date("Y-m-d",$endtime));
		$this->view->pick('orchard/order');
	}
	public function orchardAction(){
		$land = new OrchardLand();
		$orchard = new Orchard();
		$landLevelInfo = $orchard->getLandType();
		//分页数据
		$pindex = max(1, $this->request->get('page'));
		$this->op =  $this->request->get('op')? $this->request->get('op'):'display';
		$this->view->setVar('op',$this->op);
		$this->keywords = $this->request->get('keywords')? $this->request->get('keywords'):'';
		$this->landId = $this->request->get('landId')? $this->request->get('landId'):'';
		$this->landStatus = $this->request->get('landStatus')? $this->request->get('landStatus'):'';
		$condition = " id>0";
		if($this->op == 'plowing'){
			$id = $this->request->get('id');
			$level = $this->request->get('level');
			if($id<=0 || $level<0){
				exit("<script>alert('操作失败!');window.location.href='/admin/orchard/orchard?op=display&page={$pindex}';</script>");
			}
			$landInfo =  $land->findFirst("id=".$id);
			if($landInfo == false || $landInfo->plowing == $level){
				exit("<script>alert('操作失败,条件不符！');window.location.href='/admin/orchard/orchard?op=display&page={$pindex}';</script>");
			}
			$landInfo->plowing = $level;
			$landInfo->updatetime = TIMESTAMP;
			$flag = $landInfo->save();
			if ($flag == false) {
				exit("<script>alert('操作失败，请重试!');window.location.href='/admin/orchard/orchard?op=display&page={$pindex}';</script>");
			}
			exit("<script>alert('操作成功!');window.location.href='/admin/orchard/orchard?op=display&page={$pindex}';</script>");
		}
		if(!empty($this->keywords)){
			$condition .= " AND (nickname like '%{$this->keywords}%' OR uid like '%{$this->keywords}%' OR mobile like '%{$this->keywords}%')";
		}
		if($this->landId !== ""){
			$condition .= " AND landId = '{$this->landId}' ";
		}
		if($this->landStatus !== ""){
			$condition .= " AND landStatus = '{$this->landStatus}' ";
		}
		if (!empty($this->request->get('time'))) {
			$time = $this->request->get('time');
			$starttime =  strtotime(date($time['start'],time()));
			$endtime =  strtotime(date($time['end'],time()))+86399;
			$condition .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
		}else{
			$starttime = strtotime(date("Y-m-1 00:00:00",time()));
			$endtime = strtotime(date("Y-m-d 23:59:59",time()));
			$condition .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
		}
		$landList =  $land->find(array(
				'conditions' =>$condition,
				'order'		 =>'id DESC'
			));
		$paginator = new PaginatorModel(array("data"	=> $landList,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$this->view->setVar('landList',$page);
		$this->view->setVar('keywords',$this->keywords);
		$landIdInfo = $land->getLandInfo();
		$landStatusInfo= $land->getLandStatus();
		$this->view->setVar('landId',$this->landId);
		$this->view->setVar('landStatus',$this->landStatus);
		$this->view->setVar('landIdInfo',$landIdInfo);
		$this->view->setVar('landLevelInfo',$landLevelInfo);
		$this->view->setVar('landStatusInfo',$landStatusInfo);
		$this->view->setVar('starttime',date("Y-m-d",$starttime));
		$this->view->setVar('endtime',date("Y-m-d",$endtime));
		$this->view->pick('orchard/land');
	}
	public function dogAction(){
		$dog = new OrchardDog();
		//分页数据
		$pindex = max(1, $this->request->get('page'));
		$this->op =  $this->request->get('op')? $this->request->get('op'):'display';
		$this->view->setVar('op',$this->op);
		$this->keywords = $this->request->get('keywords')? $this->request->get('keywords'):'';
		$condition = " id>0";
		if(!empty($this->keywords)){
			$condition .= " AND (nickname like '%{$this->keywords}%' OR uid like '%{$this->keywords}%' OR id like '%{$this->keywords}%' OR mobile like '%{$this->keywords}%'  OR dogName like '%{$this->keywords}%')";
		}
		if (!empty($this->request->get('time'))) {
			$time = $this->request->get('time');
			$starttime =  strtotime(date($time['start'],time()));
			$endtime =  strtotime(date($time['end'],time()))+86399;
			$condition .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
		}else{
			$starttime = strtotime(date("Y-m-1 00:00:00",time()));
			$endtime = strtotime(date("Y-m-d 23:59:59",time()));
			$condition .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
		}
		$dogList =  $dog->find(array(
				'conditions' =>$condition,
				'order'		 =>'id DESC'
			));
		$paginator = new PaginatorModel(array("data"	=> $dogList,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$this->view->setVar('starttime',date("Y-m-d",$starttime));
		$this->view->setVar('endtime',date("Y-m-d",$endtime));
		$this->view->setVar('dogList',$page);
		$this->view->setVar('keywords',$this->keywords);
		$this->view->pick('orchard/dog');
	}
	public function userAction(){
		$user = new OrchardUser();
		//分页数据
		$pindex = max(1, $this->request->get('page'));
		$this->op =  $this->request->get('op')? $this->request->get('op'):'display';
		$this->view->setVar('op',$this->op);
		$this->keywords = $this->request->get('keywords')? $this->request->get('keywords'):'';
		$this->status = $this->request->get('status')? $this->request->get('status'):0;
		$this->ulevel = $this->request->get('ulevel')?$this->request->get('ulevel'):'';
		$condition = " id >0 ";
		if(!empty($this->keywords)){
			$condition .= " AND (nickname like '%{$this->keywords}%' OR uid like '%{$this->keywords}%' OR mobile like '%{$this->keywords}%')";
		}
		if(!empty($this->status)){
			$condition .= " AND status ='{$this->status}'";
		}
//		if (!empty($this->request->get('time'))) {
//			$time = $this->request->get('time');
//			$starttime =  strtotime(date($time['start'],time()));
//			$endtime =  strtotime(date($time['end'],time()))+86399;
//			$condition .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
//		}else{
//			$starttime = strtotime(date("Y-m-1 00:00:00",time()));
//			$endtime = strtotime(date("Y-m-d 23:59:59",time()));
//			$condition .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
//		}
		if (!empty($this->ulevel)){
			$condition .= " AND grade = {$this->ulevel}";
		}
		if($this->op == 'status'){
			$id = $this->request->get("id");
			if($id<=0){
				exit("<script>alert('参数异常修改失败!');window.location.href='".$this->app_admin_path."/admin/orchard/user?op=display&page=".$pindex."';</script>");
			}
			$this->db->begin();
			$user = $user->findFirst("id={$id}");
			if(empty($user)){
				exit("<script>alert('果园会员数据信息异常!');window.location.href='".$this->app_admin_path."/admin/orchard/user?op=display&page=".$pindex."';</script>");
			}
			$mc = new User();
			$mc = $mc->findFirst("id='{$user->uid}'");
			if(empty($mc)){
				exit("<script>alert('会员数据信息异常!');window.location.href='".$this->app_admin_path."/admin/orchard/user?op=display&page=".$pindex."';</script>");
			}
			if($user->status =="1"){
				$mc->status = $user->status = 9;
			}else{
				$mc->status = $user->status = 1;
			}
			$mc->updatetime = $user->updatetime =TIMESTAMP;
			$flag = $user->update();
			$flag1 = $mc->update();
			if($flag == false || $flag1 == false){
				$this->db->rollback();
				exit("<script>alert('更新失败!');window.location.href='".$this->app_admin_path."/admin/orchard/user?op=display&page=".$pindex."';</script>");
			}else{
				$this->db->commit();
				exit("<script>alert('更新成功!');window.location.href='".$this->app_admin_path."/admin/orchard/user?op=display&page=".$pindex."';</script>");
			}
		}elseif($this->op == 'hail'){
			if($this->status == 0){
				$condition .= " AND status=0 ";
			}
			$hail = new OrchardHailFellow();
			$hailList =  $hail->find(array(
					'conditions' =>$condition,
					'order'		 =>'id DESC'
				));
			$paginator = new PaginatorModel(array("data"	=> $hailList,"limit"	=>$this->psize,"page" =>$pindex));
			$page = $paginator->getPaginate();
			$this->view->setVar('hailList',$page);
		}elseif($this->op == 'savehail'){
			$id = $this->request->get("id");
			$status =  $this->request->get("status");
			if($id<=0 || !@in_array($status,array(1,9))){
				exit("<script>alert('参数异常修改失败!');window.location.href='".$this->app_admin_path."/admin/orchard/user?op=hail&page=".$pindex."';</script>");
			}
			$this->db->begin();
			$hail = new OrchardHailFellow();
			$item = $hail->findFirst("id={$id}");
			if(empty($item)){
				$this->db->rollback();
				exit("<script>alert('果园会员数据信息异常!');window.location.href='".$this->app_admin_path."/admin/orchard/user?op=display&page=".$pindex."';</script>");
			}
			if($status ==9){
				$item->status = 9;
				$flag1 = true;
			}elseif($status ==1){
				$hailUser = $hail->findFirst("uid={$item->huid} AND huid='{$item->uid}'");
				$item->status = 1;
				if(empty($hailUser)){
					$hail->status =1;
					$hail->uid = $item->huid;
					$hail->huid = $item->uid;
					$hailInfo = $this->selectUserInfo($item->uid);
					$hail->nickname = $hailInfo->nickname;
					$hail->mobile = $hailInfo->mobile;
					$hail->createtime = $hail->updatetime = TIMESTAMP;
					$flag1 = $hail->save();
				}else{
					$hailUser->status = 1;
					$hailUser->updatetime = TIMESTAMP;
					$flag1 = $hailUser->update();
				}
			}
			$item->updatetime = TIMESTAMP;
			$flag = $item->update();
			if($flag == false || $flag1 == false){
				$this->db->rollback();
				exit("<script>alert('更新失败!');window.location.href='".$this->app_admin_path."/admin/orchard/user?op=hail&page=".$pindex."';</script>");
			}else{
				$this->db->commit();
				exit("<script>alert('更新成功!');window.location.href='".$this->app_admin_path."/admin/orchard/user?op=hail&page=".$pindex."';</script>");
			}
		}elseif($this->op == 'admin'){
			$orchard = new Orchard();
			$getAdminType = $orchard->getAdminType();
			$this->view->setVar('getAdminType',$getAdminType);
			if ($this->request->getPost()){
				$this->db->begin();
				$data = $this->request->getPost();
				$user = new OrchardUser();
				$user = $user->findFirst("uid='{$data['uid']}'");
				if($user == false){
					$this->db->rollback();
					exit("<script>alert('更新失败!');window.location.href='".$this->app_admin_path."/admin/orchard/user';</script>");
				}
				$model = $data["model"];
				if($data["types"] == "adminded" && $user->$model>=$data["nums"]){
					$user->$model -= $data["nums"];
					$nums = -$data["nums"];
					$optitle = "扣除";
				}elseif($data["types"] == "adminadd"){
					$user->$model += $data["nums"];
					$nums = $data["nums"];
					$optitle = "添加";
				}else{
					$this->db->rollback();
					exit("<script>alert('更新失败!');window.location.href='".$this->app_admin_path."/admin/orchard/user';</script>");
				}
				$user->updatetime = TIMESTAMP;
				$flag = $user->update();

				if($flag == false){
					$this->db->rollback();
					exit("<script>alert('更新失败!');window.location.href='".$this->app_admin_path."/admin/orchard/user';</script>");
				}
				$logs = new OrchardLogs();
				$logs->uid = $data["uid"];
				$logs->mobile = $user->mobile;
				$logs->types= $data["types"];
				$logs->nums= $nums;
				$logs->disUid = 1;
				$logs->status = 1;
				$logs->createtime = TIMESTAMP;
				$logs->msg = "管理员后台".$optitle.$getAdminType[$data['model']].$data["nums"];
				$flag = $logs->save();
				if($flag == false){
					$this->db->rollback();
					exit("<script>alert('更新失败!');window.location.href='".$this->app_admin_path."/admin/orchard/user';</script>");
				}
				$this->db->commit();
				exit("<script>alert('更新成功!');window.location.href='".$this->app_admin_path."/admin/orchard/user';</script>");
			}
		}elseif($this->op == 'edit'){
			$id = $this->request->get('id');
			if ($this->request->isPost()){
				$data = $this->request->getPost();
				$types = $this->gettypes();
				$this->db->begin();
				$userInfo = OrchardUser::findFirst("id = '{$data['id']}'");
				foreach ($data as $key=>$value){
					$k = ($userInfo->$key - $data[$key]);
					if ($k != 0){
						$info = $userInfo->$key;
						$userInfo->$key = abs($data[$key]);
						$result = $userInfo->update();
						if (empty($result)){
							$this->db->rollback();
							$this->message('更新失败','','error');
						}else{
							$result= $this->SaveOrchardLogs(['uid'=>$data['uid'],'msg'=>'原库存'.$info.'后台操作'.$types[$key].'修改数量为'.abs($data[$key]),'num'=>abs($data[$key])]);
							if (empty($result)){
								$this->db->rollback();
								exit("<script>alert('记录保存失败');history.go(-1);</script>");
							}
						}

					}
				}
				$this->db->commit();
				$this->response->redirect(APP_ADMIN_PATH.'/orchard/user');
			}else{
				$userInfo = OrchardUser::findFirst("id = $id");
				if (!empty($userInfo)){
					$this->view->setVar('item',$userInfo);
				}else{
					exit("<script>alert('暂无未开通游戏');history.go(-1);</script>>");
				}
			}
		}elseif($this->op == 'downgrade'){
			$uid = $this->request->get('uid');
			$userInfo = OrchardUser::findFirst("uid = '{$uid}'");
			if($userInfo == false || $userInfo->grade<=1){
				exit("<script>alert('用户信息获取失败，无法操作');history.go(-1);</script>>");
			}
			$this->db->begin();
			$userInfo->grade -=1;
			$userInfo->updatetime = TIMESTAMP;
			$rea = $userInfo->update();
			$reb = $this->db->query("DELETE FROM `dhc_orchard_land` WHERE uid='{$uid}' AND landId>='{$userInfo->grade}'");
			//掉级日志记录
			$rec = $this->saveDowngrade(array("uid"=>$uid,"houseLv"=>$userInfo->grade+1,"grade"=>$userInfo->grade,"htime"=>time(),"info"=>json_encode($userInfo),"status"=>2));
			if($rea == false || $reb == false || $rec == false){
				$this->db->rollback();
				exit("<script>alert('操作失败,请重试！');history.go(-1);</script>");
			}
			$this->db->commit();
			exit("<script>alert('操作成功！');history.go(-1);</script>");
		}
		$userList =  $user->find(array(
				'conditions' =>$condition,
				'order'		 =>'id DESC'
			));
		$paginator = new PaginatorModel(array("data"	=> $userList,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$all_people = count($userList);
		$this->view->setVar('all_peple',$all_people);
		$this->view->setVar('userList',$page);
		$this->view->setVar('status',$this->status);
		$this->view->setVar('keywords',$this->keywords);
		$this->view->setVar('ulevel',$this->ulevel);
		$this->view->pick('orchard/user');
	}
	public function selectUserInfo($uid = ""){
		$user = new OrchardUser();
		return  $user->findFirst("uid='{$uid}'");
	}
	public function getToolType(){
		return [
			""=>"无选择",
			"1"=>"种子",
//			"2"=>"道具",
			"3"=>"宝箱",
			"4"=>"锄头",
			"5"=>"宠物",
			"6"=>"化肥",
			"7"=>"洒水壶",
			"8"=>"除草剂",
			"9"=>"除虫剂",
			"10"=>"绿宝石",
			"11"=>"紫宝石",
			"12"=>"蓝宝石",
			"13"=>"黄宝石",
			"14"=>"苦瓜汁",
            "15"=>"土地卡"
		];
	}
//	//土地类型
//	public function getLandType(){
//		return [
//			"1"=>"普通土地",
//			"2"=>"红土地",
//			"3"=>"黑土地",
//			"4"=>"金土地",
//		];
//	}
	//材料类型
	public function getDuiType(){
		$data = [
			"0"=>"钻石",
			"1"=>"木材",
			"2"=>"石材",
			"3"=>"钢材",
		];
		if(USER_TYPE == "yansheng"){
			$data[4] = "苦瓜";
		}
		return $data;
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
	//背景类型
	function getBackgroundType(){
		return [
			"1"=>"初始背景",
			"2"=>"田园风格",
			"3"=>"城市风光",
			"4"=>"沙滩风光",
		];
	}
	//神像类型
	public function getLogsType(){
		return [
			""=>"未知",
			"add"=>"添加",
			"ded"=>"扣除",
			"deddiamonds"=>"扣除钻石",
			"adddiamonds"=>"增加钻石",
			"dedwood"=>"扣除木材",
			"addwood"=>"增加木材",
			"dedstone"=>"扣除石材",
			"addstone"=>"增加石材",
			"dedsteel"=>"扣除钢材",
			"addsteel"=>"增加钢材",
			"adddogfood1"=>"增加普通狗粮",
			"adddogfood2"=>"增加优质狗粮",
			"deddogfood1"=>"扣除普通狗粮",
			"deddogfood2"=>"扣除优质狗粮",
			"dedroseseed"=>"扣除玫瑰之心",
			"addroseseed"=>"增加玫瑰之心",
			"dedseed"=>"扣除种子",
			"addseed"=>"增加种子",
			"giverose"=>"赠送玫瑰之心",
			"dedchoe"=>"扣除铜锄头",
			"addchoe"=>"增加铜锄头",
			"dedshoe"=>"扣除银锄头",
			"addshoe"=>"增加银锄头",
			"dedwcan"=>"扣除洒水壶",
			"addwcan"=>"增加洒水壶",
			"dedhcide"=>"扣除除草剂",
			"addhcide"=>"增加除草剂",
			"dedicide"=>"扣除除虫剂",
			"addicde"=>"增加除虫剂",
			"dedgoods"=>"扣除果实",
			"addgoods"=>"增加果实",
			"dedcfert"=>"扣除化肥",
			"addcfert"=>"增加化肥",
			"addemerald"=>"增加绿宝石",
			"addpurplegem"=>"增加紫宝石",
			"addsapphire"=>"增加蓝宝石",
			"addtopaz"=>"增加黄宝石",
			"addkuguazhi"=>"增加苦瓜汁",
			"dedemerald"=>"扣除绿宝石",
			"dedpurplegem"=>"扣除紫宝石",
			"dedsapphire"=>"扣除蓝宝石",
			"dedtopaz"=>"扣除黄宝石",
			"dedkuguazhi"=>"扣除苦瓜汁",
			"addcoing"=>"添加金币",
			"dedcoing"=>"扣除金币",
			"adddiamonds"=>"增加钻石",
			"deddiamonds"=>"扣除钻石",
            "addredcard"=>"增加红土地卡",
            "dedredcard"=>"扣除红土地卡",
            "addblackcard"=>"增加黑土地卡",
            "dedblackcard"=>"扣除黑土地卡",
            "addgoldcard"=>"增加金土地卡",
            "dedgoldcard"=>"扣除金土地卡",


			"adminadd"=>"管理添加",
			"adminupdate"=>"管理更新",
			"adminded"=>"管理扣除",
		];
	}

	//产品类型
	public function gettypes(){
		return [
			'diamonds'=>'金币',
			'wood'	  =>'木材',
			'stone'	  =>'石材',
			'steel'	  =>'钢材',
			'dogFood1'=>'普通狗粮',
			'dogFood2'=>'优质狗粮2',
			'roseSeed'=>'玫瑰花种子',
			'choe'	  =>'铜锄头',
			'shoe'	  =>'银锄头',
			'cchest'  =>'铜宝箱',
			'schest'  =>'银宝箱',
			'gchest'  =>'金宝箱',
			'dchest'  =>'钻石宝箱',
			'cfert'	  =>'化肥',
			'wcan'	  =>'洒水壶',
			'hcide'	  =>'除草剂',
			'emerald' =>'绿宝石',
			'purplegem'=>'紫宝石',
			'sapphire'=>'蓝宝石',
			'topaz'	  =>'黄宝石',
			"kuguazhi"=>"苦瓜汁",
            'redcard'=>'红土地卡',
            'blackcard'=>'黑土地卡',
            'goldcard'=>'金土地卡'
		];
	}
	public function getError($flag,$obj){
		if($flag == false){
			foreach ($obj->getMessages() as $message) {
				echo $message . '<br>';
			}die;
		}
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

	//导出会员数据
	//博创导出支付列表
	public function printAction(){

			$sql = "SELECT id,uid,nickname,mobile,diamonds,wood,stone,steel,grade,dogFood1,dogFood2,roseSeed,choe,shoe,cchest,schest,gchest,dchest,cfert,wcan,hcide,icide,emerald,purplegem,sapphire,topaz,redcard,blackcard,goldcard,createtime,status FROM dhc_orchard_user  ";
			$data = $this->db->query($sql)->fetchAll();
			foreach ($data as $key=>&$value){
				foreach ($value as $k=>$v){
					if (is_numeric($k)){
						unset($value[$k]);
					}
				}
			}
			if (!empty($data)){
				$list = [
					'ID','UID','昵称','手机号','钻石','木材','石材','钢材','房屋等级','普通狗粮','优质狗粮','玫瑰花种子','铜锄头','银锄头','铜宝箱','银宝箱','金宝箱','钻石宝箱','化肥','洒水壶','除草剂','除虫剂','绿宝石','紫宝石','蓝宝石','黄宝石','红土地卡','黑土地卡','金土地卡','创建时间','状态'
				];

				$this->csv_export($data,$list,'会员列表');
			}else{
				exit("<script>alert('暂无充值记录');history.go(-1);</script>>");
			}

	}
	/**
	 * 导出excel(csv)
	 * @data 导出数据
	 * @headlist 第一行,列名
	 * @fileName 输出Excel文件名
	 */
	function csv_export($data = array(), $headlist = array(), $fileName) {
		header('Content-Type: application/vnd.ms-excel');
		header('Content-Disposition: attachment;filename="'.$fileName.'.csv"');
		header('Cache-Control: max-age=0');

		//打开PHP文件句柄,php://output 表示直接输出到浏览器
		$fp = fopen('php://output', 'a');

		//输出Excel列名信息
		foreach ($headlist as $key => $value) {
			//CSV的Excel支持GBK编码，一定要转换，否则乱码
			$headlist[$key] = iconv('utf-8', 'gbk', $value);
		}
		//将数据通过fputcsv写到文件句柄
		fputcsv($fp, $headlist);

		//计数器
		$num = 0;

		//每隔$limit行，刷新一下输出buffer，不要太大，也不要太小
		$limit = 100000;

		//逐行取出数据，不浪费内存
		$count = count($data);
		for ($i = 0; $i < $count; $i++) {

			$num++;
			//刷新一下输出buffer，防止由于数据过多造成问题
			if ($limit == $num) {
				ob_flush();
				flush();
				$num = 0;
			}
			$row = $data[$i];
			foreach ($row as $key => $value) {
				$row[$key] = iconv('utf-8', 'gbk', $value);
				if ($row['status'] == 1){$row['status']=iconv('utf-8', 'gbk', '正常');}
				if ($row['status'] == 9){$row['status']=iconv('utf-8', 'gbk', '禁用');}
				if($key == 'createtime'){
					$row[$key] = date("Y-m-d H:i:s",$value);
				}
			}
//			foreach ($row as $key=>$value){
//				if ($key == 'accountnumber'){
//					$row[$key] = "'".$value;
//				}
//			}
			fputcsv($fp, $row);

		}die;

	}
}

