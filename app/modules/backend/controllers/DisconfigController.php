<?php
namespace Dhc\Modules\Backend\Controllers;

use Dhc\Models\Config;

class DisConfigController extends ControllerBase
{
	public function indexAction() {
		$config = new Config;
		$this->view->setVar('yansheng', USER_TYPE);
		if ($this->request->isPost()) {
			$data = $this->request->getPost('rebate');
			$flag = $config->set("rebate", json_encode($data));
			$channel_billing_type = $this->request->getPost('types');
			$flag1 = $this->channelBilling($channel_billing_type);
			if ($flag == false||$flag1 == false) {
				return $this->message("提交失败，请重试！", "referer", "info");
			} else {
				return $this->message("提交成功！", "referer", "success");
			}
		}
		$rebate = $config->get("rebate");
		if (!empty($rebate)) {
			$rebate = json_decode($rebate, true);
			$this->view->setVar('rebate', $rebate);
		}
		$channel_billing_type = $config->get('channel_billing_type');
		if (!empty($channel_billing_type)){
			$channel_billing_type = json_decode($channel_billing_type,true);
			$this->view->setVar('channel_billing_type',$channel_billing_type);
		}
	}
	public function channelBilling($channel_billing_type){
		$config = new  Config();
		$config->key = 'channel_billing_type';
		$config->value = $channel_billing_type;
		return $config->save();
	}
}
