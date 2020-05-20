
<!--文章模块开始-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if op === 'list' %}active{%else%}{%endif%}">
				<a  href="{{ apppath }}/product/plist?op=list" aria-expanded="{% if op === 'list' %}true{% else %}false{% endif %}">当日行情</a>
			</li>
			<li class="{% if op === 'order' %} active {%else%}{%endif%}">
				<a  href="{{ apppath }}/product/plist?op=order" aria-expanded="{% if op === 'order' %}true{% else %}false{% endif %}">挂单列表</a>
			</li>
			<li class="{% if op === 'count' %} active {%else%} {%endif%}">
				<a  href="{{ apppath }}/product/plist?op=count" aria-expanded="{% if op === 'count' %}true{% else %}false{% endif %}">统计中心</a>
			</li>
			
		</ul>
		<div class="tab-content">
		{%if op == 'list'%}
			<div id="demo-lft-tab-1" class="tab-pane fade  {% if op === 'list' %} active in{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>id</th>
									<th>产品名称</th>
									<th>现价</th>
									<th>今开</th>
									<th>最高</th>
									<th>最低</th>
									<th>涨幅</th>
									<th>跌幅</th>
									<th>成交量</th>
								</tr>
								</thead>
								<tbody>
								{% if plist is defined %}
									{% for row in plist %}
										{% if row is not scalar  %}
												<tr>
													<td>{{ row.id }}</td>
													<td>{{ row.title }}</td>
													<td>
														{% if row.price is defined %}
															{{ row.price }}
														{%else%}
															0
														{% endif %}
													</td>
													<td>{% if row.OpeningPrice is defined %}{{ row.OpeningPrice }}{% else %}0{% endif %}</td>
													<td>{% if row.HighestPrice is defined %}{{ row.HighestPrice }}{% else %}0{% endif %}</td>
													<td>{% if row.LowestPrice is defined %}{{ row.LowestPrice }}{% else %}0{% endif %}</td>
													<td>
													{% if row.price is defined %}
														{{ "%.2f"|format((row.price-row.OpeningPrice)/row.OpeningPrice*100) }}%
														{%else%}
														0%
													{%endif%}
													</td>
													<td>
													{%if row.price is defined%}
														{{"%.2f"|format((row.price-row.LowestPrice)/row.OpeningPrice*100)}}%
														{%else%}
                                                        0%
													{%endif%}
													</td>
													<td>{% if row.Volume is defined %}{{ row.Volume }}{% else %}0{% endif %}</td>
												</tr>
										{% endif %}
									{% endfor %}
								{% endif %}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			{% endif%}
			{% if op == 'order'%}
			<div id="demo-lft-tab-2" class="tab-pane fade {% if op === 'order' %} active in{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/product/plist">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">产品名称</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input type="hidden" value="order" name="op"/>
									<input class="form-control" id="demo-vs-definput" type="text" name="title" value="{% if title is defined %}{{ title }}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">产品id</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="sid" value="{% if sid is defined %}{{ sid }}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">价格</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="price" value="{% if price is defined %}{{ price }}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索条件</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6" style="line-height: 30px;font-size: 14px;">
									<input id=" demo-vs-definput" type="radio" name="status" value="1"{% if status is defined%}{% if status === '1' %}checked{% endif %}{% endif %}>已完成
									<input id="demo-vs-definput" type="radio" name="status" value="0"{% if status is defined%}{% if status === '0' %}checked{% endif %}{% endif %}>未完成
								</div>
							</div>
							<div class="text-lg-center">
								<button class="btn btn-info fa fa-search" type="submit">搜索</button>
							</div>
						<div class="table-responsive">
							<table class="table table-hover">
							<thead>
							<tr>
								<th>挂单用户id</th>
								<th>产品id</th>
								<th>产品名称</th>
								<th>挂单类型</th>
								<th>挂单数量</th>
								<th>挂单价格</th>
								<th>挂单时间</th>
								<th>挂单状态</th>
								<th>结束时间</th>
								<th>成交数量</th>
								<th>交易用户id</th>
							</tr>
							</thead>
							<tbody>
								{% if orderlist is defined %}
									{% for row in orderlist['items'] %}

											<tr>
												<td>{{ row['uid'] }}</td>
												<td>{{ row['sid'] }}</td>
												<td>{{ row['goods'] }}</td>
												<td>
													{% if row['type'] === '1' %}买{% else %}卖{% endif %}
												</td>
												<td>{{ row['number'] }}</td>
												<td>{{ row['price'] }}</td>
												<td><?php echo date('Y-m-d H:i:s',$row['createtime'])?></td>
												<td>
												<span class="text-muted"><i class="demo-pli-clock"><div class="label label-table label-success">{% if row['status'] === '0' %}正常{% elseif row['status'] === '1' %}结束{% elseif row['status'] === '2' %}撤销{% endif %}</div></i></span></td>
												<td>
													{% if row['endtime'] is defined %}<?php echo date('Y-m-d H:i:s',$row['endtime'])?>{% else %} ---{% endif %}
												</td>
												<td>{{ row['dealnum'] }}</td>
												<td>{{ row['bid'] }}</td>
											</tr>

									{% endfor %}
								{% endif %}
							</tbody>
							</table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="{{apppath}}/product/plist?page=1&op=order{%if title is defined%}&title={{title}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}{%if price is defined%}&price={{price}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/product/plist?op=order{%if title is defined%}&title={{title}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}{%if price is defined%}&price={{price}}{%endif%}&page={{ orderlist['before'] }}">上一页</a></li>
									<li><a href="{{apppath}}/product/plist?op=order{%if title is defined%}&title={{title}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}{%if price is defined%}&price={{price}}{%endif%}&page={{ orderlist['next'] }}">下一页</a></li>
									<li><a href="{{apppath}}/product/plist?op=order{%if title is defined%}&title={{title}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}{%if price is defined%}&price={{price}}{%endif%}&page={{ orderlist['total_pages'] }}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							</div>
						</div>
						</form>
					</div>
				</div>
			</div>
			{%endif%}
			{% if op == 'count'%}
			<div id="demo-lft-tab-3" class="tab-pane fade  {% if op == 'count' %} active in{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>产品id</th>
									<th>产品名称</th>
									<th>累计交易</th>
									<th>累计挂单</th>
									<th>累计完成</th>
									<th>累计买入</th>
									<th>累计卖出</th>
									<th>累计手续费</th>
								</tr>
								</thead>
								<tbody>
								{% if countData is defined %}
									{% for rows in countData %}
												<tr>
													<td>{{ rows['id'] }}</td>
													<td>{{ rows['title'] }}</td>
													<td>{{ rows['count'] }}</td>
													<td>{{ rows['count1'] }}</td>
													<td>{{ rows['count2'] }}</td>
													<td>{{ rows['count3'] }}</td>
													<td>{{ rows['count4'] }}</td>
													<td>{{ rows['count5'] }}</td>
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
		</div>
	</div>
</div>
<!--文章模块结束--!>
