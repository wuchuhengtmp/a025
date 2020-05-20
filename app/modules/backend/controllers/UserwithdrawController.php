<?php
namespace Dhc\Modules\Backend\Controllers;

use Dhc\Models\OperatorLog;
use Dhc\Models\User;
use Dhc\Models\UserCost;
use Dhc\Models\UserVirtual;
use Dhc\Models\UserWithdraw;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;

class UserWithdrawController extends ControllerBase{
	public $op = '';
	public $psize = 20;
	public $pindex = 1;
	public function listAction(){
		$this->op =$this->request->get('op');
		$this->pindex = $this->request->get('page');
		$keywords = $this->request->get('keywords');
		if (!empty($keywords)){
			$conditions = "status = 0 AND uid LIKE '{$keywords}' OR realname LIKE '{$keywords}'";
			$condition = "status = 1 AND uid LIKE '{$keywords}' OR realname LIKE '{$keywords}'";
		}else{
			$conditions = "status = 0";
			$condition = "status = 1";
		}
		if ($this->op == 'list'){
			$userWithdraw = UserWithdraw::find(
				[
					'conditions'=>$conditions,
					'order'=>'createtime DESC'
				]
			);
			$userWithdraws = UserWithdraw::find(
				[
					'conditions'=>$condition,
					'order'=>'createtime DESC'
				]
			);

		}elseif($this->op == 'edit'){
			$userWithdraws = UserWithdraw::find(
				[
					'conditions'=>$condition,
					'order'=>'createtime DESC'
				]
			);
			$userWithdraw = UserWithdraw::find(
				[
					'conditions'=>$conditions,
					'order'=>'createtime DESC'
				]
			);
		}
		$paginator = new PaginatorModel(
			array(
				"data"	=> $userWithdraw,
				"limit"	=>$this->psize,
				"page" =>$this->pindex
			));
		$page = $paginator->getPaginate();
		$paginator = new PaginatorModel(
			array(
				"data"	=> $userWithdraws,
				"limit"	=>$this->psize,
				"page" =>$this->pindex
			));
		$pages = $paginator->getPaginate();
		$this->view->setVar('withdraw',$page);
		$this->view->setVar('withdraws',$pages);
		$this->view->setVar('show',$this->op);
		$this->view->setVar('keywords',$keywords);
		$this->view->pick('userwithdraw/list');
	}
	public function editAction(){
		if ($this->request->isPost()){
			$data = $this->request->getPost('name');
			$this->db->begin();
			if (!empty($data)){
				foreach ($data as $v){
						$userWithdraw = UserWithdraw::findFirst("id =$v");
						if ($userWithdraw->status === '0'){
							$userWithdraw->status = '1';
							$result = $userWithdraw->update();
							if (!$result){
								$this->db->rollback();
								echo json_encode(
									$mes = array(
										'data'=>$userWithdraw->id,
										'msg'=>'该用户审核失败',
										'code'=>'1'
									)
								);die;
							}
						}
				};
				$this->db->commit();
				echo json_encode(
					$mes = array(
						'data'=>'success',
						'msg'=>'审核成功',
						'code'=>'0'
					)
					);die;
				}
		}
		$userWithdraw = UserWithdraw::find("status = 1");
		$paginator = new PaginatorModel(
			array(
				"data"	=> $userWithdraw,
				"limit"	=>$this->psize,
				"page" =>$this->pindex
			));
		$page = $paginator->getPaginate();
		$this->view->setVar('items',$page);
		$this->view->setVar('show','edit');
		$this->view->pick('list');
	}

	public function overAction(){
        $this->pindex = $this->request->get('page');
        $conditions = "status  =2 ";
        $keywords = $this->request->get('keywords');
        if (!empty($keywords)){
            $conditions .= " AND realname LIKE '%{$keywords}%' OR uid LIKE '{$keywords}'";
            $this->view->setVar('keywords',$keywords);
        }
        if (empty($this->pindex)){$this->pindex = 1;}
        $userWithdraw = UserWithdraw::find(
            [
                'conditions'=>$conditions,
                'order'=>'createtime DESC'
            ]
        );
        $paginator = new PaginatorModel(
            array(
                "data"	=> $userWithdraw,
                "limit"	=>$this->psize,
                "page" =>$this->pindex
            ));
        $page = $paginator->getPaginate();
        $this->view->setVar('withdraw',$page->items);
        $this->view->setVar('page',$page);
    }

