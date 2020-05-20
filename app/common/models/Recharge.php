<?php
namespace Dhc\Models;

class Recharge extends BaseModel
{
	public function initialize() {
		$this->setSource("dhc_user_recharge");
	}
}
