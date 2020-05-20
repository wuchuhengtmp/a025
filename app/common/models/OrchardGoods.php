<?php

namespace Dhc\Models;

class OrchardGoods extends BaseModel{
	public function initialize(){
		$this->setSource("dhc_orchard_goods");
	}
}