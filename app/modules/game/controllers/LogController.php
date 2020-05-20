<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\OrchardLogs;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;
use Phalcon\Http\Response;

class LogController extends ControllerBase{
	public $psize = 9;
	public function initialize() {
		$this->checkToken();
	}
	//日志记录列表 分页显示
	public function ListAction(){
		$logs = new OrchardLogs();
		$pindex = max(1,$this->request->getPost("page"));
		$lists = $logs->find(array(
					'conditions'	=>	"uid = $this->userid AND status=1 ",
					'columns'		=>	'createtime,msg,nums',
					'order'			=>	"createtime DESC"
				));
		$paginator = new PaginatorModel(array("data"	=> $lists,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$list = $this->object2array($page);
		if(!empty($list["items"])){
			foreach ($list["items"] as &$value) {
				$value["time"] = date("Y-m-d H:i:s",$value["createtime"]);
			}
		}
		$data['list'] = $list["items"];
		$data['curPage'] = $list["current"];
		if($list["total_pages"]>0){
			if($list["total_pages"]>100){
				$totalPage = 100;
			}else{
				$totalPage = $list["total_pages"];
			}
		}else{
			$totalPage =1;
		}
		$data['totalPage'] = $totalPage;
		$this->ajaxResponse($data, "日志列表",0);
	}
	//清空日志记录
	public function emlogsAction(){
		$logs = new OrchardLogs();
//		$pindex = max(1,$this->request->getPost("page"));
		$lists = $logs->find(array(
					'conditions'	=>	"uid = $this->userid AND status=1",
					'columns'		=>	'createtime,msg,id',
					'order'			=>	"createtime desc"
				));
//		$paginator = new PaginatorModel(array("data"	=> $lists,"limit"	=>$this->psize,"page" =>$pindex));
//		$page = $paginator->getPaginate();
		$list = $this->object2array($lists);
		if(empty($list)){
			$this->ajaxResponse("", "已无更多日志记录!",1);
		}
		$flag = true;
		$this->db->begin();
		if(!empty($list)){
			foreach ($list as $value) {
				$logs = new OrchardLogs();
				$item = $logs->findFirst("id={$value['id']}");
				$item->status = 2;
				$flag = $item->update();
				if($flag == false){
					break;
				}
			}
		}
		if($flag){
			$this->db->commit();
			$this->ajaxResponse("", "一键清空操作成功!",0);
		}else{
			$this->db->rollback();
			$this->ajaxResponse("", "一键清空操作失败!",1);
		}
	}
}
