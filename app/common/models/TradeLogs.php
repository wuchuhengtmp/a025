<?php
namespace Dhc\Models;

class TradeLogs extends BaseModel
{
	public function initialize() {
		$this->setSource("dhc_trade_logs");
	}
}
