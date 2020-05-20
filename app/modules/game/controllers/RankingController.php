<?php

namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\User;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardDog;
use Dhc\Models\OrchardHailFellow;
use Phalcon\Http\Response;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;


class RankingController extends ControllerBase{
	public $psize = 10;
	public function initialize() {
		$this->checkToken();
	}
	// 玩家排行榜 前100 一页10条
	public function rankPlayerAction(){
		$pindex = max(1,$this->request->getPost("page"));
		$user = new OrchardUser();
		$lists = $user->find(array(
			'columns'		=>	'uid,nickname,grade,diamonds',
			'order'			=>	"grade desc,diamonds desc",
			'limit'=>'100'
		));
		$paginator = new PaginatorModel(array("data"	=> $lists,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$arr = $this->object2array($lists); 
		$data = array();
		if(!empty($arr)){
			foreach ($arr as $key => $value) {
				if($value["uid"] == $this->userid){
					$data["rank"] =$key+1;
					break;
				}
			}
		}
		$list = $this->object2array($page);
		if(!empty($list["items"])){
			foreach ($list["items"] as $key =>&$value) {
				$value["rank"] = ($key+1)+($pindex-1)*$this->psize;
				$value["userName"] = $value["nickname"];
				$value["level"] = $value["grade"];
				unset($list["items"][$key]["nickname"],$list["items"][$key]["grade"]);
			}
		}
		$data['list'] = $list["items"];
		$data['curPage'] = $list["current"];
		$data['totalPage'] = $list["total_pages"];
		$this->ajaxResponse($data, "排行榜信息",0);
	}
	// 玩家宠物排行榜 前100 一页10条
	public function rankingPetAction(){
		$pindex = max(1,$this->request->getPost("page"));
		$dog = new OrchardDog();
		$lists = $dog->find(array(
			'columns'		=>	'uid,nickname,dogLevel,dogName,score',
			'order'			=>	"dogLevel desc,score desc",
			'limit'=>'100'
		));
		$paginator = new PaginatorModel(array("data"	=> $lists,"limit"	=>$this->psize,"page" =>$pindex));
		$page = $paginator->getPaginate();
		$arr = $this->object2array($lists);
		$data = array();
		if(!empty($arr)){
			foreach ($arr as $key => $value) {
				if($value["uid"] == $this->userid){
					$data["rank"] =$key+1;
					break;
				}
			}
		}
		$list = $this->object2array($page);
		if(!empty($list["items"])){
			foreach ($list["items"] as $key =>&$value) {
				$value["rank"] = ($key+1)+($pindex-1)*$this->psize;
				$value["ownerName"] = $value["nickname"];
				$value["level"] = $value["dogLevel"];
				unset($list["items"][$key]["nickname"],$list["items"][$key]["dogLevel"]);
			}
		}
		
		$data['list'] = $list["items"];
		$data['curPage'] = $list["current"];
		$data['totalPage'] = $list["total_pages"];
		$this->ajaxResponse($data, "排行榜信息",0);
	}
	// 好友排行榜 一页10条
	public function rankFriendAction(){
		$pindex = max(1,$this->request->getPost("page"));
		$hail = new OrchardHailFellow();
		$lists = $hail->find("uid='{$this->userid}' AND status=1");
		$list = $this->object2array($lists);
		$data = array();
		if(!empty($list)){
			$str = $this->userid.",";
			foreach ($list as $key => $value) {
				$str .=$value["huid"].",";
			}
			$str = trim($str,",");
			$user = new OrchardUser();
			$lists = $user->find(array(
				'conditions'	=>	"uid in($str)",
				'columns'		=>	'uid,nickname,grade,diamonds',
				'order'			=>	"grade desc,diamonds desc",
				'limit'=>'100'
			));
			$paginator = new PaginatorModel(array("data"	=> $lists,"limit"	=>$this->psize,"page" =>$pindex));
			$page = $paginator->getPaginate();
			$arr = $this->object2array($lists);
			if(!empty($arr)){
				foreach ($arr as $key => $value) {
					if($value["uid"] == $this->userid){
						$data["rank"] =$key+1;
						break;
					}
				}
			}
			$list = $this->object2array($page);
			if(!empty($list["items"])){
				foreach ($list["items"] as $key =>&$value) {
					$value["rank"] = ($key+1)+($pindex-1)*$this->psize;
					$value["userName"] = $value["nickname"];
					$value["level"] = $value["grade"];
					unset($list["items"][$key]["nickname"],$list["items"][$key]["grade"]);
				}
			}
			$data['list'] = $list["items"];
			$data['curPage'] = $list["current"];
			$data['totalPage'] = $list["total_pages"];
			$this->ajaxResponse($data, "排行榜信息",0);
		}else{
			$this->ajaxResponse("", "暂无更多好友！",1);
		}
	}
}
