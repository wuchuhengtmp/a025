<?php
namespace Dhc\Modules\Backend\Controllers;

use Dhc\Models\Admin;
use Dhc\Models\AdminJurisdiction;

//权限
class JurisdictionController extends ControllerBase{

	public function listAction(){
//		$actionName = $this->dispatcher->getActionName();
//		var_dump($actionName);die;
		$userList = Admin::find();
		$this->view->setVar('userList',$userList);
		$this->view->pick('jurisdiction/list');
		$this->view->setVar('show','list');
	}
	public function addAction(){
		if ($this->request->isPost()){
			$username = trim($this->request->getPost('username'));
			$salt = $this->create_salt(6);
			$isPassword = trim($this->request->getPost('password'));
			$status = $this->request->getPost('status');
			$role = $this->request->getPost('role');
			if ($role<=$this->session->get('role')){
				exit("<script>alert('不能添加大于自己权限的用户'); window.location.href=window.location.href</script>");
			}
			if (!empty($username)){
				$userInfo =Admin::findFirst("user = '$username'");
				if ($userInfo){
					exit("<script>alert('用户已存在'); window.location.href=window.location.href</script>");
				}
				$user = new Admin();
				$user->user = $username;
				$user->salt = $salt;
				$user->password = md5($salt.$isPassword);
				$user->status = $status;
				$user->createtime = TIMESTAMP;
				$user->role = $role;
				$user->jurisdiction = AdminJurisdiction::findFirst(
					array(
						'conditions'=>"role = $role",
						'columns'	=>'jurisdiction'
					)
				)->jurisdiction;
				$result = $user->save();
				if (!$result){
					foreach ($user->getMessages() as $message){
						echo $message.'<br>';
					}die;
				}
				if ($result){
					exit("<script>alert('添加成功'); window.location.href='".APP_ADMIN_PATH."/jurisdiction/list'</script>");
				}else{
					exit("<script>alert('添加失败'); window.location.href = window.location.href</script>");
				}
			}
		}
		$this->view->setVar('show','add');
		$this->view->pick('jurisdiction/add');
	}
	public function updateAction(){
		$jurisdictionList = $this->getResouce();
		$this->view->setVar('jList',$jurisdictionList);
		if (!empty($this->request->get('id'))){
			$id = trim($this->request->get('id'));
			$pid =$this->session->get('operate');
			if ($id < $pid){
				exit("<script>alert('不能操作权限大于自己的用户'); window.location.href='".APP_ADMIN_PATH."/jurisdiction/list'</script>");
			}
			$userInfo = Admin::findFirst("id = $id");
			if (!$userInfo){exit("<script>alert('用户不存在'); window.location.href='".APP_ADMIN_PATH."/jurisdiction/list'</script>");}
			$jurisdictions = $userInfo->jurisdiction;
			$jurisdictions = explode('-',$jurisdictions);
			$this->view->setVar('juriList',$jurisdictions);
			$this->view->setVar('item',$userInfo);
			$this->view->setVar('show','update');
		}
		if ($this->request->isPost()){
			$id = $this->request->getPost('id');
			$role = $this->request->getPost('role');
			$status = $this->request->getPost('status');
			$article = $this->request->getPost('article');
			$config = $this->request->getPost('config');
			$jurisdiction = $this->request->getPost('jurisdiction');
			$product = $this->request->getPost('product');
			$orchard = $this->request->getPost('orchard');
			$user= $this->request->getPost('user');
			$warehouse= $this->request->getPost('warehouse');
			$userwithdraw = $this->request->getPost('userwithdraw');
			$spread = $this->request->getPost('spread');
			$core = $this->request->getPost('core');
			$admin = Admin::findFirst("id = $id");
			if (!$admin){
				exit("<script>alert('用户不存在'); window.location.href='".APP_ADMIN_PATH."/jurisdiction/list'</script>");
			}
			if (!empty($this->request->getPost('rPassword'))){
				$salt  = $admin->salt;
				$rPassword = $this->request->getPost('rPassword');
				$admin->role = $role;
				$admin->password = md5($salt.$rPassword);
			}
			$admin->status = $status;
			$admin->jurisdiction = $article.'-'.$config.'-'.$jurisdiction.'-'.$product.'-'.$orchard.'-'.$user.'-'.$warehouse.'-'.$userwithdraw.'-'.$spread.'-'.$core;
			$result = $admin->update();
			if ($result){
				exit("<script>alert('更新成功'); window.location.href='".APP_ADMIN_PATH."/jurisdiction/list'</script>");
			}else{
				exit("<script>alert('更新失败'); window.location.href='".APP_ADMIN_PATH."/jurisdiction/list'</script>");
			}
		}
	}
	public function deleteAction(){
		if ($this->request->isGet()){
			$id =$this->request->get('id');
			$pid =$this->session->get('operate');
			if ($id < $pid){
				exit("<script>alert('不能操作权限大于自己的用户'); window.location.href='".APP_ADMIN_PATH."/jurisdiction/list'</script>");
			}
			$admin = Admin::findFirst("id= $id");
			$result = $admin->delete();
			if ($result){
				exit("<script>alert('删除成功'); window.location.href='".APP_ADMIN_PATH."/jurisdiction/list'</script>");
			}else{
				exit("<script>alert('删除失败'); window.location.href='".APP_ADMIN_PATH."/jurisdiction/list'</script>");
			}
		}
	}
}
