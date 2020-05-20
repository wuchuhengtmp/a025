require.config({
	baseUrl: '/assets/lib/',
	urlArgs: "ver=0.0.1",
	paths: {
		'css': 'require-css/css.min',
		'jquery': 'jquery/jquery.min',
		'metismenu': 'metismenu/metisMenu',
		'nanoscroller': 'nanoscroller/jquery.nanoscroller.min',
		'bootstrap': 'bootstrap/js/bootstrap.min',
		'kindeditor': 'kindeditor/lang/zh_CN',
		'kindeditor-main': 'kindeditor/kindeditor-min',
		'nifty': 'nifty/js/nifty',
		'util': '../js/util'
	},
	shim: {
		'jquery': {
			exports: '$'
		},
		'bootstrap': {
			deps: ['jquery']
		},
		'metismenu': {
			deps: ['jquery']
		},
		'nanoscroller': {
			deps: ['jquery']
		},
		'nifty': {
			deps: ['jquery', 'bootstrap']
		},
		'util': {
			deps: ['jquery', 'metismenu', 'nanoscroller']
		},
		'kindeditor': {
			deps: ['kindeditor-main', 'css!../lib/kindeditor/themes/default/default.css']
		}
	}
});
