<?php
namespace Dhc\Models;

use Phalcon\Exception;

class Config extends BaseModel
{
	public $key;
	public $value;

	public function initialize() {
		$this->setSource("dhc_config");
	}

	public function set($key, $value) {
		$this->key = $key;
		$this->value = $value;
		return $this->save();
	}

	public function get($key) {
		$config = $this->findFirst("key = '{$key}'");
		$this->value = $config->value;
		if(empty($this->value)){
			return false;
		}else{
			return $this->value;
		}
	}
}
