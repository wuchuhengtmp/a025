
<!--文章模块开始-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="true">用户支付记录</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade  active in">
				<div class="panel">
				<div class="panel-heading">
                	<div class="panel-control">
                		<span class="label label-info">合计成功充值{{ total_money }}元</span>
                	</div>
                </div>
				<div class="panel-body">
					<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/recharge/recharge">
                              <div class="form-group">
                                     <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户id</label>
                                     <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                    	 <input class="form-control" id="demo-vs-definput" type="text" name="uid" value="{% if itemUser is defined %}{{itemUser}}{% else %}{% endif %}">
                                     </div>
                              </div>
                              <div class="form-group">
                                     <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">订单号</label>
                                     <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                         <input class="form-control" id="demo-vs-definput" type="text" name="orderNumber" {% if itemOrder is defined %}{{itemOrder}}{% else %}{% endif %} >
                                     </div>
                              </div>
                              <div class="form-group">
                                     <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">支付状态</label>
                                         <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                              				<select class="form-control" id="demo-vs-definput" name="payStatus">
                              					<option value="">全部</option>
                              					<option value="1"{%if payStatus is defined%}{%if payStatus === '1'%}selected{%endif%}{%endif%}>支付成功</option>
												<option value="2"{%if payStatus is defined%}{%if payStatus === '2'%}selected{%endif%}{%endif%}>待支付</option>
											</select>
                                          </div>
                              </div>
                               <div class="form-group">
                                    <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">支付类型</label>
                                         <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                   			 <select class="form-control" id="demo-vs-definput" name="payType">
                                   			  <option value="">全部</option>
											  <option value="wechet"{%if payType is defined%}{%if payType === 'wechet'%}selected{%endif%}{%endif%}>微信</option>
											  <option value="alipay"{%if payType is defined%}{%if payType === 'alipay'%}selected{%endif%}{%endif%}>支付宝</option>
											  <option value="qq"{%if payType is defined%}{%if payType === 'qq'%}selected{%endif%}{%endif%}>qq钱包</option>
											  <option value="back"{%if payType is defined%}{%if payType === 'back'%}selected{%endif%}{%endif%}>后台充值</option>
											  <option value="YB"{%if payType is defined%}{%if payType === 'YB'%}selected{%endif%}{%endif%}>易宝支付</option>
                                    		</select>
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
									<th>id</th>
									<th>用户</th>
									<th>订单</th>
									<th>充值数量</th>
									<th>支付类型</th>
									<th>支付时间</th>
									<th>支付状态</th>
								</tr>
								</thead>
								<tbody>
								{% if prolist is defined %}
									{% for row in prolist['items'] %}
										<tr>
													<td>{{row['id']}}</td>
													<td>{{row['uid']}}</td>
													<td>{{row['orderNumber']}}</td>
													<td>{{row['number']}}</td>
													<td>
													{% if row['payType'] ==='wechet'%}微信
													{% elseif row['payType'] ==='alipay'%}支付宝
													{% elseif row['payType'] ==='qq'%}qq钱包
													{% elseif row['payType'] ==='back'%}后台充值
													{% elseif row['payType'] ==='YB'%}易宝支付
													{% endif %}
													</td>
													<td>{{ date('Y-m-d H:i:s', row['createTime']) }}</td>
													<td>
													{% if row['payStatus'] === '1'%}支付成功
													{% elseif row['payStatus'] === '2'%}待支付
													{% elseif row['payStatus'] === '2'%}支付失败
													{% endif %}
													</td>
												</tr>
									{% endfor %}
								{% endif %}
								</tbody>
							</table>
							<div class="bars pull-left">
                            	<a href="{{apppath}}/recharge/print">
                            	<button class="btn btn-info">
                            	<i class="demo-pli-cross"></i> 全部导出
                            	</button>
                            	</a>
                           </div>
                         <div class="panel-body text-center">
                                <ul class="pagination">
                                      <li><a href="{{apppath}}/recharge/recharge?page=1{% if itemUser is defined %}&uid={{itemUser}}{% endif %}{%if itemOrder is defined %}&itemOrder={{itemOrder}}{% endif %}{%if payType is defined%}&payType={{payType}}{%endif%}{%if payType is defined%}&payStatus={{payStatus}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
                                      <li><a href="{{apppath}}/recharge/recharge?page={{ prolist['before'] }} {% if itemUser is defined %}&uid={{itemUser}}{% endif %}{%if itemOrder is defined %}&itemOrder={{itemOrder}}{% endif %}{%if payType is defined%}&payType={{payType}}{%endif%}{%if payType is defined%}&payStatus={{payStatus}}{%endif%}">上一页</a></li>
                                      <li><a href="{{apppath}}/recharge/recharge?page={{ prolist['next'] }}{% if itemUser is defined %}&uid={{itemUser}}{% endif %}{%if itemOrder is defined %}&itemOrder={{itemOrder}}{% endif %}{%if payType is defined%}&payType={{payType}}{%endif%}{%if payType is defined%}&payStatus={{payStatus}}{%endif%}">下一页</a></li>
                                      <li><a href="{{apppath}}/recharge/recharge?page={{ prolist['total_pages'] }}{% if itemUser is defined %}&uid={{itemUser}}{% endif %}{%if itemOrder is defined %}&itemOrder={{itemOrder}}{% endif %}{%if payType is defined%}&payType={{payType}}{%endif%}{%if payType is defined%}&payStatus={{payStatus}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
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
