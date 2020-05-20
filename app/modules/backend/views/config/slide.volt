<?php $this->flashSession->output(); ?>
<div class="nav-tabs-custom">
	<div class="tab-base">
		<!--Nav Tabs-->
		<ul class="nav nav-tabs">
			<li class="{% if op is defined%}{% if op === 'list' %}active{% else %} {% endif %}{% endif%} ">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if op is defined%}{% if op === 'list' %}true{% else %}false {% endif %}{% endif%}">幻灯管理</a>
			</li>
			<li class="{% if op is defined%}{% if op === 'edit' %}active{% else %} {% endif %}{% endif%}">
				<a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="{% if op is defined%}{% if op === 'edit' %}true{% else %}false {% endif %}{% endif%}">幻灯编辑</a>
			</li>
		</ul>
		<!--Tabs Content-->
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op === 'list' %}active in{% else %} {% endif %}{% endif%} ">
				<div class="panel">
					<div class="panel-body">
						<div class="pad-btm form-inline">
							<div class="row">
								<div class="col-sm-6 table-toolbar-left">
									<button id="demo-btn-addrow" class="btn btn-purple"
											onclick="window.location.href='{{ apppath }}/config/slide?op=edit'">添加幻灯
									</button>
								</div>
							</div>
						</div>
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>#</th>
									<th>标题</th>
									<th>地址</th>
									<th>预览</th>
									<th>状态</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
								{% if slidelist is defined %}
									{%  for rows in slidelist %}
										{% if rows is not scalar  %}
										{% for  row in rows%}
											<tr>
												<td>{{ row.id }}</td>
												<td>{{ row.title }}</td>
												<td>{{ row.address }}</td>
												<td>
													<img src="{{ row.address }}" style="height: 50px;height: 50px">
												</td>
												<td>
													<div class="label label-table label-success">
														{% if row.status === '1' %}启用
														{% else %}停用
														{% endif %}
													</div>
												</td>
												<td>
													<button class="btn btn-warning btn-labeled fa fa-edit"><a href="{{ apppath }}/config/slide?op=edit&id={{ row.id }}">编辑</a></button>
													<button class="btn btn-warning btn-labeled fa fa-trash" onclick="window.alert('确认要删除么？')"><a href="{{ apppath }}/config/slide?op=del&id={{ row.id }}">删除</button>
												</td>
											</tr>
											{% endfor %}
											{% endif %}
									{% endfor %}
								{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="{{apppath}}/config/slide?op=list&page=1" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/config/slide?op=list&page={{ slidelist.before }}">上一页</a></li>
									<li><a href="{{apppath}}/config/slide?op=list&page={{ slidelist.last }}">下一页</a></li>
									<li><a href="{{apppath}}/config/slide?op=list&page={{ slidelist.total_pages }}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="demo-lft-tab-2" class="tab-pane fade {% if op is defined%}{% if op === 'edit' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/config/slide/add">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">标题</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="title" value="{% if item is defined %}{{ item.title }}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">图片</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									{% if item is defined %}
									<?=Dhc\Component\MyTags::tpl_upload_images("address",$item->address)?>
									{% else %}
									<?=Dhc\Component\MyTags::tpl_upload_images("address")?>
									{% endif %}
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="status" class="form-control">
										<option value="1" {% if item is defined %}{% if item.status === 1 %}selected{% endif %}{% endif %}>启用</option>
										<option value="0" {% if item is defined %}{% if item.status === 1 %}selected{% endif %}{% endif %}>禁用</option>
									</select>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input type="hidden" name ='id' value="{% if item is defined %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>


				</div>
			</div>

		</div>
	</div>
