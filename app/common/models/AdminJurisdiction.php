<?php
namespace Dhc\Models;

class AdminJurisdiction extends BaseModel
{
	public $id;

	public function initialize()
	{
		$this->setSource("dhc_admin_jurisdiction");
	}
}
