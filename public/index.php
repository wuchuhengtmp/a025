<?php
/**
 * 主要入口
 */
 //调试时开启这句，屏蔽if
define('DEVELOPMENT', true);
//if(isset($_GET['debug']) && $_GET['debug'] == 'xb'){
//	define('DEVELOPMENT', true);
//}else{
//	define('DEVELOPMENT', $_SERVER['HTTP_HOST'] == 'www.917e.cn');
//}
require '../app/bootstrap_web.php';
