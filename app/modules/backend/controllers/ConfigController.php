<?php

namespace Dhc\Modules\Backend\Controllers;
use Dhc\Models\Config;
use Dhc\Models\UserService;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;
use Dhc\Models\Slide;

class ConfigController extends ControllerBase
{
	public function indexAction() {
		if ($this->request->isPost()){
			$data = $this->request->getPost();
			$configInfo = new Config();
			$configInfo->value = serialize($data);
			$configInfo->key = 'web';
			$result = $configInfo->save();
			if ($result){
				$this->message('操作成功');
			}else{
				foreach ($configInfo->getMessages() as $message){
					echo $message;
				}die;
			}
		}
		$configInfo = Config::findFirst("key='web'");
		if (!empty($configInfo)){
			$info = unserialize($configInfo->value);
			$this->view->setVar("configInfo",$info);
		}
	}
	public function slideAction(){
		$slide = new Slide();
		$op = $this->request->get('op');
		if($this->request->getPost()){
			$data = $this->request->getPost();
			$slide->title = $data['title'];
			$slide->address = $data['address'];
			$slide->status = $data['status'];
			if($data['id']){
				$slide->id = $data['id'];
				$result= $slide->update();
			}else{
				$result = $slide->save();
			}
			if ($result) {
				$this->response->redirect( APP_ADMIN_PATH.'/config/slide/list' );
			}else{
				foreach ($slide->getMessages() as $message) {
					echo $message . '<br>';
				}die;
			}
		}
		if($op == 'edit'){
			if($this->request->get('id')) {
				$item = $slide->findFirst($this->request->get('id'));
			}
		}elseif($op == 'del'){
			$id = $this->request->get('id');
			$slide->id = $id;
			$result = $slide->delete();
			if(!$result){
				echo 'NO';
			}
			$this->response->redirect(APP_ADMIN_PATH.'/config/slide?op=list');
		}
		if(!$this->request->get('op')){
			$op ='list';
		}
		if(!$this->request->get('page')){
			$page = 1;
		}else{
			$page = $this->request->get('page');
		}
		$slidelist =  $slide->find();
		$paginator = new PaginatorModel(
			array(
				"data"	=> $slidelist,
				"limit"	=>5,
				"page" =>$page
			)
		);
		$page = $paginator->getPaginate();

		$this->view->setVar('slidelist',$page);
		$this->view->setVar('item', $item);
		$this->view->setVar('op',$op);
	}