    public function updataAction(){
		if ($this->request->isPost()){
			$data = $this->request->getPost('name');
			if (!empty($data)){
				foreach ($data as $v){
					$this->db->begin();
					$userWithdraw = UserWithdraw::findFirst("id =$v");
					if ($userWithdraw->status == '1'){
						$userWithdraw->status = '2';
						$result = $userWithdraw->update();
						$userInfo = User::findFirst("id = $userWithdraw->uid");
						$userInfo->Frozen -=($userWithdraw->goldnumber+$userWithdraw->fee);
						$this->saveLogs(array('uid'=>$userWithdraw->uid,'num'=>($userWithdraw->goldnumber+$userWithdraw->fee),'title'=>'提现完成冻结金币减少'.($userWithdraw->goldnumber+$userWithdraw->fee)));
						$this->saveTradeLogs(array("uid"=>$userWithdraw->uid,'num'=>($userWithdraw->goldnumber+$userWithdraw->fee),'log'=>'提现完成冻结金币减少'.($userWithdraw->goldnumber+$userWithdraw->fee),'type'=>'dedfrozencoing'));
						$userInfoResult = $userInfo->update();
						if (!$result||!$userInfoResult){
							echo json_encode(
								$mes = array(
									'data'=>$userWithdraw->id,
									'msg'=>$userWithdraw->id.'更新失败',
									'code'=>'1'
								)
							);die;
						}
						$orderTime = $userWithdraw->createtime;
						$uid =$userWithdraw->uid;
						$orderNumber = 'TX'.date("YmdHis",$orderTime).str_pad($uid,'6','0',STR_PAD_LEFT);;
						$userCost = UserCost::findFirst("orderNumber = '$orderNumber' and uid =$uid");
						if ($userCost){
								$userCost->status = '1';
								$userCost->endtime = TIMESTAMP;
								$userCostResult = $userCost->update();
						}
						if ($result&&$userInfoResult&&@$userCostResult){
							$flag = true;
							$this->db->commit();
						}else{
							$this->db->rollback();
							echo json_encode(
								$mes = array(
									'data'=>'error',
									'msg'=>$v.'更新失败请注意',
									'code'=>'0'
								)
							);die;
						}
					}
				};
			}
			if ($flag){
				echo json_encode(
					$mes = array(
						'data'=>'success',
						'msg'=>'更新成功',
						'code'=>'0'
					)
				);die;
			}

		}
		$userWithdraw = UserWithdraw::find();
		$paginator = new PaginatorModel(
			array(
				"data"	=> $userWithdraw,
				"limit"	=>$this->psize,
				"page" =>$this->pindex
			));
		$page = $paginator->getPaginate();
		$this->view->setVar('items',$page);
		$this->view->setVar('show','edit');
		$this->view->pick('list');
	}
	public function restAction(){
		if ($this->request->isPost()){
			$data = $this->request->getPost('name');
			if (!empty($data)){
				$flag =false;
				foreach ($data as $value){
					$flag = true;
					$this->db->begin();
					$userwithdraw = UserWithdraw::findFirst("id =$value");
					if ($userwithdraw->status === '1'){
						$userwithdraw->status = 3;
						$userInfo = User::findFirst("id = $userwithdraw->uid");
						if (!$userInfo){$this->ajaxResponse('error',"$userwithdraw->uid 该用户不存在",'1');}
						$userInfo->coing += ($userwithdraw->fee+$userwithdraw->goldnumber);
						$userInfo->Frozen -= ($userwithdraw->fee+$userwithdraw->goldnumber);
						$this->saveLogs(array('uid'=>$userwithdraw->uid,'num'=>($userwithdraw->fee+$userwithdraw->goldnumber),'title'=>'提现退回金币增加'.($userwithdraw->fee+$userwithdraw->goldnumber)));
						$this->saveLogs(array('uid'=>$userwithdraw->uid,'num'=>($userwithdraw->fee+$userwithdraw->goldnumber),'title'=>'提现退回冻结金币减少'.($userwithdraw->fee+$userwithdraw->goldnumber)));
						$this->saveTradeLogs(array("uid"=>$userwithdraw->uid,'num'=>($userwithdraw->fee+$userwithdraw->goldnumber),'log'=>'提现退回金币增加'.($userwithdraw->fee+$userwithdraw->goldnumber),'type'=>'addcoing'));
						$this->saveTradeLogs(array("uid"=>$userwithdraw->uid,'num'=>($userwithdraw->fee+$userwithdraw->goldnumber),'log'=>'提现退回冻结金币减少'.($userwithdraw->fee+$userwithdraw->goldnumber),'type'=>'dedfrozencoing'));
						$userInfoResult = $userInfo->update();
						if ($userInfoResult){$userwithdrawResult = $userwithdraw->update();}
					}
					if (!$userInfoResult||!$userwithdrawResult){
						$this->db->rollback();
						$flag=false;
						$this->ajaxResponse('error','订单退回异常','1');
					}else{
						$this->db->commit();
					}
				}
			}
			if ($flag){$this->ajaxResponse('success','退回成功','0');}else{$this->ajaxResponse('error','异常','1');}

		}
	}
	public function printAction(){
		$op = $this->request->get('op');
		if ($op == 'over'){
			$sql = "SELECT id,uid,goldnumber,accountnumber,realname,bankaccount,province,city,withdrawtype,costname,status FROM dhc_user_withdraw WHERE status = 2";
		}elseif($op == 'list'){
			$sql = "SELECT id,uid,goldnumber,accountnumber,realname,bankaccount,province,city,withdrawtype,costname,status FROM dhc_user_withdraw WHERE status = 0";
		}else{
			$sql = "SELECT id,uid,goldnumber,accountnumber,realname,bankaccount,province,city,withdrawtype,costname,status FROM dhc_user_withdraw WHERE status = 1";
		}
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
				'ID','UID','金额','收款人帐号','收款人名称','收款人开户行','收款人所在省','收款人所在市县','转账类型','汇款用途','审核状态'
			];
			$this->csv_export($data,$list,'提现列表');
		}else{
			exit("<script>alert('暂无提现申请');history.go(-1);</script>>");
		}
	}
	public function export($data){
		$data['title'] = "提现列表";
		$data['spread'] = '推广奖励';
		$objPHPExcel = $this->PHPExcel;
		// Set document properties
		$objPHPExcel->getProperties()->setCreator("-IT共享支持部")
			->setLastModifiedBy("OTRS REPORTER")
			->setTitle("OTRS报表")
			->setSubject("Office 2007 XLSX Document")
			->setDescription("OTRS Report for Office 2007 XLSX, generated using PHP classes.")
			->setKeywords("office 2007 ")
			->setCategory("OTRS");
		// Add some data
		$objPHPExcel->setActiveSheetIndex(0)
					->setCellValue("A1",'ID')
					->setCellValue("B1",'UID')
					->setCellValue('C1', '金额')
					->setCellValue('D1', '收款人帐号')
					->setCellValue('E1', '收款人名称')
					->setCellValue('F1', '收款人开户行')
					->setCellValue('G1', '收款人所在省')
					->setCellValue('H1', '收款人所在市县')
					->setCellValue('I1', '转账类型')
					->setCellValue('J1', '状态')
					->setCellValue('K1', '汇款用途');
		// Rename worksheet
		$time = date("Y-m-d",time());
		$objPHPExcel->getActiveSheet()->setTitle('withdraw'.$time);
		$k = 2;
		foreach ($data as $value){
			if ($k-1>count($value)){
				break;
			}
			$objPHPExcel->setActiveSheetIndex(0)
				->setCellValue('A'.$k,$value['id'])
				->setCellValue('B'.$k,$value['uid'])
				->setCellValue('C'.$k, $value['goldnumber'])
				->setCellValueExplicit('D'.$k,$value['accountnumber'],\PHPExcel_Cell_DataType::TYPE_STRING)
				->setCellValue('E'.$k, $value['realname'])
				->setCellValue('F'.$k, $value['bankaccount'])
				->setCellValue('G'.$k, $value['province'])
				->setCellValue('H'.$k, $value['city'])
				->setCellValue('I'.$k, $this->gettypename($value['withdrawtype']))
				->setCellValue('J'.$k,$value['status'] )
				->setCellValue('K'.$k,'推广佣金' );
			$k++;

		}
		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$objPHPExcel->setActiveSheetIndex(0);

		// Redirect output to a client’s web browser (Excel5)
		header('Content-Type: text/csv');
		header('Content-Disposition: attachment;filename="OTRS.xls"');
		header('Cache-Control: max-age=0');
		// If you're serving to IE 9, then the following may be needed
		header('Cache-Control: max-age=1');
		// If you're serving to IE over SSL, then the following may be needed
		header ('Expires: Mon, 26 Jul 1997 05:00:00 GMT'); // Date in the past
		header ('Last-Modified: '.gmdate('D, d M Y H:i:s').' GMT'); // always modified
		header ('Cache-Control: cache, must-revalidate'); // HTTP/1.1
		header ('Pragma: public'); // HTTP/1.0

		$objWriter = \PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
		$objWriter->save('php://output');
		exit;
	}
	//编辑提现信息
	public function createAction()
	{
		$id = $this->request->get('id');
		$data = $this->request->getPost();
		//如果是post数据编辑
		if ($this->request->isPost()) {
			$userWithdraw = UserWithdraw::findFirst("id = '{$data['id']}'");
			if (empty($userWithdraw)) {
				$this->message('操作失败，操作对象不存在', APP_ADMIN_PATH . "/userwithdraw/list?op=list", 'error');
			}
			$userWithdraw->accountnumber = $data['accountnumber'];
			$userWithdraw->goldnumber = $data['goldnumber'];
			$userWithdraw->fee = $data['fee'];
			$userWithdraw->uid = $data['uid'];
			$userWithdraw->bankaccount = $data['bankaccount'];
			$userWithdraw->withdrawtype = $data['withdrawtype'];
			$userWithdraw->province = $data['province'];
			$userWithdraw->city = $data['city'];
			$userWithdraw->costname = $data['costname'];
			$userWithdraw->realname = $data['realname'];
			$result = $userWithdraw->update();
			if (empty($result)) {
				$this->message('操作失败，记录更新失败', APP_ADMIN_PATH . "/userwithdraw/list?op=list", 'error');
			} else {
				$this->message('操作成功，记录更新成功', APP_ADMIN_PATH . '/userwithdraw/list?op=list', 'success');
			}
		}
			//如果是get数据显示
			if ($this->request->isGet()) {
				if (!empty($id)) {
					$userWithdraw = UserWithdraw::findFirst("id = '{$id}'");
					if (empty($userWithdraw)) {
						$this->message('操作失败，操作对象不存在', APP_ADMIN_PATH.'/userwithdraw/list?op=list', 'error');
					}
					$this->view->setVar('item', $userWithdraw);
					$this->view->setVar('show', 'create');
				}
			}
			$this->view->setVar('id', $id);

	}

	public function VupdataAction(){
		if ($this->request->isPost()){
			$data = $this->request->getPost('name');
			if (!empty($data)){
				foreach ($data as $v){
					$this->db->begin();
					$userWithdraw = UserVirtual::findFirst("id =$v");
					if ($userWithdraw->status == 1){
						$userWithdraw->status = '2';
						$result = $userWithdraw->update();
						$userInfo = User::findFirst("id = $userWithdraw->uid");
						$userInfo->Frozen -=$userWithdraw->goldnumber;
						$this->saveLogs(array('uid'=>$userWithdraw->uid,'num'=>$userWithdraw->goldnumber,'title'=>'提现完成冻结金币减少'.($userWithdraw->goldnumber)));
						$this->saveTradeLogs(array("uid"=>$userWithdraw->uid,'num'=>$userWithdraw->goldnumber,'log'=>'提现完成冻结金币减少'.($userWithdraw->goldnumber),'type'=>'dedfrozencoing'));
						$userInfoResult = $userInfo->update();
						if (!$result||!$userInfoResult){
							echo json_encode(
								$mes = array(
									'data'=>$userWithdraw->id,
									'msg'=>$userWithdraw->id.'更新失败',
									'code'=>'1'
								)
							);die;
						}
						$orderTime = $userWithdraw->createtime;
						$uid =$userWithdraw->uid;
						$orderNumber = 'XT'.date("YmdHis",$orderTime).str_pad($uid,'6','0',STR_PAD_LEFT);;
						$userCost = UserCost::findFirst("orderNumber = '$orderNumber' and uid =$uid");
						if ($userCost){
							$userCost->status = '1';
							$userCost->endtime = TIMESTAMP;
							$userCostResult = $userCost->update();
						}
						if ($result&&$userInfoResult&&@$userCostResult){
							$flag = true;
							$this->db->commit();
						}else{
							$this->db->rollback();
							echo json_encode(
								$mes = array(
									'data'=>'error',
									'msg'=>$v.'更新失败请注意',
									'code'=>'0'
								)
							);die;
						}
					}
				};
			}else{
				echo json_encode(
					$mes = array(
						'data'=>'error',
						'msg'=>'操作失败，未选定操作对象',
						'code'=>'1'
					)
				);die;

			}
			if ($flag){
				echo json_encode(
					$mes = array(
						'data'=>'success',
						'msg'=>'更新成功',
						'code'=>'0'
					)
				);die;
			}

		}
		$userWithdraw = UserVirtual::find();
		$paginator = new PaginatorModel(
			array(
				"data"	=> $userWithdraw,
				"limit"	=>$this->psize,
				"page" =>$this->pindex
			));
		$page = $paginator->getPaginate();
		$this->view->setVar('items',$page);
		$this->view->setVar('show','edit');
		$this->view->pick('list');

	}
	//虚拟币批量审核
	public function VupdatasAction()
	{
		if ($this->request->isPost()) {
			$data = $this->request->getPost('name');
			if (!empty($data)) {
				foreach ($data as $v) {
					$this->db->begin();
					$userWithdraw = UserVirtual::findFirst("id =$v");

					if ($userWithdraw->status == '0') {
						$userWithdraw->status = '1';
						$result = $userWithdraw->update();
						if (empty($result)) {
							$this->db->rollback();
							echo json_encode(
								$mes = array(
									'data' => $userWithdraw->id,
									'msg' => $userWithdraw->id . '更新失败请注意',
									'code' => '1'
								)
							);
							die;
						}else{
							$this->db->commit();
						}
					}
				}
				echo json_encode(
					$mes = array(
						'data' => 'success',
						'msg' =>  '更新成功',
						'code' => '0'
					)
				);
				die;

			};
		} else {
			echo json_encode(
				$mes = array(
					'data' => 'error',
					'msg' => '操作失败，未选定操作对象',
					'code' => '1'
				)
			);
			die;

		}
	}

	public function VrestAction(){
		if ($this->request->isPost()){
			$data = $this->request->getPost('name');
			if (!empty($data)){

				$flag =false;
				foreach ($data as $value){
					$flag = true;
					$this->db->begin();
					$userwithdraw = UserVirtual::findFirst("id =$value");
					if ($userwithdraw->status === '1'){
						$userwithdraw->status = 3;
						$userInfo = User::findFirst("id = $userwithdraw->uid");
						if (!$userInfo){$this->ajaxResponse('error',"$userwithdraw->uid 该用户不存在",'1');}
						$userInfo->coing += $userwithdraw->goldnumber;
						$userInfo->Frozen -= $userwithdraw->goldnumber;
						$this->saveLogs(array('uid'=>$userwithdraw->uid,'num'=>($userwithdraw->goldnumber),'title'=>'提现退回金币增加'.($userwithdraw->goldnumber)));
						$this->saveLogs(array('uid'=>$userwithdraw->uid,'num'=>($userwithdraw->goldnumber),'title'=>'提现退回冻结金币减少'.($userwithdraw->goldnumber)));
						$this->saveTradeLogs(array("uid"=>$userwithdraw->uid,'num'=>($userwithdraw->goldnumber),'log'=>'提现退回金币增加'.($userwithdraw->goldnumber),'type'=>'addcoing'));
						$this->saveTradeLogs(array("uid"=>$userwithdraw->uid,'num'=>($userwithdraw->goldnumber),'log'=>'提现退回冻结金币减少'.($userwithdraw->goldnumber),'type'=>'dedfrozencoing'));
						$userInfoResult = $userInfo->update();
						if ($userInfoResult){$userwithdrawResult = $userwithdraw->update();}
					}
					if (!$userInfoResult||!$userwithdrawResult){
						$this->db->rollback();
						$flag=false;
						$this->ajaxResponse('error','订单退回异常','1');
					}else{
						$this->db->commit();
					}
				}
			}
			if ($flag){$this->ajaxResponse('success','退回成功','0');}else{$this->ajaxResponse('error','异常','1');}

		}
	}

	public function VprintAction(){

		$sql = "SELECT id,uid,goldnumber,number,address,createtime,rebate,status FROM dhc_virtual_withdraw WHERE status = 2";
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
				'ID','UID','提现金币数量','提现数量','收货地址','提现时间','兑换比例','审核状态'
			];
			$this->C_export($data,$list,'虚拟币提现列表');
		}else{
			exit("<script>alert('暂无提现申请');history.go(-1);</script>>");
		}
	}


	function C_export($data = array(), $headlist = array(), $fileName) {
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
				if ($row['status'] == 1){$row['status']=iconv('utf-8', 'gbk', '通过');}
				if ($row['status'] == 2){$row['status']=iconv('utf-8', 'gbk', '完成');}
				if ($key == 'createtime'){
					$row[$key] = date("Y-m-d H:i:s",$value);
				}
			}
			foreach ($row as $key=>$value){
				if ($key == 'accountnumber'){
					$row[$key] = "'".$value;
				}
			}
			fputcsv($fp, $row);
		}exit;
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
				if ($row['status'] == 1){$row['status']=iconv('utf-8', 'gbk', '通过');}
				if ($row['status'] == 2){$row['status']=iconv('utf-8', 'gbk', '完成');}
				if ($row['withdrawtype'] == 1){$row['withdrawtype']= iconv('utf-8', 'gbk', '行内转账');}
				if ($row['withdrawtype'] == 2){$row['withdrawtype']=iconv('utf-8', 'gbk', '同城跨行');}
				if ($row['withdrawtype'] == 3){$row['withdrawtype']=iconv('utf-8', 'gbk', '异地跨行');}
			}
			foreach ($row as $key=>$value){
				if ($key == 'accountnumber'){
					$row[$key] = "'".$value;
				}
			}
			fputcsv($fp, $row);
		}exit;
	}

	protected function getuserName($uid){
		$username = User::findFirst(
			array(
				'conditions'=>"id =$uid",
				'columns'	=>"realname"
			)
		);
		if ($username){
			return $username->realname;
		}else{
			return '';
		}
	}
	protected function gettypename($type){
		if ($type === '1'){
			return '行内转账';
		}elseif ($type === '2'){
			return '同城跨行';
		}elseif ($type==='3'){
			return '异地跨行';
		}else{
			return ' ';
		}
	}

	public function saveLogs($data){
		$operate = $this->session->get('operate');
		$logs = new OperatorLog();
		$logs->uid = $data['uid'];
		$logs->operator = $operate;
		$logs->createtime = TIMESTAMP;
		$logs->title = $data['title'];
		$result =  $logs->save();
		if (!$result){
			foreach ($logs->getMessages() as $message){
				echo  $message;
			}die;
		}
	}
	//虚拟币提现列表
	public function virtualAction(){
		$page 	 = $this->request->get('page');
		$keyword = $this->request->get('keywords');
		$op = $this->request->get('op');
		if (empty($op)){
			$op = 'list';
		}
		if (empty($page)){
			$page = 1;
		}
		$conditions =  "status = 0";
		$condition = 'status = 1';
		if (!empty($keyword)){
			$conditions .= " AND uid = '{$keyword}'";
			$condition .= " AND uid = '{$keyword}'";
		}
		$pageoffset = ($page - 1)*$this->psize;
		$sql = "SELECT * FROM dhc_virtual_withdraw  WHERE $conditions ORDER BY createtime DESC LIMIT $pageoffset,$this->psize";
		$list = $this->db->query($sql)->fetchAll();
		$sql2 = "SELECT COUNT(*) AS nums FROM dhc_virtual_withdraw WHERE $conditions";
		$total = $this->db->query($sql2)->fetch();
		$sql1 = "SELECT * FROM dhc_virtual_withdraw WHERE $condition ORDER BY createtime DESC LIMIT $pageoffset,$this->psize";
		$item = $this->db->query($sql1)->fetchAll();
		$sql3 = "SELECT COUNT(*)  AS nums FROM dhc_virtual_withdraw WHERE $condition";
		$total1 = $this->db->query($sql3)->fetch();
		//审核列表

		$total_pages = $total['nums'];
		$lists['total_pages'] = ceil($total_pages/$this->psize);
		$lists['next']		 = min($lists['total_pages'],$page+1);
		$lists['before']	 = max($page-1,1);
		$lists['last']		 = $lists['total_pages'];
		$lists['current']	 = $page;
		$lists['list']		 = $list;
		//通过
		$totals_pages = $total1['nums'];
		$items['total_pages'] = ceil($totals_pages/$this->psize);
		$items['next']		 = min($items['total_pages'],$page+1);
		$items['before']	 = max($page-1,1);
		$items['last']		 = $lists['total_pages'];
		$items['current']	 = $page;
		$items['list']		 = $item;
		$this->view->setVar('list',$lists);
		$this->view->setVar('item',$items);
//		echo '<pre>';
//		var_dump($sql);die;
		$this->view->setVar('keywords',$keyword);
		$this->view->setVar('show',$op);
	}
}
