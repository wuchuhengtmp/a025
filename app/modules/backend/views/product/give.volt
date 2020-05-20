
<!--用户赠送列表显示-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="true">赠送列表</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-2" class="tab-pane fade active in">
				<div class="tab-base tab-stacked-left">
					<div class="tab-content">
					<form class="form-horizontal form-padding " method="get" action="{{ apppath }}/product/give">
                          		 <div class="form-group">
                              		<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户id</label>
                                     <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                        <input class="form-control" id="demo-vs-definput" type="text" name="keywords" value="{% if keywords is defined %}{{ keywords }}{% else %}{% endif %}">
                                     </div>
                                 </div>
                                 <div class="form-group">
                                     <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">接受用户id</label>
                                     <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                        <input class="form-control" id="demo-vs-definput" type="text" name="accept" value="{% if accept is defined %}{{ accept }}{% else %}{% endif %}">
                                     </div>
                                 </div>
                                 <div class="form-group">
                                        <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">产品id</label>
                                        <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                    	<input class="form-control" id="demo-vs-definput" type="text" name="productid" value="{% if productid is defined %}{{ productid }}{% else %}{% endif %}">
                               			</div>
								 </div>
							<div class="form-group">
                               <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
                                 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                    <select name="status" class="form-control">
                                      <option value="3" {% if status is defined %}{% if status == 3 %}selected{% endif %}{% endif %}>
                                       全部
                                      </option>
                                      <option value="1" {% if status is defined %}{% if status == 1 %}selected{% endif %}{% endif %}>
                                       已接收
                                     </option>
                                     <option value="0" {% if status is defined %}{% if status == 0 %}selected{% endif %}{% endif %}>
                                        待接收
                                     </option>
                                     <option value="2" {% if status is defined %}{% if status == 2 %}selected{% endif %}{% endif %}>
                                       退回/撤销
                                     </option>
                                   </select>
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
									<th>ID</th>
									<th>赠送用户id</th>
									<th>接收用户id</th>
									<th>赠送产品id</th>
									<th>赠送数量</th>
									<th>赠送状态</th>
									<th>赠送产品名称</th>
									<th>赠送时间</th>
									<th>赠送产品手续费</th>
									<th>赠送金币索取</th>
								</tr>
								</thead>
								<tbody>
								{% if giveList is defined %}
									{% for row in giveList['items'] %}
												<tr>
													<td>{{ row['id'] }}</td>
													<td>{{ row['uid'] }}</td>
													<td>{{ row['accept'] }}</td>
													<td>{{ row['productid'] }}</td>
													<td>{{ row['number'] }}</td>
													<td>
														{%if row['status'] == 1%}接收成功{%endif%}
														{%if row['status'] == 2%}退回/撤销{%endif%}
														{%if row['status'] == 0%}等待接收{%endif%}
													</td>
													<td>{{ row['title'] }}</td>
													<td><?php echo date('Y-m-d H:i:s',$row['createtime'])?></td>
													<td>{{ row['fee'] }}</td>
													<td>{{ row['giveGold'] }}</td>
												</tr>
									{% endfor %}
								{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
							{%if giveList['total_pages'] > 1 %}
								<ul class="pagination">
									<li><a href="{{apppath}}/product/give?page=1{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if productid is defined%}&productid={{productid}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}{%if accept is defined%}&accept={{accept}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/product/give?page={{giveList['before']}}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if productid is defined%}&productid={{productid}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}{%if accept is defined%}&accept={{accept}}{%endif%}">上一页</a></li>
									<li><a href="{{apppath}}/product/give?page={{giveList['current']}}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if productid is defined%}&productid={{productid}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}{%if accept is defined%}&accept={{accept}}{%endif%}">当前第{{giveList['current']}}页</a></li>
									<li><a href="{{apppath}}/product/give?page={{giveList['total_pages']}}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if productid is defined%}&productid={{productid}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}{%if accept is defined%}&accept={{accept}}{%endif%}">共{{giveList['total_pages']}}页</a></li>
									<li><a href="{{apppath}}/product/give?page={{ giveList['next'] }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if productid is defined%}&productid={{productid}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}{%if accept is defined%}&accept={{accept}}{%endif%}">下一页</a></li>
									<li><a href="{{apppath}}/product/give?page={{ giveList['last'] }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}{%if productid is defined%}&productid={{productid}}{%endif%}{%if status is defined%}&status={{status}}{%endif%}{%if accept is defined%}&accept={{accept}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							{%endif%}
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
</div>
<!--文章模块结束--!>


