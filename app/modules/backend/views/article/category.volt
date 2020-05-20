<!--文章模块开始-->
<p><?php $this->flash->output();?></p>
<div class="nav-tabs-custom">
    <div class="tab-base">
        <!--Nav Tabs-->
        <ul class="nav nav-tabs">
            <li class=" {% if show === 'list' %} active {% else %} {% endif %}">
                <a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show === 'list' %}true{% else %}false{% endif %}">文章分类</a>
            </li>
            <li class="{% if show === 'edit' %} active {% else %} {% endif %}">
                <a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="{% if show === 'edit' %}true{% else %}false{% endif %}">分类编辑</a>
            </li>
        </ul>
        <!--Tabs Content-->
        <div class="tab-content">
            <div id="demo-lft-tab-1" class="tab-pane fade {% if show === 'list' %} active in {% endif %}">
                <div class="panel">
                    <div class="panel-body">
                        <div class="pad-btm form-inline">
                            <div class="row">
                                <div class="col-sm-6 table-toolbar-left">
                                    <button id="demo-btn-addrow" class="btn btn-purple" onclick="window.location.href='{{apppath}}/article/category?op=edit'" style="display:none">添加分类</button>
                                </div>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th class="text-center">id</th>
                                    <th>上级分类</th>
                                    <th>分类名称</th>
                                    <th>备注</th>
                                    <th>创建时间</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                                <tbody>
								{% for rows in categoryList %}
									{% if rows is not scalar  %}
										{%  for row in rows %}
									<tr>
										<td><i>{{ row.id }}</i></td>
										<td>{{ row.pid }}</td>
										<td><span class="text-muted"><i class="demo-pli-clock">{{ row.title }}</i></span></td>
										<td>
											{{ row.remark }}
										</td>
										<td><?php echo date('Y-m-d H:i:s',$row->createtime)?></td>
										<td>
											<a href="{{apppath}}/article/category?op=edit&id={{ row.id }}" class="btn btn-default btn-sm" title="编辑"><i class="fa fa-edit"></i></a>
											<a href="{{apppath}}/article/category?op=del&id={{ row.id }}" class="btn btn-default btn-sm" title="删除" onclick="window.alert('确定删除？')" style="display:none"><i class="fa fa-trash"></i></a>
										</td>
									</tr>
										{% endfor %}
								{% endif %}
								{% endfor %}
                                </tbody>
                            </table>
							<div class="panel-body text-center" style="display:none">
								<ul class="pagination">
									<li><a href="{{apppath}}/article/category?op=list&page=1" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/article/category?op=list&page={{ categoryList.before }}">上一页</a></li>
									<li><a href="{{apppath}}/article/category?op=list&page={{ categoryList.last }}">下一页</a></li>
									<li><a href="{{apppath}}/article/category?op=list&page={{ categoryList.total_pages }}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							</div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="demo-lft-tab-2" class="tab-pane fade {% if show === 'edit' %} active in {% endif %}">
                <div class="panel">
                    <form class="panel-body form-horizontal form-padding " method="post" action="{{ apppath }}/article/category?op=list">
                        <div class="form-group">
                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">上级分类</label>
                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<select class="form-control" id="demo-vs-definput" name="pid">
									<option value="0">0</option>
									{% for pids in preid %}
										{% if item.id is defined %}
												<option value="{{ pids.id }}" class="{% if item.id === pids.id %}select{% endif %} ">{{ pids.id }}</option>
											{% else %}
												<option value="{{ pids.id }}">{{ pids.id }}</option>
										{% endif %}
									{% endfor %}
								</select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">分类名称</label>
                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                <input class="form-control" id="demo-vs-definput" type="text" name="title" value="{% if item.title is defined %}{{ item.title }}{% endif %}">
                            </div>
                        </div>

						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">图标</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								{% if item is defined %}
									<?=Dhc\Component\MyTags::tpl_upload_images("icon",$item->icon)?>
								{% else %}
									<?=Dhc\Component\MyTags::tpl_upload_images("icon")?>
								{% endif %}
							</div>
						</div>
                        <div class="form-group">
                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">备注</label>
                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                <input class="form-control" id="demo-vs-definput" type="text" name="remark" value="{% if item.remark is defined %}{{ item.remark }}{% endif %}">
                            </div>
                        </div>

                        <div class="panel-footer text-left">
							<input type="hidden" value="{% if item.id is defined %}{{ item.id }}{% endif %}" name="id">
                            <button class="btn btn-success" type="submit">添加</button>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
    <!--文章模块结束-->
