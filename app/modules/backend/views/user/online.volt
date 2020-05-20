<?php $this->flashSession->output(); ?>
<!--商品信息-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="active">
				<a href="{{ apppath }}/user/online" aria-expanded="true">会员列表</a>
			</li>
		</ul>
		<div class="tab-content">
				<div class="panel-body">
					<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/user/online">
						<input class="form-control" type="hidden" name="op" value="hail">
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员id，帐号">
							</div>
						</div>
						<div class="text-lg-center">
							<button class="btn btn-info fa fa-search" type="submit">搜索</button>
						</div>
					</form>
				</div>
				<div id="demo-lft-tab-1" class="tab-pane fade active in">
					<div class="panel">
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-hover">
									<thead>
										<tr>
											<th>记录ID</th>
											<th>会员ID</th>
											<th>用户帐号</th>
											<th>登录时间</th>
										</tr>
									</thead>
									<tbody>
									{% if list is defined %}
									{% for row in list['list'] %}
									<tr>
										<td>{{ row['id'] }}</td>
										<td>{{ row['uid'] }}</td>
										<td>{{ row['user'] }}</td>
										<td>{{ date("Y-m-d H:i:s",row['logintime']) }}</td>
									</tr>
									{% endfor %}
									{% endif %}
									</tbody>
								</table>
								<div class="panel-body text-center">
									{% if list['total_pages'] >1 %}
									<ul class="pagination">
										<li><a href="{{apppath}}/user/online&page=1{% if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
										<li><a href="{{apppath}}/user/online&page={{ hailList.before }}{% if keywords is defined%}&keywords={{keywords}}{%endif%}">上一页</a></li>
										<li><a href="#">第{{ list['current'] }}页</a></li>
										<li><a href="#">共{{ list['total_pages'] }}页</a></li>
										<li><a href="{{apppath}}/user/online&page={{ list['next'] }}{% if keywords is defined%}&keywords={{keywords}}{%endif%}">下一页</a></li>
										<li><a href="{{apppath}}/user/online&page={{ list['total_pages'] }}{% if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
									</ul>
									{% endif %}
								</div>
							</div>
						</div>
					</div>
				</div>
		</div>
	</div>
</div>
<!--日志模块结束--!>

