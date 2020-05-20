<?php
namespace Dhc\Modules\Game\Controllers;
class IndexController extends ControllerBase
{

	/**
	 * 分发控制器管理
	 * eq:?c=auth&a=login
	 */
	public function indexAction() {
		$controller = $this->request->get("c", "string");
		$action = $this->request->get("a", "string");
		if ($controller == "index" && $action == "index") {
			echo "OK";
			exit;
		}

		$this->dispatcher->forward(array(
			'module' => 'game',
			'controller' => $controller,
			'action' => $action
		));
	}
}
