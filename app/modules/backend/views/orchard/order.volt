<?php $this->flashSession->output(); ?>
<!--商品信息-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if op is defined %}{% if op == 'display' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/order?op=display&page={{orderList.current}}&payStatus=1" aria-expanded="{% if op is defined %}{% if op == 'display' %}true{% else %} false{% endif %}{% endif %}">订单记录</a>
			</li>
		</ul>
		{% if op == 'display' %}
		<div class="tab-content">
			<div class="panel-body">
				<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/orchard/order">
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员编号 订单号">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">支付类型</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<select name="payStatus" class="form-control">
								<option value="1" {% if payStatus is defined %}{% if payStatus == 1 %}selected{% endif %}{% endif %}>
									已支付
								</option>
								<option value="0" {% if payStatus is defined %}{% if payStatus == 0 %}selected{% endif %}{% endif %}>
									未支付
								</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">购买类型</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<select name="types" class="form-control">
								{% for key,row in orderType %}
								<option value="{{ key }}" {% if types is defined %}{% if key == types %}selected{% endif %}{% endif %}>
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
										<th>订单号</th>
										<th>购买类型</th>
										<th>支付状态</th>
										<th>支付数量</th>
										<th>购买数量</th>
										<th>创建时间</th>
										<th>支付时间</th>
									</tr>
								</thead>
								<tbody>
								{% if orderList is defined %}
								{% for list in orderList %}
								{% if list is not scalar %}
								{% for rows in list %}
								<tr>
									<td>{{ rows.uid }}</td>
									<td>{{ rows.nickname }}<br/>{{ rows.mobile }}</td>
									<td>{{ rows.orderId }}</td>
									<td><?php echo $orderType[$rows->types];?></td>
									<td>
										{% if rows.payStatus == 1 %}
										已支付
										{% endif %}
										{% if rows.payStatus == 0 %}
										未支付
										{% endif %}
									</td>
									<td>{{ rows.coing }}</td>
									<td>{{ rows.fruit }}</td>
									<td>{{ date("Y-m-d H:i:s",rows.createtime) }}</td>
									<td>{{ date("Y-m-d H:i:s",rows.payTime) }}</td>
									{% endfor %}
									{% endif %}
									{% endfor %}
									{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								{% if orderList.total_pages >1 %}
								<ul class="pagination">
									<li><a href="{{apppath}}/orchard/order?op=display&page=1{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{% if payStatus is defined %}&payStatus={{payStatus}}{% endif %}" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/orchard/order?op=display&page={{ orderList.before }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{% if payStatus is defined %}&payStatus={{payStatus}}{% endif %}">上一页</a></li>
									<li><a href="#">第{{ orderList.current }}页</a></li>
									<li><a href="#">共{{ orderList.total_pages }}页</a></li>
									<li><a href="{{apppath}}/orchard/order?op=display&page={{ orderList.next }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{% if payStatus is defined %}&payStatus={{payStatus}}{% endif %}">下一页</a></li>
									<li><a href="{{apppath}}/orchard/order?op=display&page={{ orderList.total_pages }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{% if payStatus is defined %}&payStatus={{payStatus}}{% endif %}" class="demo-pli-arrow-right">尾页</a></li>
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

