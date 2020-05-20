<?php
namespace Dhc\Models;

class Dailydate extends BaseModel
{
   public function initialize()
   {
   	$this->setSource('dhc_trade_dailydate');
   }
}
