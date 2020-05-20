
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="true">提现完成</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade  active in ">
				<div class="panel">
					<div class="panel-heading">
						<h3 class="panel-title">提现完成</h3>
					</div>
					<div class="panel-body">
					<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/userwithdraw/over?page=1">
                    	<div class="form-group">
                    		<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
                    			<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                    				<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员id或名称">
                    			</div>
                    	</div>
                     	<div class="text-lg-center">
                    		<button class="btn btn-info fa fa-search" type="submit">搜索</button>
                    	</div>
                    </form>
						<div class="bootstrap-table">
							<div class="fixed-table-toolbar"></div>
							<div class="fixed-table-container" style="padding-bottom: 0px;">
								<div class="fixed-table-body">
									<form method="post" >
									<table class="demo-add-niftycheck table table-hover" data-toggle="table" data-url="data/bs-table-simple.json" data-page-size="10" data-pagination="true">
										<thead>
										<tr>

											<th style="" data-field="id" tabindex="0">
												<div class="th-inner ">ID</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="id" tabindex="0">
                                            	<div class="th-inner ">UID</div>
                                            	<div class="fht-cell"></div>
                                            </th>
											<th style="" data-field="name" tabindex="0">
												<div class="th-inner ">金额</div><div class="fht-cell"></div>
											</th>
											<th style="" data-field="date" tabindex="0">
												<div class="th-inner ">收款人帐号</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
												<div class="th-inner ">收款人名称</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
												<div class="th-inner ">收款人开户行</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
												<div class="th-inner ">收款人所在省</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
												<div class="th-inner ">收款人所在市县</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
												<div class="th-inner ">转账类型</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
												<div class="th-inner ">汇款用途</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
                                                <div class="th-inner ">提现时间</div>
                                                <div class="fht-cell"></div>
                                             </th>
											<th style="" data-field="amount" tabindex="0">
                                            	<div class="th-inner ">审核状态</div>
                                            	<div class="fht-cell"></div>
                                            </th>
										</tr>
										</thead>
										<tbody id="childInput">
										{% if withdraw is defined %}
											{% for row in withdraw %}


														<tr data-index="{{ row.id }}">

															<td style="">{{ row.id }}</td>
															<td style="">{{ row.uid }}</td>
															<td style="">{{ row.goldnumber }}</td>
															<td style="">{{ row.accountnumber }}</td>
															<td style="">
															{{ row.realname }}
															</td>
															<td style="">{{ row.bankaccount }}</td>
															<td style="">{{ row.province }}</td>
															<td style="">{{ row.city }}</td>
															<td style="">
																{% if row.withdrawtype ==='1' %}
																	行内转账
																{% elseif row.withdrawtype ==='2' %}
																	同城跨行
																{% elseif row.withdrawtype ==='3' %}
																	异地跨行
																{% endif %}
															</td>
															<td style="">{{ row.costname }}</td>
															<td style=""><?php echo date('Y-m-d H:i:s',$row->createtime)?></td>
															<td style="">
																{%if  row.status == 1%}已通过{%endif%}
                                                            	{%if row.status == 2%}已完成{%endif%}
                                                            	{%if row.status == 3%}信息有误{%endif%}
                                                            	{%if row.status == 0%}审核中{%endif%}
															</td>
														</tr>

													{% endfor %}

										{% endif %}
										</tbody>
									</table>
									</form>
									{% if user_type == 'bochuang'%}
                                    	   <div class="bars pull-left">
                                           <a href="{{apppath}}/userwithdraw/print?op=over">
                                           <button class="btn btn-info">
                                           <i class="demo-pli-cross"></i> 全部导出
                                           </button>
                                             </a>
                                          </div>
                                    {%endif%}
								</div>
								<div class="panel-body text-center">
									{% if page.total_pages >1 %}
										<ul class="pagination">
											<li><a href="{{apppath}}/userwithdraw/over?page=1{%if keywords is defined%}&keywords = {{keywords}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
											<li><a href="{{apppath}}/userwithdraw/over?page={{ page.before }}{%if keywords is defined%}&keywords = {{keywords}}{%endif%}">上一页</a></li>
											<li><a href="{{apppath}}/userwithdraw/over?page={{ page.next }}{%if keywords is defined%}&keywords = {{keywords}}{%endif%}">下一页</a></li>
											<li><a href="{{apppath}}/userwithdraw/over?page={{ page.total_pages }}{%if keywords is defined%}&keywords = {{keywords}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
										</ul>
									{% endif %}
								</div>
							</div>
						</div>
						<div class="clearfix"></div>
					</div>	</div>
			</div>
		</div>
	</div>
</div>


<!-- 提现模块结束--!>
