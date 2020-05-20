<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


namespace Dhc\Models;

class OrchardOrder extends BaseModel{
	public function initialize(){
		$this->setSource("dhc_orchard_order");
	}
	public function getOrderType(){
		return array(
			"seed"=>"种子",
			"other"=>"其他"
		);
	}
}