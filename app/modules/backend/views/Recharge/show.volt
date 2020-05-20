<!--用户列表-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if show is defined %}{% if show === 'show' %}active{% else %} {% endif %}{% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show is defined %}{% if show === 'show' %}true{% else %} false{% endif %}{% endif %}">支付方式列表</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if show is defined %}{% if show === 'show' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
					 <div class="pad-btm form-inline">
                       <div class="panel-control">
                       	<span class="label label-info">提示：只能启用一种支付状态</span>
                       	</div>
                      <div class="col-sm-6 table-toolbar-left">
                          <button id="demo-btn-addrow" class="btn btn-purple" onclick="window.location.href='{{apppath}}/recharge/list'"><i class="demo-pli-add"></i> 增加</button>
                      </div>
                     </div>
                       </div>
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>id</th>
									<th>支付方式</th>
									<th>状态</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
								{% if paylist is defined %}
								{% for item in paylist %}
									<tr>
										<td>{{item.id}}</td>
										<td>
										{% if item.payType === 'fuyou'%}富有{% endif %}
										{% if item.payType === 'wft'%}威富通{% endif %}
										{% if item.payType === 'YB'%}易宝支付{% endif %}
										{% if item.payType === 'weichet'%}qq钱包
										{% endif %}
										</td>
										<td>
										{% if item.status ==='0' %}停用
										{% elseif item.status === '1'%}启用
										{% endif %}
										</td>
										<td>
											<a href="{{apppath}}/recharge/list?id={{item.id}}">
												<button class="btn btn-warning btn-labeled fa fa-edit">更新</button>
											</a>
										</td>
									</tr>
								{% endfor %}
								{% endif %}
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
	</div>
</div>

<!--文章模块结束--!>
