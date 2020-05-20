<?php

namespace Dhc\Library;

use function Dhc\Func\Common\error;
use function Dhc\Func\Common\is_error;
use Dhc\Models\Config;
use Dhc\Models\DistributionList;
use Dhc\Models\TradeLogs;
use Dhc\Models\User;
use Phalcon\Di\Injectable;
use Phalcon\Exception;

class Distribution extends Injectable
{
	private $uid;
	private $gold;
	private $type;
	private $user;
	private $rebate; // 配置文件分销佣金比例
	private $channelRebate; // 个人渠道佣金比例
	private $channelBillingType; // 渠道结算类型 0是下个月初 1是立即
	private $salesmanRebate; // 个人业务员佣金比例
	private $relation;
	private $typeArr = ["兑换钻石" => 1, "大盘手续费" => 2]; // 返佣类型
	private $log;
	private $hasChannel = false; // 是否已经存在渠道
	private $twoHasChannel = 3; // 是否已经存在渠道
	private $channelRebate2 =1; //渠道比例初始化
	//private $hostName = "yansheng";//修改此参数控制 用户平台渠道分销层级变化

	public function __construct($uid, $gold, $type, $log = '未定义') {
		$uid = intval($uid);
		if (empty($uid)) {
			throw new Exception("用户UID不能为空");
		}
		$gold = sprintf("%.5f", $gold);
		if (empty($gold) || $gold <= 0) {
			throw new Exception("金额不能为空");
		}
		if (empty($type) || !in_array($type, $this->typeArr)) {
			throw new Exception("类型不能为空或不存在");
		}
		$this->uid = $uid;
		$this->gold = $gold;
		$this->type = $type;
		$this->log = $log;

		$this->user = $this->getUser($uid);

		$this->relation = explode("-", $this->user->superior);
		if (!is_array($this->relation)) {
			throw new Exception("上下级关系不正常");
		}

		$config = new Config();
		$this->rebate = json_decode($config->get("rebate"), true);
		$channelBillingType = $config::findFirst('key = "channel_billing_type"');
		$this->channelBillingType = in_array($channelBillingType->value, [0, 1]) ?  $channelBillingType->value : 0;
		if (empty($this->rebate)) {
			throw new Exception("管理员尚未配置比例");
		}
	}

	/**
	 * @return bool
	 * @throws Exception
	 */
	public function start() {
		$this->db->begin();
		foreach ($this->relation as $key => $uid) {
			if ($uid == 0) {
				break;
			}
			$level = $key + 1;
			$flagA = $flagB = true;
			// 判断用户是否是业务员，限制返佣级别为2
			if ($level <= 2) {
				if ($this->isSalesMan($uid, $level)) {
					$rebate = $this->salesmanRebate;
					$flagA = $this->addRecord($uid, $level, $rebate, 'common');
				} else if (isset($this->rebate[$this->type]['common'][$level])) {
					$rebate = $this->rebate[$this->type]['common'][$level];
					$flagA = $this->addRecord($uid, $level, $rebate, 'common');
				}
			}
			if (is_error($flagA)) {
				$this->db->rollback();
				throw new Exception($flagA['message']);
			}

			if ($this->isChannel($uid)) {
				if(USER_TYPE == "yansheng"){
					$this->twoHasChannel --;
				}else{
					$this->twoHasChannel = false;
				}
				$channelRebate = $this->channelRebate;
				$flagB = $this->addRecord($uid, $level, $channelRebate, 'channel');
			}
			if (is_error($flagB)) {
				$this->db->rollback();
				throw new Exception($flagB['message']);
			}
		}
		$this->db->commit();
		return true;
	}

