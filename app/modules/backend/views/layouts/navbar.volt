{% if login is defined %}
	{% if login === 'login' %}
<header id="navbar">
	<div id="navbar-container" class="boxed">
		<div class="navbar-header">
			<a href="#" class="navbar-brand">
				<img src="/assets/img/logo.png" alt="夺金农场" class="brand-icon">
				<div class="brand-title">
					<span class="brand-text">Nifty</span>
				</div>
			</a>
		</div>
		<div class="navbar-content clearfix">
			<ul class="nav navbar-top-links pull-right">
				<li id="dropdown-user" class="dropdown">
					<a href="#" data-toggle="dropdown" class="dropdown-toggle text-right" aria-expanded="false">
					<span class="pull-right">
						<img class="img-circle img-user media-object" src="/assets/img/avatar/1.png" alt="Profile Picture">
					</span>
						<div class="username hidden-xs"><i class="fa fa-user-circle-o"></i><strong>{% if admin is defined %}{{ admin }}{% endif %}</strong></div>
					</a>

					<div class="dropdown-menu dropdown-menu-md dropdown-menu-right panel-default">
						<ul class="head-list">
							<li>
								<a href="#">
									<i class="demo-pli-male icon-lg icon-fw"></i> 修改资料
								</a>
							</li>
							{#<li>#}
								{#<a href="#">#}
									{#<span class="badge badge-danger pull-right">9</span>#}
									{#<i class="demo-pli-mail icon-lg icon-fw"></i> 查看消息#}
								{#</a>#}
							{#</li>#}
							<li>
								<a href="{{ apppath }}/config/index">
									<span class="label label-success pull-right">New</span>
									<i class="demo-pli-gear icon-lg icon-fw"></i> 系统设置
								</a>
							</li>
						</ul>
						<div class="pad-all text-right">
							<a href="{{ apppath }}/index/out" class="btn btn-primary">
								<i class="demo-pli-unlock"></i>退出
							</a>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>
</header>
{% endif %}
{% endif %}
