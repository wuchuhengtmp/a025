
<!--文章模块开始-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="true">已完成交易列表</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-2" class="tab-pane fade active in">
				<div class="tab-base tab-stacked-left">
					<div class="tab-content">
					<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/product/pdata">
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
						<div id="demo-stk-lft-tab-1" class="tab-pane active">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>挂单用户id</th>
									<th>产品id</th>
									<th>产品名称</th>
									<th>挂单数量</th>
									<th>挂单价格</th>
									<th>挂单时间</th>
									<th>挂单类型</th>
									<th>结束时间</th>
									<th>成交数量</th>
									<th>交易用户id</th>
								</tr>
								</thead>
								<tbody>
								{% if pList is defined %}
									{% for row in pList['items'] %}
											{% if row['status'] == '1' %}
												<tr>
													<td>{{ row['uid'] }}</td>
													<td>{{ row['sid'] }}</td>
													<td>{{ row['goods'] }}</td>
													<td>{{ row['number'] }}</td>
													<td>{{ row['price'] }}</td>
													<td><?php echo date('Y-m-d H:i:s',$row['createtime'])?></td>
													{#<td><?php echo date('Y-m-d H:i:s',$row['createtime'])?></td>#}
													<td>
														<span class="text-muted"><i class="demo-pli-clock">
																 <div class="label label-table label-success">
																	 {% if row['type'] === '1' %}收购
																	 {% elseif row['type'] === '0' %}出售
																	 {% endif %}
																 </div>
														</i></span>
													</td>
													<td>
													{%if row['endtime'] >0%}
															<?php echo date('Y-m-d H:i:s',$row['endtime'])?>
													{%endif%}
													</td>
													<td>{{ row['dealnum'] }}</td>
													<td>{{ row['bid'] }}</td>
												</tr>
												{% endif %}
									{% endfor %}
								{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="{{apppath}}/product/pdata?page=1{%if uid is defined%}&uid={{uid}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/product/pdata?page={{ pList['before'] }}{%if uid is defined%}&uid={{uid}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}">上一页</a></li>
									<li><a href="{{apppath}}/product/pdata?page={{ pList['current'] }}{%if uid is defined%}&uid={{uid}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}">当前第{{ pList['current'] }}页</a></li>
									<li><a href="{{apppath}}/product/pdata?page={{ pList['total_pages'] }}{%if uid is defined%}&uid={{uid}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}">共{{ pList['total_pages'] }}页</a></li>
									<li><a href="{{apppath}}/product/pdata?page={{ pList['next'] }}{%if uid is defined%}&uid={{uid}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}">下一页</a></li>
									<li><a href="{{apppath}}/product/pdata?page={{ pList['total_pages'] }}{%if uid is defined%}&uid={{uid}}{%endif%}{%if sid is defined%}&sid={{sid}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
</div>
<!--文章模块结束--!>


