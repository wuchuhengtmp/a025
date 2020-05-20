<?php
namespace Dhc\Models;

class UserGold extends BaseModel
{
	public function initialize() {
		$this->setSource("dhc_user_gold");
	}
}
