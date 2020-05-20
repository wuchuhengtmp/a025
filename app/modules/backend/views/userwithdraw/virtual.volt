
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
								<form class="form-horizontal" method='get' action="{{ apppath }}/userwithdraw/virtual?op=list">
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
										<input type="hidden" id="urlPath" value="{{ apppath }}/userwithdraw/Vupdata">
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
												<div class="th-inner ">提现金币数量</div><div class="fht-cell"></div>
											</th>
											<th style="" data-field="date" tabindex="0">
												<div class="th-inner ">提现数量</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
												<div class="th-inner ">收货地址</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
												<div class="th-inner ">提现时间</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
												<div class="th-inner ">兑换比例</div>
												<div class="fht-cell"></div>
											</th>
											<th style="" data-field="amount" tabindex="0">
												<div class="th-inner ">审核状态</div>
												<div class="fht-cell"></div>
											</th>
										</tr>
										</thead>
										<tbody id="childInput">
										{% if list is defined %}
											{% for row in list['list'] %}
												{% if row['status'] === '0' %}
														<tr data-index="{{ row['id'] }}">
															<td class="bs-checkbox ">
																<input data-index="0" name="btSelectItem[]" type="checkbox" value="{{ row['id'] }}">
															</td>
															<td style="">{{ row['id'] }}</td>
															<td style="">{{ row['uid'] }}</td>
															<td style="">{{ row['goldnumber'] }}</td>
															<td style="">{{ row['number'] }}</td>
															<td style="">
															{{ row['address'] }}
															</td>
															<td><?php echo date('Y-m-d H:i:s',$row['createtime'])?></td>
															<td style="">{{ row['rebate'] }}</td>
															<td style="">
																{%if  row['status'] == 1%}已通过{%endif%}
                                                            	{%if row['status'] == 2%}已返回{%endif%}
                                                            	{%if row['status'] == 3%}信息有误{%endif%}
                                                            	{%if row['status'] == 0%}审核中{%endif%}
															</td>
														</tr>
												{% endif %}
											{% endfor %}
										{% endif %}
										</tbody>
									</table>
										<div class="bars pull-left">
											<button id="demo-delete-row"  type="button"  onclick="updateData()" class="btn btn-info"><i class="demo-pli-cross"></i>批量审核</button>
										</div>
									</form>
								</div>
								<div class="panel-body text-center">
									{% if list['total_pages'] > 1 %}
										<ul class="pagination">
											<li><a href="{{apppath}}/userwithdraw/virtual?op=list&page=1{%if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
											<li><a href="{{apppath}}/userwithdraw/virtual?op=list&page={{ list['before'] }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}">上一页</a></li>
											<li><a href="{{apppath}}/userwithdraw/virtual?op=list&page={{ list['next'] }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}">下一页</a></li>
											<li><a href="{{apppath}}/userwithdraw/virtual?op=list&page={{ list['total_pages'] }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
										</ul>
									{% endif %}
								</div>
							</div>
						</div>
						<div class="clearfix"></div>
					</div>	</div>
			</div>
			<div id="demo-lft-tab-2" class="tab-pane fade {% if show === 'edit' %} active in {% endif %}">
				<div class="panel">
					<div class="panel-heading">
						<h3 class="panel-title">提现列表</h3>
					</div>
					<div class="panel-body">
					<form class="form-horizontal" action="{{ apppath }}/userwithdraw/virtual?op=edit">
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

										<input type="hidden" value="{{ apppath }}/userwithdraw/Vupdata" id="urlPathPass">
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
													<div class="th-inner ">提现金币数量</div><div class="fht-cell"></div>
												</th>
												<th style="" data-field="date" tabindex="0">
													<div class="th-inner ">提现数量</div>
													<div class="fht-cell"></div>
												</th>
												<th style="" data-field="amount" tabindex="0">
													<div class="th-inner ">收货地址</div>
													<div class="fht-cell"></div>
												</th>
												<th style="" data-field="amount" tabindex="0">
													<div class="th-inner ">提现时间</div>
													<div class="fht-cell"></div>
												</th>
												<th style="" data-field="amount" tabindex="0">
													<div class="th-inner ">兑换比例</div>
													<div class="fht-cell"></div>
												</th>
												<th style="" data-field="amount" tabindex="0">
													<div class="th-inner ">审核状态</div>
													<div class="fht-cell"></div>
												</th>
											</tr>
											</thead>
											<tbody id="inputCheckPass">
											{% if item is defined %}
												{% for items in item['list'] %}
													<tr data-index="{{ items['id'] }}">
														<td class="bs-checkbox ">
															<input data-index="0" name="btSelectItem" type="checkbox" value="{{ items['id'] }}">
															{#<input type="hidden" name="id[]" value="{{ item['id'] }}">#}
														</td>
														<td style="">{{ items['id'] }}</td>
														<td style="">{{ items['uid'] }}</td>
														<td style="">{{ items['goldnumber'] }}</td>
														<td style="">{{ items['number'] }}</td>
														<td style="">
															{{items['address']}}
                                                        </td>
                                                        <td><?php echo date('Y-m-d H:i:s',$items['createtime'])?></td>
														<td style="">{{ items['rebate'] }}</td>
														<td style="">
														{%if  items['status'] == 1%}已通过{%endif%}
														{%if items['status'] == 2%}已返回{%endif%}
														{%if items['status']== 3%}信息有误{%endif%}
														{%if items['status'] == 0%}审核中{%endif%}
														</td>
													</tr>
												{% endfor %}
											{% endif %}
											</tbody>
										</table>
									<div class="bars pull-left">
											<a href="{{apppath}}/userwithdraw/Vprint&op=list">
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
									{% if item['total_pages'] >1 %}
										<ul class="pagination">
											<li><a href="{{apppath}}/userwithdraw/virtual?op=edit&page=1{%if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
											<li><a href="{{apppath}}/userwithdraw/virtual?op=edit&page={{ item['before'] }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}">上一页</a></li>
											<li><a href="{{apppath}}/userwithdraw/virtual?op=edit&page={{ item['next'] }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}">下一页</a></li>
											<li><a href="{{apppath}}/userwithdraw/virtual?op=edit&page={{ item['total_pages'] }}{%if keywords is defined%}&keywords={{keywords}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
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
	var jump= "{{ apppath }}/userwithdraw/Vupdatas";
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
				window.location.href = "{{ apppath }}/userwithdraw/virtual?op=list";
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
				window.location.href = "{{ apppath }}/userwithdraw/virtual?op=list";
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
		url: "{{ apppath }}/userwithdraw/Vrest",
		data: {"name":data},
		success: function(data) {
			data = JSON.parse(data);
			if(data.code==0){
				alert(data.msg);
				window.location.href = "{{ apppath }}/userwithdraw/virtual?op=list";
			}else{
				alert(data.msg);
			}
		}
	})

}


//订单打印




</script>

<!-- 提现模块结束--!>
