<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\OrchardSign;
use Dhc\Models\OrchardUser;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;
use Phalcon\Http\Response;

class SignController extends ControllerBase{
	public $psize = 6;
	public function initialize() {
		$this->checkToken();
		$this->config = $this->getConfig("sign");
		$this->starttime = strtotime(date('Y-m-d', time()));
	}
	function signAction(){
		if($this->config["status"] == 0){
			$this->ajaxResponse("", "签到升级中",1);
		}
		$sign = new OrchardSign();
		$signList = $sign->find("uid='{$this->userid}' AND createtime>=".$this->starttime);
		$signList = $this->object2array($signList);
		if(count($signList)>=$this->config["daySize"]){
			$this->ajaxResponse("", "今日签到已达上限！",1);
		}
		$this->db->begin();
		$sign->uid = $this->userid;
		$sign->config = json_encode($this->config);
		$sign->signLevel = $this->config["types"];
		$sign->createtime = TIMESTAMP;
		$onoTitleInfo = $this->onoTitleInfo();
		$str = "";
		$user = new OrchardUser();
		$user = $user->findFirst("uid='{$this->userid}'");
		if($this->config["types"] ==2){
			//$arr = array("1"=>"seed","2"=>"diamonds","3"=>"cfert","4"=>"hcide","5"=>"icide","6"=>"wcan","7"=>"emerald","8"=>"purplegem","9"=>"sapphire","10"=>"topaz");
			$dataArr = $this->arrKeySign($this->config);
			$mt = rand(1,count($dataArr));
			$model = $dataArr[$mt];
			if($mt ==1){
				$flag = $this->saveProduct($this->seedId, $this->config[$model]);
				if($flag == false){
					$this->db->rollback();
					$this->ajaxResponse('', "签到赠送{$onoTitleInfo[$model]}失败!","1");
				}
				$flag = $this->saveOrchardLogs(array("mobile"=>$this->mobile,"types"=>"addseed","nums"=>$this->config[$dataArr[$mt]],"msg"=>$user->nickname."签到获得".$onoTitleInfo[$model]."*".$this->config[$model]));
				if($flag == false){
					$this->db->rollback();
					$this->ajaxResponse('', "签到赠送{$onoTitleInfo[$model]}失败!","1");
				}
			}else{
				//用户道具信息更新
				$user->$model += $this->config[$dataArr[$mt]];
				$user->updatetime =TIMESTAMP;
				$flag = $user->update();
				if($flag == false){
					$this->db->rollback();
					$this->ajaxResponse("", "签到赠送{$onoTitleInfo[$model]}失败!","1");
				}
				//更新用户狗粮日志
				$flag = $this->saveOrchardLogs(array("mobile"=>$user->mobile,"nums"=>$this->config[$dataArr[$mt]],"types"=>"add".$model,"msg"=>$user->nickname."签到获得".$onoTitleInfo[$model]."*".$this->config[$dataArr[$mt]]));
				if($flag == false){
					$this->db->rollback();
					$this->ajaxResponse("", "签到更新{$onoTitleInfo[$model]}失败日志操作失败，请重试！！",1);
				}
			}
			$this->config = array($model=>$this->config[$model]);
			$str .= "恭喜获得".$onoTitleInfo[$model].$this->config[$dataArr[$mt]]."个";
		}elseif($this->config["types"] ==1){
			foreach ($this->config as $key => $value) {
				if(@in_array($key,array("daySize","types","status"))){
					continue;
				}
				if($value>0){
					if($key == "seed"){
						$flag = $this->saveProduct($this->seedId, $value);
						if($flag == false){
							$this->db->rollback();
							$this->ajaxResponse('', "签到赠送{$onoTitleInfo[$key]}失败!","1");
						}
						$flag = $this->saveOrchardLogs(array("mobile"=>$this->mobile,"types"=>"addseed","nums"=>$value,"msg"=>$user->nickname."签到获得".$onoTitleInfo[$key]."*".$value));
						if($flag == false){
							$this->db->rollback();
							$this->ajaxResponse('', "签到赠送{$onoTitleInfo[$key]}失败!","1");
						}
					}else{
						//用户道具信息更新
						$user->$key += $value;
						$user->updatetime =TIMESTAMP;
						$flag = $user->update();
						if($flag == false){
							$this->db->rollback();
							$this->ajaxResponse("", "签到赠送{$onoTitleInfo[$key]}失败!","1");
						}
						//更新用户狗粮日志
						$flag = $this->saveOrchardLogs(array("mobile"=>$user->mobile,"nums"=>$value,"types"=>"add".$key,"msg"=>$user->nickname."签到获得".$onoTitleInfo[$key]."*".$value));
						if($flag == false){
							$this->db->rollback();
							$this->ajaxResponse("", "签到更新{$onoTitleInfo[$key]}失败日志操作失败，请重试！！",1);
						}
					}
				}
				$str .=$onoTitleInfo[$model].$this->config[$dataArr[$mt]]."颗";
			}
		}
		$sign->info = json_encode($this->config);
		$flag = $sign->save();
		if($flag == false){
			$this->db->rollback();
			$this->ajaxResponse("", "签到失败！",1);
		}
		$this->db->commit();
		$userInfo = $this->selectUser($this->userid, "index");
		$data["userInfo"] = $userInfo;
		$this->ajaxResponse($data["userInfo"], "签到成功！".$str,0);
	}
	//转换key值
	function arrKeySign($data){
		$arr = array();
		$level = 0;
		foreach ($data as $key => $value) {
			if(@in_array($key,array("daySize","types","status"))){
				continue;
			}
			$level++;
			$arr[$level] = $key;
		}
		return $arr;
	}
	
	//签到记录列表 分页显示
	public function ListAction(){
		$sign = new OrchardSign();
		$pindex = max(1,$this->request->getPost("page"));
		$lists = $sign->find(array(
					'conditions'	=>	"uid = $this->userid ",
					'columns'		=>	'createtime,msg,nums',
					'order'			=>	"createtime desc"
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
		$data['totalPage'] = $list["total_pages"];
		$this->ajaxResponse($data, "签到列表",0);
	}
}
