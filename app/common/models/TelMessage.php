<?php
namespace Dhc\Models;

class TelMessage extends BaseModel
{

	public function initialize()
	{
		$this->setSource("dhc_user_message");
	}
}