	/**
	 * 增加返佣记录
	 * @param int $uid
	 * @param int $level
	 * @param float $rebate
	 * @param string $disType
	 * @return array|bool
	 */
	public function addRecord($uid, $level, $rebate, $disType = 'common') {
		if (empty($uid)) {
			return error(1, "上级uid不能为空");
		}
		if (empty($rebate)) {
			return error(1, "分销比例不存在");
		}

		$distribution = new DistributionList();
		$distribution->uid = $uid;
		$distribution->cUid = $this->uid;
		$distribution->level = $level;
		$distribution->gold = $this->gold;
		$distribution->type = $this->type;
		$distribution->disType = $disType;
		$distribution->rebate = $rebate;
		$distribution->amount = $rebate * $this->gold * 0.01;
		if(USER_TYPE == "yansheng" && $disType == "channel"){
			if($this->twoHasChannel ==2){
				$this->channelRebate2 = $distribution->amount;
			}else{
				$distribution->rebate = $this->rebate[3]['common'][$this->twoHasChannel];
				$distribution->amount = $this->channelRebate2 * $distribution->rebate * 0.01;
			}
		}
		$distribution->createTime = TIMESTAMP;
		$distribution->log = $this->log;
		if ($disType == 'common') {
			$distribution->effectTime = TIMESTAMP;
			$distribution->updateTime = TIMESTAMP;
			$distribution->status = 1;
		} elseif ($disType == 'channel') {
			if($this->channelBillingType == 1){
				$distribution->effectTime = TIMESTAMP;
				$distribution->updateTime = TIMESTAMP;
				$distribution->status = 1;
			}else{
				$monthFirstDay = strtotime(date('Y-m-01 00:00:01', time()));
				$distribution->effectTime = strtotime(date('Y-m-d H:i:s', strtotime('next month', $monthFirstDay))); // 下个月1号凌晨生效
				$distribution->updateTime = 0;
				$distribution->status = 0;
			}
		} else {
			return error(1, "推广类型不存在【{$disType}】");
		}
		$flag = $distribution->save();
		if ($flag == false) {
			return error(1, "分佣记录保存失败");
		} else {
			if ($distribution->status == 1) {
				$this->addGold($uid, $distribution->amount, $disType);
			}
			return true;
		}
	}

	/**
	 * 是否是渠道代理 并获取渠道代理返佣比例
	 * @param $uid
	 * @return bool
	 */
	public function isChannel($uid) {
		// 只能出现一个渠道代理
		if ($this->hasChannel && $this->twoHasChannel == false) {
			$this->channelRebate = 0;
			return false;
		}
		$user = $this->getUser($uid, false);
		if (!empty($user) && $user->channelRebate > 0) {
			$this->hasChannel = true;
			$this->channelRebate = $user->channelRebate;
			return true;
		} else {
			$this->channelRebate = 0;
			return false;
		}
	}

	/**
	 * 增加用户金币
	 * @param $uid
	 * @param $amount
	 * @throws Exception
	 */
	private function addGold($uid, $amount, $disType) {
		$user = $this->getUser($uid, false);
		if ($user) {
			$user->coing += $amount;
			if ($user->save() == false) {
				throw new Exception("金币操作失败【{$uid}】");
			} else {
				if ($disType == 'common') {
					$type = '业务员';
				} elseif ($disType == 'channel') {
					$type = '渠道代理';
				}
				$this->saveTradeLogs(['uid' => $uid, 'num' => $amount, 'log' => $type . '下级返佣金币增加' . $amount, 'type' => 'addcoing']);
			}
		}
	}

	/**
	 * 保存日志
	 */

	public function saveTradeLogs($data = array()) {
		$logs = new TradeLogs();
		$logs->uid = $data["uid"];
		$logs->mobile = $this->getMoblie($data["uid"]);
		$logs->num = $data["num"];
		$logs->logs = $data["log"];
		$logs->type = $data["type"];
		$logs->createtime = TIMESTAMP;
		$logs->status = 1;
		$result = $logs->save();
		return $result;
	}

	public function getMoblie($uid) {
		$userinfo = User::findFirst("id = $uid");
		if ($userinfo) {
			$mobile = $userinfo->user;
		} else {
			$mobile = '';
		}
		return $mobile;
	}

	/**
	 * 获取用户信息
	 * @param $uid
	 * @param bool $isExit 用户不存在是否继续
	 * @return bool|\Phalcon\Mvc\Model
	 * @throws Exception
	 */
	private function getUser($uid, $isExit = true) {
		$user = User::findFirst([
			'conditions' => "id = '{$uid}'"
		]);
		if ($user == false) {
			if ($isExit === false) {
				return false;
			} else {
				throw new Exception("要查找的用户不存在【{$uid}】");
			}
		}
		return $user;
	}

	/**
	 * 是否是该等级的业务员
	 * @param $uid
	 * @param $level
	 * @return bool
	 */
	private function isSalesMan($uid, $level) {
		$user = $this->getUser($uid, false);
		if (!empty($user) && !empty($user->salesmanRebate)) {
			$salesmanRebate = json_decode($user->salesmanRebate, true);
			if ($salesmanRebate && !empty($salesmanRebate[$this->type][$level])) {
				$this->salesmanRebate = $salesmanRebate[$this->type][$level];
				return true;
			} else {
				return false;
			}
		} else {
			$this->salesmanRebate = 0;
			return false;
		}
	}

}
