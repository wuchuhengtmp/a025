<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


namespace Dhc\Models;

class OrchardLand extends BaseModel{
	public function initialize(){
		$this->setSource("dhc_orchard_land");
	}
	public function getLandInfo(){
		return array(
			""=>"全部土地",
			"0"=>"一号土地",
			"1"=>"二号土地",
			"2"=>"三号土地",
			"3"=>"四号土地",
			"4"=>"五号土地",
			"5"=>"六号土地",
			"6"=>"七号土地",
			"7"=>"八号土地",
			"8"=>"九号土地",
			"9"=>"十号土地",
			"10"=>"十一号土地",
			"11"=>"十二号土地"
		);
	}
	public function getLandStatus(){
		return array(
			"0"=>"全部",
			"1"=>"种子期",
			"2"=>"发芽期",
			"3"=>"成长期",
			"4"=>"成熟期",
			"5"=>"枯萎期",
			"9"=>"空白期"
		);
	}
}
