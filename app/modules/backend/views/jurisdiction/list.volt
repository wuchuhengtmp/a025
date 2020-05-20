<!--用户列表-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if show is defined %}{% if show === 'list' %}active{% else %} {% endif %}{% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show is defined %}{% if show === 'list' %}true{% else %} false{% endif %}{% endif %}">后台管理员列表</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if show is defined %}{% if show === 'list' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<div class="pad-btm form-inline">
							<div class="row">
								<div class="col-sm-6 table-toolbar-left">
									<button id="demo-btn-addrow" class="btn btn-purple" onclick="window.location.href='{{apppath}}/jurisdiction/add'"><i class="demo-pli-add"></i> 添加用户</button>
								</div>
							</div>
						</div>
						<div class="table-responsive">
							<form method="post">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>id</th>
									<th>用户名</th>
									<th>状态</th>
									<th>用户组</th>
									<th>添加时间</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
								{% if userList is defined %}
								{% for row in userList %}
								<tr>
									<td>{{ row.id }}</td>
									<td>{{ row.user }}</td>
									<td>

										{% if row.status === '1' %}启用{% else %}{% endif %}
										{% if row.status === '0' %}禁用{% else %}{% endif %}

									</td>
									<td>
										 {% if row.role === '1' %}管理员{% endif %}
										 {% if row.role === '2' %}操作员{% endif %}
										 {% if row.role === '3' %}普通会员{% endif %}
									</td>
									<td><?php echo date('Y-m-d H:i:s',$row->createtime)?></td>
									<td>
									<button class="btn btn-success btn-labeled fa fa-refresh">
									<a href="{{ apppath }}/jurisdiction/update?id={{ row.id }}">
									更新
									</a>
									</button>
									<button class="btn btn-warning btn-labeled fa fa-close">
									<a href="{{ apppath }}/jurisdiction/delete?id={{ row.id }}">
									删除
									</a>
									</button>
									</td>
									</tr>
									{% endfor %}
									{% endif %}
								</tbody>
							</table>
							</form>
							<div class="panel-body text-center">
								<ul class="pagination">
									{#<li>#}
										{#<a href="{{ apppath }}/user/list?op=list&page=1" class="demo-pli-arrow-right">首页</a>#}
									{#</li>#}
									{#<li><a href="{{ apppath }}/user/list?op=list&page={{ ulist.before }}">上一页</a></li>#}
									{#<li><a href="{{ apppath }}/user/list?op=list&page={{ ulist.last }}">下一页</a></li>#}
									{#<li>#}
										{#<a href="{{ apppath }}/user/list?op=list&page={{ ulist.total_pages }}" class="demo-pli-arrow-right">尾页</a>#}
									{#</li>#}
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
