var gulp = require('gulp');
var proxy = require('http-proxy-middleware');
var browserSync = require('browser-sync');
var reload = browserSync.reload;

// 跨域设置
var jsonPlaceholderProxy = proxy(['/wapi', '/assets', '/addons'], {
	// target: 'http://farm.bcnrc.com/',
	target: 'http://a025.mxnt.net/',
	//target: 'http://taojin.www.com/',
	changeOrigin: true,
	logLevel: 'debug',
	pathRewrite: {
		'^/wapi' : '',
		'^/assets' : '/assets/',
		'^/addons' : '/addons/',
	}
});

// 监听文件变化自动刷新
gulp.task('reload:css', function (){
	gulp.src('src/assets/css/*.css', {})
		.pipe(browserSync.reload({stream: true}));
});

gulp.task('watch', function () {
	gulp.watch('src/assets/css/*.css', ['reload:css']);
	gulp.watch('src/assets/js/*/*.js').on('change', reload);
	gulp.watch('src/assets/img/*.?(png|jpg|gif|js)').on('change', reload);
	gulp.watch('src/*.html').on('change', reload);
	gulp.watch('src/templates/*/*.html').on('change', reload);
});

gulp.task('server', function () {
	browserSync.init({
		server: {
			baseDir: "./",
			port: 3000,
			middleware: [jsonPlaceholderProxy]
		},
		open: "external",
		notify: false,
		startPath: 'index.html'
	});
});

gulp.task('default', function () {
	gulp.start('server');
});
