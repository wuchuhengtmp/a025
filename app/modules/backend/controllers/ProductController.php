<?php
/**
 * 大盘类
 * @pram grail 产品列表
 * @pram plist 交易列表
 * @pram pdata 交易资料
 */

namespace Dhc\Modules\Backend\Controllers;

use Dhc\Models\Config;
use Dhc\Models\Dailydate;
use Dhc\Models\OrchardLand;
use Dhc\Models\TradeLogs;
use Dhc\Models\User;
use Dhc\Models\UserProduct;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;
use Dhc\Models\Product;
use Dhc\Models\Order;
use Dhc\Models\OrchardGoods;


class ProductController extends ControllerBase
{
	public $uid;
	private $pageSize = 20;

	public function productAction()
	{
		$product = new Product();
		$op = $this->request->get();
		$op = explode('/', $op['_url']);
		if (empty($op[4])) {
			$this->view->setVar('show', 'list');
		}
		if (empty($op[4]) | $op[4] == 'page' || $op[4] != 'page') {
			$productList = Product::find();
			$totalpage = ceil(count($productList) / 5);
			if (!empty($op[5])) {
				if ($op[5] > $totalpage) {
					$page = $totalpage;
				} elseif ($op[5] <= 0) {
					$page = 1;
				} else {
					$page = $op[5];
				}
			} else {
				$page = 1;
			}
			//分页
			$this->view->setVar('pagenow', $page);
			$paginator = new PaginatorModel(
				array(
					"data" => $productList,
					"limit" => '20',
					"page" => $page
				)
			);
			$page = $paginator->getPaginate();
			$pagelist = $page->items;
			$this->view->setVar('show', 'list');
			$this->view->setVar('tpage', $totalpage);
			$this->view->setVar('product', $pagelist);
		}
		if ($op[4]) {
			if ($op[4] == 'list') {
				if ($this->request->getpost()) {
					$data = $this->request->getPost();
					$product->title = $data['title'];
					$product->thumb = $data['thumb'];
					$product->startprice = $data['startprice'];
					$product->status = $data['status'];
					$product->rise = $data['rise'];
					$product->fall = $data['fall'];
					$product->poundage = $data['poundage'];
					$product->depict = $data['depict'];
					$product->seedTime = $data['seedTime'];
					$product->displayorder = $data['displayorder'];
					$product->tradeStatus = $data['tradeStatus'];
					$product->sproutingTime = $data['sproutingTime'];
					$product->growTime = $data['growTime'];
					if ($data['id']) {
						$pid = $data['id'];
						$products = Product::findFirst("id = $pid");
						$products->title = $data['title'];
						$products->thumb = $data['thumb'];
						$products->startprice = $data['startprice'];
						$products->status = $data['status'];
						$products->displayorder = $data['displayorder'];
						$products->tradeStatus = $data['tradeStatus'];
						$products->rise = $data['rise'];
						$products->fall = $data['fall'];
						$products->poundage = $data['poundage'];
						$products->depict = $data['depict'];
						$products->seedTime = $data['seedTime'];
						$products->sproutingTime = $data['sproutingTime'];
						$products->growTime = $data['growTime'];
						$result = $products->update();
					} else {
						$this->message("不可添加产品");
						$product->createtime = TIMESTAMP;
						$result = $product->update();
					}
					if (!$result) {
						foreach ($product->getMessages() as $message) {
							echo $message . '<br>';
						}
						die;
					}
				}
				$this->view->setVar('show', 'list');
				$this->response->redirect(APP_ADMIN_PATH . '/product/product');
			} elseif ($op[4] == 'edit') {
				if ($op[5]) {
					$id = $op[5];
					$item = $product->findFirst($id);
					$this->view->setVar('item', $item);
				}
				$this->view->setVar('show', 'edit');
			} elseif ($op[4] == 'add') {
				$this->view->setVar('show', 'edit');
			}
			elseif ($op[4]=="use")
            {
                if ($op[5]) {
                    $id = $op[5];
                    $item =  Product::findFirst($id);
                    $item->chanceinfo=json_decode($item->chanceinfo,true);
                    $goods = new OrchardGoods();
                    $list=$goods->find(array(
                        "conditions"=>"type!=5",
                        'order'			=>	"tId"
                    ));
                    $this->view->setVar('list', $list);
                    $this->view->setVar('item', $item);
                    $this->view->setVar('chanceInfo', $item->chanceinfo);
                    $this->view->setVar('show', 'use');
                }
            }
            elseif ($op[4]=="saveuse"){
                if ($this->request->getpost()) {
                    $data = $this->request->getPost();
                    if ($data['id']) {
                        $pid = $data['id'];
                        $product = Product::findFirst("id = $pid");
                        $product->chanceinfo=!empty($data["chanceInfo"])?json_encode($data["chanceInfo"],JSON_UNESCAPED_UNICODE):"0";
                        $result = $product->update();
                        if (!$result) {
                            foreach ($product->getMessages() as $message) {
                                echo $message . '<br>';
                            }
                            die;
                        }
                    }
                }
                $this->view->setVar('show', 'list');
                $this->response->redirect(APP_ADMIN_PATH . '/product/product');
            }
		}
		$this->view->pick('product/product');
	}

