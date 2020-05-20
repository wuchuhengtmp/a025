<?php
namespace Dhc\Models;

class Order extends BaseModel
{
	public function initialize()
	{
		$this->setSource("dhc_trade_order");
	}
}
