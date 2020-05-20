
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if show === 'list' %}active{% else %} {% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show === 'list' %}true{% else %}false{% endif %}">提现列表</a>
			</li>
			<li class="{% if show === 'edit' %}active{% else %} {% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="{% if show === 'edit' %}true{% else %}false{% endif %}">提现审核</a>
			</li>
			{% if show === 'create' %}
			<li class="active">
            	<a data-toggle="tab" href="#demo-lft-tab-3" aria-expanded="true">提现操作</a>
            </li>
			{% endif %}
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if show === 'list' %} active in {% endif %}">
				<div class="panel">
					<div class="panel-heading">
						<h3 class="panel-title">提现列表</h3>
					</div>
					<div class="panel-body">
						<div class="bootstrap-table">
							<div class="fixed-table-toolbar"></div>
							<div class="fixed-table-container" style="padding-bottom: 0px;">
								<div class="fixed-table-body">
								<form class="form-horizontal" method='get' action="{{ apppath }}/userwithdraw/list?op=list">
                                       <div class="form-group">
                                        <label class="col-xs-12 col-sm-3 col-md-1 control-label">关键字</label>
                                            <div class="col-xs-12 col-sm-9 col-md-6">
                                               <input type="text" name="keywords" value="{{ keywords }}" placeholder="请输入UID、用户姓名，查找用户" class="form-control">
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
									<form method="post" >
										<input type="hidden" id="urlPath" value="{{ apppath }}/userwithdraw/edit?op=edit">
									<table class="demo-add-niftycheck table table-hover" data-toggle="table" data-url="data/bs-table-simple.json" data-page-size="10" data-pagination="true">
										<thead>
										<tr>
											<th class="bs-checkbox " style="width: 36px; " data-field="state" tabindex="0">
												<div class="th-inner ">
													<input name="btSelectAll" type="checkbox" onclick="checkedAll(this)"></div>
												<div class="fht-cell"></div>
											</th>
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
                                            	<div class="th-inner ">审核状态</div>
                                            	<div class="fht-cell"></div>
                                            </th>
                                            <th style="" data-field="amount" tabindex="0">
                                               <div class="th-inner ">提现时间</div>
                                               <div class="fht-cell"></div>
                                            </th>

										</tr>
										</thead>
										<tbody id="childInput">
										{% if withdraw is defined %}
											{% for rows in withdraw %}
												{% if rows is not scalar  %}
												{% for row in rows %}
													{% if row.status === '0' %}
														<tr data-index="{{ row.id }}">
															<td class="bs-checkbox ">
																<input data-index="0" name="btSelectItem[]" type="checkbox" value="{{ row.id }}">
															</td>
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
															<td style="">
																{%if  row.status == 1%}已通过{%endif%}
                                                            	{%if row.status == 2%}已返回{%endif%}
                                                            	{%if row.status == 3%}信息有误{%endif%}
                                                            	{%if row.status == 0%}审核中{%endif%}
															</td>
															<td><?php echo date('Y-m-d H:i:s',$row->createtime)?></td>

														</tr>
														{% endif %}
													{% endfor %}
												{% endif %}
											{% endfor %}
										{% endif %}
										</tbody>
									</table>
										<div class="bars pull-left">
												<button class="btn btn-info">
												<a href="{{apppath}}/userwithdraw/print?op=list" style="color:#fff">
                                        			<i class="demo-pli-cross"></i> 批量导出
                                        		</a></button>
											<button id="demo-delete-row"  type="button"  onclick="updateData()" class="btn btn-info"><i class="demo-pli-cross"></i>批量审核</button>
										</div>
									</form>
								</div>
								<div class="panel-body text-center">
									{% if withdraw.total_pages >1 %}
										<ul class="pagination">
											<li><a href="{{apppath}}/UserWithdraw/list?op=list&page=1{%if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
											<li><a href="{{apppath}}/UserWithdraw/list?op=list&page={{ withdraw.before }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}">上一页</a></li>
											<li><a href="{{apppath}}/UserWithdraw/list?op=list&page={{ withdraw.next }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}">下一页</a></li>
											<li><a href="{{apppath}}/UserWithdraw/list?op=list&page={{ withdraw.total_pages }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
										</ul>
									{% endif %}
								</div>
							</div>
						</div>
						<div class="clearfix"></div>
					</div>	</div>
			</div>
			{%if show == 'create' %}
			<div id="demo-lft-tab-3" class="tab-pane fade active in">
			 <div id="demo-lft-tab-2" class="tab-pane fade {% if show === 'edit' %} active in {% endif %}">
                                <div class="panel">
                                    <form class="panel-body form-horizontal form-padding " method="post"  action="{{apppath}}/article/article/list">
                                        <!--Static-->
                                        <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户id*</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input type="text" class="form-control" name="uid" value="{% if item.uid is defined %}{{ item.uid }}{% endif %}">
                                              </div>
                                         </div>
                                          <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">收款开户行</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input type="text" class="form-control" name="bankaccount" value="{% if item.bankaccount is defined %}{{ item.bankaccount }}{% endif %}">
                                              </div>
                                          </div>
                                        <div class="form-group">
                                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">银行帐号*</label>
            								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
            									<input type="text" class="form-control" name="accountnumber" value="{% if item.accountnumber is defined %}{{ item.accountnumber }}{% endif %}">
            								</div>
                                        </div>
            							<div class="form-group">
                                           <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">提现金币数量</label>
                                           <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                               <input type="text" class="form-control" name="goldnumber" value="{% if item.goldnumber is defined %}{{ item.goldnumber }}{% endif %}">
                                           </div>
                                        </div>
                                        <div class="form-group">
                                           <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">手续费</label>
                                           <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                               <input type="text" class="form-control" name="fee" value="{% if item.fee is defined %}{{ item.fee }}{% endif %}">
                                           </div>
                                        </div>
                                        <div class="form-group">
                                                 <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">省份/直辖市</label>
                                                <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                <input type="text" class="form-control" name="province" value="{% if item.province is defined %}{{ item.province }}{% endif %}">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                             <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">市/县</label>
                                             <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                              <input type="text" class="form-control" name="city" value="{% if item.city is defined %}{{ item.city }}{% endif %}">
                                             </div>
                                        </div>
                                         <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">消费类型</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                 <input type="text" class="form-control" name="costname" value="{% if item.costname is defined %}{{ item.costname }}{% endif %}">
                                              </div>
                                         </div>
                                         <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">提现用户</label>
                                                  <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input type="text" class="form-control" name="realname" value="{% if item.realname is defined %}{{ item.realname }}{% endif %}">
                                             </div>
                                         </div>
                                        <div class="form-group">
                                                 <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">提现类型</label>
                                                   <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                   <select class="form-control" id="demo-vs-definput" name="withdrawtype">
                                                    <option value="3" class="{% if item.withdrawtype === 1 %}selected{% endif %} ">行内转账</option>
                                                    <option value="4"class="{% if item.withdrawtype === 2 %}selected{% endif %} ">同城跨行</option>
                                                    <option value="4"class="{% if item.withdrawtype === 3 %}selected{% endif %} ">异地跨行</option>
                                                   </select>
                                              </div>
                                        </div>
                                          <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
                                               <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                 <select class="form-control" id="demo-vs-definput" name="status">
                                                    <option value="3" class="{% if item.id === 1 %}selected{% endif %} ">审核通过</option>
                                                    <option value="4"class="{% if item.id === 0 %}selected{% endif %} ">审核中</option>
                                                    <option value="5"class="{% if item.id === 2 %}selected{% endif %} ">已完成</option>
                                                    <option value="5"class="{% if item.id === 3 %}selected{% endif %} ">信息有误</option>
                                                 </select>
                                              </div>
                                          </div>

                                    </form>
                                </div>
                            </div>
			</div>
			{%endif%}
			<div id="demo-lft-tab-2" class="tab-pane fade {% if show === 'edit' %} active in {% endif %}">
				<div class="panel">
					<div class="panel-heading">
						<h3 class="panel-title">提现列表</h3>
					</div>
					<div class="panel-body">
					<form class="form-horizontal" action="{{ apppath }}/userwithdraw/list?op=edit">
                           <div class="form-group">
                            <label class="col-xs-12 col-sm-3 col-md-1 control-label">关键字</label>
								<div class="col-xs-12 col-sm-9 col-md-6">
									<input type="text" name="keywords" value="{{ keywords }}" placeholder="请输入UID、用户姓名，查找用户" class="form-control">
								</div>
                            </div>
                            <div class="form-group">
                              <label class="col-xs-12 col-sm-3 col-md-1 control-label"></label>
                           <div class="col-xs-12 col-sm-9 col-md-6">
                             <input type="hidden" name="op" value="edit"/>
                             <button class="btn btn-info fa fa-search" type="submit">搜索</button>
                           </div>
                      </div>
                   </form>
						<div class="bootstrap-table">
							<div class="fixed-table-toolbar"></div>
							<div class="fixed-table-container" style="padding-bottom: 0px;">
								<div class="fixed-table-body">

										<input type="hidden" value="{{ apppath }}/userwithdraw/updata" id="urlPathPass">
										<table class="demo-add-niftycheck table table-hover" data-toggle="table" data-url="data/bs-table-simple.json" data-page-size="10" data-pagination="true">
											<thead>
											<tr>
												<th class="bs-checkbox " style="width: 36px; " data-field="state" tabindex="0">
													<div class="th-inner ">
														<input name="btSelectAll" type="checkbox" onclick="checkedAllPass(this)"></div>
													<div class="fht-cell"></div>
												</th>
												<th style="" data-field="id"  tabindex="0">
													<div class="th-inner ">ID</div>
													<div class="fht-cell"></div>
												</th>
												<th style="" data-field="id"  tabindex="0">
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
                                                	<div class="th-inner ">审核状态</div>
                                                	<div class="fht-cell"></div>
                                                </th>
                                                <th style="" data-field="amount" tabindex="0">
                                                    <div class="th-inner ">提现时间</div>
                                                    <div class="fht-cell"></div>
                                                </th>
                                                <th style="" data-field="amount" tabindex="0">
                                                    <div class="th-inner ">操作</div>
                                                    <div class="fht-cell"></div>
                                                </th>
											</tr>
											</thead>
											<tbody id="inputCheckPass">
											{% if withdraws is defined %}
												{% for items in withdraws %}
													{% if items is not scalar  %}
													{% for item in items %}
													<tr data-index="{{ row.id }}">
														<td class="bs-checkbox ">
															<input data-index="0" name="btSelectItem" type="checkbox" value="{{ item.id }}">
															{#<input type="hidden" name="id[]" value="{{ item.id }}">#}
														</td>
														<td style="">{{ item.id }}</td>
														<td style="">{{ item.uid }}</td>
														<td style="">{{ item.goldnumber }}</td>
														<td style="">{{ item.accountnumber }}</td>
														<td style="">

															{{item.realname}}
                                                        </td>
														<td style="">{{ item.bankaccount }}</td>
														<td style="">{{ item.province }}</td>
														<td style="">{{ item.city }}</td>
														<td style="">
															{% if item.withdrawtype ==='1' %}
																行内转账
															{% elseif item.withdrawtype ==='2' %}
																同城跨行
															{% elseif item.withdrawtype ==='3' %}
																异地跨行
															{% endif %}
														</td>
														<td style="">{{ item.costname }}</td>
														<td style="">
														{%if  item.status == 1%}已通过{%endif%}
														{%if item.status == 2%}已返回{%endif%}
														{%if item.status == 3%}信息有误{%endif%}
														{%if item.status == 0%}审核中{%endif%}
														</td>
														<td><?php echo date('Y-m-d H:i:s',$item->createtime)?></td>
														<td>
                                                        	<a href="{{apppath}}/userwithdraw/create?id={{ item.id }}">
                                                             <button class="btn btn-warning btn-labeled fa fa-edit">编辑</button>
                                                           </a>
                                                        </td>
													</tr>

													{% endfor %}
													{% endif %}
												{% endfor %}
											{% endif %}
											</tbody>
										</table>
									<div class="bars pull-left">
											<a href="{{apppath}}/userwithdraw/print">
											<button class="btn btn-info">
											<i class="demo-pli-cross"></i> 批量导出
											</button>
											</a>
											<button id="demo-delete-row" type="button" class="btn btn-info" onclick="updateDataPass()"><i class="demo-pli-cross"></i> 批量完成
											</button>
											<button id="demo-delete-row" type="button" class="btn btn-info" onclick="restorder()"><i class="demo-pli-cross"></i> 订单退回
											</button>
									</div>
								</div>
								<div class="panel-body text-center">
									{% if withdraws.total_pages >1 %}
										<ul class="pagination">
											<li><a href="{{apppath}}/UserWithdraw/list?op=edit&page=1{%if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
											<li><a href="{{apppath}}/UserWithdraw/list?op=edit&page={{ withdraws.before }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}">上一页</a></li>
											<li><a href="{{apppath}}/UserWithdraw/list?op=edit&page={{ withdraws.next }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}">下一页</a></li>
											<li><a href="{{apppath}}/UserWithdraw/list?op=edit&page={{ withdraws.total_pages }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
										</ul>
									{% endif %}
								</div>
							</div>
						</div>
						<div class="clearfix"></div>
					</div>
				</div>
				</div>
			</div>

		</div>
	</div>
</div>
<script>
//批量审核
function checkedAll(e){
	var check=$(e).prop("checked");
	var inputs=$("#childInput").find("input");
	if(check){
		inputs.each(function(){
			$(this).prop("checked",true);
		});

	}else{
		inputs.each(function(){
			$(this).prop("checked",false);
		});
	}
};
function updateData(){
	var data=[];
	var jump=$("#urlPath").val();
	var inputs=$("#childInput").find("input");
	inputs.each(function(){
		if($(this).prop("checked")){
			data.push($(this).val());
		}
	});
	$.ajax({
		type: "post",
		url: jump,
		data: {"name":data},
		success: function(data) {
			data = JSON.parse(data);
			if(data.code==0){
				alert(data.msg);
				window.location.href = "{{ apppath }}/userwithdraw/list?op=list";
			}else{
				alert(data.msg);
			}
		}
	})

}
//批量通过
function checkedAllPass(e){
	var check=$(e).prop("checked");
	var inputs=$("#inputCheckPass").find("input");
	if(check){
		inputs.each(function(){
			$(this).prop("checked",true);
		});
	}else{
		inputs.each(function(){
			$(this).prop("checked",false);
		});
	}
};
function updateDataPass(){
	var data=[];
	var jump=$("#urlPathPass").val();
	var inputs=$("#inputCheckPass").find("input");
	inputs.each(function(){
		if($(this).prop("checked")){
			data.push($(this).val());
		}
	});
	$.ajax({
		type: "post",
		url: jump,
		data: {"name":data},
		success: function(data) {
			data = JSON.parse(data);
			if(data.code==0){
				alert(data.msg);
				window.location.href = "{{ apppath }}/userwithdraw/list?op=list";
			}else{
				alert(data.msg);
			}
		}
	})

}
//订单撤回
function restorder(){
	var data=[];
	var jump=$("#urlPathPass").val();
	var inputs=$("#inputCheckPass").find("input");
	inputs.each(function(){
		if($(this).prop("checked")){
			data.push($(this).val());
		}
	});
	$.ajax({
		type: "post",
		url: "{{ apppath }}/userwithdraw/rest",
		data: {"name":data},
		success: function(data) {
			data = JSON.parse(data);
			if(data.code==0){
				alert(data.msg);
				window.location.href = "{{ apppath }}/userwithdraw/list?op=list";
			}else{
				alert(data.msg);
			}
		}
	})

}


//订单打印




</script>

<!-- 提现模块结束--!>