	public function plistAction()
	{
		$op = $this->request->get('op');
		if($op == 'list'){
		$productlist = new Product();
		$prolist = $productlist->find(
			array(
				'order' => 'displayorder DESC'
			)
		);

		foreach ($prolist as $key => $value) {
			$arr[] = array($value->id);
		}

		$data = array();
		foreach ($arr as $v) {
			$data[] = $this->getMakertinfo($v[0]);
		}
		foreach ($prolist as $key => $value) {
			foreach ($data as $k => $v) {
				if ($v['marketinfo']['sid'] == $value->id) {
					$value->price = $v['marketinfo']['price'];
					$value->OpeningPrice = $v['marketinfo']['OpeningPrice'];
					$value->HighestPrice = $v['marketinfo']['HighestPrice'];
					$value->LowestPrice = $v['marketinfo']['LowestPrice'];
					$value->limitup = $v['marketinfo']['limitup'];
					$value->limitdown = $v['marketinfo']['limitdown'];
					$value->Volume = $v['marketinfo']['Volume'];
				}
			}
			$products[] = $value;
		}
		$this->view->setVar('plist', $products);
		}elseif($op == 'order'){
		if ($this->request->isGet()) {
			$title = $this->request->get('title');
			$status = $this->request->get('status');
			$price = $this->request->get('price');
			$sid = $this->request->get('sid');
			$this->view->setVar('title', $title);
			$this->view->setVar('status', $status);
			$this->view->setVar('price', $price);
			$this->view->setVar('sid', $sid);
			$condition = "1=1";
			if (!empty($title)) {
				$condition = "goods like '$title'";
				if (!empty($sid)) {
					$condition = " sid = $sid and goods like '$title'";
					if ($status !== null) {
						$condition = "sid = $sid and status = $status and goods like '$title' ";
						if (!empty($price)) {
							$condition = " sid = $sid and status = $status and price = $price and goods like '$title'";
						}
					} else {
						if (!empty($price)) {
							$condition = "sid =$sid and status = $status and goods like '$title'";
						}
					}
				} else {
					if ($status !== null) {
						$condition = "status = $status ";
						if (!empty($price)) {
							$condition = " status = $status and price = $price and goods like '$title'";
						}
					} else {
						if (!empty($price)) {
							$condition = " price = $price";
						}
					}
				}

			} else {

				if (!empty($sid)) {
					$this->view->setVar('sid', $sid);
					$condition = "sid = $sid";
					if ($status !== null) {
						$condition = " sid = $sid and status = $status ";
						if (!empty($price)) {
							$condition = " sid = $sid and status = $status and price = $price ";
						}
					} else {
						if (!empty($price)) {
							$condition = "  price =$price";
						}
					}
				} else {
					if (!empty($status)) {
						$condition = "status = $status ";
						if (!empty($price)) {
							$condition = " status = $status and price = $price ";
						}
					} else {
						if (!empty($price)) {
							$condition = " price = $price";
						} else {
							$condition = "";
						}
					}
				}
			}
		}

		if (empty($condition)){
			$condition = '1=1';
		}
		$page = $this->request->get('page','int',1);
		$pageoffset = ($page - 1) * $this->pageSize;
		$sql = "SELECT * FROM dhc_trade_order WHERE $condition ORDER BY createtime DESC LIMIT $pageoffset,$this->pageSize";
		$orderlist = $this->db->query($sql)->fetchAll();

		$sql1 = "SELECT COUNT(*) AS total FROM dhc_trade_order WHERE $condition";
		$total = $this->db->query($sql1)->fetch();
		$list['total']	=	ceil($total['total']/$this->pageSize);
		$list['next']	=	min($list['total'],$page+1);
		$list['before']	=	max(1,$page-1);
		$list['last']	=	$list['total'];
		$list['current']=	$page;
		$list['items']	=	$orderlist;
		$list['total_pages'] = $list['total'];
		$this->view->setVar('orderlist', $list);
		$this->view->setVar('op', $op);

		}elseif($op == 'count'){
		//统计信息
		$product = new Product();
		$product = $product->find(['columns'=>'id,title','order'=>'id ASC']);
		$countData = array();
		if ($product != false){
			foreach ($product as $key =>$value){
				$data = $this->getTotal($value->id);
				$countData[$value->id] = array(
					"id" => $value->id,
					"title" => $value->title,
					"count1" => $data['count1'] ? $data['count1'] : 0,
					"count2" => $data['count2'] ? $data['count2'] : 0,
					"count3" => $data['count3'] ? $data['count3'] : 0,
					"count4" => $data['count4'] ? $data['count4'] : 0,
					"count5" => $data['count5'] ? $data['count5'] : 0,
					"count" =>$data['count'] ? $data['count'] : 0
				);
			}
		}
//		if ($product != false) {
//			foreach ($product as $key => $value) {
//				$order = new Order();
//				$order = $order->find("sid='{$value->id}'");
//				$countData[$value->id] = array(
//					"id" => $value->id,
//					"title" => $value->title,
//					"count1" => 0,
//					"count2" => 0,
//					"count3" => 0,
//					"count4" => 0,
//					"count5" => 0,
//					"count" => 0
//				);
//
//				$order = $this->object2array($order);
//
//				if ($order != false) {
//					foreach ($order as $key => $val) {
//						$countData[$value->id]['count'] += $val['number'];
//						$countData[$value->id]['count1'] += $val['number'];
//						$countData[$value->id]['count2'] += $val['dealnum'];
//						$countData[$value->id]['count5'] += $val['fee'];
//						if ($val["type"] == 1) {
//							$countData[$value->id]["count3"] += $val["number"];
//						} else {
//							$countData[$value->id]["count4"] += $val["number"];
//						}
//
//					}
//
//				}
//
//			}
//
//		}


		$this->view->setVar('countData', $countData);
		}
		$this->view->setVar('op',$op);
		$this->view->pick('product/plist');

//		$product = new Product();
//		$prolist = $product->find();
//		foreach ($data as $key=>$value){
//			$result[]=[
//				'id'=>$value->sid,
//				'num'=>$value->number,
//			];
//		}
//		$tnum = array();
//		foreach ($result as $key=>$value){
//			for ($k =1;$k<count($result);$k++){
//				if($result[$k]['id'] == $value['id']){
//					$tnum[$value['id']] += $value['num'];
//				}
//			}
//		}
//		$this->view->setVar('tnum',$tnum);//产品和成交量
//		//获取最新价格
//		$y = date("Y");
//		$m = date("m");
//		$d = date("d");
//		$day_start = mktime(0,0,0,$m,$d,$y);
//		$day_end   = mktime(24,59,59,$m,$d,$y);
//		$daydata = new Dailydate();
//			$opprice = $order ->find(
//				array(
//					'columns'=>'uid,sid,price,createtime,endtime',
//					'order'	=>'createtime DESC'
//				)
//			);
//
//		$arr = array();
//		foreach ($opprice as $key=>$value){
//			$arr[] =array(
//				'uid'	=>$value->uid,
//				'sid' => $value->sid,
//				'price' => $value->price,
//				'createtime'=>$value->createtime,
//				'endtime'	=>$value->endtime
//			);
//		}
//		foreach ($arr as $key=>$value){
//			foreach ($value as $k=>$v){
//				if($value['sid'] == $k){
//						if($value['price']<=$v){
//							$value['price'] = $v;
//						}
//				}
//			}
//		}
//		$op = $this->request->get();
//		$op = explode('/',$op['_url']);
//		if(empty($op)){
//			$page = 1;
//		}
//		if(!empty($op[5])){
//			$page = $op[5];
//		}
//		$paginator = new PaginatorModel(
//			array(
//				"data"	=> $data,
//				"limit"	=> 5,
//				"page"	=>$page
//			)
//		);
//		$page = $paginator->getPaginate();
//		$this->view->setVar('dailinfo',$dailyinfo);
//		$this->view->setVar('pList',$page);
//		$this->view->pick('product/plist');
	}

