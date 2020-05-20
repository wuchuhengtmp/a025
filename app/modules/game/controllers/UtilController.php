<?php
namespace Dhc\Modules\Game\Controllers;
use Dhc\Component\VerifyImage;
class UtilController extends ControllerBase{
	public function getVerifyAction(){
		$verify = new VerifyImage();
		$verify->entry();
	}
	public function checkVerify($code){
		$verify = new VerifyImage();
		return $verify->check($code);
	}
	public function getAppSsidAction(){
		$di = $this->getDI();
		$data= array("ssid"=>$di->get("session")->getId());
		$this->ajaxResponse($data, "ssid返回!", 0);
	}
}