	public function serviceAction(){
		$op = $this->request->get('op');
		if (empty($op)){
			$op = 'list';
		}
		$userServicr = UserService::find();
		if ($op == 'edit'){
			$id = $this->request->get('id');
			if (!empty($id)){
				$service = UserService::findFirst("id = $id");
				$this->view->setVar('item',$service);
			}
			$type = $this->request->get('type');
			$this->view->setVar('k',$type);
		}elseif ($op =='list'){
			if ($this->request->isPost()){
				$title = $this->request->getPost('title');
				$way = $this->request->getPost('way');
				$userInfo = new UserService();
				$userInfo->title = $title;
				$userInfo->way = $way;
				$userInfo->type = $this->request->getPost('type');
				if ($this->request->getPost('id')){
					$id = $this->request->getPost('id');
					$service = UserService::findFirst("id = $id");
					$service->title = $this->request->getPost('title');
					$service->way = $this->request->getPost('way');
					$service->type = $this->request->getPost('type');
					$upResult = $service->update();
					if ($upResult){echo "<script>alert('操作成功');</script>";}
					$this->response->redirect( APP_ADMIN_PATH.'/config/service?op=list' );
				}else{
					$result = $userInfo->save();
					if (!$result){
						foreach ($userInfo->getMessages() as $message){
							echo  $message;
						}die;
					}
				}
				$this->response->redirect( APP_ADMIN_PATH.'/config/service?op=list' );
			}
		} elseif ($op == 'del'){
			$id = trim($this->request->get('id'));
			if (!empty($id)){
				$userInfo = UserService::findFirst("id =$id");
				$result = $userInfo->delete();
				if ($result){
					$this->response->redirect( APP_ADMIN_PATH.'/config/service?op=list' );
				}
			}
		}
		if (!empty($userServicr)){
			$this->view->setVar('sList',$userServicr);
		}
		if ($op == 'del'){
			$op = 'list';
		}
		$this->view->setVar('show',$op);
	}
	public function sitMessageAction(){
		$op = $this->request->get('op');
		$type = $this->request->get('type');
		$keys =['jh','message'];
		if (empty($op)){
			$op = 'list';
		}

		if ($op == 'list'){
			if (USER_TYPE == 'duojin'){
				$message = Config::find("key = 'jh' OR key = 'message'");
			}else{
				$message = Config::find("key = 'message'");
			}
			if (!empty($message)){
				foreach ($message as $key=>$value){
					$data[] = unserialize($value->value);
				}
				$this->view->setVar('message',$data);
				$this->view->pick('config/messageList');
			}
		}elseif ($op =='edit'){
			$data = $this->request->getPost();
			if (empty($type)){
				$exit = Config::findFirst("key = 'message'");
				$info = unserialize($exit->value);
				if (empty($info)||empty($info['type'])){
					$type = 'message';
				}else{
					$type = 'jh';
				}
			}
			if ($type){
				if (!empty($data)){
					$config = Config::findFirst("key = '{$type}'");
					if (empty($config)){
						$this->message("操作失败");
					}
					$data = $this->request->getPost();
					if (!empty($config)){
						$config->value = serialize($data);
						$result = $config->update();
					}
					if ($result){
						echo ("<script>alert('操作成功');</script>");
						$this->response->redirect(APP_ADMIN_PATH."/Config/sitMessage");
					}else{
						exit("<script>alert('操作失败');window.location.href =window.location.href ;</script>");
					}
				}else{
					$sql = "SELECT * FROM dhc_config WHERE `key` = '{$type}'";
					$configInfo = $this->db->query($sql)->fetch();
					if (!empty($configInfo)){
						$messInfo = unserialize($configInfo['value']);
						$this->view->setVar('message',$messInfo);
					}

					$this->view->pick('config/sitMessage');
				}

			}else{
				$config = new Config();
				$config->key = 'message';
				$config->value = serialize($data);
				$result = $config->save();
				if ($result){
					exit("<script>alert('操作成功');history.go(-1);</script>");
				}else{
					exit("<script>alert('操作失败');window.location.href =window.location.href ;</script>");
				}
			}

			$this->view->setVar('type',$type);
			$this->view->pick('config/sitMessage');
		}

	}

	public function copyrightAction(){
		if ($this->request->isPost()){
			$data = $this->request->getPost();
			$config = new Config();
			$config->key = 'copyright';
			$config->value = serialize($data);
			$result = $config->save();
			if ($result){
				$this->message("操作成功");
			}else{
				$this->message("操作失败");
			}
		}
		$message = Config::findFirst("key = 'copyright'");
		if (!empty($message)){
			$data = unserialize($message->value);
			$this->view->setVar('copyright',$data);
		}
	}
	public function gameinfoAction(){
		if ($this->request->isPost()){
			$data = $this->request->getPost();
			$config = new Config();
			$config->key = 'game';
			$config->value = serialize($data);
			$result = $config->save();
			if ($result){
				$this->message("操作成功");
			}else{
				$this->message("操作失败");
			}
		}
		$message = Config::findFirst("key = 'game'");
		if (!empty($message)){
			$data = unserialize($message->value);
			$this->view->setVar('game',$data);
		}
	}

	public function userwithdrawAction(){
		$userwithdraw = Config::findFirst("key = 'withdraw'");
		if ($this->request->isPost()){
			$data = $this->request->getPost();
			if (!empty($userwithdraw)){
				$userwithdraw->value = serialize($data);
				$result = $userwithdraw->update();
				if (!empty($result)){
					$this->message('更新成功','','success');
				}
			}else{
				$userwithdraw = new  Config();
				$userwithdraw->key = 'withdraw';
				$userwithdraw->value = serialize($data);
				$result  = $userwithdraw->save();
				if (!empty($result)){
					$this->message('操作成功','','success');
				}
			}
		}
		if (!empty($userwithdraw)){
			$value = unserialize($userwithdraw->value);
			$this->view->setVar('withdraw',$value);
		}
	}

	public function groupsAction(){
		$data = $this->request->getPost();
		$images = Config::findFirst("key = 'images'");
		if (empty($data)){
			$value = unserialize($images->value);
			$this->view->setVar('item',$value);
		}else{
			if (empty($images)){
				$images = new Config();
				$images->key = 'images';
				$images->value = serialize($data);
				$result = $images->save();
			}else{
				$images->value = serialize($data);
				$result = $images->update();
			}
			if (empty($result)){
				$this->message('操作失败','','error');
			}else{
				$this->message('操作成功','','success');
			}
		}
	}
}

