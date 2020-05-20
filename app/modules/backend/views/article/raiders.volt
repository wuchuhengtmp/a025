
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if show === 'list' %}active{% else %} {% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show === 'list' %}true{% else %}false{% endif %}">攻略列表</a>
			</li>
			<li class="{% if show === 'edit' %}active{% else %} {% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="{% if show === 'edit' %}true{% else %}false{% endif %}">攻略审核</a>
			</li>
			<li class="{% if show === 'wait' %}active{% else %} {% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-3" aria-expanded="{% if show === 'wait' %}true{% else %}false{% endif %}">待审核</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if show === 'list' %} active in {% endif %}">
				<div class="panel">
					<div class="panel-body">
						{#<div class="pad-btm form-inline">#}
							{#<div class="row">#}
								{#<div class="col-sm-6 table-toolbar-left">#}
									{#<button id="demo-btn-addrow" class="btn btn-purple" onclick="window.location.href='{{apppath}}/article/raiders?op=add'"><i class="demo-pli-add"></i> 发表攻略</button>#}
								{#</div>#}
							{#</div>#}
						{#</div>#}
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th class="text-center">id</th>
									<th>攻略标题</th>
									<th>攻略内容</th>
									<th>审核状态</th>
									<th>发表日期</th>
									<th>阅读类型</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
									{% if rlist is defined %}
										{% for rows in rlist %}
											{% if rows is not scalar  %}
											{% for row in rows %}
									<tr>
										<td><i>{{ row.id }}</i></td>
										<td>{{ row.title }}</td>
										<td><span class="text-muted contentSub">{{ row.content }}</span></td>
										<td>
											<div class="label label-table label-success">{% if row.status ==='1' %}审核通过{% elseif row.status === '-1'%}审核未通过{% else %}待审核{% endif %}</div>
										</td>
										<td><?php echo date('Y-m-d H:i:s',$row->createtime)?></td>
										<td>{% if row.type === '1' %}付费阅读{% else %}免费阅读{% endif %}</td>
										<td>
											<a href="{{ apppath }}/article/raiders?op=edit&id={{ row.id }}" class="btn btn-default btn-sm" title="编辑"><i class="fa fa-edit"></i></a>
											<a href="{{ apppath }}/article/raiders?op=del&id={{ row.id }}" class="btn btn-default btn-sm" title="删除" onclick="window.alert('确定删除？')"><i class="fa fa-trash"></i></a>
										</td>
									</tr>

										{#{% endfor %}#}
									{% endfor %}
												{% endif %}
									{% endfor %}
								{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="{{apppath}}/article/raiders?op=list&page=1" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/article/raiders?op=list&page={{ rlist.before }}">上一页</a></li>
									<li><a href="{{apppath}}/article/raiders?op=list&page={{ rlist.next }}">下一页</a></li>
									<li><a href="{{apppath}}/article/raiders?op=list&page={{ rlist.total_pages }}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="demo-lft-tab-2" class="tab-pane fade {% if show === 'edit' %} active in {% endif %}">
				<div class="panel">
					<form class="panel-body form-horizontal form-padding " method="post"  action="{{apppath}}/article/raiders?op=list">
						<!--Static-->
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">攻略类型</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<select class="form-control" id="demo-vs-definput" name="cid">
								<option value="1" {% if item.type is defined %}{% if item.type === '1' %}selected{% else %}{% endif %}{% endif %}>付费攻略</option>
								<option value="0"{% if item.type is defined %}{% if item.type === '0' %}selected{% else %}{% endif %}{% endif %}>免费攻略</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">攻略标题</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input type="text" class="form-control" name="title" value="{% if item.title is defined %}{{ item.title }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label" for="demo-email-input" >文章作者</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input type="text" class="form-control" name="auth" value="{% if item.auth is defined %}{{ item.auth }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">审核</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<select class="form-control" id="demo-vs-definput" name="status">
									<option value="1" {% if item.status is defined %}{% if item.status === '1' %}selected{% endif %}{% endif %}>通过</option>
									<option value="-1" {% if item.status is defined %}{% if item.status === '-1' %}selected{% endif %}{% endif %}>不通过</option>
									<option value="0" {% if item.status is defined %}{% if item.status === '0' %}selected{% endif %}{% endif %}>待审核</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label" for="demo-email-input" >审核结果</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input type="text" placeholder="通过或者不通过原因" class="form-control" name="reason" value="{% if item.reason is defined %}{{ item.reason }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label" for="demo-textarea-input">文章内容</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								{% if item is defined %}
									<?php echo Dhc\Component\MyTags::tpl_ueditor('content',$item->content)?>
								{% else %}
									<?php  echo Dhc\Component\MyTags::tpl_ueditor('content')?>
								{% endif %}
							</div>
						</div>
						<div class="panel-footer text-left">
							<input type="hidden" value="{% if item.id is defined %}{{ item.id }}{% endif %}" name="id">
							<button class="btn btn-success" type="submit">确定</button>
						</div>
					</form>
				</div>
			</div>
			<div id="demo-lft-tab-3" class="tab-pane fade {% if show === 'wait' %} active in {% endif %}">
				<div class="panel">
					<div class="panel-body">
						{#<div class="pad-btm form-inline">#}
						{#<div class="row">#}
						{#<div class="col-sm-6 table-toolbar-left">#}
						{#<button id="demo-btn-addrow" class="btn btn-purple" onclick="window.location.href='{{apppath}}/article/raiders?op=add'"><i class="demo-pli-add"></i> 发表攻略</button>#}
						{#</div>#}
						{#</div>#}
						{#</div>#}
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th class="text-center">id</th>
									<th>攻略标题</th>
									<th>攻略内容</th>
									<th>审核状态</th>
									<th>发表日期</th>
									<th>阅读类型</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
								{% if wlist is defined %}
									{% for rs in wlist %}
										{% if rs is not scalar  %}
											{% for r in rs %}
												<tr>
													<td><i>{{ r.id }}</i></td>
													<td>{{ r.title }}</td>
													<td><span class="text-muted"><i class="demo-pli-clock"></i> {{ r.content }}</span></td>
													<td>
														<div class="label label-table label-success">{% if r.status ==='1' %}审核通过{% elseif r.status === '-1'%}审核未通过{% else %}待审核{% endif %}</div>
													</td>
													<td><?php echo date('Y-m-d H:i:s',$r->createtime)?></td>
													<td>{% if r.type === '1' %}付费阅读{% else %}免费阅读{% endif %}</td>
													<td>
														<a href="{{ apppath }}/article/raiders?op=edit&id={{ r.id }}" class="btn btn-default btn-sm" title="编辑"><i class="fa fa-edit"></i></a>
														<a href="{{ apppath }}/article/raiders?op=del&id={{ r.id }}" class="btn btn-default btn-sm" title="删除" onclick="window.alert('确定删除？')"><i class="fa fa-trash"></i></a>
													</td>
												</tr>
											{% endfor %}
										{% endif %}
									{% endfor %}
								{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="{{apppath}}/article/raiders?op=wait&page=1" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/article/raiders?op=wait&page={{ wlist.before }}">上一页</a></li>
									<li><a href="{{apppath}}/article/raiders?op=wait&page={{ wlist.last }}">下一页</a></li>
									<li><a href="{{apppath}}/article/raiders?op=wait&page={{ wlist.total_pages }}" class="demo-pli-arrow-right">尾页</a></li>
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
<script>
window.onload=function(){
	var contentSubAll=document.getElementsByClassName("contentSub");
    	for(var i=0;i<contentSubAll.length;i++){
    		var tempText=contentSubAll[i].innerHTML;
    		if(tempText.length>=20){
    			tempText=tempText.substr(0,20);
    			contentSubAll[i].innerHTML=tempText+"……";
    		}

    	}
}




</script>

