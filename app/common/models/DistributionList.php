<?php
namespace Dhc\Models;
class DistributionList extends BaseModel
{
	public $uid;
	public $cUid;
	public $gold;
	public $type;
	public $effectTime;
	public $createTime;
	public $rebate;
	public $amount;
	public $disType;
	public $level;
	public $status;
	public $updateTime;
	public $log;

	public function initialize() {
		$this->setSource("dhc_distribution_list");
	}
}
