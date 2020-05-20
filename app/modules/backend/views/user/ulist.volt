<!--用户列表-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if op === 'list' %}active{% endif %}"><a href="?op=list">用户列表</a></li>
			<li class="{% if op === 'edit' %}active{% endif %}"><a href="?op=edit">{% if id is empty %}添加{% else %}编辑{% endif %}用户</a></li>
			{% if op === 'recharge' %}<li class="active"><a href="javascript:void(0)">金币充值</a></li>{% endif %}
			{% if op === 'logs' %}<li class="active"><a href="javascript:void(0)">金币记录</a></li>{% endif %}
			<li class="{% if op === 'manage' %}active{% endif %}"><a href="?op=manage">用户挂单</a></li>
			<li class="{% if op === 'channel' %}active{% endif %}"><a href="?op=channel">渠道代理</a></li>
			{% if op === 'performance' %}<li class="active"><a href="javascript:void(0)">团队佣金</a></li>{% endif %}
			{% if op === 'channels' %}<li class="active"><a href="javascript:void(0)">{%if type == 'common'%}推广奖励{%elseif type == 'channel'%}个人业绩{%endif%}</a></li>{% endif %}
			{% if op === 'channellist' %}<li class="active"><a href="javascript:void(0)">下级列表</a></li>{% endif %}
			<li class="{% if op === 'salesman' %}active{% endif %}"><a href="?op=salesman">业务员管理</a></li>
		</ul>
		<div class="tab-content">
			{% if op === 'list' %}
			<div id="demo-lft-tab-1" class="tab-pane fade active in">
				<div class="panel">
					<div class="panel-heading">
						<div class="panel-control">
							<span class="label label-info">合计{{ page.total_items }}人 - 金币共计￥{{ all_price }} {%if user_type == 'jindao'%}- 在线{{online}}人{%endif%}</span>
						</div>
						<h4 class="panel-title">筛选</h4>
					</div>
					<div class="panel-body">
						<form class="form-horizontal">
							<div class="form-group">
								<label class="col-xs-12 col-sm-3 col-md-1 control-label">关键字</label>
								<div class="col-xs-12 col-sm-9 col-md-6">
									<input type="text" name="keyword" value="{{ keyword }}" placeholder="请输入UID、用户名、昵称，查找用户" class="form-control">
								</div>
							</div>

							<div class="form-group">
								<label class="col-xs-12 col-sm-3 col-md-1 control-label"></label>
								<div class="col-xs-12 col-sm-9 col-md-6">
									<input type="hidden" name="op" value="list"/>
									<button class="btn btn-info fa fa-search" type="submit">搜索</button>
								</div>
							</div>
						</form>
					</div>
				</div>
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>UID</th>
									<th>用户名</th>
									<th>状态</th>
									<th>昵称</th>
									<th>推荐人id</th>
									<th>用户组</th>
									<th>金币</th>
									<th>冻结金币</th>
									<th>金币总额</th>
									<th>上次登录</th>
									<th>注册时间</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
									{% for row in page.items %}
										<tr>
											<td>{{ row.id }}</td>
											<td>{{ row.user }}</td>
											<td>
												{% if row.status === '1' %}正常
												{% elseif row.status === '9' %}禁用
												{% else %}异常
												{% endif %}
											</td>
											<td>
												{% if row.nickname is defined %}
													{{ row.nickname }}
												{% else %}
													暂未设置
												{% endif %}
											</td>
											<td>
											{%if row.superior>0%}
												{{ row.superior }}
											{%else%}---
											{%endif%}
											</td>
											<td>{{ row.usergroup }}</td>
											<td>{{ row.coing }}</td>
											<td>{{ row.Frozen }}</td>
											<td>{{ row.coing+row.Frozen }}</td>
											<td>{% if row.lasttime is not empty %}{{ date('Y-m-d H:i:s', row.lasttime) }}{% else %}暂未登陆{% endif %}</td>
											<td>{{ date('Y-m-d H:i:s', row.createTime) }}</td>
											<td>
												<a href="?op=edit&id={{ row.id }}">
													<button class="btn btn-warning btn-labeled fa fa-edit">编辑</button>
												</a>
												{#
												<a href="?op=recharge&id={{ row.id }}">
													<button class="btn btn-success btn-labeled fa fa-money">金币充值</button>
												</a>#}
												<a href="?op=manage&user={{ row.id }}&status=1">
													<button class="btn btn-success btn-labeled fa fa-money">挂单记录</button>
												</a>
												<a href="?op=logs&uid={{ row.id }}">
													<button class="btn btn-success btn-labeled fa fa-money">金币记录</button>
												</a>
												<a href="?op=channels&uid={{ row.id }}">
                                                	<button class="btn btn-success btn-labeled fa fa-money">推广奖励</button>
                                                </a>
                                                <a href="?op=channellist&uid={{ row.id }}">
                                                    <button class="btn btn-success btn-labeled fa fa-money">推广列表</button>
                                                </a>
											</td>
										</tr>
									{% endfor %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="?op=list&page=1{%if keyword is defined%}?keyword={{keyword}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
									{% if  page.current != 1 %}
										<li><a href="?op=list&page={{ page.before }}{%if keyword is defined%}&keyword={{keyword}}{%endif%}">上一页</a></li>
									{% endif %}
									{% if  page.current != page.last %}
									<li><a href="?op=list&page={{ page.next }}{%if keyword is defined%}&keyword={{keyword}}{%endif%}">下一页</a></li>
									{% endif %}
									<li><a href="?op=list&page={{ page.last }}{%if keyword is defined%}&keyword={{keyword}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			{% elseif op == 'edit' %}
			<div id="demo-lft-tab-2" class="tab-pane fade active in">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户帐号</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="user" value="{% if item is defined %}{{ item.user }}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户昵称</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="nickname" value="{% if item is defined %}{{ item.nickname }}{% endif %}">
								</div>
							</div>
							<div class="form-group">
                            	<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户真实姓名</label>
                            	<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                            		<input class="form-control" type="text" name="realname" value="{% if item is defined %}{{ item.realname }}{% endif %}">
                            	</div>
                            </div>
                            <div class="form-group">
                                 <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户身份证号</label>
                                 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                     <input class="form-control" type="text" name="idcard" value="{% if item is defined %}{{ item.idcard }}{% endif %}">
                                 </div>
                            </div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">设置密码</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="password" value="" placeholder="重置密码使用，不需要请勿填写">
								</div>
							</div>
							<div class="form-group">
                            	<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">作者认证等级</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="authLevel" class="form-control">
										<option value="0" {% if item is defined %}{% if item.authLevel === '0' %}selected{% endif %}{% endif %}>普通作者</option>
										<option value="1" {% if item is defined %}{% if item.authLevel === '1' %}selected{% endif %}{% endif %}>银牌作者</option>
										<option value="2" {% if item is defined %}{% if item.authLevel === '2' %}selected{% endif %}{% endif %}>金牌作者</option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">业务员佣金</label>
								<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
									<div class="input-group">
										<span class="input-group-addon">一级农场</span>
										<input type="text" name="salesmanRebate[1][1]" value="{% if item.salesmanRebate['1']['1'] is defined %}{{ item.salesmanRebate['1']['1'] }}{% else %}0{% endif %}" class="form-control">
										<span class="input-group-addon">%</span>
									</div>
									<div class="input-group">
										<span class="input-group-addon">二级农场</span>
										<input type="text" name="salesmanRebate[1][2]" value="{% if item.salesmanRebate['1']['2'] is defined %}{{ item.salesmanRebate['1']['2'] }}{% else %}0{% endif %}" class="form-control">
										<span class="input-group-addon">%</span>
									</div>
									<div class="input-group">
										<span class="input-group-addon">一级庄园</span>
										<input type="text" name="salesmanRebate[2][1]" value="{% if item.salesmanRebate['2']['1'] is defined %}{{ item.salesmanRebate['2']['1'] }}{% else %}0{% endif %}" class="form-control">
										<span class="input-group-addon">%</span>
									</div>
									<div class="input-group">
										<span class="input-group-addon">二级庄园</span>
										<input type="text" name="salesmanRebate[2][2]" value="{% if item.salesmanRebate['2']['2'] is defined %}{{ item.salesmanRebate['2']['2'] }}{% else %}0{% endif %}" class="form-control">
										<span class="input-group-addon">%</span>
									</div>
									<span class="help-block" style="color: red;">如果不需要请保持空或0， 否则会覆盖后台设置的全局比例</span>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">渠道代理</label>
								<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
									<div class="input-group">
										<input class="form-control" type="text" name="channelRebate" value="{% if item is defined %}{{ item.channelRebate }}{% else %}0{% endif %}" placeholder="设置渠道代理提成比例">
										<span class="input-group-addon" id="basic-addon2">%</span>
									</div>
									<span class="help-block" style="color: red;">如果不是渠道代理，请保持空</span>
								</div>
							</div>
							{#<div class="form-group">#}
								{#<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">推广手续费</label>#}
								{#<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">#}
									{#<input class="form-control" type="text" name="spreadfee" value="{% if item is defined %}{{ item.spreadfee }}{% else %}0{% endif %}">#}
								{#</div>#}
							{#</div>#}
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户组</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="usergroup" class="form-control">
										<option value="代理机构" {% if item is defined %}{% if item.usergroup === '代理机构' %}selected{% endif %}{% endif %}>代理机构</option>
										<option value="普通用户" {% if item is defined %}{% if item.usergroup === '普通用户' %}selected{% endif %}{% endif %}>普通用户</option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="status" class="form-control">
										<option value="1" {% if item is defined %}{% if item.status === '1' %}selected{% endif %}{% endif %}>启用</option>
										<option value="9" {% if item is defined %}{% if item.status === '9' %}selected{% endif %}{% endif %}>禁用</option>
									</select>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input type="hidden" name='id' value="{% if item is defined %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			{% elseif op === 'manage' %}
			<div id="demo-lft-tab-3" class="tab-pane fade active in">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="get">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户帐号/ID</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="user" value="{% if uid is defined %}{{ uid }}{% else %}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">产品id</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="sid" value="{% if sid is defined %}{{ sid }}{% else %}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索条件</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<label class="radio-inline">
										<input type="radio" name="status" value="1" {% if status == 1 %}checked{% endif %}/>已完成
									</label>
									<label class="radio-inline">
										<input type="radio" name="status" value="0" {% if status == 0 %}checked{% endif %}/>未完成
									</label>
								</div>
							</div>
							<div class="text-lg-center">
								<input type="hidden" name="op" value="manage"/>
								<button class="btn btn-info fa fa-search" type="submit">搜索</button>
							</div>
						</form>
					</div>
					<div class="table-responsive">
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
							{% for row in page.items %}
								<tr>
									<td>{{ row.uid }}</td>
									<td>{{ row.sid }}</td>
									<td>{{ row.goods }}</td>
									<td>{{ row.number }}</td>
									<td>{{ row.price }}</td>
									<td>

										<?php echo date('Y-m-d H:i:s',$row->createtime)?>

									</td>
									<td>
										 <span class="label label-table label-success">
											 {% if row.type === '1' %}收购
											 {% elseif row.type === '0' %}出售
											 {% elseif row.type === '2' %}撤销
											 {% endif %}
										 </span>
									</td>
									<td>
										{%if row.endtime != 0%}
										<?php echo date('Y-m-d H:i:s',$row->endtime)?>
										{%endif%}
									</td>
									<td>{{ row.dealnum }}</td>
									<td>{{ row.bid }}</td>
								</tr>
							{% endfor %}
							</tbody>
						</table>
						<div class="panel-body text-center">
							<ul class="pagination">
								<li><a href="?op=manage&page=1&user={%if uid is defined%}{{uid}}{%endif%}&sid={%if sid is defined%}{{sid}}{%endif%}&status={%if status is defined%}{{status}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
								{% if  page.current != 1 %}
									<li><a href="?op=manage&page={{ page.before }}&user={%if uid is defined%}{{uid}}{%endif%}&sid={%if sid is defined%}{{sid}}{%endif%}&status={%if status is defined%}{{status}}{%endif%}">上一页</a></li>
								{% endif %}
								{% if  page.current != page.last %}
									<li><a href="?op=manage&page={{ page.next }}&user={%if uid is defined%}{{uid}}{%endif%}&sid={%if sid is defined%}{{sid}}{%endif%}&status={%if status is defined%}{{status}}{%endif%}">下一页</a></li>
								{% endif %}
								<li><a href="?op=manage&page={{ page.last }}&user={%if uid is defined%}{{uid}}{%endif%}&sid={%if sid is defined%}{{sid}}{%endif%}&status={%if status is defined%}{{status}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			{% elseif op === 'recharge' %}
			<div id="demo-lft-tab-4" class="tab-pane fade active in">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="?recharge">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label" >id</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="id" value="{% if item is defined %}{{ item.id }}{% endif %}" disabled="disabled" >
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户帐号</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="user"  value="{% if item is defined %}{{ item.user }}{% endif %}">
								</div>
							</div>
							{#
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">现有金币</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="coing"  value="{% if item is defined %}{{ item.coing }}{% endif %}">
								</div>
							</div>#}
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">金币充值</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="rechargecoing" value="0">
								</div>
							</div>
							<div class="panel-footer text-left">
								<input type="hidden" name="op" value="recharge"/>

								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			{% elseif op === 'logs' %}
			<div id="demo-lft-tab-1" class="tab-pane fade active in">
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>UID</th>
									<th>操作人UID</th>
									<th>充值金额</th>
									<th>冻结金额</th>
									<th>操作时间</th>
								</tr>
								</thead>
								<tbody>
								{% for row in page.items %}
									<tr>
										<td>{{ row.uid }}</td>
										<td>{{ row.oid }}</td>
										<td>{{ row.gold }}</td>
										<td>{{ row.frozen }}</td>
										<td>{{ date('Y-m-d H:i:s', row.createtime) }}</td>
									</tr>
								{% endfor %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="?op=logs&page=1" class="demo-pli-arrow-right">首页</a></li>
									{% if  page.current != 1 %}
										<li><a href="?op=logs&page={{ page.before }}">上一页</a></li>
									{% endif %}
									{% if  page.current != page.last %}
										<li><a href="?op=logs&page={{ page.next }}">下一页</a></li>
									{% endif %}
									<li><a href="?op=logs&page={{ page.last }}" class="demo-pli-arrow-right">尾页</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			{% elseif op === 'channel' %}
			<div id="demo-lft-tab-1" class="tab-pane fade active in">
				<div class="panel">
					<div class="panel-heading">
						<div class="panel-control">
							<span class="label label-info">合计{{ page.total_items }}人</span>
						</div>
						<h4 class="panel-title">筛选</h4>
					</div>
					<div class="panel-body">
						<form class="form-horizontal">
							<div class="form-group">
								<label class="col-xs-12 col-sm-3 col-md-1 control-label">关键字</label>
								<div class="col-xs-12 col-sm-9 col-md-6">
									<input type="text" name="keyword" value="{{ keyword }}" placeholder="请输入UID、用户名、昵称，查找用户" class="form-control">
								</div>
							</div>

							<div class="form-group">
								<label class="col-xs-12 col-sm-3 col-md-1 control-label"></label>
								<div class="col-xs-12 col-sm-9 col-md-6">
									<input type="hidden" name="op" value="channel"/>
									<button class="btn btn-info fa fa-search" type="submit">搜索</button>
								</div>
							</div>
						</form>
					</div>
				</div>
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>UID</th>
									<th>账号</th>
									<th>昵称</th>
									<th>用户组</th>
									<th>金币</th>
									<th>冻结金币</th>
									<th>金币总额</th>
									<th>渠道佣金比例</th>
									<th>注册时间</th>
									<th>状态</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
								{% for row in page.items %}
									<tr>
										<td>{{ row.id }}</td>
										<td>{{ row.user }}</td>
										<td>
											{% if row.nickname is defined %}
												{{ row.nickname }}
											{% else %}
												暂未设置
											{% endif %}
										</td>
										<td>{{ row.usergroup }}</td>
										<td>{{ "%.4f"|format(row.coing) }}</td>
										<td>{{ "%.4f"|format(row.Frozen) }}</td>
										<td>{{ "%.4f"|format(row.coing+row.Frozen) }}</td>
										<td>{{ row.channelRebate }}%</td>
										<td>{{ date('Y-m-d H:i:s', row.createTime) }}</td>
										<td>
											{% if row.status === '1' %}正常
											{% elseif row.status === '9' %}禁用
											{% else %}异常
											{% endif %}
										</td>
										<td>
											<a href="?op=edit&id={{ row.id }}">
												<button class="btn btn-warning btn-labeled fa fa-edit">编辑</button>
											</a>
											<a href="?op=performance&uid={{ row.id }}">
												<button class="btn btn-success btn-labeled fa fa-money">团队佣金
												</button>
											</a>
											<a href="?op=channels&uid={{ row.id }}&type=channel">
                                            	<button class="btn btn-success btn-labeled fa fa-money">个人业绩
                                            	</button>
                                            </a>
                                            <a href="?op=channellist&uid={{ row.id }}">
                                                 <button class="btn btn-success btn-labeled fa fa-money">推广列表
                                                </button>
                                            </a>
										</td>
									</tr>
								{% endfor %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="?op=channel&page=1" class="demo-pli-arrow-right">首页</a></li>
									{% if  page.current != 1 %}
										<li><a href="?op=list&page={{ page.before }}">上一页</a></li>
									{% endif %}
									{% if  page.current != page.last %}
										<li><a href="?op=channel&page={{ page.next }}">下一页</a></li>
									{% endif %}
									<li><a href="?op=channel&page={{ page.last }}" class="demo-pli-arrow-right">尾页</a>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			{% elseif op === 'salesman' %}
			<div id="demo-lft-tab-1" class="tab-pane fade active in">
				<div class="panel">
					<div class="panel-heading">
						<h4 class="panel-title">筛选</h4>
					</div>
					<div class="panel-body">
						<form class="form-horizontal">
							<div class="form-group">
								<label class="col-xs-12 col-sm-3 col-md-1 control-label">关键字</label>
								<div class="col-xs-12 col-sm-9 col-md-6">
									<input type="text" name="keyword" value="{{ keyword }}"
										   placeholder="请输入UID、用户名、昵称，查找用户" class="form-control">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-3 col-md-1 control-label"></label>
								<div class="col-xs-12 col-sm-9 col-md-6">
									<input type="hidden" name="op" value="salesman"/>
									<button class="btn btn-info fa fa-search" type="submit">搜索</button>
								</div>
							</div>
						</form>
					</div>
				</div>
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th>UID</th>
									<th>账号</th>
									<th>昵称</th>
									<th>用户组</th>
									<th>金币</th>
									<th>冻结金币</th>
									<th>金币总额</th>
									<th>业务员佣金比例</th>
									<th>注册时间</th>
									<th>状态</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
								{% for row in page['items'] %}
									<tr>
										<td>{{ row['id'] }}</td>
										<td>{{ row['user'] }}</td>
										<td>
											{% if row['nickname'] is defined %}
												{{ row['nickname'] }}
											{% else %}
												暂未设置
											{% endif %}
										</td>
										<td>{{ row['usergroup'] }}</td>
										<td>{{ "%.4f"|format(row['coing']) }}</td>
										<td>{{ "%.4f"|format(row['Frozen']) }}</td>
										<td>{{ "%.4f"|format(row['coing']+row['Frozen']) }}</td>
										<td>
											<?php
												$salesmanRebate= json_decode($row['salesmanRebate'], true);
												echo '一级农场:' . $salesmanRebate[1][1] . '  二级农场:' . $salesmanRebate[1][2];
												echo '<br>';
												echo '一级庄园:' . $salesmanRebate[2][1] . '  二级庄园:' . $salesmanRebate[2][2];
											?>
										</td>
										<td>{{ date('Y-m-d H:i:s', row['createTime']) }}</td>
										<td>
											{% if row['status'] === '1' %}正常
											{% elseif row['status'] === '9' %}禁用
											{% else %}异常
											{% endif %}
										</td>
										<td>
											<a href="?op=edit&id={{ row['id'] }}">
												<button class="btn btn-warning btn-labeled fa fa-edit">编辑</button>
											</a>
										</td>
									</tr>
								{% endfor %}
								</tbody>
							</table>

							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="?op=performance&uid={{ uid }}&page=1" class="demo-pli-arrow-right">首页</a></li>
									{% if  page['current'] != 1 %}
										<li><a href="?op=performance&uid={{ uid }}&page={{ page['before'] }}">上一页</a></li>
									{% endif %}
									{% if  page['current'] != page['last'] %}
										<li><a href="?op=performance&uid={{ uid }}&page={{ page['next'] }}">下一页</a></li>
									{% endif %}
									<li><a href="?op=performance&uid={{ uid }}&page={{ page['last'] }}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			{% elseif op === 'performance' %}
			<div id="demo-lft-tab-1" class="tab-pane fade active in">
					<div class="panel">
						<div class="panel-control">
                    		<span class="label label-info">合计{{ page['count'] }}人 - 业绩共计￥{{totalPrice}} - 佣金共计￥{{money}}</span>
                    	</div>
						<div class="panel-heading">
							<h4 class="panel-title">筛选</h4>
						</div>
						<div class="panel-body">
							<form class="form-horizontal">
								<div class="form-group">
									<label class="col-xs-12 col-sm-3 col-md-1 control-label">关键字</label>
									<div class="col-xs-12 col-sm-9 col-md-6">
										<input type="text" name="keyword" value="{{ keyword }}" placeholder="请输入UID、用户名、昵称，查找用户" class="form-control">
									</div>
								</div>

								<div class="form-group">
									<label class="col-xs-12 col-sm-3 col-md-1 control-label"></label>
									<div class="col-xs-12 col-sm-9 col-md-6">
										<input type="hidden" name="op" value="performance"/>
										<input type="hidden" name="uid" value="{{ uid }}"/>
										<button class="btn btn-info fa fa-search" type="submit">搜索</button>
									</div>
								</div>
							</form>
						</div>
					</div>
					<div class="panel">
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-hover">
									<thead>
									<tr>
										<th>UID</th>
										<th>账号</th>
										<th>昵称</th>
										<th>农场业绩</th>
										<th>庄园业绩</th>
										<th>业绩小计</th>
									</tr>
									</thead>
									<tbody>
									{% for row in page['items'] %}
										<tr>
											<td>{{ row['id'] }}</td>
											<td>{{ row['user'] }}</td>
											<td>
												{% if row['nickname'] is defined and row['nickname'] is not empty %}
													{{ row['nickname'] }}
												{% else %}
													暂未设置
												{% endif %}
											</td>
											<td>{{ "%.4f"|format(row['type_1']) }}</td>
											<td>{{ "%.4f"|format(row['type_2']) }}</td>
											<td>{{ "%.4f"|format(row['type_1'] + row['type_2']) }}</td>
										</tr>
									{% endfor %}
									</tbody>
								</table>
								<div class="panel-body text-center">
									<ul class="pagination">
										<li><a href="?op=performance&uid={{ uid }}&page=1" class="demo-pli-arrow-right">首页</a></li>
										{% if  page['current'] != 1 %}
											<li><a href="?op=performance&uid={{ uid }}&page={{ page['before'] }}">上一页</a></li>
										{% endif %}
										{% if  page['current'] != page['last'] %}
											<li><a href="?op=performance&uid={{ uid }}&page={{ page['next'] }}">下一页</a></li>
										{% endif %}
										<li><a href="?op=performance&uid={{ uid }}&page={{ page['last'] }}" class="demo-pli-arrow-right">尾页</a></li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
				{% elseif op === 'channels' %}
                			<div id="demo-lft-tab-1" class="tab-pane fade active in">
                					<div class="panel">
                					<div class="panel-control">
                                        <span class="label label-info">业绩{{all_money}}￥ - 佣金{{all_price}}￥</span>
                                    </div>
                						<div class="panel-heading">
                							<h4 class="panel-title">筛选</h4>
                						</div>
                						<div class="panel-body">
                							<form class="form-horizontal">
                							<div class="form-group">
                                                	<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">时间</label>
                                                		<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                			<?=Dhc\Component\MyTags::TimePiker("time",array('starttime'=>$starttime,'endtime'=>$endtime))?>
                                                		</div>
                                                </div>
                								<div class="form-group">
                									<label class="col-xs-12 col-sm-3 col-md-1 control-label"></label>
                									<div class="col-xs-12 col-sm-9 col-md-6">
                										<input type="hidden" name="op" value="channels"/>
                										<input type="hidden" name="type" value="{%if type is defined%}{{type}}{%endif%}"/>
                										<input type="hidden" name="uid" value="{{ uid }}"/>
                										<button class="btn btn-info fa fa-search" type="submit">搜索</button>
                									</div>
                								</div>
                							</form>
                						</div>
                					</div>
                					<div class="panel">
                						<div class="panel-body">
                							<div class="table-responsive">
                								<table class="table table-hover">
                									<thead>
                									<tr>
                										<th>来源UID</th>
                										<th>来源昵称</th>
                										<th>来源账号</th>
                										<th>消费金额</th>
                										<th>分佣比例</th>
                										<th>获得佣金</th>
                										<th>获得时间</th>
                										<th>结算时间</th>
                									</tr>
                									</thead>
                									<tbody>
                									{%if channels is defined%}
														{%for row in channels['list']%}
															<tr>
															<td>{{row['cUid']}}</td>
															<td>
															{%for names in realname%}
															{%if names['id'] == row['cUid']%}
																{{names['realname']}}
															{%endif%}
															{%endfor%}
															</td>
															<td>
															{%for names in realname%}
                                                            		{%if names['id'] == row['cUid']%}
                                                            		{{names['user']}}
                                                            		{%endif%}
                                                            {%endfor%}
															</td>
															<td>{{row['gold']}}</td>
															<td>{{row['rebate']}}</td>
															<td>{{row['amount']}}</td>
															<td>{{ date("Y-m-d H:i:s",row['createTime']) }}</td>
															<td>
															{% if row['effectTime'] !== '0'%}
																{{ date("Y-m-d H:i:s",row['effectTime']) }}
															{%endif%}
															</td>
															</tr>
														{%endfor%}
                									{%endif%}
                									</tbody>
                								</table>
                								<div class="panel-body text-center">
                									<ul class="pagination">
                									{% if channels['total_pages'] > 1 %}
                										<li><a href="?op=channels&uid={{ uid }}&page=1{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if type is defined%}&type={{type}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
                										{%if channels['before']!=1%}
                										<li><a href="?op=channels&uid={{ uid }}&page={{ channels['before'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if type is defined%}&type={{type}}{%endif%}">上一页</a></li>
                										{%endif%}
                										<li><a href="?op=channels&uid={{ uid }}&page={{ channels['next'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if type is defined%}&type={{type}}{%endif%}">下一页</a></li>
                										<li><a href="?op=channels&uid={{ uid }}&page={{ channels['last'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if type is defined%}&type={{type}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>

													{% endif %}
                									</ul>
                								</div>
                							</div>
                						</div>
                					</div>
                				</div>
                			{% elseif op === 'channellist' %}
                                            			<div id="demo-lft-tab-1" class="tab-pane fade active in">
                                            					<div class="panel">
                                            					<div class="panel-control">
                                                                    <span class="label label-info">{%if channellist['number'] is defined %}直接推广{{channellist['number']}}个 - 间接推广{{channellist['sum']-channellist['number']}}个{%endif%}</span>
                                                                </div>
                                                                <div class="panel-heading">
                                                                      <h4 class="panel-title">筛选</h4>
                                                                </div>
                                                                <div class="panel-body">
                                                                   <form class="form-horizontal">
                                                                        <div class="form-group">
                                                                          		<div class="form-group">
                                                                                <label class="col-xs-12 col-sm-3 col-md-1 control-label">关键字</label>
                                                                                	<div class="col-xs-12 col-sm-9 col-md-6">
                                                                                		<input type="text" name="keyword" value="{{ keywords }}" placeholder="请输入UID、用户名，查找用户" class="form-control">
                                                                                	</div>
                                                                                </div>
                                                                                <div class="col-xs-12 col-sm-9 col-md-6">
                                                                                	<input type="hidden" name="op" value="channellist"/>
                                                                                	<input type="hidden" name="uid" value="{{ uid }}"/>
                                                                                	<button class="btn btn-info fa fa-search" type="submit">搜索</button>
                                                                               </div>
                                                                           </div>
                                                                      </form>
                                                                      </div>
                                            					</div>
                                            					<div class="panel">
                                            						<div class="panel-body">
                                            							<div class="table-responsive">
                                            								<table class="table table-hover">
                                            									<thead>
                                            									<tr>
                                            										<th>ID</th>
                                            										<th>用户名</th>
                                            										<th>推广级别</th>
                                            										<th>注册时间</th>
                                            										<th>已领取</th>
                                            										<th>未领取</th>
                                            									</tr>
                                            									</thead>
                                            									<tbody>
                                            									{%if channellist is defined%}
                            														{%for row in channellist['items']%}

                            															<tr>
                            															<td>{{row['id']}}</td>
                            															<td>
                            																{{row['user']}}
                            															</td>
                            															<td>
                            															{%if row['level'] is defined%}
                            																{{row['level']+1}}{%else%}未知
                            															{%endif%}
																						</td>
                            															<td>{{ date("Y-m-d H:i:s",row['createTime']) }}</td>
                            															<td>{{ row['yes'] }}</td>
                            															<td>{{ row['no'] }}</td>
                            															</tr>
                            														{%endfor%}
                                            									{%endif%}
                                            									</tbody>
                                            								</table>
                                            								<div class="bars pull-left">
                                                                            	<button class="btn btn-info">
                                                                            		<a href="{{apppath}}/user/print{%if uid is defined%}?uid={{uid}}{%endif%}" style="color:#fff">
                                                                                        <i class="demo-pli-cross"></i> 批量导出
                                                                                     </a></button>
                                                                            </div>
                                            								<div class="panel-body text-center">
                                            									<ul class="pagination">
                                            									{%if channellist['total_page'] is defined%}
                                            									{% if  channellist['total_page'] > 1 %}
                                            										<li><a href="?op=channellist&uid={{ channellist['uid'] }}&page=1" class="demo-pli-arrow-right">首页</a></li>
                                            										{%if  channellist['before']!=1%}
                                            										<li><a href="?op=channellist&uid={{ channellist['uid'] }}&page={{ channellist['before'] }}">上一页</a></li>
                                            										{%endif%}
                                            										{% if channellist['current'] != channellist['last']%}
                                            										<li><a href="?op=channellist&uid={{ channellist['uid'] }}&page={{ channellist['current']+1 }}">下一页</a></li>
                                            										<li><a href="?op=channellist&uid={{ channellist['uid'] }}&page={{ channellist['last'] }}" class="demo-pli-arrow-right">尾页</a></li>
                                                                                   {%endif%}
                            													{% endif %}
                            													{% endif %}
                                            									</ul>
                                            								</div>
                                            							</div>
                                            						</div>
                                            					</div>
                                            				</div>

                              {% endif %}

		</div>
	</div>
</div>
