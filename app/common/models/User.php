<?php
namespace Dhc\Models;

class User extends BaseModel
{
	public function initialize() {
		$this->setSource("dhc_user");
	}
}
