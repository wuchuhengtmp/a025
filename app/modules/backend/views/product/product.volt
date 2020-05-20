
<!--文章模块开始-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if show === 'list' %}active{% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show === 'list' %}true{% else %}false{% endif %}">产品列表</a>
			</li>
			{% if show === 'edit' %}
			<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="{% if show === 'edit' %}true{% else %}false{% endif %}">产品编辑</a>
			</li>
			{% endif %}
			{% if show === 'use' %}
            			<li class="active">
            				<a data-toggle="tab" href="#demo-lft-tab-3" aria-expanded="{% if show === 'edit' %}true{% else %}false{% endif %}">使用奖励</a>
            			</li>
            			{% endif %}
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if show === 'list' %} active in{% endif %}">
				<div class="panel">
					<div class="panel-body">

						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
								<tr>
									<th class="text-center">id</th>
									<th>产品名称</th>
									<th>初始价格</th>
									<th>创建时间</th>
									<th>状态</th>
									<th>手续费</th>
									<th>涨幅</th>
									<th>跌幅</th>
									<th>操作</th>
								</tr>
								</thead>
								<tbody>
								{% for row in product %}
									<tr>
										<td><i> {{ row.id }}</i></td>
										<td><i> {{ row.title }}</i></td>
										<td>{{ row.startprice }}</td>
										<td><span class="text-muted"><i class="demo-pli-clock"></i> <?php echo date('Y-m-d H:i:s',$row->createtime)?></span></td>
										<td>
											<div class="label label-table label-success">{% if row.status is '1' %}启用{% elseif row.status is '0' %}停用{% endif %}</div>
										</td>
										<td>{{ row.poundage }}</td>
										<td >{{ row.rise }}</td>
										<td>{{ row.fall }}</td>
										<td>
											<a href="{{apppath}}/product/product/edit/{{ row.id }}" class="btn btn-default btn-sm" title="编辑"><i class="fa fa-edit"></i></a>
											{% if row.id !=1 %}
											    <a href="{{apppath}}/product/product/use/{{ row.id }}" class="btn btn-default btn-sm" title="使用奖励"><i class="fa fa-edit"></i>使用奖励</a>
            			                    {% endif %}
										</td>
									</tr>
								{% endfor %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								<ul class="pagination">
									<li><a href="{{apppath}}/product/product/page/1" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/product/product/page/{% if pagenow is defined %}{{ pagenow-1 }}{% else %}1{% endif %}">上一页</a></li>
									<li><a href="{{apppath}}/product/product/page/{% if pagenow is defined %}{{ pagenow+1 }}{% else %}1{% endif %}">下一页</a></li>
									<li><a href="{{apppath}}/product/product/page/{% if tpage is defined %}{{ tpage }}{% else %}1{% endif %}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="demo-lft-tab-2" class="tab-pane fade {% if show === 'edit' %} active in{% endif %}">
				<div class="panel">
					<form class="panel-body form-horizontal form-padding " method="post"  action="{{apppath}}/product/product/list">
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">产品名称</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input type="text" class="form-control" name="title" value="{% if item.title is defined %}{{ item.title }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">产品图片</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								{% if item is defined %}
									<?=Dhc\Component\MyTags::tpl_upload_images("thumb",$item->thumb)?>
								{% else %}
									<?=Dhc\Component\MyTags::tpl_upload_images("thumb")?>
								{% endif %}
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">初始价格</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" id="demo-vs-definput"  name="startprice" value="{% if item.startprice is defined %}{{ item.startprice }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label" for="demo-email-input" >状态</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<select name="status" class="form-control"  id="demo-vs-definput" >
									<option value="1" {% if item.status is defined %}{% if item.status === '1' %} selected {% endif %}{% endif %}>启用</option>
									<option value="0" {% if item.status is defined %}{% if item.status === '0' %} selected {% endif %}{% endif %}>停用</option>
								</select>
							</div>
						</div>
						<div class="form-group">
                        							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label" for="demo-email-input" >交易状态</label>
                        							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                        								<select name="tradeStatus" class="form-control"  id="demo-vs-definput" >
                        									<option value="1" {% if item.tradeStatus is defined %}{% if item.tradeStatus === '1' %} selected {% endif %}{% endif %}>开启</option>
                        									<option value="0" {% if item.tradeStatus is defined %}{% if item.tradeStatus === '0' %} selected {% endif %}{% endif %}>关闭</option>
                        								</select>
                        							</div>
                        						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">涨幅</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" id="demo-vs-definput"  name="rise" value="{% if item.rise is defined %}{{ item.rise }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
                        							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">排序顺序</label>
                        							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                        								<input class="form-control" id="demo-vs-definput"  name="displayorder" value="{% if item.displayorder is defined %}{{ item.displayorder }}{% endif %}">
                        							</div>
                        						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">跌幅</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" id="demo-vs-definput"  name="fall" value="{% if item.fall is defined %}{{ item.fall }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">手续费</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" id="demo-vs-definput"  name="poundage" value="{% if item.poundage is defined %}{{ item.poundage }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">简介</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" name="depict" value="{% if item.depict is defined %}{{ item.depict }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">种子周期/小时</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" name="seedTime" value="{% if item.seedTime is defined %}{{ item.seedTime }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">发芽周期/小时</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" name="sproutingTime" value="{% if item.sproutingTime is defined %}{{ item.sproutingTime }}{% endif %}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">生长周期/小时</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" name="growTime" value="{% if item.growTime is defined %}{{ item.growTime }}{% endif %}">
							</div>
						</div>
						<div class="panel-footer text-left">
							<input type="hidden" value="{% if item.id is defined %}{{ item.id }}{% endif %}" name="id">
							<button class="btn btn-success" type="submit">添加</button>
						</div>
					</form>
					<!--===================================================-->
					<!-- END BASIC FORM ELEMENTS -->
				</div>
			</div>
            <div id="demo-lft-tab-3" class="tab-pane fade {% if show === 'use' %} active in{% endif %}">
                <div class="panel">
                    <form class="panel-body form-horizontal form-padding " method="post"  action="{{apppath}}/product/product/saveuse">
						<div class="form-group">
							<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">当前果实</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input class="form-control" value="{% if item.title is defined %}{{ item.title }}{% endif %}" readonly="readonly">
							</div>
						</div>
						<div class="input-group">
                            <span class="input-group-addon">空奖品概率</span>
								<input class="form-control" name="chanceInfo[nullpercent]" value="{% if chanceInfo['nullpercent'] is defined %}{{ chanceInfo['nullpercent'] }}{% endif %}">
                            <span class="input-group-addon">%</span>
						</div>
						<div class="input-group">
                            <span class="input-group-addon">奖品描述</span>
								<input class="form-control" name="chanceInfo[desc]" value="{% if chanceInfo['desc'] is defined %}{{ chanceInfo['desc'] }}{% endif %}">
						</div>
                        <div class="input-group">
                            <span class="input-group-addon">金币</span>
                            <input type="hidden" name="chanceInfo[win][0][tid]" value="diamonds" >
                            <span class="input-group-addon">获得概率</span>
                            <input type="text" name="chanceInfo[win][0][percent]" value="{% if chanceInfo['win'] is not empty and chanceInfo['win'][0] is not empty and chanceInfo['win'][0]['percent'] >= 0 %}{{ chanceInfo['win'][0]['percent'] }}{% endif %}" class="form-control" title="">
                            <span class="input-group-addon">%，最少数量</span>
                            <input type="text" name="chanceInfo[win][0][min]" value="{% if chanceInfo['win'] is not empty and chanceInfo['win'][0] is not empty and chanceInfo['win'][0]['min'] >= 0 %}{{ chanceInfo['win'][0]['min'] }}{% endif %}" class="form-control" title="">
                            <span class="input-group-addon">，最多数量</span>
                            <input type="text" name="chanceInfo[win][0][max]" value="{% if chanceInfo['win'] is not empty and chanceInfo['win'][0] is not empty and chanceInfo['win'][0]['max'] >= 0 %}{{ chanceInfo['win'][0]['max'] }}{% endif %}" class="form-control" title="">
                        </div>
                        {% set list=list %}
                        {% for index in 0..list|length-1 %}
                            <div class="input-group">
                                <span class="input-group-addon">{{list[index].tName}}</span>
                                <input type="hidden" name="chanceInfo[win][{{index+1}}][tid]" value="{{list[index].tId}}" >
                                <span class="input-group-addon">获得概率</span>
                                <input type="text" name="chanceInfo[win][{{index+1}}][percent]" value="{% if chanceInfo['win'] is not empty and chanceInfo['win'][index+1] is not empty and chanceInfo['win'][index+1]['percent'] >= 0 %}{{ chanceInfo['win'][index+1]['percent'] }}{% endif %}" class="form-control" title="">
                                <span class="input-group-addon">%，最少数量</span>
                                <input type="text" name="chanceInfo[win][{{index+1}}][min]" value="{% if chanceInfo['win'] is not empty and chanceInfo['win'][index+1] is not empty and chanceInfo['win'][index+1]['min'] >= 0 %}{{ chanceInfo['win'][index+1]['min'] }}{% endif %}" class="form-control" title="">
                                <span class="input-group-addon">，最多数量</span>
                                <input type="text" name="chanceInfo[win][{{index+1}}][max]" value="{% if chanceInfo['win'] is not empty and chanceInfo['win'][index+1] is not empty and chanceInfo['win'][index+1]['max'] >= 0 %}{{ chanceInfo['win'][index+1]['max'] }}{% endif %}" class="form-control" title="">
                            </div>
                        {% endfor %}
						<div class="panel-footer text-left">
							<input type="hidden" value="{% if item.id is defined %}{{ item.id }}{% endif %}" name="id">
							<button class="btn btn-success" type="submit">保存</button>
						</div>
                    </form>
                    <!--===================================================-->
                    <!-- 果实使用奖励 -->
                </div>
            </div>
		</div>
	</div>
</div>
<!--文章模块结束--!>
