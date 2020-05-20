<?php $this->flashSession->output(); ?>
<!--商品信息-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if op is defined %}{% if op == 'display' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/logs?op=display&page={{logsList['current']}}" aria-expanded="{% if op is defined %}{% if op == 'display' %}true{% else %} false{% endif %}{% endif %}">日志列表</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'list' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/logs?op=list&page={{logsList['current']}}" aria-expanded="{% if op is defined %}{% if op == 'display' %}true{% else %} false{% endif %}{% endif %}">消息列表</a>
			</li>
			{% if op == 'post' %}
			<li class="{% if op is defined %}{% if op == 'post' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/logs?op=post" aria-expanded="{% if op is defined %}{% if op == 'post' %}true{% else %} false{% endif %}{% endif %}">系统消息发布中</a>
			</li>
			{% endif %}
			<li class="{% if op is defined %}{% if op == 'downgrade' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/logs?op=downgrade" aria-expanded="{% if op is defined %}{% if op == 'downgrade' %}true{% else %} false{% endif %}{% endif %}">房屋降级记录</a>
			</li>
		</ul>
		{% if op == 'display' %}
		<div class="tab-content">
			<div class="panel-body">
				<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/orchard/logs">
					<div class="form-group">
						<div class="panel-control">
                    							<span class="label label-info">合计{{ total_nums }}</span>
                    	</div>
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员编号 信息 数量">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">信息类型</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<select name="types" class="form-control">
								{% for key,row in logsType %}
								<option value="{{ key }}" {% if types is defined %}{% if key == types %}selected{% endif %}{% endif %}>
									{{ row }}
								</option>
								{% endfor %}
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<select name="status" class="form-control">
								<option value="1" {% if status is defined %}{% if status == 1 %}selected{% endif %}{% endif %}>
									正常
								</option>
								<option value="2" {% if status is defined %}{% if status == 2 %}selected{% endif %}{% endif %}>
									已读
								</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">时间</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<?=Dhc\Component\MyTags::TimePiker("time",array("starttime"=>$starttime,"endtime"=>$endtime))?>
						</div>
					</div>
					<div class="text-lg-center">
						<button class="btn btn-info fa fa-search" type="submit">搜索</button>
					</div>
				</form>
			</div>
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined %}{% if op == 'display' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
									<tr>
										<th>日志ID</th>
										<th>会员ID</th>
										<th>会员信息</th>
										<th>操作类型</th>
										<th>数量</th>
										<th>消息</th>
										<th>状态</th>
										<th>时间</th>
									</tr>
								</thead>
								<tbody>
								{% if logsList is defined %}
								{% for rows in logsList['list'] %}
								<tr>
									<td>{{ rows['id'] }}</td>
									<td>{{ rows['uid'] }}</td>
									<td>{{ rows['mobile'] }}</td>
									<td>
										{% for key,row  in  logsType %}
										{% if key == rows['types'] %}
										{{ row }}
										{% endif %}
										{% endfor%}
									</td>
									<td>{{ rows['nums'] }}</td>
									<td>{{ rows['msg'] }}</td>
									<td>
										{% if rows['status'] == '1' %}
											正常
										{% elseif rows['status'] == '2' %}
											已读
										{% else %}
											异常
										{% endif %}
									</td>
									<td>{{ date("Y-m-d H:i:s",rows['createtime']) }}</td>
									</tr>
									{% endfor %}
									{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="{{apppath}}/orchard/logs?op=display&page=1{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if types is defined%}&types={{types}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/orchard/logs?op=display&page={{ logsList['before'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if types is defined%}&types={{types}}{%endif%}">上一页</a></li>
									<li><a href="#">第{{ logsList['current'] }}页</a></li>
									<li><a href="#">共{{ logsList['total_pages'] }}页</a></li>
									<li><a href="{{apppath}}/orchard/logs?op=display&page={{ logsList['next'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if types is defined%}&types={{types}}{%endif%}">下一页</a></li>
									<li><a href="{{apppath}}/orchard/logs?op=display&page={{ logsList['total_pages'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if types is defined%}&types={{types}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			{% endif %}
			{% if op == 'list' %}
			<div class="tab-content">
			<div class="panel-body">
				<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/orchard/logs?op=list">
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员编号 信息 数量">
							<input class="form-control" type="hidden" name="op" value="list">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">信息类型</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<select name="types" class="form-control">
								{% for key,row in logsType %}
								<option value="{{ key }}" {% if types is defined %}{% if key == types %}selected{% endif %}{% endif %}>
									{{ row }}
								</option>
								{% endfor %}
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<select name="status" class="form-control">
								<option value="1" {% if status is defined %}{% if status == 1 %}selected{% endif %}{% endif %}>
									公布中
								</option>
								<option value="2" {% if status is defined %}{% if status == 2 %}selected{% endif %}{% endif %}>
									已结束
								</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">时间</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<?=Dhc\Component\MyTags::TimePiker("time",array("starttime"=>$starttime,"endtime"=>$endtime))?>
						</div>
					</div>
					<div class="text-lg-center">
						<button class="btn btn-info fa fa-search" type="submit">搜索</button>
						<a href="{{ apppath }}/orchard/logs?op=post">
							<div class="btn btn-default"><i class="glyphicon glyphicon-leaf"></i> 系统消息发布</div>
						</a>
					</div>
				</form>
			</div>
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined %}{% if op == 'list' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
									<tr>
										<th>日志ID</th>
										<th>会员ID</th>
										<th>操作类型</th>
										<th>数量</th>
										<th>消息</th>
										<th>状态</th>
										<th>时间</th>
									</tr>
								</thead>
								<tbody>
								{% if logsList is defined %}
								{% for rows in logsList['list'] %}
								<tr>
									<td>{{ rows['id'] }}</td>
									<td>{{ rows['uid'] }}</td>
									<td>
										{% for key,row  in  logsType %}
										{% if key == rows['types'] %}
										{{ row }}
										{% endif %}
										{% endfor%}
									</td>
									<td>{{ rows['nums'] }}</td>
									<td>{{ rows['msg'] }}</td>
									<td>
										{% if rows['status'] == '1' %}
										<a class="btn btn-default btn-sm" href="{{apppath}}/orchard/logs?op=status&id={{ rows['id'] }}">公布中</a>
										{% elseif rows['status'] == '2' %}
										<a class="btn btn-default btn-sm" href="{{apppath}}/orchard/logs?op=status&id={{ rows['id'] }}">已结束</a>
										{% else %}
											异常
										{% endif %}
									</td>
									<td>{{ date("Y-m-d H:i:s",rows['createtime']) }}</td>
									{% endfor %}

									{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								{% if logsList['total_pages'] >1 %}
								<ul class="pagination">
									<li><a href="{{apppath}}/orchard/logs?op=list&page=1" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/orchard/logs?op=list&page={{ logsList['before'] }}">上一页</a></li>
									<li><a href="#">第{{ logsList['current'] }}页</a></li>
									<li><a href="#">共{{ logsList['total_pages'] }}页</a></li>
									<li><a href="{{apppath}}/orchard/logs?op=list&page={{ logsList['next'] }}">下一页</a></li>
									<li><a href="{{apppath}}/orchard/logs?op=list&page={{ logsList['total_pages'] }}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
								{% endif %}
							</div>
						</div>
					</div>
				</div>
			</div>
			{% endif %}
			{% if op == 'post' %}
			<div class="tab-content">
				<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'post' %}active in{% else %} {% endif %}{% endif%}">
					<div class="panel">
						<div class="panel-body">
							<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/logs?op=post">
								<div class="form-group">
									<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">系统消息</label>
									<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
										<input class="form-control" id="demo-vs-definput" type="text" name="msg" value="">
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
			{% endif %}
			{% if op == 'downgrade'%}
			<div class="tab-content">
            			<div class="panel-body">
            				<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/orchard/logs?op=downgrade">
            					<div class="form-group">
            						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
            						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
            							<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员编号 等级">
            							<input class="form-control" type="hidden" name="op" value="downgrade">
            						</div>
            					</div>
            					<div class="form-group">
            						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
            						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
            							<select name="status" class="form-control">
            								<option value="1" {% if status is defined %}{% if status == 1 %}selected{% endif %}{% endif %}>
            									系统
            								</option>
            								<option value="2" {% if status is defined %}{% if status == 2 %}selected{% endif %}{% endif %}>
            									管理
            								</option>
            							</select>
            						</div>
            					</div>
            					<div class="form-group">
            						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">时间</label>
            						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
            									<?=Dhc\Component\MyTags::TimePiker("time",array("starttime"=>$starttime,"endtime"=>$endtime))?>
            						</div>
            					</div>
            					<div class="text-lg-center">
            						<button class="btn btn-info fa fa-search" type="submit">搜索</button>
            					</div>
            				</form>
            			</div>
            			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined %}{% if op == 'downgrade' %}active in{% else %} {% endif %}{% endif %}">
            				<div class="panel">
            					<div class="panel-body">
            						<div class="table-responsive">
            							<table class="table table-hover">
            								<thead>
            									<tr>
            										<th>降级ID</th>
            										<th>会员ID</th>
            										<th>房屋等级</th>
            										<th>降级等级</th>
            										<th>升级时间</th>
            										<th>降级时间</th>
            										<th>类型</th>
            									</tr>
            								</thead>
            								<tbody>
            								{% if List is defined %}
            								{% for rows in List['list'] %}
            								<tr>
            									<td>{{ rows['id'] }}</td>
            									<td>{{ rows['uid'] }}</td>
            									<td>{{ rows['houseLv'] }}
            									</td>
            									<td>{{ rows['grade'] }}</td>
            									<td>{{ date("Y-m-d H:i:s",rows['htime']) }}</td>

            									<td>{{ date("Y-m-d H:i:s",rows['createtime']) }}</td>
            									<td>
													{% if rows['status'] == '1' %}
													系统
													{% elseif rows['status'] == '2' %}
													管理
													{% else %}
														异常
													{% endif %}
												</td>
											{% endfor %}

											{% endif %}
            								</tbody>
            							</table>
            							<div class="panel-body text-center">
            								{% if List['total_pages'] >1 %}
            								<ul class="pagination">
            									<li><a href="{{apppath}}/orchard/logs?op=downgrade&page=1" class="demo-pli-arrow-right">首页</a></li>
            									<li><a href="{{apppath}}/orchard/logs?op=downgrade&page={{ List['before'] }}">上一页</a></li>
            									<li><a href="#">第{{ List['current'] }}页</a></li>
            									<li><a href="#">共{{ List['total_pages'] }}页</a></li>
            									<li><a href="{{apppath}}/orchard/logs?op=downgrade&page={{ List['next'] }}">下一页</a></li>
            									<li><a href="{{apppath}}/orchard/logs?op=downgrade&page={{ List['total_pages'] }}" class="demo-pli-arrow-right">尾页</a></li>
            								</ul>
            								{% endif %}
            							</div>
            						</div>
            					</div>
            				</div>
            			</div>
			{% endif %}
		</div>
	</div>
</div>
<!--日志模块结束--!>

