<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if show is defined %}{% if show === 'update' %}active{% else %} {% endif %}{% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show is defined %}{% if show === 'update' %}true{% else %} false{% endif %}{% endif %}">更新用户信息</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if show is defined %}{% if show === 'update' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/jurisdiction/update">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">帐号</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="username" value="{% if item is defined %}{{ item.user }}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">重置密码</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" placeholder="如需要请输入新密码" type="text" name="rPassword">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户组</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="role" class="form-control">
										<option value="1" {% if item is defined %}{% if item.role === '1' %}selected{% endif %}{% endif %}>
											管理员
										</option>
										<option value="2" {% if item is defined %}{% if item.role === '2' %}selected{% endif %}{% endif %}>
											操作员
										</option>
										<option value="3" {% if item is defined %}{% if item.role === '3' %}selected{% endif %}{% endif %}>
											普通用户
										</option>
									</select>
								</div>
							</div>
							<div class="form-group goodstype3">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户权限设置</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									{% if jList is defined %}
										{% for key,row in jList %}
											<div class="input-group" data-item="1">
												<span class="input-group-addon">
													{% if row === 'article' %}文章模块{% endif %}
													{% if row === 'config' %}配置模块{% endif %}
													{% if row === 'jurisdiction' %}权限模块{% endif %}
													{% if row === 'product' %}大盘模块{% endif %}
													{% if row === 'orchard' %}商品模块{% endif %}
													{% if row === 'user' %}用户模块{% endif %}
													{% if row === 'warehouse' %}统计模块{% endif %}
													{% if row === 'userwithdraw' %}提现模块{% endif %}
													{% if row === 'spread' %}推广模块{% endif %}
													{% if row === 'core' %}核心模块{% endif %}
												</span>
												<select name="{{ row }}" class="form-control">
													<option value="{{ key }}"{% if juriList[key-1] is not empty %}selected{% else %}{% endif %}>启用</option>
													<option value=""{% if juriList[key-1] is empty %}selected{% else %}{% endif %}>禁用</option>
												</select>
											</div>
										{% endfor %}
									{% endif %}
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
								<input type="hidden" name="id" value="{{ item.id }}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
