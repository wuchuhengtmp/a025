<?php

use Phalcon\Di\FactoryDefault;
use Phalcon\Mvc\Application;
ini_set("display_errors", "on");
error_reporting(E_ALL);

define('BASE_PATH', dirname(__DIR__));
define('APP_PATH', BASE_PATH . '/app');
define('WEB_PATH', BASE_PATH . '/public');
define('TIMESTAMP', time());
try {
	/**
	 * The FactoryDefault Dependency Injector automatically registers the services that
	 * provide a full stack framework. These default services can be overidden with custom ones.
	 */
	$di = new FactoryDefault();

	/**
	 * Include 基础服务
	 */
	include APP_PATH . '/config/services.php';

	/**
	 * Include web服务
	 */
	include APP_PATH . '/config/services_game.php';

	/**
	 * 获取配置信息
	 */
	$config = $di->getConfig();

	/**
	 * Include 自动注册
	 */
	include APP_PATH . '/config/loader.php';

	/**
	 * Include 自动注册
	 */
	include APP_PATH . '/common/func/Common.php';

	/**
	 * 处理应用请求
	 */
	$application = new Application($di);

	/**
	 * 注册应用模板
	 */
	$application->registerModules([
		"game" => [
			"className" => 'Dhc\Modules\Game\Module'
		]
	]);
	$application->handle()->send();


} catch (\Exception $e) {
	echo $e->getMessage() . '<br>';
	echo '<pre>' . $e->getTraceAsString() . '</pre>';
}
