<?php
namespace Dhc\Models;

class WithdrawAddress extends BaseModel
{
	public function initialize() {
		$this->setSource("dhc_withdraw_address");
	}
}
