
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="true">审核列表</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade  active in ">
				<div class="panel">
					<div class="panel-heading">
						<h3 class="panel-title">审核列表</h3>
					</div>
					<div class="panel-body">
						<div class="bootstrap-table">
							<div class="fixed-table-toolbar"></div>
							<div class="fixed-table-container" style="padding-bottom: 0px;">
								<div class="fixed-table-body">
									<form method="post" >
										<input type="hidden" id="urlPath" value="{{ apppath }}/user/passIdcard">
										<input type="hidden" id="urlPaths" value="{{ apppath }}/user/returncard">
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
                                                <div class="th-inner ">真实姓名</div>
                                                <div class="fht-cell"></div>
                                             </th>
											<th style="" data-field="name" tabindex="0">
												<div class="th-inner ">正面照</div><div class="fht-cell"></div>
											</th>
											<th style="" data-field="date" tabindex="0">
												<div class="th-inner ">反面照</div>
												<div class="fht-cell"></div>
											</th>

										</tr>
										</thead>
										<tbody id="childInput">
										{% if userlist is defined %}
											{% for row in userlist['list'] %}
													<tr data-index="{{ row['id'] }}">
															<td class="bs-checkbox ">
																<input data-index="0" name="btSelectItem[]" type="checkbox" value="{{ row['id'] }}">
															</td>
															<td style="">{{ row['id'] }}</td>

															<td style="">{{ row['realname'] }}</td>
															<td style=""><img src="{{ row['idcardFront'] }}"></td>
															<td style=""><img src="{{ row['idcardback'] }}"></td>
													</tr>
												{% endfor %}
										{% endif %}
										</tbody>
									</table>
										<div class="bars pull-left">
											<button id="demo-delete-row"  type="button"  onclick="updateData()" class="btn btn-info"><i class="demo-pli-cross"></i>批量审核</button>
											<button id="demo-delete-row"  type="button"  onclick="returnData()" class="btn btn-info"><i class="demo-pli-cross"></i>批量退回</button>
										</div>
									</form>
								</div>
								<div class="panel-body text-center">
									{% if userlist['total_pages'] >1 %}
										<ul class="pagination">
											<li><a href="{{apppath}}/UserWithdraw/list?op=list&page=1" class="demo-pli-arrow-right">首页</a></li>
											<li><a href="{{apppath}}/UserWithdraw/list?op=list&page={{ userlist['before'] }}">上一页</a></li>
											<li><a href="{{apppath}}/UserWithdraw/list?op=list&page={{ userlist['next'] }}">下一页</a></li>
											<li><a href="{{apppath}}/UserWithdraw/list?op=list&page={{ userlist['total_pages'] }}" class="demo-pli-arrow-right">尾页</a></li>
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
				window.location.href = "{{ apppath }}/user/idcard";
			}else{
				alert(data.msg);
			}
		}
	})

}
function returnData(){
	var data=[];
	var jump=$("#urlPaths").val();
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
				window.location.href = "{{ apppath }}/user/idcard";
			}else{
				alert(data.msg);
			}
		}
	})

}

</script>

<!-- 提现模块结束--!>
