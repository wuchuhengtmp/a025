<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2017/6/3
 * Time: 9:30
 */
namespace Dhc\Models;
//后台种子操作日志
class OperatorLog extends BaseModel
{

	public function initialize()
	{
		$this->setSource("dhc_operator_log");
	}
}
