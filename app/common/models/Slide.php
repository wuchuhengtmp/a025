<?php
namespace Dhc\Models;

class Slide extends BaseModel
{
	public $id;

	public function initialize()
	{
		$this->setSource("dhc_config_slide");
	}
}
