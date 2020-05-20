<?php
namespace Dhc\Func\Common;

function toMedia($src) {
	global $config;
	if (empty($src)) {
		return '';
	}
	$tmp = strtolower($src);
	if (strExists($tmp, 'http://') || strExists($tmp, 'https://')) {
		return $src;
	}
	if (strpos($src, './upload') === 0) {
		return $config['siteUrl'] . str_replace('./', '', $src);
	}
	return $src;
}

function strExists($string, $find) {
	return !(strpos($string, $find) === FALSE);
}

function error($errno, $message = '') {
	return array(
		'errno' => $errno,
		'message' => $message,
	);
}

function is_error($data) {
	if (empty($data) || !is_array($data) || !array_key_exists('errno', $data) || (array_key_exists('errno', $data) && $data['errno'] == 0)) {
		return false;
	} else {
		return true;
	}
}

//数组调整key值
function getArrayKey($list, $keyfield = "") {
	if (!empty($list)) {
		$rs = array();
		foreach ($list as $key => $value) {
			if (isset($value[$keyfield])) {
				$rs[$value[$keyfield]] = $value;
			} else {
				$rs[] = $value;
			}
		}
		$list = $rs;
	}
	return $list;
}

function object2array(&$object) {
	$object = json_decode(json_encode($object), true);
	return $object;
}
