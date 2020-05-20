<?php

use Phalcon\Mvc\Url as UrlResolver;
use Phalcon\Session\Adapter\Files as SessionAdapter;
use Phalcon\Mvc\View\Engine\Volt as VoltEngine;
use Phalcon\Flash\Direct as FlashDirect;
use Phalcon\Flash\Session as FlashSession;
use Phalcon\Mvc\Dispatcher; //11
use Phalcon\Events\Manager as EventsManager; //22
use Phalcon\Mvc\Model\Manager as ModelsManager;
/**
 * Registering a router
 */
$di->setShared('router', function () {
	return require APP_PATH . '/config/routes.php';
});

/**
 * The URL component is used to generate all kinds of URLs in the application
 */
$di->setShared('url', function () {
	$config = $this->getConfig();

	$url = new UrlResolver();
	$url->setBaseUri($config->application->baseUri);

	return $url;
});

/**
 * Starts the session the first time some component requests the session service
 */
$di->setShared('session', function () {
	$session = new SessionAdapter();

	$ssid = '';
	if(isset($_GET["ssid"]) && !empty(trim($_GET["ssid"]))){
		$ssid = trim($_GET["ssid"]);
	} else if (isset($_POST["ssid"]) && !empty(trim($_POST["ssid"]))){
		$ssid = trim($_POST["ssid"]);
	}
	if(!empty($ssid)){
		$session->setId($ssid);
	}

	$session->start();

	return $session;
});

/**
 * Register the session flash service with the Twitter Bootstrap classes
 */
$di->set('flash', function () {
	return new FlashDirect([
		'error' => 'alert alert-danger',
		'success' => 'alert alert-success',
		'notice' => 'alert alert-info',
		'warning' => 'alert alert-warning'
	]);
});
$di->set("flashSession", function () {
	return new FlashSession([
		'error' => 'alert alert-danger',
		'success' => 'alert alert-success',
		'notice' => 'alert alert-info',
		'warning' => 'alert alert-warning'
	]);
}
);
/**
 * Configure the Volt service for rendering .volt templates
 */
$di->setShared('voltShared', function ($view) {
	$config = $this->getConfig();

	$volt = new VoltEngine($view, $this);
	$compiledPath = $config->application->cacheDir . 'volt/';
	if (!file_exists($compiledPath)) {
		mkdir($compiledPath, 0755, true);
	}
	$volt->setOptions([
		'compiledPath' => $config->application->cacheDir . 'volt/',
		'compiledSeparator' => '_',
		'compileAlways' => true // 开发过程使用，上线后需要删除或修改为false
	]);

	return $volt;
});

/**
 * 注入模板自定义标签
 */
$di->set(
	"Func",
	function () {
		return new Dhc\Component\Func();
	}
);
$di->set(
	"dispatcher",
	function (){
		//创建一个事件管理器
		$eventsManager = new EventsManager();
		//监听分发器中使用安全插件产生的事件
		$eventsManager->attach(
			"dispatch:beforeExecuteRoute",
			new SecurityPlugin()
		);

		// 处理异常和使用 NotFoundPlugin 未找到异常
		$eventsManager->attach(
			"dispatch:beforeException",
			new NotFoundPlugin()
		);
		$dispatcher = new Dispatcher();

		// 分配事件管理器到分发器
		$dispatcher->setEventsManager($eventsManager);

		return $dispatcher;

	}
);
/***
 * 注册phpexcel
 **/
$di->set('PHPExcel',function (){
	require_once APP_PATH.'/common/library/phpexcel/PHPExcel.php';
	return new PHPExcel();
});

$di->set('modelsManager', function() {
	return new ModelsManager();
});

