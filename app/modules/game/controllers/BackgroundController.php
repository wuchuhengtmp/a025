<?php

namespace Dhc\Modules\Game\Controllers;
use Dhc\Models\OrchardUser;
use Dhc\Models\OrchardBackground;
use Phalcon\Http\Response;

class BackgroundController extends ControllerBase{
	public function initialize() {
		$this->checkToken();
	}
	function listAction(){
		$background = new OrchardBackground();
		$data = $background->find("uid='{$this->userid}' order by status desc,updatetime desc");
		$data = $this->object2array($data);
		$this->ajaxResponse($data, "装扮信息返回",0);
	}
	function switchBackgroundAction(){
		if($this->request->isPost()){
			$this->db->begin();
			$backId = $this->request->getPost("backId");
			if($backId == false){
				$this->db->rollback();
				$this->ajaxResponse("", "请选择模板装扮",1);
			}
			$flag = $this->saveUserBackground($backId);
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "模板更新失败",1);
			}
			$user = new OrchardUser();
			$user = $user->findFirst("uid='{$this->userid}'");
			if($user == false){
				$this->db->rollback();
				$this->ajaxResponse("", "用户信息获取失败",1);
			}
			$user->skin = $backId;
			$user->updatetime =TIMESTAMP;
			$flag = $user->update();
			if($flag == false){
				$this->db->rollback();
				$this->ajaxResponse("", "装扮失败，请重试！",1);
			}
			$this->db->commit();
			$this->ajaxResponse("", "装扮成功！",0);
		}
	}
}
