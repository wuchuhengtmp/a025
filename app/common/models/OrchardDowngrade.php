<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2017/10/27
 * Time: 10:43
 */
namespace Dhc\Models;

class OrchardDowngrade extends BaseModel{
	public function initialize(){
		$this->setSource("dhc_orchard_downgrade");
	}
}