	public function pdataAction()
	{
		$page = $this->request->get('page','int',1);
		$uid = $this->request->get('uid');
		$sid = $this->request->get('sid');
		$conditions = 'dealnum>0';
		if (!empty($uid)) {
			$conditions .= " AND uid  = '{$uid}' ";
		}
		if (!empty($sid)) {
			$conditions .= " AND sid = '{$sid}' ";
		}
		$pageofset = ($page-1)*$this->pageSize;
		$sql = "SELECT * FROM `dhc_trade_order` WHERE $conditions ORDER BY createtime DESC LIMIT $pageofset,$this->pageSize";
		$orderList =$this->db->query($sql)->fetchAll();
		$sql1 = "SELECT COUNT(*) AS total FROM dhc_trade_order WHERE $conditions";
		$total = $this->db->query($sql1)->fetch();
		$list['total_pages'] = ceil($total['total'] / $this->pageSize);
		$list['before']	 	 = max($page-1,1);
		$list['next']		 = min($page+1,$list['total_pages']);
		$list['current']	 = $page;
		$list['last']		 = $total['total'];
		$list['items']		 = $orderList;
		$this->view->setVar('pList', $list);
		$this->view->setVar('uid',$uid);
		$this->view->setVar('sid',$sid);
	}

	//假数据添加
	public function adddateAction()
	{
		$time = 24 * 60 * 60;
		for ($i = 1; $i < 5; $i++) {
			$dailydate = new Dailydate();
			$dailydate->sid = 1;
			if ($i % 2 == 0) {
				$dailydate->OpeningPrice = 0.00025;
				$dailydate->ClosingPrice = 0.00016;
				$dailydate->HighestPrice = 0.00125;
				$dailydate->LowestPrice = 0.00015;

			} else {
				$dailydate->opprice += 0.00025;
				$dailydate->closeprice += 0.00016;
				$dailydate->heightprice += 0.00125;
				$dailydate->lowprice += 0.00015;
			}

			$dailydate->createtime += $time;
			$result = $dailydate->save();
		}
		die;
	}

