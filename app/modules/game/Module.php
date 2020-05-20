<?php
namespace Dhc\Modules\Game;

use Phalcon\Loader;
use Phalcon\DiInterface;
use Phalcon\Mvc\Dispatcher;
use Phalcon\Mvc\ModuleDefinitionInterface;
use Phalcon\Mvc\View;

class Module implements ModuleDefinitionInterface
{
	/**
	 * Registers an autoloader related to the module
	 *
	 * @param DiInterface $di
	 */
	public function registerAutoloaders(DiInterface $di = null) {
		$loader = new Loader();

		$loader->registerNamespaces([
			'Dhc\Modules\Game\Controllers' => __DIR__ . '/controllers/'
		]);

		$loader->register();
	}

	/**
	 * Registers services related to the module
	 *
	 * @param DiInterface $di
	 */
	public function registerServices(DiInterface $di) {
		$di->set('view', function () {
			$view = new View();
			$view->disable();
			return $view;
		});
		/**
		 * Set the default namespace for dispatcher
		 */
		$di->setShared('dispatcher', function () {
			$dispatcher = new Dispatcher();
			$dispatcher->setDefaultNamespace('Dhc\Modules\Game\Controllers');
			return $dispatcher;
		});
	}
}
