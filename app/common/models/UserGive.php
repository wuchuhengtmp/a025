<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2017/4/6
 * Time: 18:26
 */
namespace Dhc\Models;

class UserGive extends BaseModel{

	public function initialize(){
		$this->setSource("dhc_user_give");
	}
}
