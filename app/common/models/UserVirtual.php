<?php
namespace Dhc\Models;

class UserVirtual extends BaseModel
{
	public function initialize() {
		$this->setSource("dhc_virtual_withdraw");
	}
}
