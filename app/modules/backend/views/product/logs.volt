<?php $this->flashSession->output(); ?>
<!--商品信息-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="active">
				<a href="{{ apppath }}/product/logs?page={{logsList.current}}" aria-expanded="true">日志列表</a>
			</li>
		</ul>
		<div id="demo-lft-tab-1" class="tab-pane fade active in">
		<div class="tab-content">
        			<div class="panel-body">
        				<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/product/logs">
        					<div class="form-group">
        						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">搜索信息</label>
        						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
        							<input class="form-control" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% endif %}" placeholder="请输入会员编号">
        						</div>
        					</div>
        					<div class="form-group">
        						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">信息类型</label>
        						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
        							<select name="type" class="form-control">
        								<option value="all" {% if type is defined %}{% if type === 'all' %}selected{% endif %}{% endif %}>
                                            	全部
                                         </option>
        								<option value="addcoing" {% if type is defined %}{% if type === 'addcoing' %}selected{% endif %}{% endif %}>
        									增加金币
        								</option>
        								<option value="addproduct" {% if type is defined %}{% if type === 'addproduct' %}selected{% endif %}{% endif %}>
                                           增加产品
                                        </option>
                                         <option value="dedproduct" {% if type is defined %}{% if type === 'dedproduct' %}selected{% endif %}{% endif %}>
                                            扣除产品
                                         </option>
                                          <option value="dedcoing" {% if type is defined %}{% if type === 'dedcoing' %}selected{% endif %}{% endif %}>
                                               扣除金币
                                           </option>
                                         <option value="addfrozenproduct" {% if type is defined %}{% if type === 'addfrozenproduct' %}selected{% endif %}{% endif %}>
                                              增加冻结产品
                                          </option>
                                          <option value="addfrozencoing" {% if type is defined %}{% if type === 'addfrozencoing' %}selected{% endif %}{% endif %}>
                                               增加冻结金币
                                          </option>
                                          <option value="dedfrozenproduct" {% if type is defined %}{% if type === 'dedfrozenproduct' %}selected{% endif %}{% endif %}>
                                              扣除冻结产品
                                          </option>
                                          <option value="dedfrozencoing" {% if type is defined %}{% if type === 'dedfrozencoing' %}selected{% endif %}{% endif %}>
                                              扣除冻结金币
                                          </option>
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
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
									<tr>
										<th>日志ID</th>
										<th>会员ID</th>
										<th>用户帐号</th>
										<th>数量</th>
										<th>操作内容</th>
										<th>状态</th>
										<th>时间</th>
										<th>操作类型</th>
									</tr>
								</thead>
								<tbody>
								{%if logs is defined%}
								{%for row in logs['list']%}
								<tr>
									<td>{{row['id']}}</td>
									<td>{{row['uid']}}</td>
									<td>{{row['mobile']}}</td>
									<td>{{row['num']}}</td>
									<td>{{row['logs']}}</td>
									<td>
									{%if row['status'] == 1%}正常{%endif%}
									{%if row['status'] != 1%}异常{%endif%}
									</td>
									<td>
									{{ date("Y-m-d H:i:s",row['createtime']) }}
									</td>
									<td>
									{%if  row['type'] == 'addfrozenproduct'%}产品冻结{%endif%}
									{%if  row['type'] == 'dedfrozenproduct'%}扣除冻结产品{%endif%}
									{%if  row['type'] == 'dedfrozencoing'%}扣除冻结金币{%endif%}
									{%if  row['type'] == 'addfrozencoing'%}冻结金币{%endif%}
									{%if  row['type'] == 'addcoing'%}增加金币{%endif%}
									{%if  row['type'] == 'dedcoing'%}扣除金币{%endif%}
									{%if  row['type'] == 'addproduct'%}增加产品{%endif%}
									{%if  row['type'] == 'dedproduct'%}扣除产品{%endif%}
									</td>
									</tr>
								{%endfor%}
								{%endif%}
								</tbody>
							</table>
							<div class="panel-body text-center">
								{% if logs['total_pages'] >1 %}
                                	<ul class="pagination">
                                		<li><a href="{{apppath}}/product/logs?page=1{%if type is defined%}&type={{type}}{%endif%}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
                                		<li><a href="{{apppath}}/product/logs?page={{ logs['before'] }}{%if type is defined%}&type={{type}}{%endif%}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if keywords is defined%}&keywords={{keywords}}{%endif%}">上一页</a></li>
                                		<li><a href="#">第{{ logs['current'] }}页</a></li>
                                		<li><a href="#">共{{ logs['total_pages'] }}页</a></li>
                                		<li><a href="{{apppath}}/product/logs?page={{ logs['next'] }}{%if type is defined%}&type={{type}}{%endif%}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if keywords is defined%}&keywords={{keywords}}{%endif%}">下一页</a></li>
                                		<li><a href="{{apppath}}/product/logs?page={{ logs['total_pages'] }}{%if type is defined%}&type={{type}}{%endif%}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
                                	</ul>
                                {% endif %}
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!--日志模块结束--!>