	public function getMakertinfo($productid)
	{
		$today = new Dailydate();
		$td = strtotime(date("Y-m-d"));
		$yd = strtotime(date('Y-m-d', strtotime('-1 day')));
		$todayinfo = $today->findFirst("sid = $productid and Date >= $td");
		if ($todayinfo) {
			$data['marketinfo'] = array(
				'sid' => $todayinfo->sid,
				'OpeningPrice' => $todayinfo->OpeningPrice,
				'HighestPrice' => $todayinfo->HighestPrice,
				'LowestPrice' => $todayinfo->LowestPrice,
				'Volume' => $todayinfo->Volume,
			);
			$product = new Product();
			$productinfo = $product->find(
				array(
					'conditions' => 'status = 1',
					'columns' => 'rise,fall,id,title'
				)
			);
			$dailydata = new Dailydate();
			$orderinfo = $dailydata->findFirst(
				array(
					'conditions' => "Date>=$yd and Date < $td",
					'columns' => '	ClosingPrice'
				)
			);
			$closingprice = $orderinfo->ClosingPrice;
			foreach ($productinfo as $key => $value) {
				if ($value->id == $data['marketinfo']['sid']) {
					$data['marketinfo']['limitup'] = $closingprice * ($value->rise + 1);
					$data['marketinfo']['limitdown'] = $closingprice * (1 - $value->fall);
					$data['marketinfo']['title'] = $value->title;
				}
			}
			$order = new Order();
			$currentprice = $order->findFirst(
				array(
					'conditions' => "status = 1 and sid = $productid",
					'columns' => 'sid,price',
					'order' => 'endtime DESC',
				)
			);
			$data['marketinfo']['price'] = $currentprice->price;
		} else {

			$data['marketinfo'] = array(
				'sid' => '',
				'title' => '',
				'OpeningPrice' => '',
				'HighestPrice' => '',
				'LowestPrice' => '',
				'Volume' => '',
				'limitup' => '',
				'limitdown' => ''
			);
		}
		return $data;

	}

