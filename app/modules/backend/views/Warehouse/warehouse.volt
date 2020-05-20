<!--用户列表-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if show is defined %}{% if show === 'manage' %}active{% else %} {% endif %}{% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show is defined %}{% if show === 'list' %}true{% else %} false{% endif %}{% endif %}">用户产品信息</a>
			</li>
			{% if show is defined %}{% if show === 'addp' %}
			<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="{% if show is defined %}{% if show === 'addp' %}true{% else %} false{% endif %}{% endif %}">用户产品添加</a>
			</li>
			{% endif %}{% endif %}
			<li class="{% if show is defined %}{% if show === 'count' %}active{% else %} {% endif %}{% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-3" aria-expanded="{% if show is defined %}{% if show === 'count' %}true{% else %} false{% endif %}{% endif %}">产品统计</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if show is defined %}{% if show === 'manage' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
					<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/warehouse/list?op=manage">
                    							<div class="form-group">
                    								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户id</label>
                    								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                    									<input class="form-control" id="demo-vs-definput" type="text" name="uid" value="{% if uid is defined %}{{ uid }}{% else %}{% endif %}">
                    								</div>
                    							</div>
                    							<div class="form-group">
                    								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">产品id</label>
                    								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                    									<input class="form-control" id="demo-vs-definput" type="text" name="sid" value="{% if sid is defined %}{{ sid }}{% else %}{% endif %}">
                    								</div>
                    							</div>

                    							<div class="text-lg-center">
                    								<button class="btn btn-info fa fa-search" type="submit">搜索</button>
                    							</div>
                    </form>
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>用户id</th>
									<th>产品名称</th>
									<th>产品id</th>
									<th>数量</th>
								</tr>
								</thead>
								<tbody>
								{% if prolist is defined %}
									{% for row in prolist['items'] %}
									<tr>
									<td>{{ row['uid'] }}</td>
									<td>{{ row['title'] }}</td>
									<td>{{ row['sid'] }}</td>
									<td>{% if row['number'] is defined %}{{ row['number'] }}
										{% else %}-----
										{% endif %}
									</td>
									</tr>
									{% endfor %}
								{% endif %}
								</tbody>
							</table>

                                 <div class="bars pull-left">
                                 <a href="{{apppath}}/warehouse/print">
                                 <button class="btn btn-info">
                                 <i class="demo-pli-cross"></i> 全部导出
                                 </button>
                                      </a>
                                 </div>

							<div class="panel-body text-center">
                            		<ul class="pagination">
                            			<li>
                            				<a href="{{ apppath }}/warehouse/list?op=manage&page=1{%if uid is defined%}&uid={{uid}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}" class="demo-pli-arrow-right">首页</a>
                            				</li>
                            				<li><a href="{{ apppath }}/warehouse/list?op=manage&page={{ prolist['before'] }}{%if uid is defined%}&uid={{uid}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}">上一页</a></li>
                            					<li><a href="{{ apppath }}/warehouse/list?op=manage&page={{ prolist['next'] }}{%if uid is defined%}&uid={{uid}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}">下一页</a></li>
                            					<li>
                            					<a href="{{ apppath }}/warehouse/list?op=manage&page={{ prolist['total_pages'] }}{%if uid is defined%}&uid={{uid}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}" class="demo-pli-arrow-right">尾页</a>
                            				</li>
                            		</ul>
                            	</div>
						</div>
					</div>
				</div>
			</div>
			{% if show is defined %}{% if show === 'addp' %}
			<div id="demo-lft-tab-2" class="tab-pane fade active in">
				<div class="panel">
					<form class="panel-body form-horizontal form-padding " method="post" action="addProduct?op=list">
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">产品</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<select class="form-control" id="demo-vs-definput" name="title">
									{% if productName is defined %}
										{% for row in productName %}
										<option value="{{ row.id }}">{{ row.title }}</option>
									{% endfor %}
									{% endif %}
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户id</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" id="demo-vs-definput" type="text" name="userid" placeholder="请输入用户id">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">数量</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" id="demo-vs-definput" type="text" name="number" placeholder="请输入数量">
							</div>
						</div>
						<div class="panel-footer text-left">
							<button class="btn btn-success" type="submit">添加</button>
						</div>
					</form>
				</div>
			</div>
			{% endif %}{% endif %}
			<div id="demo-lft-tab-3" class="tab-pane fade {% if show is defined %}{% if show === 'count' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>产品id</th>
									<th>产品名称</th>
									<th>数量</th>
								</tr>
								</thead>
								<tbody>
								{% for keys,lists in countData %}
								<tr>
									<td>{{ lists['sid'] }}</td>
									<td>{{ lists['title'] }}</td>
									<td>{{ lists['count'] }}</td>
								</tr>
								{% endfor %}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--文章模块结束--!>
