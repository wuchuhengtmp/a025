
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
		    {% if show === 'list' %}
			<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="true">联系方式</a>
			</li>
			{% endif %}
			{% if show === 'edit' %}
			<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="{% if show === 'edit' %}true{% else %}false{% endif %}">添加联系方式</a>
			</li>
			{% endif %}
		</ul>
		<div class="tab-content">
		{% if show === 'list' %}
			<div id="demo-lft-tab-1" class="tab-pane fade active in ">
				<div class="panel">
					<div class="panel-body">
						<div class="pad-btm form-inline">
							<div class="row">
								<div class="col-sm-6 table-toolbar-left">
									<button id="demo-btn-addrow" class="btn btn-purple" onclick="window.location.href='{{apppath}}/config/service?op=edit&type=2'"><i class="demo-pli-add"></i> 添加</button>
								</div>
							</div>
						</div>
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th >id</th>
									<th>服务名称</th>
									<th>联系方式</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
								{% if sList is defined %}
									{% for row in sList %}
										<tr>
											<td>{{ row.id }}</td>
											<td>{{ row.title }}</td>
											<td>{{ row.way }}</td>
											<td>
												<a href="{{ apppath }}/config/service?op=edit&id={{ row.id }}" class="btn btn-default btn-sm" title="编辑"><i class="fa fa-edit"></i></a>
												{%if row.type !=0 %}
												<a href="{{ apppath }}/config/service?op=del&id={{ row.id }}" class="btn btn-default btn-sm" title="删除"><i class="fa fa-trash"></i></a>
												{%endif%}
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
			{%endif%}
			{% if show === 'edit' %}
			<div id="demo-lft-tab-2" class="tab-pane fade  active in ">
				<div class="panel">
					<form class="panel-body form-horizontal form-padding " method="post"  action="{{apppath}}/config/service?op=list">
						<!--Static-->
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">服务名称</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input type="text" class="form-control" name="title" value="{% if item.title is defined %}{{ item.title }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">联系方式</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input type="text" class="form-control" name="way" value="{% if item.title is defined %}{{ item.way }}{% endif %}">
							</div>
						</div>
						{%if k == 2 or item.type != 0%}
                        <div class="form-group">
                             <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">操作类型</label>
                             <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                  <select name="type" class="form-control">
                                        <option value="2" {% if item is defined %}{% if item.type == 2 %}selected{% endif %}{% endif %}>
                                             客服QQ/微信
                                        </option>
                                        <option value="3" {% if item is defined %}{% if item.type == 3 %}selected{% endif %}{% endif %}>
                                             服务热线
                                        </option>
                                  </select>
                             </div>
                        </div>
                        {%endif%}
						<div class="panel-footer text-left">
						    {% if item is defined %}
						    <input type="hidden" value="{% if item.type is defined %}{{ item.type }}{% endif %}" name="type">
							<input type="hidden" value="{% if item.id is defined %}{{ item.id }}{% endif %}" name="id">
							{% endif %}
							<button class="btn btn-success" type="submit">添加</button>
						</div>
					</form>
				</div>
			</div>
            {%endif%}

		</div>
	</div>
</div>
<!--文章模块结束--!>