	//日志
	public function logsAction()
	{
		$page = $this->request->get('page');
		$keyword = $this->request->get('keywords');
		$type = $this->request->get('type');
		if (empty($page)) {
			$page = 1;
		}

		$conditions = '1 = 1';
		if (!empty($keyword)) {
			$conditions .= " AND uid = {$keyword}";
		}
		if (!empty($type) && $type != 'all') {
			$conditions .= " AND type = '{$type}'";
		} else {
			$type = 'all';
		}
		if (!empty($this->request->get('time'))) {
			$time = $this->request->get('time');
			$starttime = strtotime(date($time['start'], TIMESTAMP));
			$endtime = strtotime(date($time['end'], TIMESTAMP)) + 86399;
			$conditions .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
		} else {
			$starttime = strtotime(date("Y-m-1 00:00:00", TIMESTAMP));
			$endtime = strtotime(date("Y-m-d 23:59:59", TIMESTAMP));
			$conditions .= " AND createtime >= {$starttime} AND createtime <= {$endtime} ";
		}
//		var_dump($conditions);die;
//		$logs = TradeLogs::find(
//			[
//				'conditions'=>$conditions,
//				'order'=>'createtime DESC'
//			]
//		);
//		$paginator = new PaginatorModel(
//			array(
//				"data"	=> $logs,
//				"limit"	=>20,
//				"page" =>$page
//			)
//		);
//		$page = $paginator->getPaginate();
		$this->pagesize = 20;
		$pageoffset = ($page - 1) * $this->pagesize;
		$sql = "SELECT * FROM dhc_trade_logs WHERE $conditions ORDER BY createtime DESC  LIMIT $pageoffset, $this->pagesize";
		$lists = $this->db->query($sql)->fetchAll();
		$sql1 = "SELECT COUNT(*) AS numbers FROM dhc_trade_logs WHERE $conditions";
		$totals = $this->db->query($sql1)->fetch();
		$pages['list'] = $this->getArray($lists);
		$totals_number = ceil($totals['numbers'] / $this->pagesize);
		$pages['next'] = min($totals_number, $page + 1);
		$pages['last'] = max($totals_number, 1);
		$pages['current'] = max($page, 1);
		$pages['before'] = max($page - 1, 1);
		$pages['total_pages'] = max($totals_number, 1);
		$this->view->setVar('starttime', date("Y-m-d", $starttime));
		$this->view->setVar('endtime', date("Y-m-d", $endtime));
		$this->view->setVar('pages', $page);
		$this->view->setVar('keywords', $keyword);
		$this->view->setVar('type', $type);
		$this->view->setVar('logs', $pages);

	}

