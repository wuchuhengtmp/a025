<?php

namespace Dhc\Modules\Frontend\Controllers;

use Dhc\Component\VerifyImage;
use function Dhc\Func\Common\object2array;
use Dhc\Models\User;
use Dhc\Models\Article;
class IndexController extends ControllerBase
{

	public function indexAction() {
		if($_SERVER["HTTP_HOST"] === "www.duojinnc.com" || $_SERVER["HTTP_HOST"] === "www.duojinfarm.com"){
			header("Location:../farm/");
		}else{
			header("Location:../farm/");
		}
		$this->view->disable();

	}

	public function infoAction() {
		$this->view->disable();
		$verify = new VerifyImage();
		$verify->entry(1);
	}

    public function noticelistAction()
    {
        $articleList = Article::find(
            [
                'conditions' => "cid=3",
                'limit' => 10,
                'order' => 'updateTime DESC'
            ]
        );
        $this->view->setVar('articleList',$articleList);
        $this->view->pick('index/noticelist');
    }
    public function gonglueAction()
    {
        $articleList = Article::find(
            [
                'conditions' => "cid=4",
                'limit' => 10,
                'order' => 'updateTime DESC'
            ]
        );
        $this->view->setVar('articleList',$articleList);
        $this->view->pick('index/noticelist');
    }
	public function notFoundAction() {
		$router = $this->di->get("router");
		echo "你要寻找的页面不存在！<br>";
		echo "链接：" . $this->request->getURI() . "<br>";
		echo "模块：" . $router->getModuleName() . "<br>";
		echo "控制器：" . $router->getControllerName() . "<br>";
		echo "方法：" . $router->getActionName() . "<br>";
		$this->view->disable();
	}
}
