<?php
namespace Dhc\Modules\Backend\Controllers;
use Dhc\Models\Admin;
use Dhc\Models\Article;
use Phalcon\Http\Response;

class IndexController extends ControllerBase
{

	public function indexAction() {
		$app_admin_path = APP_ADMIN_PATH;
		$this->view->setVar('apppath',$app_admin_path);
		$this->view->pick('index/login');
	}
	public function loginAction(){
		if ($this->cookies->get('user')){
			$this->view->setVar('user',$this->cookies->get('user'));
		}
		$this->view->pick('index/login');

	}
	public function noticelistAction()
    {
        $this->view->pick('index/noticelist');
    }
	public function  noticeAction(){
		$article = new Article();
		$result = $article->find(15);
		foreach ($result as $v){
			$content = $v->content;
		}
		$response = new Response();
		if($result === false){
			$response->setJsonContent(
				[
					"status"=>"NOT-FOUND"
				]
			);
		}else{
			$response->setJsonContent(
				[
					"status" => "FOUND",
					"data"	=>[
						"content"	=>$content
					]
				]
			);
		}
		return $response;
	}
	//验证登录
	public function authAction(){
		if ($this->request->getPost()){
			$user = trim($this->request->getPost('username'));
			$password = trim($this->request->getPost('password'));
			if (empty($user||empty($password))){
				exit("<script>alert('帐号或者密码错误');window.location.href='".APP_ADMIN_PATH."/index/login'</script>");
			}
			$user = Admin::findFirst("user = '$user'");
			if (!$user){
				exit("<script>alert('用户不存在');window.location.href='".APP_ADMIN_PATH."/index/login'</script>");
			}
			if ($user->status !== '1'){
				exit("<script>alert('账户异常或已被管理员禁用，请联系管理员');window.location.href='".APP_ADMIN_PATH."/index/login'</script>");
			}
			if ($user->password !== md5($user->salt.$password)){
				exit("<script>alert('密码错误');window.location.href='".APP_ADMIN_PATH."/index/login'</script>");
			}
			$this->session->set('operate',$user->id);
			$this->session->set('role',$user->role);
			$this->view->setVar('login','login');
			$remember = $this->request->getPost('remember');
			if ($remember ==='1'){//如果用户登录的时候选择了保存帐号信息
				$this->cookies->set('user',$user);
			}
			exit("<script>alert('欢迎');window.location.href='".APP_ADMIN_PATH."/article/article?op=list'</script>");
		}
		exit("<script>alert('未登录');window.location.href='".APP_ADMIN_PATH."/index/login'</script>");
//		$this->view->setVar('login','login');
	}
	//退出登录
	public function outAction(){
		$result = $this->session->destroy();
		if ($result){
			exit("<script>alert('退出成功');window.location.href='".APP_ADMIN_PATH."/index/login'</script>");
		}
	}
}

