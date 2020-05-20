<?php
namespace Dhc\Models;

class UserService extends BaseModel
{
	public function initialize() {
		$this->setSource("dhc_user_service");
	}
}
