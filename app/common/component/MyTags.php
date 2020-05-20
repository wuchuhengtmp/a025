<?php
namespace Dhc\Component;

use Phalcon\Tag;
use Dhc\Func\Common;

class MyTags extends Tag
{

	/**
	 * 生成富文本编辑器
	 * @param string $name 表单名
	 * @param string $content 内容
	 * @param array $options
	 * @return string
	 * @internal param string $placeholder 表单提示
	 */
	public static function tpl_ueditor($name, $content = "", $options = array('width' => '100%', 'height' => '300px')) {
		$code = "";
		if (!defined('TPL_INIT_KE')) {
			$code .= '
				<link rel="stylesheet" href="/assets/lib/kindeditor/themes/default/default.css" />
				<script type="text/javascript" src="/assets/lib/kindeditor/kindeditor-min.js"></script>
				<script type="text/javascript" src="/assets/lib/kindeditor/lang/zh_CN.js"></script>
			';
			define('TPL_INIT_KE', true);
		}
		$code .= '<textarea name="' . $name . '" id="' . $name . '">' . $content . '</textarea>';
		$code .= '
			<script>
				KindEditor.ready(function(K) {
					K.create("#' . $name . '", {
						width: "' . $options['width'] . '",
						height: "' . $options['height'] . '",
						uploadJson: "/util/fileUpload/",
						fileManagerJson: "/util/fileManager/"
					});
				});
			</script>
		';
		return $code;
	}

	/**
	 * 图片上传
	 * @param string $name 表单名
	 * @param string $value 表单值
	 * @param string $default 默认缩略图片
	 * @param array $options 参数
	 * @return string
	 * @internal param string $content 内容
	 * @internal param string $placeholder 表单提示
	 */
	public static function tpl_upload_images($name, $value = "", $default = "", $options = array()) {
		if (empty($value)) {
			$default = empty($default) ? '/assets/img/noPic_192x192.png' : $default;
		} else {
			$default = Common\toMedia($value);
		}

		$code = "";
		if (!defined('TPL_INIT_KE')) {
			$code .= '
				<link rel="stylesheet" href="/assets/lib/kindeditor/themes/default/default.css" />
				<script type="text/javascript" src="/assets/lib/kindeditor/kindeditor-min.js"></script>
				<script type="text/javascript" src="/assets/lib/kindeditor/lang/zh_CN.js"></script>
			';
			define('TPL_INIT_KE', true);
		}
		$code .= '
		<div class="input-group">
			<input type="text" name="' . $name . '" value="' . $value . '" class="form-control" autocomplete="off">
			<span class="input-group-btn">
				<button class="btn btn-default" type="button" id="' . $name . '_btn">选择图片</button>
			</span>
		</div>
		<div class="input-group" style="margin-top:.5em;">
			<img src="' . $default . '" onerror="this.title=\'图片未找到\'" id="' . $name . '_img" class="img-responsive img-thumbnail" width="150" />
			<em class="close" style="position:absolute; top: 0; right: -14px;" title="删除这张图片" onclick="util.deleteImage(this)">×</em>
		</div>';
		$code .= '
			<script>
				requirejs(["util"]);
				KindEditor.ready(function(K) {
					K("#' . $name . '_btn").click(function() {
						var editor = K.editor({
							allowFileManager: true,
							uploadJson: "/util/fileUpload/",
							fileManagerJson: "/util/fileManager/"
						});
						editor.loadPlugin("image", function() {
							editor.plugin.imageDialog({
								imageUrl : K("input[name=' . $name . ']").val(),
								clickFn : function(url, title, width, height, border, align) {
									K("input[name=' . $name . ']").val(url);
									K("#' . $name . '_img").attr("src",url);
									editor.hideDialog();
								}
							});
						});
					});
				});
			</script>
		';
		return $code;
	}

	//生成时间选择器
	public static function TimePiker($name = "", $value = array()){
		$code = '';
		if (!defined('TPL_INIT_TIME')){
			$code .='
			<link rel="stylesheet" type="text/css" href="/assets/lib/bootstrap/css/calendar-blue.css"/>
			<script type="text/javascript" src="/assets/lib/bootstrap/js/calendar.js"></script>
			';
			define('TPL_INIT_TIME', true);
		}
		$value['starttime'] = empty($value['starttime']) ? date('Y-m-d'): $value['starttime'];
		$value['endtime'] = empty($value['endtime']) ? $value['starttime'] : $value['endtime'];
		$code .='<button class="btn btn-default daterange daterange-date" type="button">';
		$code .= '
			<input type="text" name="'.$name . '[start]'.'" id="J_time_start" class="date" size="12" value="'. $value['starttime'].'" style="border:none;">
                    -
			<input type="text" name="'.$name . '[end]'.'" id="J_time_end" class="date" size="12" value="'. $value['endtime'].'" style="border:none;"></span></button>
		';
		$code .= '
		<script>
			Calendar.setup({
				inputField : "J_time_start",
				ifFormat   : "%Y-%m-%d",
				showsTime  : false,
				timeFormat : "24"
			});
			Calendar.setup({
				inputField : "J_time_end",
				ifFormat   : "%Y-%m-%d",
				showsTime  : false,
				timeFormat : "24"
			});
			$(\'.J_preview\').preview(); //查看大图
			$(\'.J_cate_select\').cate_select({top_option:lang.all}); //分类联动
			$(\'.J_tooltip[title]\').tooltip({offset:[10, 2], effect:\'slide\'}).dynamic({bottom:{direction:\'down\', bounce:true}});
		</script>
		';
		return $code;
	}
}
?>
