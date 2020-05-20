{% if login is not defined %}
<div id="container" class="cls-container">
	<div class="cls-content">
		<div class="cls-content-sm panel">
			<div class="panel-body" style=" background-color: #9acfea ;margin-top: 100px">
				<div class="mar-ver pad-btm">
					<h3 class="h4 mar-no">后台管理系统登录</h3>
					<p class="mar-no">欢迎使用</p>
				</div>
				<form action="{{ apppath }}/index/auth" method="post">
					<div class="form-group">
						<input type="text" class="form-control" placeholder="帐号" name="username" value="{% if user is defined %}{{ user }}{% endif %}">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="密码" name="password">
					</div>
					<div class="checkbox pad-btm text-left">
						<input id="demo-form-checkbox" name="remember" value="1" class="magic-checkbox" {% if user is defined %}checked{% else %}{% endif %} type="checkbox" style=" margin-left: 0">
						<label for="demo-form-checkbox">记住帐号</label>
					</div>
					<button class="btn btn-primary btn-lg btn-block" type="submit">登录</button>
				</form>
			</div>
	</div>
</div>
	</div>
{% endif %}
<div id="container" class="effect aside-float aside-bright navbar-fixed footer-fixed mainnav-fixed mainnav-lg">
	{% include "layouts/navbar.volt" %}
	{% include "layouts/boxed.volt" %}
	{% include "layouts/footer.volt" %}
</div>

