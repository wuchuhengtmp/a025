<?php
namespace Dhc\Modules\Backend\Controllers;
use Dhc\Library\Distribution;
use Dhc\Models\Config;
use Dhc\Models\DistributionList;
use Dhc\Models\UserProduct;
use Dhc\Models\User;
use Phalcon\Exception;

class TestController extends ControllerBase
{
	protected function initialize() {
		$this->view->disable();
	}

	/**
	 * 测试方法 测试专用
	 */
	public function disAction() {
		try{
			$dis = new Distribution(11, 100, 1);
			$flag = $dis->start();
			var_dump($flag);
		}catch (Exception $e){
			echo $e->getFile() . ' on line ' . $e->getLine() . ':' . $e->getMessage();
		}
	}

	/**
	 * 测试findFirst
	 */
	public function firstAction() {
		$product = new UserProduct();
		$product = $product->findFirst("uid=29 AND sid='80004'");
		echo $product->number;
	}

	public function configAction() {
		$config = new Config();
		$flag = $config->set(1, 3);
		var_dump($flag);
		$this->getSqlError($flag, $config);
	}
	private $data = [];
	private $relation = '';
	public function fixedAction() {
		$list = User::find(['columns' => 'id, superior'])->toArray();
		foreach($list as $key=>$user){
			$this->data[$user['id']] = $user;
			$superior = explode('-', $user['superior']);
			$this->data[$user['id']]['pid'] = $superior[0];
			unset($list[$key]);
		}
		foreach($this->data as $key=>$val){
			$this->relation = '';
			$this->data[$key]['relation'] = $this->getRelation($val['id']);
			if($this->data[$key]['relation'] != $this->data[$key]['superior']){
				print_r($this->data[$key]);
			}
		}
	}
	
	private function getRelation($uid) {
		$user = $this->getUser($uid);
		$pid = $user['pid'];
		if($pid != 0){
			if(!$this->getUser($pid)){
				echo "用户{$uid}的上级{$pid}不存在";
				$this->relation .= '0';
				return $this->relation;
			}else{
				$this->relation .= $pid . '-';
				return $this->getRelation($pid);
			}
		}else{
			$this->relation .= '0';
			return $this->relation;
		}
	}
	
	private function getUser($uid) {
		if (!isset($this->data[$uid])) {
			return false;
		}
		return $this->data[$uid];
	}
}
