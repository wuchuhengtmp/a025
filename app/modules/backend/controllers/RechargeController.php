<?php
namespace Dhc\Modules\Backend\Controllers;

use Dhc\Models\Recharge;
use Dhc\Models\UserConfig;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;
class RechargeController extends ControllerBase{
	private $pagesize = 20;
	public function listAction(){
		if ($this->request->get('id')){
			$id = $this->request->get('id');
			$userConfig = UserConfig::findFirst("id =$id");
		if ($userConfig){
			$this->view->setVar('item',$userConfig);
		}
		}

		$this->view->setVar('show','list');
		$this->view->pick('Recharge/list');
	}
	public function showAction(){

		if ($this->request->isPost()){
			$payType = $this->request->getPost('payType');
			$merchant_no = $this->request->getPost('merchant_no');
			$terminal_id = $this->request->getPost('terminal_id');
			$status  =$this->request->getPost('status');
			$access_token = $this->request->getPost('access_token');
			if (empty($this->request->getPost('id'))){
				if (!empty($payType)&&!empty($merchant_no)&&!empty($terminal_id)&&!empty($status)&&!empty($access_token)){
					$PayConfig = new UserConfig();
					$PayConfig->payType = $payType;
					$PayConfig->merchant_no = $merchant_no;
					$PayConfig->terminal_id = $terminal_id;
					$PayConfig->status = $status;
					$PayConfig->access_token = $access_token;
					$result = $PayConfig->save();
					if ($result){
						exit("<script>alert('操作成功');window.location.href=window.location.href</script>");
					}else{
						exit("<script>alert('操作失败');window.location.href=window.location.href</script>");
					}
				}else{
					exit("<script>alert('部分数据有误');window.location.href=window.location.href</script>");
				}
			}else{
				$id = $this->request->getPost('id');
				$userConfig = UserConfig::findFirst("id =$id");
				if ($userConfig){
					$userConfig->payType = $payType;
					$userConfig->merchant_no = $merchant_no;
					$userConfig->terminal_id =$terminal_id;
					$userConfig->access_token =$access_token;
					$userConfig->status  =$status;
					$result = $userConfig->update();
				}
				if ($result){
					exit("<script>alert('操作成功');window.location.href=window.location.href</script>");
				}else{
					exit("<script>alert('操作失败');window.location.href=window.location.href</script>");
				}
			}

		}
		$payList =UserConfig::find();
		if ($payList){
			$this->view->setVar('paylist',$payList);
		}
		$this->view->setVar('show','show');
		$this->view->pick('Recharge/show');
	}

	public function rechargeAction(){
		$page= $this->request->get('page','int','1');
		$payType = $this->request->get('payType');
		$payStatus = $this->request->get('payStatus');
		$orderNumber = $this->request->get('orderNumber');
		$uid  =$this->request->get('uid');
		$condition = '1=1';
		$condition1 = ' payStatus =1';
		if (!empty($uid)){
			$condition .= " AND uid  = $uid ";
			$condition1 .= " AND uid  = $uid ";
		}
		if (!empty($orderNumber)){
			$condition .= " AND orderNumber = '$orderNumber'";
		}
		if (!empty($payType)){
			$condition .= " AND payType = '$payType'";
		}
		if (!empty($payStatus)){
			$condition .= " AND payStatus = $payStatus";
		}
		$pageoffset = ($page-1) *$this->pagesize;
		$sql = "SELECT * FROM dhc_user_recharge WHERE $condition ORDER BY createtime DESC  LIMIT $pageoffset,$this->pagesize";
		$rechargelist = $this->db->query($sql)->fetchAll();
		$sql1 = "SELECT COUNT(*) AS total FROM dhc_user_recharge WHERE $condition";
		$total = $this->db->query($sql1)->fetch();
		$sql2 = "SELECT SUM(number) AS total_money FROM dhc_user_recharge WHERE $condition1";
		$totalMoney = $this->db->query($sql2)->fetch();
		$total_money = $totalMoney['total_money'];
		if (empty($total_money)){
			$total_money = 0;
		}
		$list['total_pages']	= ceil($total['total']/$this->pagesize);
		$list['next']			= min($page+1,$list['total_pages']);
		$list['before']			= max(1,$page-1);
		$list['current']		= $page;
		$list['last']			= $list['total_pages'];
		$list['items']			= $rechargelist;
		$this->view->setVar("itemOrder",$orderNumber);
		$this->view->setVar('payType',$payType);
		$this->view->setVar('payStatus',$payStatus);
		$this->view->setVar("itemUser",$uid);
		$this->view->setVar("total_money",$total_money);
		$this->view->setVar('prolist',$list);
		$this->view->pick('Recharge/recharge');
	}

	//博创导出支付列表
	public function printAction(){
		$sql = "SELECT id,uid,orderNumber,`number`,payType,payStatus,createTime FROM dhc_user_recharge";
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
				'ID','UID','订单号','充值数量','充值类型','充值状态','充值时间','支付方式'
			];
			$this->csv_export($data,$list,'支付列表');
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
				if ($row['payStatus'] == 1){$row['payStatus']=iconv('utf-8', 'gbk', '成功');}
				if ($row['payStatus'] == 2){$row['payStatus']=iconv('utf-8', 'gbk', '待支付');}
				if ($row['payStatus'] == 3){$row['payStatus']=iconv('utf-8', 'gbk', '支付失败');}
				if ($row['payType'] == 'alipay'){$row['withdrawtype']= iconv('utf-8', 'gbk', '支付宝');}
				if ($row['payType'] == 'wechet'){$row['withdrawtype']=iconv('utf-8', 'gbk', '微信');}
				if ($row['payType'] == 'back'){$row['withdrawtype']=iconv('utf-8', 'gbk', '后台充值');}
				if ($row['payType'] == 'qq'){$row['withdrawtype']=iconv('utf-8', 'gbk', 'qq钱包');}
				if($key == 'createTime'){
					$row[$key] = date("Y-m-d H:i:s",$value);
				}
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
