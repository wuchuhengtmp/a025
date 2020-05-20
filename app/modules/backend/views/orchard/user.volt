<?php $this->flashSession->output(); ?>
<!--商品信息-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if op is defined %}{% if op == 'display' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/user?op=display&page={{userList.current}}" aria-expanded="{% if op is defined %}{% if op == 'display' %}true{% else %} false{% endif %}{% endif %}">会员列表</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'hail' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/user?op=hail&page=1&status=1" aria-expanded="{% if op is defined %}{% if op == 'hail' %}true{% else %} false{% endif %}{% endif %}">好友列表</a>
			</li>
			{% if op == 'admin' %}
			<li class="active">
				<a href="{{ apppath }}/orchard/user?op=admin" aria-expanded="true">管理员操作</a>
			</li>
			{% endif %}
			{% if op == 'edit' %}
            	<li class="active">
            		<a href="{{ apppath }}/orchard/user?op=edit" aria-expanded="true">管理员操作</a>
            	</li>
           	{% endif %}
		</ul>
		{% if op == 'display' %}
		<div class="tab-content">
			<div class="panel-body">
				<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/orchard/user">
							<div class="panel-control">
                                 <span class="label label-info">合计{{all_peple}}人 </span>
                             </div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员编号昵称电话">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<select name="status" class="form-control">
								<option value="1" {% if status is defined %}{% if status == 1 %}selected{% endif %}{% endif %}>
									正常
								</option>
								<option value="9" {% if status is defined %}{% if status == 9 %}selected{% endif %}{% endif %}>
									禁止
								</option>
							</select>
						</div>
					</div>
					<div class="form-group">
                    	<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">会员等级</label>
                    	<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<div  class="input-group">
								<span class="input-group-addon">等级</span>
								<input type="text" name="ulevel" value="{%if ulevel is defined%}{{ulevel}}{%endif%}"  class="form-control">
							</div>
                    	</div>
                    	</div>

					<div class="text-lg-center">
						{#
						<a href="{{ apppath }}/orchard/user?op=admin">
							<div class="btn btn-default"><i class="glyphicon glyphicon-leaf"></i> 管理操作</div>
						</a>
						#}
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
										<th>记录ID</th>
										<th>会员ID</th>
										<th>昵称</th>
										<th>电话</th>

										<th>钻石</th>
										<th>木材</th>
										<th>石材</th>
										<th>钢材</th>
										<th>等级</th>

										<th>普通狗粮</th>
										<th>优质狗粮</th>
										<th>玫瑰之心</th>
										<th>铜锄头</th>
										<th>银锄头</th>
										<th>铜宝箱</th>
										<th>银宝箱</th>
										<th>金宝箱</th>
										<th>钻石宝箱</th>
										<th>化肥</th>
										<th>洒水壶</th>
										<th>除草剂</th>
										<th>除虫剂</th>
										<th>绿宝石</th>
										<th>紫宝石</th>
										<th>蓝宝石</th>
										<th>黄宝石</th>
										<th>红土地卡</th>
										<th>黑土地卡</th>
										<th>金土地卡</th>

										<th>创建时间</th>
										<th>更新时间</th>
										<th>状态</th>
										<th>操作</th>
									</tr>
								</thead>
								<tbody>
								{% if userList is defined %}
								{% for list in userList %}
								{% if list is not scalar %}
								{% for rows in list %}
								<tr>
									<td>{{ rows.id }}</td>
									<td>{{ rows.uid }}</td>
									<td>{{ rows.nickname }}</td>
									<td>{{ rows.mobile }}</td>

									<td>{{ rows.diamonds }}</td>
									<td>{{ rows.wood }}</td>
									<td>{{ rows.stone }}</td>
									<td>{{ rows.steel }}</td>
									<td>{{ rows.grade }}</td>
									<td>{{ rows.dogFood1 }}</td>
									<td>{{ rows.dogFood2 }}</td>
									<td>{{ rows.roseSeed }}</td>
									<td>{{ rows.choe }}</td>
									<td>{{ rows.shoe }}</td>
									<td>{{ rows.cchest }}</td>
									<td>{{ rows.schest }}</td>
									<td>{{ rows.gchest }}</td>
									<td>{{ rows.dchest }}</td>
									<td>{{ rows.cfert }}</td>
									<td>{{ rows.wcan }}</td>
									<td>{{ rows.hcide }}</td>
									<td>{{ rows.icide }}</td>
									<td>{{ rows.emerald }}</td>
									<td>{{ rows.purplegem }}</td>
									<td>{{ rows.sapphire }}</td>
									<td>{{ rows.topaz }}</td>
									<td>{{ rows.redcard }}</td>
									<td>{{ rows.blackcard }}</td>
									<td>{{ rows.goldcard }}</td>

									<td>{{ date("Y-m-d H:i:s",rows.createtime) }}</td>
									<td>{{ date("Y-m-d H:i:s",rows.updatetime) }}</td>
									<td>
										{% if rows.status == '1' %}
											正常
										{% elseif rows.status == '9' %}
											禁用
										{% else %}
											异常
										{% endif %}
									</td>
									<td>
										<button class="btn btn-warning btn-labeled">
											{% if rows.id>0 and rows.status ==1%}
											<a href="{{apppath}}/orchard/user?op=status&id={{ rows.id }}">禁用</a>
											{% endif %}
											{% if rows.id>0 and rows.status ==9%}
											<a href="{{apppath}}/orchard/user?op=status&id={{ rows.id }}">恢复</a>
											{% endif %}
											{%if user_type == 'duojin'%}
											<a href="?op=edit&id={{ rows.id }}">
                                            	<button class="btn btn-warning btn-labeled fa fa-edit">编辑</button>
                                            </a>
                                            {%endif%}
										</button>
										{%if user_type == "chuangjin"%}
										<button class="btn btn-warning btn-labeled">
											<a href="{{apppath}}/orchard/user?op=downgrade&uid={{ rows.uid }}">
												房屋降级
											</a>
										</button>
										{%endif%}
									</td>

									{% endfor %}
									{% endif %}
									{% endfor %}
									{% endif %}
								</tbody>
							</table>
							<div class="bars pull-left">
                                  <a href="{{apppath}}/Orchard/print">
                                  <button class="btn btn-info">
                                  <i class="demo-pli-cross"></i> 全部导出
                                  </button>
                                </a>
                             </div>
							<div class="panel-body text-center">
								{% if userList.total_pages >1 %}
								<ul class="pagination">
									<li><a href="{{apppath}}/orchard/user?op=display&page=1&ulevel={{ ulevel }}{% if keywords is defined %}&keywords={{keywords}}{%endif%}{% if status is defined%}&status={{status}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/orchard/user?op=display&page={{ userList.before }}{% if keywords is defined %}&keywords={{keywords}}{%endif%}{% if status is defined%}&status={{status}}{%endif%}&ulevel={{ ulevel }}">上一页</a></li>
									<li><a href="#">第{{ userList.current }}页</a></li>
									<li><a href="#">共{{ userList.total_pages }}页</a></li>
									<li><a href="{{apppath}}/orchard/user?op=display&page={{ userList.next }}{% if keywords is defined %}&keywords={{keywords}}{%endif%}{% if status is defined%}&status={{status}}{%endif%}&ulevel={{ ulevel }}">下一页</a></li>
									<li><a href="{{apppath}}/orchard/user?op=display&page={{ userList.total_pages }}{% if keywords is defined %}&keywords={{keywords}}{%endif%}{% if status is defined%}&status={{status}}{%endif%}&ulevel={{ ulevel }}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
								{% endif %}
							</div>
						</div>
					</div>
				</div>
			</div>
			{% endif %}
			{% if op == 'hail' %}
			<div class="tab-content">
				<div class="panel-body">
					<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/orchard/user?op=hail">
						<input class="form-control" type="hidden" name="op" value="hail">
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员编号昵称电话">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<select name="status" class="form-control">

									<option value="1" {% if status is defined %}{% if status == 1 %}selected{% endif %}{% endif %}>
										正常
									</option>
									<option value="9" {% if status is defined %}{% if status == 9 %}selected{% endif %}{% endif %}>
										拒绝
									</option>
									<option value="0" {% if status is defined %}{% if status == "0" %}selected{% endif %}{% endif %}>
										申请中
									</option>
								</select>
							</div>
						</div>
						<div class="text-lg-center">
							<button class="btn btn-info fa fa-search" type="submit">搜索</button>
						</div>
					</form>
				</div>
				<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined %}{% if op == 'hail' %}active in{% else %} {% endif %}{% endif %}">
					<div class="panel">
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-hover">
									<thead>
										<tr>
											<th>记录ID</th>
											<th>会员ID</th>
											<th>好友uid</th>
											<th>好友昵称</th>
											<th>好友电话</th>
											<th>创建时间</th>
											<th>更新时间</th>
											<th>状态</th>
											<th>操作</th>
										</tr>
									</thead>
									<tbody>
									{% if hailList is defined %}
									{% for list in hailList %}
									{% if list is not scalar %}
									{% for rows in list %}
									<tr>
										<td>{{ rows.id }}</td>
										<td>{{ rows.uid }}</td>
										<td>{{ rows.huid }}</td>
										<td>{{ rows.nickname }}</td>
										<td>{{ rows.mobile }}</td>
										<td>{{ date("Y-m-d H:i:s",rows.createtime) }}</td>
										<td>{{ date("Y-m-d H:i:s",rows.updatetime) }}</td>
										<td>
											{% if rows.status == '1' %}
												正常
											{% elseif rows.status == '9' %}
												拒绝
											{% else %}
												申请中
											{% endif %}
										</td>
										<td>
											{% if rows.id>0 and rows.status =="0" %}
											<button class="btn btn-warning btn-labeled">
												<a href="{{apppath}}/orchard/user?op=savehail&id={{ rows.id }}&status=1&page={{ hailList.current }}">通过</a>
												<a href="{{apppath}}/orchard/user?op=savehail&id={{ rows.id }}&status=9&page={{ hailList.current }}">拒绝</a>
											</button>
											{% endif %}
										</td>

										{% endfor %}
										{% endif %}
										{% endfor %}
										{% endif %}
									</tbody>
								</table>
								<div class="panel-body text-center">
									{% if hailList.total_pages >1 %}
									<ul class="pagination">
										<li><a href="{{apppath}}/orchard/user?op=hail&page=1{% if keywords is defined%}&keywords={{keywords}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
										<li><a href="{{apppath}}/orchard/user?op=hail&page={{ hailList.before }}{% if keywords is defined%}&keywords={{keywords}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}">上一页</a></li>
										<li><a href="#">第{{ hailList.current }}页</a></li>
										<li><a href="#">共{{ hailList.total_pages }}页</a></li>
										<li><a href="{{apppath}}/orchard/user?op=hail&page={{ hailList.next }}{% if keywords is defined%}&keywords={{keywords}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}">下一页</a></li>
										<li><a href="{{apppath}}/orchard/user?op=hail&page={{ hailList.total_pages }}{% if keywords is defined%}&keywords={{keywords}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
									</ul>
									{% endif %}
								</div>
							</div>
						</div>
					</div>
				</div>
			{% endif %}
			{% if op == 'admin' %}
			<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'admin' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/user?op=admin">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">会员编号</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="uid" value="" placeholder='请输入用户的id'>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">类型</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									{% for keys,lists in getAdminType %}
									<label class="radio-inline">
										<input type="radio" name="model" value="{{ keys }}" {% if keys == 'diamonds' %}checked {% endif %}> {{ lists }}
									</label>
									{% endfor%}
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">操作</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<label class="radio-inline">
										<input type="radio" name="types" value="adminadd" checked> 添加
									</label>
									<label class="radio-inline">
										<input type="radio" name="types" value="adminded"> 扣除
									</label>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">数量</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="nums" value="">
								</div>
							</div>
							<div class="panel-footer text-left">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
			{% endif %}
			{% if op == 'edit' %}
            			<div class="tab-content">
            			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'edit' %}active in{% else %} {% endif %}{% endif%}">
            				<div class="panel">
            					<div class="panel-body">
            						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/user?op=edit">
            							<div class="form-group">
            								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">会员编号</label>
            								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
            									<div class="form-control">{{item.uid}}</div>
											</div>
            							</div>
            							<div class="form-group">
                                             <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">会员昵称</label>
                                             <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                 <input class="form-control" id="demo-vs-definput" type="text" name="nickname" value="{%if item is defined%}{{item.nickname}}{%endif%}">
                                             </div>
                                        </div>
                                        <div class="form-group">
                                             <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">电话</label>
                                             <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                   <div class="form-control">{{item.mobile}}</div>
                                             </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">钻石数量</label>
                                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                <input class="form-control" id="demo-vs-definput" type="text" name="diamonds" value="{%if item is defined%}{{item.diamonds}}{%endif%}">
                                            </div>
                                        </div>
                                         <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">木材</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                 <input class="form-control" id="demo-vs-definput" type="text" name="wood" value="{%if item is defined%}{{item.wood}}{%endif%}">
                                              </div>
                                         </div>
                                         <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">石材</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input class="form-control" id="demo-vs-definput" type="text" name="stone" value="{%if item is defined%}{{item.stone}}{%endif%}">
                                              </div>
                                         </div>
                                         <div class="form-group">
                                             <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">钢材</label>
                                             <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                 <input class="form-control" id="demo-vs-definput" type="text" name="steel" value="{%if item is defined%}{{item.steel}}{%endif%}">
                                             </div>
                                         </div>
                                         <div class="form-group">
                                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">普通狗粮</label>
                                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                              <input class="form-control" id="demo-vs-definput" type="text" name="dogFood1" value="{%if item is defined%}{{item.dogFood1}}{%endif%}">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">高级狗粮</label>
                                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                <input class="form-control" id="demo-vs-definput" type="text" name="dogFood2" value="{%if item is defined%}{{item.dogFood2}}{%endif%}">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">优质狗粮2</label>
                                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                <input class="form-control" id="demo-vs-definput" type="text" name="dogFood2" value="{%if item is defined%}{{item.dogFood2}}{%endif%}">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">玫瑰花种子</label>
                                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                <input class="form-control" id="demo-vs-definput" type="text" name="roseSeed" value="{%if item is defined%}{{item.roseSeed}}{%endif%}">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                             <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">铜锄头</label>
                                             <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                 <input class="form-control" id="demo-vs-definput" type="text" name="choe" value="{%if item is defined%}{{item.choe}}{%endif%}">
                                             </div>
                                        </div>
                                        <div class="form-group">
                                           <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">银锄头</label>
                                           <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                             <input class="form-control" id="demo-vs-definput" type="text" name="shoe" value="{%if item is defined%}{{item.shoe}}{%endif%}">
                                           </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">铜宝箱</label>
                                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                <input class="form-control" id="demo-vs-definput" type="text" name="cchest" value="{%if item is defined%}{{item.cchest}}{%endif%}">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">银宝箱</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input class="form-control" id="demo-vs-definput" type="text" name="schest" value="{%if item is defined%}{{item.schest}}{%endif%}">
                                             </div>
                                        </div>
                                         <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">金宝箱</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input class="form-control" id="demo-vs-definput" type="text" name="gchest" value="{%if item is defined%}{{item.gchest}}{%endif%}">
                                              </div>
                                         </div>
                                         <div class="form-group">
                                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">钻石宝箱</label>
                                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                <input class="form-control" id="demo-vs-definput" type="text" name="dchest" value="{%if item is defined%}{{item.dchest}}{%endif%}">
                                            </div>
                                         </div>
                                         <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">化肥</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input class="form-control" id="demo-vs-definput" type="text" name="cfert" value="{%if item is defined%}{{item.cfert}}{%endif%}">
                                              </div>
                                         </div>
                                         <div class="form-group">
                                             <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">洒水壶</label>
                                             <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                 <input class="form-control" id="demo-vs-definput" type="text" name="wcan" value="{%if item is defined%}{{item.wcan}}{%endif%}">
                                             </div>
                                         </div>
                                         <div class="form-group">
                                               <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">除草剂</label>
                                               <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                    <input class="form-control" id="demo-vs-definput" type="text" name="hcide" value="{%if item is defined%}{{item.hcide}}{%endif%}">
                                               </div>
                                         </div>
                                         <div class="form-group">
                                             <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">除虫剂</label>
                                             <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                 <input class="form-control" id="demo-vs-definput" type="text" name="icide" value="{%if item is defined%}{{item.icide}}{%endif%}">
                                             </div>
                                         </div>
                                         <div class="form-group">
                                               <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">绿宝石</label>
                                               <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                    <input class="form-control" id="demo-vs-definput" type="text" name="emerald" value="{%if item is defined%}{{item.emerald}}{%endif%}">
                                               </div>
                                         </div>
                                          <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">紫宝石</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                   <input class="form-control" id="demo-vs-definput" type="text" name="purplegem" value="{%if item is defined%}{{item.purplegem}}{%endif%}">
                                              </div>
                                          </div>
                                          <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">蓝宝石</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input class="form-control" id="demo-vs-definput" type="text" name="sapphire" value="{%if item is defined%}{{item.sapphire}}{%endif%}">
                                              </div>
                                          </div>
                                          <div class="form-group">
                                                 <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">黄宝石</label>
                                                 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                      <input class="form-control" id="demo-vs-definput" type="text" name="topaz" value="{%if item is defined%}{{item.topaz}}{%endif%}">
                                                 </div>
                                          </div>
                                      <div class="panel-footer text-left">
            								<input type='hidden'  name="id" value="{{item.id}}">
            								<input type='hidden'  name="uid" value="{{item.uid}}">
            								<button class="btn btn-success" type="submit">提交</button>
            						</div>
            						</form>
            					</div>
            				</div>
            			</div>
            		</div>
            			{% endif %}
		</div>
	</div>
</div>
<!--日志模块结束--!>

