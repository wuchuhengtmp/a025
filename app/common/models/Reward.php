<?php
namespace Dhc\Models;

class Reward extends BaseModel
{

	public function initialize()
	{
		$this->setSource("dhc_raiders_reward");
	}
}
