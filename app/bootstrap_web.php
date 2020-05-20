<?php

use Phalcon\Di\FactoryDefault;
use Phalcon\Mvc\Application;

if (DEVELOPMENT) {
    ini_set("display_errors", "on");
    error_reporting(E_ALL);
} else {
    ini_set("display_errors", "off");
    error_reporting(0);
}
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
    include APP_PATH . '/config/services_web.php';

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
        "frontend" => [
            "className" => 'Dhc\Modules\Frontend\Module'
        ],
        "backend" => [
            "className" => 'Dhc\Modules\Backend\Module'
        ],
        "game" => [
            "className" => 'Dhc\Modules\Game\Module'
        ]
    ]);

    echo $application->handle()->getContent();

} catch (\Exception $e) {

    function isAjax()
    {
        if (isset($_SERVER['HTTP_X_REQUESTED_WITH'])) {
            if ('xmlhttprequest' == strtolower($_SERVER['HTTP_X_REQUESTED_WITH']))
                return true;
        }
        //如果参数传递的参数中有ajax
        if (!empty($_POST['ajax']) || !empty($_GET['ajax']))
            return true;
        return false;
    }

    if (DEVELOPMENT) {
        echo '<pre>';
        echo $e->getMessage() . '<br>';
        var_dump($e->getFile());
        var_dump($e->getLine());
        var_dump($e->getTrace());
    } else {
        if (isAjax()) {
            $data = array();
            $data['message'] = '出现错误，请联系管理员，或稍后重试';
            $data['redirect'] = '';
            $data['type'] = 1;
            exit(json_encode($data));
        } else {
            echo '出现错误，请联系管理员，或稍后重试';
            exit;
        }
    }
}
