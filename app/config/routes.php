<?php

$router = new Phalcon\Mvc\Router();
$router->setDefaultModule('frontend');
$router->removeExtraSlashes(true);
//后台管理
$router->add(
	"/admin",
	[
		"module" => "backend",
		"controller" => 'index',
		"action" => 'index'
	]
);
//后台管理
$router->add(
	"/admin/:controller/:action/:params",
	[
		"module" => "backend",
		"controller" => 1,
		"action" => 2,
		"params" => 3,
	]
);
//前台管理
$router->add(
    "/web",
    [
        "module" => "frontend",
        "controller" => 'index',
        "action" => 'noticelist'
    ]
);
//前台管理
$router->add(
    "",
    [
        "module" => "frontend",
        "controller" => 'index',
        "action" => 'index'
    ]
);
//前台管理
$router->add(
    "/web/:controller/:action/:params",
    [
        "module" => "frontend",
        "controller" => 1,
        "action" => 2,
        "params" => 3,
    ]
);

//游戏接口
$router->add(
	"/game.api",
	[
		"module" => "game",
		"controller" => "index",
		"action" => "index"
	]
);
//工具入口
$router->add(
	"/util/:action",
	[
		"module" => "backend",
		"controller" => "util",
		"action" => 1
	]
);

$router->notFound([
	"module" => "frontend",
	"controller" => 'index',
	"action" => 'index'
]);
return $router;
