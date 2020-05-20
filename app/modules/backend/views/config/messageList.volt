<!--用户列表-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="true">短信列表</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade active in">
				<div class="panel">
					<div class="panel-body">
					 </div>
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>短信</th>
									<th>状态</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
								{% if message is defined %}
								{% for item in message %}
									<tr>
									<td>
										{%if item['type'] is defined%}
										{% if item['type'] === 'message'%}dhc{% endif %}
										{% if item['type'] === 'jh'%}聚合{% endif %}
										{%endif%}
										</td>
										<td>
										{%if item['status'] is defined%}
										{% if item['status'] ==='0' %}停用
										{% elseif item['status'] === '1'%}启用
										{% endif %}
										{%endif%}
										</td>
										<td>
											<a href="{{apppath}}/config/sitMessage?op=edit{%if item['type'] is defined%}&type={{item['type']}}{%endif%}">
												<button class="btn btn-warning btn-labeled fa fa-edit">更新</button>
											</a>
										</td>
									</tr>
								{% endfor %}
								{% endif %}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
	</div>
</div>

<!--文章模块结束--!>