	//赠送记录
	public function giveAction()
	{
		$page = $this->request->get('page', 'int', '1');
		$keywords = $this->request->get('keywords');
		$productId = $this->request->get('productid');
		$status = $this->request->get('status');
		$accept = $this->request->get('accept');
		$conditions = "1=1";
		if (!empty($keywords)) {
			$conditions .= " AND uid = '{$keywords}'";
		}
		if (!empty($productId)) {
			$conditions .= " AND productid = '{$productId}'";
		}
		if (!empty($accept)){
			$conditions .= " AND accept = '{$accept}'";
		}
		if ($status < 3&&$status>=0) {
			$conditions .= " AND status = '{$status}'";
		}
		$pageSize = $this->pageSize;
		$offset = ($page - 1) * $pageSize;
		$sql = "SELECT * FROM dhc_user_give WHERE  $conditions ORDER BY createtime DESC LIMIT $offset,$pageSize";
		$giveList = $this->db->query($sql)->fetchAll();

		$sql1 = "SELECT COUNT(*) as total FROM dhc_user_give WHERE $conditions";
		$total = $this->db->query($sql1)->fetch();
		$list['total_pages'] = ceil($total['total'] / $pageSize);
		$list['current'] = $page;
		$list['next'] = min($page + 1, $list['total_pages']);
		$list['before'] = max($page - 1, 1);
		$list['last'] = $list['total_pages'];
		$list['items'] = $giveList;
		$this->view->setVar('giveList', $list);
		$this->view->setVar('keywords', $keywords);
		$this->view->setVar('status',$status);
		$this->view->setVar('accept',$accept);
		$this->view->setVar('productid', $productId);
	}

	public function frozenAction()
	{
		$page = $this->request->get('page', 'int', '1');
		$pageSize = 1000;
		$pagestart = ($page - 1) * $pageSize;
		$sql = "SELECT id FROM dhc_user LIMIT $pagestart,$pageSize";
		$userId = $this->db->query($sql)->fetchAll();
		if (!empty($userId)) {
			foreach ($userId as $key => &$value) {
				foreach ($value as $k => $v) {
					if (is_numeric($k)) {
						unset($value[$k]);
					}
				}
			}
			//开始比对冻结产品数量
			foreach ($userId as $key => $value) {
				$this->uid = $value['id'];
				$this->RevokeFrozenAction();
			}
			$nextpage = $page + 1;
			header('location:' . APP_ADMIN_PATH . '/product/frozen/?page=' . $nextpage);
		} else {
			echo("比对结束具体查看日志");
		}

	}


