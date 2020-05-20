<?php
namespace Dhc\Models;

class UserProduct extends BaseModel
{
	public $id;

	public function initialize()
	{
		$this->setSource("dhc_user_product");
	}
}
