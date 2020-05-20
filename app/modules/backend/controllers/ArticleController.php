<?php
namespace Dhc\Modules\Backend\Controllers;
use Dhc\Models\Raiders;
use Phalcon\Paginator\Adapter\Model as PaginatorModel;
use Dhc\Models\Article;
use Dhc\Models\Category;

class ArticleController extends ControllerBase{
	public function categoryAction(){
		//获取操作
		if($this->request->get()){
			$category = new Category();
			$pre = $category->find();
			$this->view->setVar('preid',$pre);
			$op  =$this->request->get('op');
			if(empty($this->request->get('op'))){
				$this->view->setVar('show','list');
			}
			if($op == 'list'){
				if ($this->request->getPost()){
					$data = $this->request->getpost();
					$category->pid			=	$data['pid'];
					$category->title		=	$data['title'];
					$category->remark		=	$data['remark'];
					$category->createtime  	= 	TIMESTAMP;
					$category->thumb		=	$data['thumb'];
					$category->icon			=	$data['icon'];
					if($data['id']){
						$category->id = $data['id'];
						$result = $category->save();
					}else{
						$result = $category->save();
					}
					if(!$result){
						foreach ($category->getMessages() as $message){
							echo $message.'<br>';
						}
						die;
					}
					if ($result) {
						$this->response->redirect( APP_ADMIN_PATH.'/article/category/list' );
					}
				}
				$this->view->setVar('show',$op);
			}elseif ($op == 'edit'){
				if($this->request->get('id')){
					$id = $this->request->get('id');
					$item = $category->findFirst($id);
					$this->view->setVar('item',$item);
				}
				$this->view->setVar('show',$op);
			}elseif ($op == 'del'){
				$id = $this->request->get('id');
				$category->id  =$id;
				$result = $category->delete();
				if($result){
					$this->response->redirect(APP_ADMIN_PATH.'/article/category/list');
				}
			}elseif ($op == 'add'){
				$this->view->setVar('show','edit');
			}
			if(!empty($this->request->get('page'))){
				$page = $this->request->get('page');
			}else{
				$page = 1;
			}
			$categoryList = Category::find();
			$paginator = new PaginatorModel(
				array(
					"data"	=> $categoryList,
					"limit"	=>20,
					"page" =>$page
				)
			);
			$page = $paginator->getPaginate();
			$this->view->setVar('categoryList',$page);
		}
		$this->view->pick('article/category');

	}
	public function articleAction()
	{
		$article = new Article();
		$articleList = $article->find();
		$totalnum = count($articleList);
		$totalpage = ceil($totalnum/5);
		$category = new Category();
		$pre = $category->find('id');
		$this->view->setVar('preid',$pre);
		$this->view->setVar('tpage',$totalpage);
		$this->view->setVar('articleList',$articleList);
		$op = $this->request->get('_url');
		$op = explode('/',$op);
		if($op[4] != 'page'){
			$page = 1;
			$articleList = Article::find(
				[
					'order'=>'createTime DESC'
				]
			);
			$paginator = new PaginatorModel(
				array(
					"data"	=> $articleList,
					"limit"	=>20,
					"page" =>$page
				)
			);
			$page = $paginator->getPaginate();
			$pagelist = $page->items;
			$this->view->setVar('show','list');
			$this->view->setVar('articleList',$pagelist);
		}
		if(empty($op[4])){
			$op[4] = 'page';
			$op[5] = 1;
		}
		if($op[4]){
			if ($op[4] == 'edit') {
				//编辑操作
				if($op[5]){
					$id = $op[5];
					$item =$article ->findFirst($id);
					$this->view->setVar('item',$item);
				}
				$this->view->setVar('show', 'edit');
			} elseif ($op[4] == 'list') {
				//列表显示
				if($this->request->getpost()){
					$this->view->setVar('pagenow',1);
					$data = $this->request->getpost();
					if (empty($data['description'])){
						exit("<script>alert('请添加简述');history.go(-1);</script>");
					}
					if (empty($data['from'])){
						exit("<script>alert('请添加来源信息');history.go(-1);</script>");
					}
					if (empty($data['content'])){
						exit("<script>alert('请添加内容');history.go(-1);</script>");
					}
					if (empty($data['title'])){
						exit("<script>alert('请添加标题');history.go(-1);</script>");
					}
					$article->cid			=	$data['cid'];
					$article->title			=	$data['title'];
					$article->from			=	$data['from'] ;
					$article->thumb			=	$data['thumb'];
					$article->description	=	$data['description'];
					$article->content		=	$data['content'];
					if($data['id']){
						//更新
						$article->id = $data['id'];
						$uparticel  = new Article();
						$uparticel = $uparticel->findFirst($article->id);
						$data = $this->request->getpost();
						$uparticel->cid			=	$data['cid'];
						$uparticel->title			=	$data['title'];
						$uparticel->from			=	$data['from'] ;
						$uparticel->thumb			=	$data['thumb'];
						$uparticel->description	=	$data['description'];
						$uparticel->content		=	$data['content'];
						$uparticel->updateTime = TIMESTAMP;
						$result = $uparticel->update();
					}else{
						$article->createTime 	= 	TIMESTAMP;
						$article->updateTime	=	TIMESTAMP;
						$result	= $article->save();
					}
					if(!$result){
						foreach ($article->getMessages() as $message){
							echo $message.'<br>';
						}
						die;
					}else{
						$this->response->redirect( APP_ADMIN_PATH.'/article/article/list' );
					}

				}
				$this->view->setVar('show', 'list');
			} elseif ($op[4] == 'del') {
				//删除
				$id = $op[5];
				$category = Article::findFirst("id = '{$id}'");
				$res = $category->delete();
				if ($res) {
					$this->response->redirect( APP_ADMIN_PATH.'/article/article/list' );
				}
				$this->view->setVar('show','list');
			}elseif ($op[4] == 'add'){
				//添加
				$this->view->setVar('show','edit');
			}elseif($op[4] == 'page'){
				//分页
				if($op[5]<1){
					$op[5] = 1;
				}elseif ($op[5]>$totalpage){
					$op[5]=$totalpage;
				}
				$this ->view->setVar('pagenow',$op[5]);
				$page = $op[5];
				$articleList = Article::find(['order'=>'createTime DESC']);
				$paginator = new PaginatorModel(
					array(
						"data"	=> $articleList,
						"limit"	=>20,
						"page" =>$page
					)
				);
				$page = $paginator->getPaginate();
				$pagelist = $page->items;
				$this->view->setVar('show','list');
				$this->view->setVar('pages',$page);
				$this->view->setVar('articleList',$pagelist);
			}
		}else{
			$this->view->setVar('show','list');
		}
		$this->view->pick('article/article');
	}
	public function raidersAction(){
		$op = $this->request->get('op');
		$page = $this->request->get('page');
		if (empty($op)){$op ='list';}
		if (empty($page)){$page = 1;}
		$raider = new Raiders();
		$wraider = $raider->find(
			array(
				'conditions' => 'status = 0 or status = -1 ORDER BY createtime DESC'
			)
		);
		$paginator = new PaginatorModel(
			array(
				"data"	=> $wraider,
				"limit"	=>20,
				"page" =>$page
			)
		);
		$pages = $paginator->getPaginate();
		$this->view->setVar('wlist',$pages);
		if ($op){
			if ($op == 'list'){
				if ($this->request->isPost()){
					if ($this->request->get('id')){
						$id = $this->request->getPost('id');
						$raider = new Raiders();
						$raiderone = $raider->findFirst($id);
						$reason = $this->request->getPost('reason');
						$status = $this->request->getPost('status');
						$raiderone->reason = $reason;
						$raiderone->status = $status;
						$raiderone->operator = $this->session->get('uid');
						$result =$raiderone->update();
						if ($result){
							echo "<script>alert('更新成功');</script>";
							$this->response->redirect(APP_ADMIN_PATH."/article/raiders");
						}
					}
				}
			}elseif($op == 'del'){
				$id = $this->request->get('id');
				if (!empty($id)){
					$raider =  Raiders::findFirst("id = $id");
					$result = $raider->delete();
					if ($result){
						echo "<script>alert('删除成功');</script>";
						$this->response->redirect(APP_ADMIN_PATH."/article/raiders");
					}
				}
			}elseif($op == 'edit'){
				$id =$this->request->get('id');
				$raider = new Raiders();
				$item = $raider->findFirst($id);
				$this->view->setVar('item',$item);
			}
		}
		$raiders = new Raiders();
		$raiderslist = $raiders->find("status=1 order by createtime desc");
		$paginator = new PaginatorModel(
			array(
				"data"	=> $raiderslist,
				"limit"	=>20,
				"page" =>$page
			)
		);
		$page = $paginator->getPaginate();
//		echo '<pre>';
//		var_dump($page);die;
		$this->view->setVar('rlist',$page);
		$this->view->setVar('show',$op);
		$this->view->pick('article/raiders');
	}
}
