<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if show is defined %}{% if show === 'add' %}active{% else %} {% endif %}{% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show is defined %}{% if show === 'add' %}true{% else %} false{% endif %}{% endif %}">添加用户</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if show is defined %}{% if show === 'add' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/jurisdiction/add">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">帐号</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="username" value="{% if item is defined %}{{ item.user }}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">密码</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="password" name="password" value="{% if item is defined %}{{ item.coing }}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户组</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="role" class="form-control">
										<option value="1" {% if item is defined %}{% if item.role === '1' %}selected{% endif %}{% endif %}>
											管理员
										</option>
										<option value="2" {% if item is defined %}{% if item.role === '0' %}selected{% endif %}{% endif %}>
											操作员
										</option>
										<option value="3" {% if item is defined %}{% if item.role === '0' %}selected{% endif %}{% endif %}>
											普通用户
										</option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="status" class="form-control">
										<option value="1" {% if item is defined %}{% if item.status === '1' %}selected{% endif %}{% endif %}>
											启用
										</option>
										<option value="0" {% if item is defined %}{% if item.status === '0' %}selected{% endif %}{% endif %}>
											禁用
										</option>
									</select>
								</div>
							</div>
							<div class="panel-footer text-left">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
