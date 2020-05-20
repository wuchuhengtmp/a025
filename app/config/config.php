<?php
/*
 * Modified: prepend directory path of current file, because of this file own different ENV under between Apache and command line.
 * NOTE: please remove this comment.
 */
defined('BASE_PATH') || define('BASE_PATH', getenv('BASE_PATH') ?: realpath(dirname(__FILE__) . '/../..'));
defined('APP_PATH') || define('APP_PATH', BASE_PATH . '/app');
defined('SERVER') ||  define('SERVER', 'tjlogin');
define('APP_ADMIN_PATH', 'http://' . $_SERVER['HTTP_HOST'] . '/admin');
define('USER_TYPE', 'EMG'); //用户类型 可选值有 EMG、huangjin 和 chuangjin，默认是为EMG
return new \Phalcon\Config([
	'version' => '1.0',

	'database' => [
		'adapter' => 'Mysql',
		'host' => '127.0.0.1',
		'username' => 'taojin',
		'password' => 'taojin',
		'dbname' => 'taojin',
		'charset' => 'utf8',
	],
	'application' => [
		'appDir' => APP_PATH . '/',
		'modelsDir' => APP_PATH . '/common/models/',
		'migrationsDir' => APP_PATH . '/migrations/',
		'cacheDir' => BASE_PATH . '/cache/',
		'siteUrl' => 'http://' . $_SERVER['HTTP_HOST'],
		'upload' => APP_PATH . '/public/upload',
		// This allows the baseUri to be understand project paths that are not in the root directory
		// of the webpspace.  This will break if the public/index.php entry point is moved or
		// possibly if the web server rewrite rules are changed. This can also be set to a static path.
		'baseUri' => preg_replace('/public([\/\\\\])index.php$/', '', $_SERVER["PHP_SELF"]),
	],

	/**
	 * if true, then we print a new line at the end of each CLI execution
	 *
	 * If we dont print a new line,
	 * then the next command prompt will be placed directly on the left of the output
	 * and it is less readable.
	 *
	 * You can disable this behaviour if the output of your application needs to don't have a new line at end
	 */
	'printNewLine' => true
]);
