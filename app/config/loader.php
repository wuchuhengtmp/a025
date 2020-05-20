<?php

use Phalcon\Loader;

$loader = new Loader();

/**
 * Register Namespaces
 */
$loader->registerNamespaces([
	'Dhc\Models' => APP_PATH . '/common/models/',
	'Dhc\Library' => APP_PATH . '/common/library/',
	'Dhc\Component' => APP_PATH . '/common/component/'
]);

/**
 * Register module classes
 */
$loader->registerClasses([
	'Dhc\Modules\Frontend\Module'   => APP_PATH . '/modules/frontend/Module.php',
	'Dhc\Modules\Backend\Module'    => APP_PATH . '/modules/backend/Module.php',
	'Dhc\Modules\Cli\Module'        => APP_PATH . '/modules/cli/Module.php',
	'Dhc\Modules\Game\Module'       => APP_PATH . '/modules/game/Module.php'
]);

$loader->register();
