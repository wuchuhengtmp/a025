<?php

namespace Dhc\Modules\Backend\Controllers;

use Dhc\Library\Distribution;

use Dhc\Models\Product;
use Dhc\Models\User;
use Dhc\Models\UserProduct;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;

class WarehouseController extends ControllerBase
{
	private $pageSize = '20';

	public function listAction()
	{
		$op = $this->request->get('op') ? $this->request->get('op') : 'manage';
		$page = $this->request->get('page', 'int', '1');
		$uid = $this->request->get('uid');
		$sid = $this->request->get('sid');
		$productList = Product::find("status = 1");
		$conditions = "1=1";
		if (!empty($uid)) {
			$conditions .= " AND uid = $uid";
			$user = User::findFirst("id = $uid");
			if (!$user) {
				exit("<script>alert('查询错误');window.location.href =window.location.href </script>");
			}
		}
		if (!empty($sid)) {
			$conditions .= " AND sid = $sid";
			$product = Product::findFirst("id =$sid ");
			if (!$product) {
				exit("<script>alert('查询错误');window.location.href =window.location.href </script>");
			}
		}
		$conditions .= ' ORDER BY  number DESC,uid ASC';
		$pageoffset = ($page-1) *$this->pageSize;
		$sql = "SELECT uid,sid,`number` FROM dhc_user_product WHERE $conditions LIMIT $pageoffset,$this->pageSize";
		$userProductList = $this->db->query($sql)->fetchAll();
		$sql1 = "SELECT COUNT(*) AS total FROM dhc_user_product WHERE $conditions";
		$total = $this->db->query($sql1)->fetch();
		$product = new Product();
		$productInfo = $product->find(
			array(
				'columns' => 'id,title'
			)
		);
		foreach ($userProductList as $key=>$value) {
			$userProductList[$key]['title'] = $this->getProductName($value['sid']);
		}
		$list['total_pages'] = ceil($total['total']/$this->pageSize);
		$list['before']		 = max($page-1,1);
		$list['next']		 = min($page+1,$list['total_pages']);
		$list['last']		 = $list['total_pages'];
		$list['current']	 = $page;
		$list['items']		 = $userProductList;
		$this->view->setVar('uid',$uid);
		$this->view->setVar('sid',$sid);
		$this->view->setVar('productName', $productInfo);
		$this->view->setVar('prolist', $list);
		$this->view->setVar('show', $op);
		//count 统计
		$product = $this->object2array($productList);
		$product[] = array(
			"id" => "1",
			"title" => "种子"
		);
		$countData = array();
		if (!empty($product)) {
			foreach ($product as $key => $value) {
				$countData[$value["id"]] = array(
					"sid" => $value["id"],
					"title" => $value["title"],
					"count" => 0
				);
				$product = new UserProduct();
				$list = $product->find("sid='{$value['id']}'");
				$list = $this->object2array($list);
				if ($list != false) {
					foreach ($list as $key => $val) {
						$countData[$value["id"]]["count"] += $val["number"];
					}
				}
			}
		}
//		print_r($countData);exit;
		$this->view->setVar('countData', $countData);
		$this->view->setVar('op',$op);
		$this->view->pick('Warehouse/warehouse');
	}

	public function addProductAction()
	{
		if ($this->request->isPost()) {
			$userProduct = new UserProduct();
			$oid = $this->session->get('operate');
			$sid = $this->request->getPost('title');
			$user = $this->request->getPost('userid');
			$number = intval($this->request->getPost('number'));
                         
                        $user = $this->db->query("SELECT * FROM dhc_user WHERE user = $user")->fetch();
                        $user = $user ? $user['id'] : null;
			if (!User::findFirst($user)) {
				exit("<script>alert('用户不存在');window.location.href='" . APP_ADMIN_PATH . "/Warehouse/list?op=list'</script>");
			}
			//判断用户库存是否充足
			if (!empty($user)) {
				$userInfo = $userProduct->findFirst("uid = $user and sid =$sid");
				if ($userInfo) {
					if (($userInfo->number+$number) <0){
						exit("<script>alert('操作失败,用户数量不足');window.location.href='" . APP_ADMIN_PATH . "/Warehouse/list?op=addp'</script>");
					}
					$userInfo->number += $number;
				} else {
					$userProductInfo = new UserProduct();
					$userProductInfo->uid = $user;
					$userProductInfo->sid = $sid;
					$userProductInfo->number = $number;
					$userProductInfo->createtime = TIMESTAMP;
					$userProductInfo->updatetime = TIMESTAMP;
					$userProductInfoResult = $userProductInfo->save();
					if ($userProductInfoResult) {
						$this->yanshengAddDis($sid,$number,$user);
						$this->userAddProduct(array("uid" => $user, 'title' => "后台给用户添加产品数量.$sid" . $number,"num"=>$number,'sid'=>$sid));
						exit("<script>alert('添加成功');window.location.href='" . APP_ADMIN_PATH . "/Warehouse/list?op=addp'</script>");
					} else {
						foreach ($userInfo->getMessages() as $message) {
							echo $message;
						}
						die;
						$this->message('添加失败');
					}
				}
				$userInfo->updatetime = TIMESTAMP;
				$userInfoResult = $userInfo->update();
				if ($userInfoResult) {
					$this->yanshengAddDis($sid,$number,$user);
					$this->userAddProduct(array("uid" => $user, 'title' => "后台给用户添加产品数量.$sid" . $number,'num'=>$number,'sid'=>$sid));
					exit("<script>alert('添加成功');window.location.href='" . APP_ADMIN_PATH . "/Warehouse/list?op=addp'</script>");
				} else {
					exit("<script>alert('添加失败');window.location.href='" . APP_ADMIN_PATH . "/Warehouse/list?op=addp'</script>");
				}
			}
		}
	}
	//延生农牧需求变更
	public function yanshengAddDis($goodsId,$goodsNum,$userId){
		if(USER_TYPE != "yansheng" || $goodsId != 80010){
			return true;
		}
		$product = new product();
		$productInfo = $product->findFirst("id=80010");
		if($productInfo->startprice<=0){
			return false;
		}
		$this->db->begin();
		try{
			$dis = new Distribution($userId, $goodsNum*$productInfo->startprice , 1, "管理{$productInfo->title}充值");
			$dis->start();
		}catch (Exception $e){
			$this->db->rollback();
			$this->ajaxResponse('','推广费用计算失败，请审核：' . $e->getMessage(),'1');
		}
		$this->db->commit();
		return true;
	}
	public function getProductName($sid)
	{
		$product = Product::findFirst("id = $sid");
		if ($product) {
			return $product->title;
		} else {
			return '暂无';
		}
	}

	private function getProductNumber($sid, $uid)
	{
		$sql = "SELECT SUM(*) AS sum FROM dhc_user_product WHERE uid ='{$uid}' AND sid = '{$sid}'";
		$number = $this->db->query($sql)->fetch();
		if (empty($number)) {
			return 0;
		} else {
			return $number['sum'];
		}
	}


	//博创导出用户产品列表
	public function printAction(){
		$sql = "SELECT id,uid,sid,`number`,frozen FROM dhc_user_product";
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
				'ID','UID','产品id','产品数量','冻结数量'
			];
			$this->csv_export($data,$list,'用户产品表');
		}else{
			exit("<script>alert('暂无记录');history.go(-1);</script>>");
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
			}
//			foreach ($row as $key=>$value){
//				if ($key == 'accountnumber'){
//					$row[$key] = "'".$value;
//				}
//			}
			fputcsv($fp, $row);
		}exit;
	}
}