	//退回订单处理
	public function orderReturnAction(){
		$price = $this->request->getPost('price');
		$uid   = $this->request->getPost('uid');
		$type  = $this->request->getPost('type');
		$sid   = $this->request->getPost('sid');
		//将产品渲染到页面
		$sql = "SELECT id,title FROM dhc_trade_product";
		$productList = $this->db->query($sql)->fetchAll();
		//开始组合订单查询条件
		if ($this->request->isPost()){
			if (empty($price)||!isset($type)||empty($sid)){
				exit("<script>alert('操作失败，请核对您的退回条件');window.location.href = window.location.href;</script>");
			}else{
				$conditions = "type = '{$type}' AND sid = '{$sid}' AND price = '{$price}' AND status = 0";
			}
			//用户id选填
			if (!empty($uid)){
				$conditions .= " AND uid = '{$uid}'";
			}
			//获取产品订单列表
//			$orderList = Order::find(
//				[
//					'conditions'=>$conditions,
//					'order'		=>'createtime ASC'
//				]
//			);
			$sql  = "SELECT * FROM dhc_trade_order WHERE $conditions";
			$orderList = $this->db->query($sql)->fetchAll();
			if (empty($orderList)){
				exit("<script>alert('操作失败，暂无可操作订单');window.location.href = window.location.href;</script>");
			}

			//获取订单退回结果
			$result = $this->ReturnOrder($orderList,$type);
			if ($result===true){
				$this->message('操作成功，订单退回正常请核对日志','','success');
			}else{
				$this->message('操作失败,订单退回异常,请核对用户数据,订单id'.$result,'','error');
			}
		}
		$this->view->setVar('product',$productList);
		$this->view->setVar('price',$price);
		$this->view->setVar('uid',$uid);
		$this->view->setVar('type',$type);
		$this->view->setVar('sid',$sid);
	}
	//根据类型退回订单
	private function ReturnOrder($orderList,$type){
		if ($type == '1'){
			foreach ($orderList as $key=>$value){
				$num = ($value['number']-$value['dealnum'])*$value['price'];
				$uid = $value['uid'];
				$id  = $value['id'];
				$result = $this->ReturnBuy($id,$uid,$num);
				if ($result !== true){
					return $result;
				}
			}
//			die;
			return $result;
		}elseif ($type == '0'){
			foreach ($orderList as $key=>$value){
				$num = ($value['number']-$value['dealnum']);
				$uid = $value['uid'];
				$sid = $value['sid'];
				$id  = $value['id'];
				$result = $this->ReturnSell($id,$uid,$num,$sid);

				if ($result !== true){
					return $result;
				}
			}
//			die;
			return $result;
		}else{
			$this->message('订单类型错误,请核实','','error');
		}
	}
	//购买订单返回
	public function ReturnBuy($id,$uid,$num){
		$this->db->begin();
		$order = Order::findFirst("id = '{$id}' AND status = 0");
		if (empty($order)){
			$this->db->rollback();
			return false;
		}
		$order->status = 1;
		$order->endtime = TIMESTAMP;
		$orderResult = $order->update();
		$userInfo = User::findFirst("id = '{$uid}'");
		if (empty($userInfo)){
			$this->db->rollback();
			return $id;
		}
		if ($userInfo->Frozen<$num){
			return $id;
		}
		$userInfo->Frozen -= $num;
		$userInfo->coing += $num;
		$userResult =  $userInfo->update();
		if (empty($orderResult)||empty($userResult)){
			$this->db->rollback();
			return $id;
		}else{
			$this->db->commit();
			$this->saveTradeLogs(['uid'=>$uid,'log'=>$id.'系统退单返回增加金币'.$num,'num'=>$num,'type'=>'addcoing']);
			$this->saveTradeLogs(['uid'=>$uid,'log'=>$id.'系统退单返回扣除冻结金币'.$num,'num'=>$num,'type'=>'dedfrozencoing']);
		}
		return true;

	}
	//出售订单返回
	public function ReturnSell($id,$uid,$num,$sid){
		$this->db->begin();
		$userProduct = UserProduct::findFirst("uid = '{$uid}' AND sid = '{$sid}'");
		echo '<pre>';

		if (empty($userProduct)){
			$this->db->rollback();
			return $id;
		}
		if ($userProduct->frozen<$num){
			return $id;
		}
		$userProduct->frozen -= $num;
		$userProduct->number += $num;
		$result = $userProduct->update();
		$order = Order::findFirst("id = '{$id}' AND status = 0");
		if (empty($order)){
			$this->db->rollback();
			return $id;
		}
		$order->status = 1;
		$order->endtime = TIMESTAMP;
		$orderResult = $order->update();
		if (empty($result)||empty($orderResult)){
			$this->db->rollback();
			return $id;
		}else{
			$this->saveTradeLogs(['uid'=>$uid,'log'=>$id.'系统退单返回增加产品'.$sid.'-'.$num,'num'=>$num,'type'=>'addproduct']);
			$this->saveTradeLogs(['uid'=>$uid,'log'=>$id.'系统退单返回扣除冻结产品'.$sid.'-'.$num,'num'=>$num,'type'=>'dedfrozenproduct']);
			$this->db->commit();
		}
		return true;

	}
	//获取用户可以冻结产品的所有数量
	public function RevokeFrozenAction()
	{
		//获取用户所有的冻结产品信息
		$uid = $this->uid;
		$sql = "SELECT frozen,sid FROM dhc_user_product WHERE uid = {$uid} AND Frozen>0";
		$list = $this->db->query($sql)->fetchAll();
		foreach ($list as $key => &$value) {
			foreach ($value as $k => $v) {
				if (is_numeric($k)) {
					unset($value[$k]);
				}
			}
		}
		//根据用户冻结产品信息在交易和赠送记录里面查找是否相等
		$this->db->begin();
		foreach ($list as $k => $v) {
			$num = 0;
			$trade = $this->getTradeFrozen($v['sid']);
			$give = $this->getGiveFrozen($v['sid']);
			if (!empty($trade)) {
				$num += $trade[0]['number'];
			}
			if (!empty($give)) {
				$num += $give[0]['number'];
			}
			if ($v['frozen'] != $num) {
				$userProduct = UserProduct::findFirst("sid = {$v['sid']} AND uid = {$uid}");
				$nums = $userProduct->frozen;
				$userProduct->frozen = $num;
				$result = $userProduct->update();
				if (!$result) {
					$this->db->rollback();
					$this->saveTradeLogs(array("uid" => $uid, "num" => $num, "type" => "dedfrozenproduct", "log" => "现冻结$nums-大盘交易系统重置冻结产品数量失败{$v['sid']}-" . $num));
				} else {
					$this->saveTradeLogs(array("uid" => $uid, "num" => $num, "type" => "dedfrozenproduct", "log" => "现冻结$nums-大盘交易系统重置冻结产品数量{$v['sid']}-" . $num));
					echo $uid . '现冻结' . $nums . '-' . $v['sid'] . '冻结产品应为' . $num . '已更新' . '<br>';
				}
			}
		}
		$this->db->commit();

	}


