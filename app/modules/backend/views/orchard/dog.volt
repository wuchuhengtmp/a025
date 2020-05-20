<?php $this->flashSession->output(); ?>
<!--商品信息-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if op is defined %}{% if op == 'display' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/dog?op=display&page={{dogList.current}}" aria-expanded="{% if op is defined %}{% if op == 'display' %}true{% else %} false{% endif %}{% endif %}">宠物管理</a>
			</li>
		</ul>
		
		{% if op == 'display' %}
		<div class="tab-content">
			<div class="panel-body">
				<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/orchard/dog?op=display">
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员编号 宠物昵称">
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
										<th>宠物id</th>
										<th>会员id</th>
										<th>会员信息</th>
										<th>宠物信息</th>
										<th>宠物状态</th>
										<th>宠物等级</th>
										<th>经验值</th>
										<th>体力值</th>
										<th>收获时效</th>
										<th>播种时效</th>
										<th>玫瑰进度</th>
										<th>评分</th>
										<th>其他信息</th>
										<th>创建时间</th>
										<th>更新时间</th>
										<th>操作时间</th>
									</tr>
								</thead>
								<tbody>
								{% if dogList is defined %}
								{% for list in dogList %}
								{% if list is not scalar %}
								{% for rows in list %}
								<tr>
									<td>{{ rows.id }}</td>
									<td>{{ rows.uid }}</td>
									<td>{{ rows.nickname }}<br/>{{ rows.mobile }}</td>
									<td>{{ rows.dogName }}</td>
									<td>
										{% if rows.status ==1%}
										守护
										{% else %}
										睡眠
										{% endif %}
									</td>
									<td>{{ rows.dogLevel }}</td>
									<td>{{ rows.experience }}</td>
									<td>{{ rows.power }}</td>
									<td>
										{% if rows.harvestTime >0 %}
										{{ date("m-d H:i",rows.harvestTime) }}
										{% else %}
										未开启
										{% endif %}
									</td>
									<td>
										{% if rows.sowingTime >0 %}
										{{ date("m-d H:i",rows.sowingTime) }}
										{% else %}
										未开启
										{% endif %}
									</td>
									<td>{{ rows.speed }}</td>
									<td>{{ rows.score }}</td>
									<td>{% if rows.otherInfo != 0%}
										{% for k,v in rows.otherInfo %}
										{{ v }}
										{% endfor %}
										{% endif%}
									</td>
									<td>{{ date("m-d H:i",rows.createtime) }}</td>
									<td>{{ date("m-d H:i",rows.updatetime) }}</td>
									<td>{{ date("m-d H:i",rows.optime) }}</td>
									{% endfor %}
									{% endif %}
									{% endfor %}
									{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								{% if dogList.total_pages >1 %}
								<ul class="pagination">
									<li><a href="{{apppath}}/orchard/dog?op=display&page=1" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/orchard/dog?op=display&page={{ dogList.before }}">上一页</a></li>
									<li><a href="#">第{{ dogList.current }}页</a></li>
									<li><a href="#">共{{ dogList.total_pages }}页</a></li>
									<li><a href="{{apppath}}/orchard/dog?op=display&page={{ dogList.next }}">下一页</a></li>
									<li><a href="{{apppath}}/orchard/dog?op=display&page={{ dogList.total_pages }}" class="demo-pli-arrow-right">尾页</a></li>
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

