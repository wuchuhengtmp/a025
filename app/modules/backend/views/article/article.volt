
<div class="nav-tabs-custom">
    <div class="tab-base">
        <ul class="nav nav-tabs">
            <li class="{% if show === 'list' %}active{% else %} {% endif %}">
                <a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show === 'list' %}true{% else %}false{% endif %}">文章列表</a>
            </li>
            <li class="{% if show === 'edit' %}active{% else %} {% endif %}">
                <a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="{% if show === 'edit' %}true{% else %}false{% endif %}">文章编辑</a>
            </li>
        </ul>
        <div class="tab-content">
            <div id="demo-lft-tab-1" class="tab-pane fade {% if show === 'list' %} active in {% endif %}">
                <div class="panel">
                    <div class="panel-body">
                        <div class="pad-btm form-inline">
                            <div class="row">
                                <div class="col-sm-6 table-toolbar-left">
                                    <button id="demo-btn-addrow" class="btn btn-purple" onclick="window.location.href='{{apppath}}/article/article/add'"><i class="demo-pli-add"></i> 添加文章</button>
                                </div>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th class="text-center">id</th>
                                    <th>文章分类</th>
                                    <th>文章标题</th>
                                    <th>文章来源</th>
                                    <th>阅读次数</th>
                                    <th>创建时间</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                                <tbody>
								{% for row in articleList %}
                                <tr>
                                    <td><i> {{ row.id }}</i></td>
                                    <td>
                                    {% if preid is defined %}
                                    {% for rows in preid %}
                                    	{% if row.cid === rows.id%}{{ rows.title}}{% endif %}
                                    {% endfor %}
                                    {% endif %}
                                    </td>
                                    <td><span class="text-muted"><i class="demo-pli-clock"></i> {{row.title}}</span></td>
                                    <td>
                                        <div class="label label-table label-success">{{ row.from }}</div>
                                    </td>
                                    <td>{{ row.readtimes|default('1') }}</td>
                                    <td><?php echo date('Y-m-d H:i:s',$row->createTime)?></td>
                                    <td>
                                        <a href="{{ apppath }}/article/article/edit/{{ row.id }}" class="btn btn-default btn-sm" title="编辑"><i class="fa fa-edit"></i></a>
										<a href="{{ apppath }}/article/article/del/{{ row.id }}" class="btn btn-default btn-sm"  title="删除" onclick="window.alert('确定删除？')" ><i class="fa fa-trash"></i></a>
                                    </td>
                                </tr>
								{% endfor %}
                                </tbody>
                            </table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="{{apppath}}/article/article/page/1" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/article/article/page/{% if pages is defined %}{{ pages.before }}{% else %}1{% endif %}">上一页</a></li>
									<li><a href="{{apppath}}/article/article/page/{% if pages is defined %}{{  pages.next }}{% else %}1{% endif %}">下一页</a></li>
									<li><a href="{{apppath}}/article/article/page/{% if pages is defined %}{{ pages.last }}{% else %}1{% endif %}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							</div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="demo-lft-tab-2" class="tab-pane fade {% if show === 'edit' %} active in {% endif %}">
                    <div class="panel">
                        <form class="panel-body form-horizontal form-padding " method="post"  action="{{apppath}}/article/article/list">
                            <!--Static-->
                            【*为必填项】
							<div class="form-group">

								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">分类</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select class="form-control" id="demo-vs-definput" name="cid">
										<option value="3" class="{% if item.id === 3 %}selected{% endif %} ">通知公告</option>
										<option value="4"class="{% if item.id === 4 %}selected{% endif %} ">行业新闻</option>
										<option value="5"class="{% if item.id === 5 %}selected{% endif %} ">首页攻略</option>
									</select>
								</div>
							</div>
                            <div class="form-group">
                                <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">文章标题*</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input type="text" class="form-control" name="title" value="{% if item.title is defined %}{{ item.title }}{% endif %}">
								</div>
                            </div>
                            {#
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">缩略图</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									{% if item is defined %}
										<?=Dhc\Component\MyTags::tpl_upload_images("thumb",$item->thumb)?>
									{% else %}
										<?=Dhc\Component\MyTags::tpl_upload_images("thumb")?>
									{% endif %}
								</div>
							</div>#}
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label" for="demo-email-input" >文章来源*</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input type="text" class="form-control" name="from" value="{% if item.from is defined %}{{ item.from }}{% endif %}">
								</div>
							</div>
                            <div class="form-group">
                                <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label" for="demo-textarea-input">简述*</label>
                                <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                    <textarea id="demo-textarea-input" rows="9" class="form-control" placeholder="简述" name="description">{% if item.description is defined %}{{ item.description }}{% endif %}</textarea>
                                </div>
                            </div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label" for="demo-textarea-input">文章内容*</label>
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
								<button class="btn btn-success" type="submit">添加</button>
							</div>
                        </form>
                    </div>
                </div>

    </div>
	</div>
</div>
<!--文章模块结束--!>
