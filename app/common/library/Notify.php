<?php
namespace Dhc\Library;
use Dhc\Models\Recharge;

$input = file_get_contents('php://input');
$data = json_decode($input,true);
PayLog($data);
if (!empty($input) && empty($_GET['out_trade_no'])) {
	if(!empty($data) && is_array($data)){
		if($data['return_code'] == '01' && $data['result_code'] == '01'){
			$data['transaction_id'] = $data['channel_trade_no'];
			$data['out_trade_no'] = $data['terminal_trace'];
			$_W['uniacid'] = $data['attach'];
			$pay = new PayResult($data);
			$resPay = $pay->start();
			if ($resPay === TRUE) {
				PayLog('支付成功！');
			} else {
				PayLog('支付失败！');
			}
		}
		exit(json_encode(array(
			'return_code' => isset($data['return_code'])?$data['return_code']:'02',
			'return_msg' => isset($data['return_msg'])?$data['return_msg']:'未收到信息'
		)));
	}
	PayLog($input);
}
	/**
	 * 日志记录函数
	 * @param max $message 日志内容，建议为数组包含操作函数和原因
	 * @param string $level 日志重要程度
	 */
	function PayLog($message = "", $level = "info") {
		$file = WEB_PATH . '/logs/';
		if(!file_exists($file)){
			@mkdir($file);
		}
		$filename = $file . date('Ymd') . '.txt';
		$content = date('Y-m-d H:i:s') . " {$level} :\n------------\n";
		if (is_string($message)) {
			$content .= "String:\n{$message}\n";
		}
		if (is_object($message)) {
			$content .= "Object:\n" . var_export($message, TRUE) . "\n";
		}
		if (is_array($message)) {
			$content .= "Array:\n";
			foreach ($message as $key => $value) {
				$content .= sprintf("%s : %s ;\n", $key, $value);
			}
		}
		$content .= "\n";
		$fp = fopen($filename, 'a+');
		fwrite($fp, $content);
		fclose($fp);
	}


