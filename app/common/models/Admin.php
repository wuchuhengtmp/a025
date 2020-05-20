<?php
namespace Dhc\Models;

class Admin extends BaseModel
{
	public $id;

	public function initialize()
	{
		$this->setSource("dhc_admin");
	}
}
