<?php $this->flashSession->output(); ?>
<!--商品信息-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if op is defined %}{% if op == 'display' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/orchard?op=display&page={{landList.current}}" aria-expanded="{% if op is defined %}{% if op == 'display' %}true{% else %} false{% endif %}{% endif %}">果园管理</a>
			</li>
		</ul>
		{% if op == 'display' %}
		<div class="tab-content">
			<div class="panel-body">
				<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/orchard/orchard">
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员编号">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">土地信息</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<select name="landId" class="form-control">
								{% for key,row in landIdInfo %}
								<option value="{{ key }}" {% if landId is defined %}{% if key == landId %}selected{% endif %}{% endif %}>
									{{ row }}
								</option>
								{% endfor %}
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">土地状态</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<select name="landStatus" class="form-control">
								{% for key,row in landStatusInfo %}
								<option value="{{ key }}" {% if landStatus is defined %}{% if key == landStatus %}selected{% endif %}{% endif %}>
									{{ row }}
								</option>
								{% endfor %}
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
										<th>会员ID</th>
										<th>会员信息</th>
										<th>土地编号</th>
										<th>土地信息</th>
										<th>土地等级</th>
										<th>果实信息</th>
										<th>果实状态</th>
										<th>创建时间</th>
										<th>更新时间</th>
										<th>操作时间</th>
										<th>操作</th>
									</tr>
								</thead>
								<tbody>
								{% if landList is defined %}
								{% for list in landList %}
								{% if list is not scalar %}
								{% for rows in list %}
								<tr>
									<td>{{ rows.uid }}</td>
									<td>{{ rows.nickname }}<br/>{{ rows.mobile }}</td>
									<td>{{ rows.landId }}</td>

									<td><?php echo $landIdInfo[$rows->landId];?></td>
									<td><?php echo $landLevelInfo[$rows->landLevel];?></td>
									<td>{{ rows.goodsName }}{{ rows.goodsNums }}颗</td>
									<td><?php echo $landStatusInfo[$rows->landStatus];?></td>
									<td>{{ date("Y-m-d H:i:s",rows.createtime) }}</td>
									<td>{{ date("Y-m-d H:i:s",rows.updatetime) }}</td>
									<td>{{ date("Y-m-d H:i:s",rows.optime) }}</td>
									<td>
									{% if rows.plowing == 9%}
									<a href="{{apppath}}/orchard/orchard?op=plowing&id={{ rows.id }}&level=0">
										<button class="btn btn-warning btn-labeled">解冻</button>
									</a>
									{% else %}
									<a href="{{apppath}}/orchard/orchard?op=plowing&id={{ rows.id }}&level=9">
										<button class="btn btn-warning btn-labeled">冻结</button>
									</a>
									{% endif%}
									</td>
									{% endfor %}
									{% endif %}
									{% endfor %}
									{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								{% if landList.total_pages >1 %}
								<ul class="pagination">
									<li><a href="{{apppath}}/orchard/orchard?op=display&page=1" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/orchard/orchard?op=display&page={{ landList.before }}">上一页</a></li>
									<li><a href="#">第{{ landList.current }}页</a></li>
									<li><a href="#">共{{ landList.total_pages }}页</a></li>
									<li><a href="{{apppath}}/orchard/orchard?op=display&page={{ landList.next }}">下一页</a></li>
									<li><a href="{{apppath}}/orchard/orchard?op=display&page={{ landList.total_pages }}" class="demo-pli-arrow-right">尾页</a></li>
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

