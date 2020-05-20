<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


namespace Dhc\Models;

class OrchardDog extends BaseModel{
	public function initialize(){
		$this->setSource("dhc_orchard_dog");
	}
}