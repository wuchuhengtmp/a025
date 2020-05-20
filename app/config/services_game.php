<?php

use Phalcon\Mvc\Url as UrlResolver;
use Phalcon\Session\Adapter\Files as SessionAdapter;
use Phalcon\Flash\Direct as FlashDirect;
use Phalcon\Flash\Session as FlashSession;
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
});
