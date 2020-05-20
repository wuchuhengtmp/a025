<?php
namespace Dhc\Models;

class Product extends BaseModel
{
	public function initialize()
	{
		$this->setSource("dhc_trade_product");
	}
}