	public function getTradeFrozen($sid)
	{
		$uid = $this->uid;
		$sql = "SELECT SUM(number-dealnum) AS number FROM dhc_trade_order WHERE status = 0 AND type = 0 AND uid ={$uid} AND sid = {$sid}";
		$list = $this->db->query($sql)->fetchAll();
		if ($list) {
			foreach ($list as $key => &$value) {
				foreach ($value as $k => $v) {
					if (is_numeric($k)) {
						unset($value[$k]);
					}
				}
			}
			return $list;
		} else {
			return '0';
		}
	}

	public function getGiveFrozen($sid)
	{
		$uid = $this->uid;
		$sql = "SELECT SUM(number) as number FROM dhc_user_give WHERE status = 0 AND  uid = {$uid} AND productid={$sid}";
		$list = $this->db->query($sql)->fetchAll();
		if (!empty($list)) {
			foreach ($list as $key => &$value) {
				foreach ($value as $k => $v) {
					if (is_numeric($k)) {
						unset($value[$k]);
					}
				}
			}
			if ($uid == '711') {
				var_dump($list);
			}
			return $list;
		} else {
			return '0';
		}
	}
	public function configAction(){
		$config = Config::findFirst("key = 'productConfig'");
		if ($this->request->isPost()){
			$data = $this->request->getPost();
			$value = serialize($data);
			if (empty($config)){
				$config = new  Config();
				$config->key = 'productConfig';
				$config->value = $value;
				$result =$config->save();
			}else{
				$config->value = $value;
				$result = $config->update();
			}
			if (empty($result)){
				$this->message('操作失败','','error');
			}else{
				$this->message('操作成功','','success');
			}
		}else{
			$data = unserialize($config->value);
			$this->view->setVar('config',$data);
		}
	}
	//获取每种产品统计信息
	public function getTotal($sid){
		$countDate = [];
		$countDate['count'] = Order::sum(
			[
				'conditions'=>"sid = $sid ",
				'column'	=>'number'
			]
		);
		$countDate['count1'] = $countDate['count'];
		$countDate['count2'] = Order::sum(
			[
				'conditions'=>"sid = $sid ",
				'column'	=>'dealnum'
			]
		);
		$countDate['count3'] = Order::sum(
			[
				'conditions'=>"sid = $sid AND type = 1",
				'column'   =>'dealnum'
			]
		);
		$countDate['count4'] = Order::sum(
			[
				'conditions'=>"sid = $sid AND type = 0",
				'column'	=>'dealnum'
			]
		);
		$countDate['count5'] = Order::sum(
			[
				'conditions'=>"sid = $sid",
				'column'	=>'fee'
			]
		);
		return $countDate;
	}
	//修复异常土地
	public function landfixedAction(){
		if ($this->request->isPost()){
			if (!empty($this->request->getPost())){
				$uid = $this->request->getPost('uid');
				$landid = $this->request->getPost('landid');
				$orchard = OrchardLand::findFirst("uid = '{$uid}' AND landId = '{$landid}'");
				if (empty($orchard)){
					$this->message('操作失败，要修复的土地不存在','','error');
				}
				if ($orchard->goodsId ==0 && $orchard->landStatus != 0){
					$orchard->goodsId = 0;
					$orchard->landStatus = 0;
					$re = $orchard->update();
					if ($re){
						$this->message('操作成功','','success');
					}else{
						$this->message('操作失败','','error');
					}
				}
			}
		}
	}

}
