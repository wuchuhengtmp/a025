<?php
/**
 * Created by PhpStorm.
 * User: afp06
 * Date: 2018/1/11
 * Time: 17:00
 */
define('CASE_NAME', '151023172200');
function startsWith($string, $pattern) {
    return $pattern === "" || strrpos($string, $pattern, -strlen($string)) !== FALSE;
}
$json = array();  //不存在就false;
if (!startsWith(CASE_NAME, 'http://')) {
    $ip = "http://www.917e.cn/app/";
    $root = $ip  . CASE_NAME ."/game_code_".CASE_NAME. ".zip";
    $update = $ip  . CASE_NAME;
    $json["code_url"] = $root;
    $json["update_url"] = $update;
} else {
    $json["code_url"] = CASE_NAME;
    $json["update_url"] = dirname(CASE_NAME);
}
echo(json_encode($json));