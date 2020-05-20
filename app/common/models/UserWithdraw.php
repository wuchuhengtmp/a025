<?php
namespace Dhc\Models;

class UserWithdraw extends BaseModel
{
	public function initialize() {
		$this->setSource("dhc_user_withdraw");
	}
}
