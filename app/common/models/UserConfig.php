<?php
namespace Dhc\Models;

class UserConfig extends BaseModel
{
	public function initialize() {
		$this->setSource("dhc_user_config");
	}
}
