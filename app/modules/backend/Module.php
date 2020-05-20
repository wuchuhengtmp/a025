<?php
namespace Dhc\Modules\Backend;

use Phalcon\Loader;
use Phalcon\Mvc\View;
use Phalcon\DiInterface;
use Phalcon\Mvc\Dispatcher;
use Phalcon\Mvc\ModuleDefinitionInterface;

class Module implements ModuleDefinitionInterface
{
    /**
     * Registers an autoloader related to the module
     *
     * @param DiInterface $di
     */
    public function registerAutoloaders(DiInterface $di = null)
    {
        $loader = new Loader();

        $loader->registerNamespaces([
            'Dhc\Modules\Backend\Controllers' => __DIR__ . '/controllers/'
        ]);

        $loader->register();
    }

    /**
     * Registers services related to the module
     *
     * @param DiInterface $di
     */
    public function registerServices(DiInterface $di)
    {
        /**
         * Setting up the view component
         */
        $di->set('view', function () {
            $view = new View();
            $view->setDI($this);
            $view->setViewsDir(__DIR__ . '/views/');

            $view->registerEngines([
                '.volt'  => 'voltShared'
            ]);

            return $view;
        });

	    /**
	     * Set the default namespace for dispatcher
	     */
	    $di->setShared('dispatcher', function() {
		    $dispatcher = new Dispatcher();
		    $dispatcher->setDefaultNamespace('Dhc\Modules\Backend\Controllers');
		    return $dispatcher;
	    });
    }
}
