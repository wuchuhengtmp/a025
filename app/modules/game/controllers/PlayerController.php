<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardHailFellow;
use Phalcon\Http\Response;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;

class PlayerController extends ControllerBase{
	public $psize = 10;
	public function initialize() {
		$this->checkToken();
	}
	//会员好友列表记录
	public function indexAction(){
		//分页数据
		$pindex = max(1, $this->request->get('page'));
		$this->op = $this->request->getPost("op")?$this->request->getPost("op"):"display";

		$player = new OrchardHailFellow();
		$condition = " isDel=0 ";
		if($this->op == 'display'){
			$condition .= " AND uid='{$this->userid}' AND status=1";
			$msg = "关系好友";
		}elseif($this->op == 'list'){
			$condition .= " AND huid='{$this->userid}' AND status=0";
			$msg = "申请好友";
		}
		$list = $player->find(array(
				'conditions' =>$condition,
				'order'		 =>'updatetime DESC'
			));
		$paginator = new PaginatorModel(array("data"	=> $list,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$data = array(
			"page"=>$pindex,
			"total"=>$page->total_pages,
			"list"=>$this->object2array($page->items)
		);
		$this->ajaxResponse($data, $msg."列表返回信息",0);
	}

	// 根据UID搜索玩家
	public function findPlayerAction(){
		if ($this->request->isPost()) {
			$uid = $this->request->getPost("uid");
			if($uid<=0){
				$this->ajaxResponse("", "请输入搜索会员编号",1);
			}
			$data = $this->selectUser(intval($uid));
			if(empty($data)){
				$this->ajaxResponse("", "玩家信息搜索失败",1);
			}
			$this->ajaxResponse($data, "玩家信息返回成功",0);
		}
	}

	// 添加玩家为好友
	public function addPlayerAction(){
		if ($this->request->isPost()) {
			$uid = $this->request->getPost("uid");
			if($uid<=0){
				$this->ajaxResponse("", "请输入会员编号！",1);
			}
			if($uid == $this->userid){
				$this->ajaxResponse("", "现无法添加自己为好友！",1);
			}
			$data = $this->selectUser($uid);
			if(empty($data)){
				$this->ajaxResponse("", "会员信息不存在，请重试！",1);
			}
			$this->db->begin();
			$hailFellow = new OrchardHailFellow();
			$hail = $hailFellow->findFirst("uid='{$this->userid}' AND huid='{$uid}' AND isDel=0");
			if(!empty($hail)){
				if($hail->status =="0"){
					$this->ajaxResponse("", "您已经申请添加此好友，请勿重复添加！",1);
				}elseif($hail->status =="9"){
					$hail->status = "0";
					$hail->updatetime = TIMESTAMP;
					$flag = $hail->update();
				}else{
					$this->ajaxResponse("", "他已经是您的好友，无需重复添加！",1);
				}
			}else{
				$hailFellow->uid = $this->userid;
				$hailFellow->huid = $uid;
				$hailFellow->mobile = $data["mobile"];
				$hailFellow->nickname = $data["userName"];
				$hailFellow->isAdd = 1;
				$hailFellow->createtime = $hailFellow->updatetime = TIMESTAMP;
				$flag = $hailFellow->save();
			}
			if($flag){
				$this->db->commit();
				$this->ajaxResponse("", "申请添加成功！请耐心等待！",0);
			}else{
				$this->db->rollback();
				$this->ajaxResponse("", "申请添加好友失败，请重试",1);
			}
		}
	}
	//申请会员点击操作 同意拒绝
	public function saveHailAction(){
		if ($this->request->isPost()) {
			$id = $this->request->getPost("id");
			if(empty($id)){
				$this->ajaxResponse("", "记录不存在，请重试！",1);
			}
			$this->db->begin();
			$hailFellow = new OrchardHailFellow();
			$item = $hailFellow->findFirst("id='{$id}' AND huid='{$this->userid}'");
			if(empty($item)){
				$this->db->rollback();
				$this->ajaxResponse("", "记录不存在，请重试！",1);
			}
			if($item->status ==1){
				$this->db->rollback();
				$this->ajaxResponse("", "好友添加记录已同意！",1);
			}
			if($item->status ==9){
				$this->db->rollback();
				$this->ajaxResponse("", "好友添加记录已拒绝！",1);
			}
			if($this->request->getPost("type") == "add"){
				$hailUser = $hailFellow->findFirst("uid='{$item->huid}' AND huid='{$item->uid}'");
				$item->status = 1;
				$msg = "添加";
				if(empty($hailUser)){
					$hailFellow->status = 1;
					$hailFellow->uid = $item->huid;
					$hailFellow->huid = $item->uid;
					$itemData = $this->selectUser($item->uid);
					$hailFellow->nickname = $itemData["userName"];
					$hailFellow->mobile = $itemData["mobile"];
					$hailFellow->createtime = $hailFellow->updatetime = TIMESTAMP;
					$flag1 = $hailFellow->save();
				}else{
					$hailUser->status = 1;
					$hailUser->updatetime = TIMESTAMP;
					$flag1 = $hailUser->update();
				}
			}else{
				$item->status =9;
				$msg = "拒绝";
				$flag1 = true;
			}
			$item->updatetime = TIMESTAMP;
			$flag = $item->update();
			if($flag == false || $flag1 == false){
				$this->db->rollback();
				$this->ajaxResponse("", "{$msg}好友失败！",1);
			}else{
				$this->db->commit();
				$this->ajaxResponse("", "{$msg}好友成功！",0);
			}
		}
	}
	//好友申请记录
	function hailListAction(){
		$hailFellow = new OrchardHailFellow();
		$pindex = max(1,$this->request->getPost("page"));
		$lists = $hailFellow->find(array(
					'conditions'	=>	"huid = $this->userid  AND status in (0,1)",
					'columns'		=>	'createtime,uid,status,id',
					'order'			=>	"createtime desc"
				));
		$paginator = new PaginatorModel(array("data"	=> $lists,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$list = $this->object2array($page);
		if(!empty($list["items"])){
			foreach ($list["items"] as $key=>&$value) {
				$user = $this->selectUser($value["uid"], "user");
				if(empty($user)){
					unset($list["items"][$key]);
				}
				$value["userName"] = !empty($user["userName"])?$user["userName"]:"";
				$value["grade"] = !empty($user["level"])?$user["level"]:"";
				$value["diamonds"] = !empty($user["diamonds"])?$user["diamonds"]:"";
				$value["time"] = date("Y-m-d H:i:s",$value["createtime"]);
				if($value["status"] == 1){
					$value["info"] = "已同意";
				}elseif($value["status"] ==9){
					$value["info"] = "已拒绝";
				}else{
					$value["info"] = "未同意";
				}
			}
		}
		$data['list'] = $list["items"];
		$data['curPage'] = $list["current"];
		$data['totalPage'] = $list["total_pages"]>0?$list["total_pages"]:1;
		$this->ajaxResponse($data, "好友申请列表",0);
	}
}
