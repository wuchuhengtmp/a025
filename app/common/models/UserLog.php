<?php
namespace Dhc\Models;

class UserLog extends BaseModel
{
	public function initialize() {
		$this->setSource("dhc_user_log");
	}
}
