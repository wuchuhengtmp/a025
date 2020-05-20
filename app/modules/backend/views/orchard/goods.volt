<?php $this->flashSession->output(); ?>
<!--商品信息-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if op is defined %}{% if op == 'display' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/goods?op=display&page={{goodsList.current}}&status={{status}}" aria-expanded="{% if op is defined %}{% if op == 'display' %}true{% else %} false{% endif %}{% endif %}">商品列表</a>
			</li>
			{% if tId != 0%}
			<li class="{% if op is defined %}{% if op == 'post' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/goods?op=post&page={{goodsList.current}}" aria-expanded="{% if op is defined %}{% if op == 'post' %}true{% else %} false{% endif %}{% endif %}">商品编辑</a>
			</li>
			{% endif %}
		</ul>
		{% if op == 'display' %}
		<div class="tab-content">

			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined %}{% if op == 'display' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-hover">
								<thead>
									<tr>
										<th>商品ID</th>
										<th>商品类型</th>
										<th>商品名称</th>
										<th>商品价格</th>
										<th>商品描述</th>
										<th>状态</th>
										<th>创建时间</th>
										<th>更新时间</th>
										<th>操作</th>
									</tr>
								</thead>
								<tbody>
								{% if goodsList is defined %}
								{% for list in goodsList %}
								{% if list is not scalar %}
								{% for rows in list %}
								<tr>
									<td>{{ rows.tId }}</td>
									<td>
										{% for key,row  in  toolType %}
										{% if key == rows.type %}
										{{ row }}
										{% endif %}
										{% endfor%}
									</td>
									<td>{{ rows.tName }}</td>
									<td>{{ rows.price }}</td>
									<td>{{ rows.depict }}</td>
									<td>
										{% if rows.status == '1' %}
											正常
										{% elseif rows.status == '0' %}
											禁用
										{% else %}
											异常
										{% endif %}
									</td>
									<td>{{ date("Y-m-d H:i:s",rows.createtime) }}</td>
									<td>{{ date("Y-m-d H:i:s",rows.updatetime) }}</td>
									<td>
										<a href="{{ apppath }}/orchard/goods?op=post&tId={{ rows.tId }}&page={{ goodsList.current }}">
											<button class="btn btn-warning btn-labeled fa fa-edit">编辑</button>
										</a>
									</td>
									{% endfor %}
									{% endif %}
									{% endfor %}
									{% endif %}
								</tbody>
							</table>
							<div class="panel-body text-center">
								{% if goodsList.total_pages >1 %}
								<ul class="pagination">
									<li><a href="{{apppath}}/orchard/goods?op=display&page=1" class="demo-pli-arrow-right">首页</a></li>
									<li><a href="{{apppath}}/orchard/goods?op=display&page={{ goodsList.before }}">上一页</a></li>
									<li><a href="#">第{{ goodsList.current }}页</a></li>
									<li><a href="#">共{{ goodsList.total_pages }}页</a></li>
									<li><a href="{{apppath}}/orchard/goods?op=display&page={{ goodsList.next }}">下一页</a></li>
									<li><a href="{{apppath}}/orchard/goods?op=display&page={{ goodsList.total_pages }}" class="demo-pli-arrow-right">尾页</a></li>
								</ul>
								{% endif %}
							</div>
						</div>
					</div>
				</div>
			</div>
			{% endif %}
			{% if op == 'post' %}
			<div id="demo-lft-tab-2" class="tab-pane fade {% if op is defined %}{% if op === 'post' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/goods?op=post&page={{goodsList.current}}">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label" disabled="disabled">商品类型</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="type" class="form-control" title="">
										{% for key,row in toolType %}
										<option value="{{ key }}" {% if item is defined %}{% if item.type ==key %}selected{% endif %}{% endif %}>
											{{ row }}
										</option>
										{% endfor %}
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">商品名称</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control"  type="text" name="tName" value="{% if item is defined %}{{ item.tName }}{% endif %}" title="">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">商品简介</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control"  type="text" name="depict" value="{% if item is defined %}{{ item.depict }}{% endif %}" title="">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">商品价格</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control"  type="text" name="price" value="{% if item is defined %}{{ item.price }}{% else %}0{% endif %}" title="">
								</div>
							</div>
							<div class="form-group goodstype6" {% if item is defined and item.type < 6 %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">效果值-秒数</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control"  type="text" name="effect" value="{% if item is defined %}{{ item.effect }}{% else %}0{% endif %}" title="">
								</div>
							</div>
							<div class="form-group goodstype14" {% if item is defined and item.type !=1 and item.type !=4 %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">一次购买量</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="pack" value="{% if item is defined %}{{ item.pack }}{% else %}0{% endif %}" title="">
								</div>
							</div>
							<div class="form-group goodstype1" {% if item is defined and item.type !=1 %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">购买上限</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="buyOut" value="{% if item is defined %}{{ item.buyOut }}{% else %}0{% endif %}" title="">
								</div>
							</div>

							<div class="form-group goodstype3" {% if item is defined and item.type !=3 %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">得到物品数量</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">

									<div class="input-group">
										<span class="input-group-addon">商品</span>
										<select name="chanceInfo[winning][0][goodsId]" class="form-control" title="">
											{% if product is defined %}
												{% for keys, lists in product %}
													<option value="{{ lists.id }}" {% if chanceInfo['winning'][0]['goodsId'] is defined and chanceInfo['winning'][0]['goodsId'] == lists.id %}selected{% endif %}>{{ lists.title }}</option>
												{% endfor %}
											{% endif %}
										</select>
										<span class="input-group-addon">数量最少</span>
										<input type="text" name="chanceInfo[winning][0][min]" value="{% if chanceInfo['winning'] is not empty and chanceInfo['winning'][0]['min'] > 0 %}{{ chanceInfo['winning'][0]['min'] }}{% endif %}" class="form-control" title="">
										<span class="input-group-addon">个，最多</span>
										<input type="text" name="chanceInfo[winning][0][max]" value="{% if chanceInfo['winning'] is not empty and chanceInfo['winning'][0]['max'] > 0 %}{{ chanceInfo['winning'][0]['max'] }}{% endif %}" class="form-control" title="">
										<span class="input-group-addon">个</span>
									</div>

									<div class="input-group">
										<span class="input-group-addon">商品</span>
										<select name="chanceInfo[winning][1][goodsId]" class="form-control" title="">
											{% if product is defined %}
												{% for keys, lists in product %}
													<option value="{{ lists.id }}" {% if chanceInfo['winning'] is not empty and chanceInfo['winning'][1]['goodsId'] == lists.id %}selected{% endif %}>{{ lists.title }}</option>
												{% endfor %}
											{% endif %}
										</select>
										<span class="input-group-addon">数量最少</span>
										<input type="text" name="chanceInfo[winning][1][min]" value="{% if chanceInfo['winning'] is not empty and chanceInfo['winning'][1]['min'] > 0 %}{{ chanceInfo['winning'][1]['min'] }}{% endif %}" class="form-control" title="">
										<span class="input-group-addon">个，最多</span>
										<input type="text" name="chanceInfo[winning][1][max]" value="{% if chanceInfo['winning'] is not empty and chanceInfo['winning'][1]['max'] > 0 %}{{ chanceInfo['winning'][1]['max'] }}{% endif %}" class="form-control" title="">
										<span class="input-group-addon">个</span>
									</div>

									<div class="input-group">
										<span class="input-group-addon">奖励</span>
										<select name="chanceInfo[winning][2][goodsId]" class="form-control" title="">
											<option value="coin">金币</option>
										</select>
										<span class="input-group-addon">数量最少</span>
										<input type="text" name="chanceInfo[winning][2][min]" value="{% if chanceInfo['winning'] is not empty and chanceInfo['winning'][2]['min'] > 0 %}{{ chanceInfo['winning'][2]['min'] }}{% endif %}" class="form-control" title="">
										<span class="input-group-addon">个，最多</span>
										<input type="text" name="chanceInfo[winning][2][max]" value="{% if chanceInfo['winning'] is not empty and chanceInfo['winning'][2]['max'] > 0 %}{{ chanceInfo['winning'][2]['max'] }}{% endif %}" class="form-control" title="">
										<span class="input-group-addon">个</span>
									</div>

								</div>
							</div>

							<div class="form-group goodstype3" {% if item is defined and item.type !=3 %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">奖品描述</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input type="text" name="chanceInfo[desc]" value="{% if chanceInfo['desc'] is not empty %}{{ chanceInfo['desc'] }}{% endif %}" class="form-control" title="">
								</div>
							</div>

							<div class="form-group goodstype3" {% if item is defined and item.type !=3 %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">开启需要</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<div class="input-group">
										<span class="input-group-addon">商品</span>
										<select name="cost[0][]" class="form-control" title="">
											{% if product is defined %}
												{% for keys,lists in product %}
													<option value="{{ lists.id }}" {% if cost[0][0] is defined and cost[0][0] == lists.id %}selected{% endif %}>{{ lists.title }}</option>
												{% endfor %}
											{% endif %}
										</select>
										<span class="input-group-addon">数量</span>
										<input type="text" name="cost[0][]" value="{% if cost[0][1] is defined and cost[0][1] > 0 %}{{ cost[0][1] }}{% endif %}"  class="form-control" title="">
										<span class="input-group-addon">个</span>
									</div>

									<div class="input-group">
										<span class="input-group-addon">商品</span>
										<select name="cost[1][]" class="form-control" title="">
											{% if product is defined %}
												{% for keys,lists in product %}
													<option value="{{ lists.id }}" {% if cost[1][0] is defined and cost[1][0] == lists.id %}selected{% endif %}>{{ lists.title }}</option>
												{% endfor %}
											{% endif %}
										</select>
										<span class="input-group-addon">数量</span>
										<input type="text" name="cost[1][]" value="{% if cost[1][1] is defined and cost[1][1] > 0 %}{{ cost[1][1] }}{% endif %}"  class="form-control" title="">
										<span class="input-group-addon">个</span>
									</div>
								</div>
							</div>

							<div class="form-group goodstype5"  {% if item is defined and item.type !=4 and item.type != 5 %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">购买等级</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control"  type="text" name="reclaimLimit" value="{% if item is defined %}{{ item.reclaimLimit }}{% else %}0{% endif %}">
								</div>
							</div>
							<div class="form-group goodstype5"  {% if item is defined and item.type != 5 %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">宠物初始信息</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<div  class="input-group">
										<span class="input-group-addon">体力初始</span>
										<input type="text" name="chanceInfo[power][1]" value="<?php if (!empty($chanceInfo) && $chanceInfo["power"][1] >0){ echo $chanceInfo["power"][1]; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">幸运值初始</span>
										<input type="text" name="chanceInfo[lucky][1]" value="<?php if (!empty($chanceInfo) && $chanceInfo["lucky"][1] >0){ echo $chanceInfo["lucky"][1]; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">攻击值初始最小</span>
										<input type="text" name="chanceInfo[attack][1][min]" value="<?php if (!empty($chanceInfo) && $chanceInfo["attack"][1]['min'] >0){ echo $chanceInfo["attack"][1]['min']; }?>"  class="form-control">
										<span class="input-group-addon">点,最大</span>
										<input type="text" name="chanceInfo[attack][1][max]" value="<?php if (!empty($chanceInfo) && $chanceInfo["attack"][1]['max'] >0){ echo $chanceInfo["attack"][1]['max']; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">防御值初始最小</span>
										<input type="text" name="chanceInfo[defense][1][min]" value="<?php if (!empty($chanceInfo) && $chanceInfo["defense"][1]['min'] >0){ echo $chanceInfo["defense"][1]['min']; }?>"  class="form-control">
										<span class="input-group-addon">点,最大</span>
										<input type="text" name="chanceInfo[defense][1][max]" value="<?php if (!empty($chanceInfo) && $chanceInfo["defense"][1]['max'] >0){ echo $chanceInfo["defense"][1]['max']; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">速度值初始最小</span>
										<input type="text" name="chanceInfo[speed][1][min]" value="<?php if (!empty($chanceInfo) && $chanceInfo["speed"][1]['min'] >0){ echo $chanceInfo["speed"][1]['min']; }?>"  class="form-control">
										<span class="input-group-addon">点,最大</span>
										<input type="text" name="chanceInfo[speed][1][max]" value="<?php if (!empty($chanceInfo) && $chanceInfo["speed"][1]['max'] >0){ echo $chanceInfo["speed"][1]['max']; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
								</div>
							</div>
							<div class="form-group goodstype4" {% if item is defined and item.type !=4  %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">赠送用户种子数量</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="seedUser" value="{% if item is defined %}{{ item.seedUser }}{% else %}0{% endif %}">
								</div>
							</div>
							<div class="form-group goodstype4" {% if item is defined and item.type !=4  %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">赠送其他信息</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<div  class="input-group">
										<span class="input-group-addon">中奖总概率万分之</span>
										<input type="text" name="chanceInfo[count][size]" value="<?php if (!empty($chanceInfo) && $chanceInfo["count"]['size'] >0){ echo $chanceInfo["count"]['size']; }?>"  class="form-control">
									</div>
									<div  class="input-group">
										<span class="input-group-addon">绿宝石%</span>
										<input type="text" name="chanceInfo[baoshi][1][chance]" value="<?php if (!empty($chanceInfo) && $chanceInfo["baoshi"][1]['chance'] >0){ echo $chanceInfo["baoshi"][1]['chance']; }?>"  class="form-control">
										<input type="hidden" name="chanceInfo[baoshi][1][mark]" value="emerald"  class="form-control">
										<span class="input-group-addon">紫宝石%</span>
										<input type="text" name="chanceInfo[baoshi][2][chance]" value="<?php if (!empty($chanceInfo) && $chanceInfo["baoshi"][2]['chance'] >0){ echo $chanceInfo["baoshi"][2]['chance']; }?>"  class="form-control">
										<input type="hidden" name="chanceInfo[baoshi][2][mark]" value="purplegem"  class="form-control">
										<span class="input-group-addon">蓝宝石%</span>
										<input type="text" name="chanceInfo[baoshi][3][chance]" value="<?php if (!empty($chanceInfo) && $chanceInfo["baoshi"][3]['chance'] >0){ echo $chanceInfo["baoshi"][3]['chance']; }?>"  class="form-control">
										<input type="hidden" name="chanceInfo[baoshi][3][mark]" value="sapphire"  class="form-control">
										<span class="input-group-addon">黄宝石%</span>
										<input type="text" name="chanceInfo[baoshi][4][chance]" value="<?php if (!empty($chanceInfo) && $chanceInfo["baoshi"][4]['chance'] >0){ echo $chanceInfo["baoshi"][4]['chance']; }?>"  class="form-control">
										<input type="hidden" name="chanceInfo[baoshi][4][mark]" value="topaz"  class="form-control">
									</div>
								</div>
							</div>
							<div class="form-group goodstype4" {% if item is defined and item.type !=4 %} style="display:none;" {% endif %}>
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">返回平台种子数量</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control"  type="text" name="seedShop" value="{% if item is defined %}{{ item.seedShop }}{% else %}0{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="status" class="form-control">
										<option value="1" {% if item is defined %}{% if item.status == '1' %}selected{% endif %}{% endif %}>
											启用
										</option>
										<option value="0" {% if item is defined %}{% if item.status == '0' %}selected{% endif %}{% endif %}>
											禁用
										</option>
									</select>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input type="hidden" name='tId' value="{% if item is defined %}{{ item.tId }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			{% endif %}
		</div>
	</div>
</div>
<script>
	requirejs(['nifty'], function () {
		$('select[name=type]').bind('change', function(){
			var type = $('select[name=type]').val();
			if(type == 1){
				$(".goodstype1").show();
				$(".goodstype14").show();
				$(".goodstype3").hide();
				$(".goodstype4").hide();
				$(".goodstype5").hide();
			}else if(type == 3){
				$(".goodstype3").show();
				$(".goodstype1").hide();
				$(".goodstype4").hide();
				$(".goodstype5").hide();
				$(".goodstype14").hide();
			}else if(type == 4){
				$(".goodstype4").show();
				$(".goodstype5").show();
				$(".goodstype14").show();
				$(".goodstype1").hide();
				$(".goodstype3").hide();
			}else if(type == 5){
				$(".goodstype5").show();
				$(".goodstype1").hide();
				$(".goodstype3").hide();
				$(".goodstype4").hide();
				$(".goodstype14").hide();
			}else{
				$(".goodstype1").hide();
				$(".goodstype3").hide();
				$(".goodstype4").hide();
				$(".goodstype5").hide();
				$(".goodstype14").hide();
			}
			if(type >=6){
				$(".goodstype6").show();
			}else{
				$(".goodstype6").hide();
			}
		});
	});
</script>
<!--商品模块结束--!>

