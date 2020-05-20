<?php $this->flashSession->output(); ?>
<div class="nav-tabs-custom">
	<div class="tab-base">
		<!--Nav Tabs-->
		<ul class="nav nav-tabs">
			<li class="{% if op is defined%}{% if op === 'post' %}active{% else %} {% endif %}{% endif%} ">
				<a href="{{ apppath }}/orchard/config?op=post" aria-expanded="{% if op is defined%}{% if op == 'post' %}true{% else %}false {% endif %}{% endif%}">基本设置</a>
			</li>
			{% if item != '' and item.id != 0%}
			<li class="{% if op is defined %}{% if op == 'duiset' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=duiset" aria-expanded="{% if op is defined %}{% if op == 'duiset' %}true{% else %} false{% endif %}{% endif %}">兑换设置</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'house' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=house" aria-expanded="{% if op is defined %}{% if op == 'house' %}true{% else %} false{% endif %}{% endif %}">房屋等级</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'dogInfo' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=dogInfo" aria-expanded="{% if op is defined %}{% if op == 'dogInfo' %}true{% else %} false{% endif %}{% endif %}">宠物等级</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'landInfo' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=landInfo" aria-expanded="{% if op is defined %}{% if op == 'landInfo' %}true{% else %} false{% endif %}{% endif %}">土地信息</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'statueInfo' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=statueInfo" aria-expanded="{% if op is defined %}{% if op == 'statueInfo' %}true{% else %} false{% endif %}{% endif %}">神像信息</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'recharge' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=recharge" aria-expanded="{% if op is defined %}{% if op == 'recharge' %}true{% else %} false{% endif %}{% endif %}">充值设置</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'background' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=background" aria-expanded="{% if op is defined %}{% if op == 'background' %}true{% else %} false{% endif %}{% endif %}">背景信息</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'package' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=package" aria-expanded="{% if op is defined %}{% if op == 'package' %}true{% else %} false{% endif %}{% endif %}">礼包信息</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'sign' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=sign" aria-expanded="{% if op is defined %}{% if op == 'sign' %}true{% else %} false{% endif %}{% endif %}">签到信息</a>
			</li>
			<li class="{% if op is defined %}{% if op == 'steal' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=steal" aria-expanded="{% if op is defined %}{% if op == 'steal' %}true{% else %} false{% endif %}{% endif %}">互偷信息</a>
			</li>
			{%if user_type == 'huangjin'%}
			<li class="{% if op is defined %}{% if op == 'crystal' %}active{% else %} {% endif %}{% endif %}">
            	<a href="{{ apppath }}/orchard/config?op=crystal" aria-expanded="{% if op is defined %}{% if op == 'crystal' %}true{% else %} false{% endif %}{% endif %}">水晶兑换</a>
            </li>
            {%endif%}
            {%if user_type == 'chuangjin'%}
			<li class="{% if op is defined %}{% if op == 'downgrade' %}active{% else %} {% endif %}{% endif %}">
				<a href="{{ apppath }}/orchard/config?op=downgrade" aria-expanded="{% if op is defined %}{% if op == 'downgrade' %}true{% else %} false{% endif %}{% endif %}">房屋降级</a>
			</li>
			{%endif%}
			{%if user_type == 'EMG'%}
            			<li class="{% if op is defined %}{% if op == 'EMG' %}active{% else %} {% endif %}{% endif %}">
            				<a href="{{ apppath }}/orchard/config?op=EMG" aria-expanded="{% if op is defined %}{% if op == 'EMG' %}true{% else %} false{% endif %}{% endif %}">	接口授权</a>
            			</li>
            			{% endif %}
			{% endif %}

		</ul>
		{% if op == 'post'%}
		<!--Tabs Content-->
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'post' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=post">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">标题</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="title" value="{% if item != '' %}{{ item.title }}{% else %}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">原始种子库存</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="total" value="{% if item != '' %}{{ item.total }}{% else %}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">当前用户可升级最高等级</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="upGrade" value="{% if item != '' %}{{ item.upGrade }}{% else %}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">金币转账手续费(%)</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="transferfee" value="{% if item != '' %}{{ item.transferfee }}{% else %}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">世界消息价格(金币/条)</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="msgprice" value="{% if item != '' %}{{ item.msgprice }}{% else %}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="status" class="form-control">
										<option value="1" {% if item != '' %}{% if item.status == 1 %}selected{% endif %}{% endif %}>启用</option>
										<option value="0" {% if item != '' %}{% if item.status == 0 %}selected{% endif %}{% endif %}>禁用</option>
									</select>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		{% endif %}
		{% if op == 'duiset' %}
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'duiset' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=duiset">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">兑换材料信息</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<div  class="input-group">
										<span class="input-group-addon"><?php echo $duiType[1];?>/块兑换需</span>
										<select name="duiInfo[1][1][pid]" class="form-control">
										{% for keys,lists in product %}
											<option value="{{ lists.id }}" {% if duiInfo is defined %}<?php if ($duiInfo[1][1]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
												{{ lists.title }}
											</option>
										{% endfor %}
										</select>
										<span class="input-group-addon">数量</span>
										<input type="text" name="duiInfo[1][1][num]" value="<?php if (!empty($duiInfo) && $duiInfo[1][1]['num'] >0){ echo $duiInfo[1][1]['num']; }?>"  class="form-control">
										<span class="input-group-addon">+</span>
										<select name="duiInfo[1][2][pid]" class="form-control">
										{% for keys,lists in product %}
											<option value="{{ lists.id }}" {% if duiInfo is defined %}<?php if ($duiInfo[1][2]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
												{{ lists.title }}
											</option>
										{% endfor %}
										</select>
										<span class="input-group-addon">数量</span>
										<input type="text" name="duiInfo[1][2][num]" value="<?php if (!empty($duiInfo) && $duiInfo[1][2]['num'] >0){ echo $duiInfo[1][2]['num']; }?>"  class="form-control">
									</div>
									<div  class="input-group">
										<span class="input-group-addon"><?php echo $duiType[2];?>/块兑换需</span>
										<select name="duiInfo[2][1][pid]" class="form-control">
										{% for keys,lists in product %}
											<option value="{{ lists.id }}" {% if duiInfo is defined %}<?php if ($duiInfo[2][1]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
												{{ lists.title }}
											</option>
										{% endfor %}
										</select>
										<span class="input-group-addon">数量</span>
										<input type="text" name="duiInfo[2][1][num]" value="<?php if (!empty($duiInfo) && $duiInfo[2][1]['num'] >0){ echo $duiInfo[2][1]['num']; }?>"  class="form-control">
										<span class="input-group-addon">+</span>
										<select name="duiInfo[2][2][pid]" class="form-control">
										{% for keys,lists in product %}
											<option value="{{ lists.id }}" {% if duiInfo is defined %}<?php if ($duiInfo[2][2]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
												{{ lists.title }}
											</option>
										{% endfor %}
										</select>
										<span class="input-group-addon">数量</span>
										<input type="text" name="duiInfo[2][2][num]" value="<?php if (!empty($duiInfo) && $duiInfo[2][2]['num'] >0){ echo $duiInfo[2][2]['num']; }?>"  class="form-control">
									</div>
									<div  class="input-group">
										<span class="input-group-addon"><?php echo $duiType[3];?>/块兑换需</span>
										<select name="duiInfo[3][1][pid]" class="form-control">
										{% for keys,lists in product %}
											<option value="{{ lists.id }}" {% if duiInfo is defined %}<?php if ($duiInfo[3][1]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
												{{ lists.title }}
											</option>
										{% endfor %}
										</select>
										<span class="input-group-addon">数量</span>
										<input type="text" name="duiInfo[3][1][num]" value="<?php if (!empty($duiInfo) && $duiInfo[3][1]['num'] >0){ echo $duiInfo[3][1]['num']; }?>"  class="form-control">
										<span class="input-group-addon">+</span>
										<select name="duiInfo[3][2][pid]" class="form-control">
										{% for keys,lists in product %}
											<option value="{{ lists.id }}" {% if duiInfo is defined %}<?php if ($duiInfo[3][2]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
												{{ lists.title }}
											</option>
										{% endfor %}
										</select>
										<span class="input-group-addon">数量</span>
										<input type="text" name="duiInfo[3][2][num]" value="<?php if (!empty($duiInfo) && $duiInfo[3][2]['num'] >0){ echo $duiInfo[3][2]['num']; }?>"  class="form-control">
									</div>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		{% endif %}
		{% if op == 'house' %}
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'house' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=house">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">房屋升级信息</label>
								<div class="col-xs-12 col-sm-10 col-md-10 col-lg-12">
									<div  class="input-group">
										<span class="input-group-addon">1-2 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[1][0]" value="<?php if (!empty($houseInfo) && $houseInfo[1][0] >0){ echo $houseInfo[1][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[1][1]" value="<?php if (!empty($houseInfo) && $houseInfo[1][1] >0){ echo $houseInfo[1][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[1][2]" value="<?php if (!empty($houseInfo) && $houseInfo[1][2] >0){ echo $houseInfo[1][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[1][3]" value="<?php if (!empty($houseInfo) && $houseInfo[1][3] >0){ echo $houseInfo[1][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[1][17]" value="<?php if (!empty($houseInfo) && $houseInfo[1][17] >0){ echo $houseInfo[1][17]; }?>"  class="form-control">
										{% endif %}
									</div>
									<div  class="input-group">
										<span class="input-group-addon">2-3 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[2][0]" value="<?php if (!empty($houseInfo) && $houseInfo[2][0] >0){ echo $houseInfo[2][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[2][1]" value="<?php if (!empty($houseInfo) && $houseInfo[2][1] >0){ echo $houseInfo[2][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[2][2]" value="<?php if (!empty($houseInfo) && $houseInfo[2][2] >0){ echo $houseInfo[2][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[2][3]" value="<?php if (!empty($houseInfo) && $houseInfo[2][3] >0){ echo $houseInfo[2][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[2][17]" value="<?php if (!empty($houseInfo) && $houseInfo[2][17] >0){ echo $houseInfo[2][17]; }?>"  class="form-control">
										{% endif %}
									</div>
									<div  class="input-group">
										<span class="input-group-addon">3-4 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[3][0]" value="<?php if (!empty($houseInfo) && $houseInfo[3][0] >0){ echo $houseInfo[3][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[3][1]" value="<?php if (!empty($houseInfo) && $houseInfo[3][1] >0){ echo $houseInfo[3][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[3][2]" value="<?php if (!empty($houseInfo) && $houseInfo[3][2] >0){ echo $houseInfo[3][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[3][3]" value="<?php if (!empty($houseInfo) && $houseInfo[3][3] >0){ echo $houseInfo[3][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[3][17]" value="<?php if (!empty($houseInfo) && $houseInfo[3][17] >0){ echo $houseInfo[3][17]; }?>"  class="form-control">
										{% endif %}
									</div>
									<div  class="input-group">
										<span class="input-group-addon">4-5 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[4][0]" value="<?php if (!empty($houseInfo) && $houseInfo[4][0] >0){ echo $houseInfo[4][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[4][1]" value="<?php if (!empty($houseInfo) && $houseInfo[4][1] >0){ echo $houseInfo[4][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[4][2]" value="<?php if (!empty($houseInfo) && $houseInfo[4][2] >0){ echo $houseInfo[4][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[4][3]" value="<?php if (!empty($houseInfo) && $houseInfo[4][3] >0){ echo $houseInfo[4][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[4][17]" value="<?php if (!empty($houseInfo) && $houseInfo[4][17] >0){ echo $houseInfo[4][17]; }?>"  class="form-control">
										{% endif %}
									</div>
									<div  class="input-group">
										<span class="input-group-addon">5-6 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[5][0]" value="<?php if (!empty($houseInfo) && $houseInfo[5][0] >0){ echo $houseInfo[5][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[5][1]" value="<?php if (!empty($houseInfo) && $houseInfo[5][1] >0){ echo $houseInfo[5][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[5][2]" value="<?php if (!empty($houseInfo) && $houseInfo[5][2] >0){ echo $houseInfo[5][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[5][3]" value="<?php if (!empty($houseInfo) && $houseInfo[5][3] >0){ echo $houseInfo[5][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[5][17]" value="<?php if (!empty($houseInfo) && $houseInfo[5][17] >0){ echo $houseInfo[5][17]; }?>"  class="form-control">
										{% endif %}
									</div>
									<div  class="input-group">
										<span class="input-group-addon">6-7 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[6][0]" value="<?php if (!empty($houseInfo) && $houseInfo[6][0] >0){ echo $houseInfo[6][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[6][1]" value="<?php if (!empty($houseInfo) && $houseInfo[6][1] >0){ echo $houseInfo[6][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[6][2]" value="<?php if (!empty($houseInfo) && $houseInfo[6][2] >0){ echo $houseInfo[6][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[6][3]" value="<?php if (!empty($houseInfo) && $houseInfo[6][3] >0){ echo $houseInfo[6][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[6][17]" value="<?php if (!empty($houseInfo) && $houseInfo[6][17] >0){ echo $houseInfo[6][17]; }?>"  class="form-control">
										{% endif %}
									</div>
									<div  class="input-group">
										<span class="input-group-addon">7-8 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[7][0]" value="<?php if (!empty($houseInfo) && $houseInfo[7][0] >0){ echo $houseInfo[7][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[7][1]" value="<?php if (!empty($houseInfo) && $houseInfo[7][1] >0){ echo $houseInfo[7][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[7][2]" value="<?php if (!empty($houseInfo) && $houseInfo[7][2] >0){ echo $houseInfo[7][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[7][3]" value="<?php if (!empty($houseInfo) && $houseInfo[7][3] >0){ echo $houseInfo[7][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[7][17]" value="<?php if (!empty($houseInfo) && $houseInfo[7][17] >0){ echo $houseInfo[7][17]; }?>"  class="form-control">
										{% endif %}
									</div>
									<div  class="input-group">
										<span class="input-group-addon">8-9 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[8][0]" value="<?php if (!empty($houseInfo) && $houseInfo[8][0] >0){ echo $houseInfo[8][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[8][1]" value="<?php if (!empty($houseInfo) && $houseInfo[8][1] >0){ echo $houseInfo[8][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[8][2]" value="<?php if (!empty($houseInfo) && $houseInfo[8][2] >0){ echo $houseInfo[8][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[8][3]" value="<?php if (!empty($houseInfo) && $houseInfo[8][3] >0){ echo $houseInfo[8][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[8][17]" value="<?php if (!empty($houseInfo) && $houseInfo[8][17] >0){ echo $houseInfo[8][17]; }?>"  class="form-control">
										{% endif %}
									</div>
									<div  class="input-group">
										<span class="input-group-addon">9-10 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[9][0]" value="<?php if (!empty($houseInfo) && $houseInfo[9][0] >0){ echo $houseInfo[9][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[9][1]" value="<?php if (!empty($houseInfo) && $houseInfo[9][1] >0){ echo $houseInfo[9][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[9][2]" value="<?php if (!empty($houseInfo) && $houseInfo[9][2] >0){ echo $houseInfo[9][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[9][3]" value="<?php if (!empty($houseInfo) && $houseInfo[9][3] >0){ echo $houseInfo[9][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[9][17]" value="<?php if (!empty($houseInfo) && $houseInfo[9][17] >0){ echo $houseInfo[9][17]; }?>"  class="form-control">
										{% endif %}
									</div>
									<div  class="input-group">
										<span class="input-group-addon">10-11 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[10][0]" value="<?php if (!empty($houseInfo) && $houseInfo[10][0] >0){ echo $houseInfo[10][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[10][1]" value="<?php if (!empty($houseInfo) && $houseInfo[10][1] >0){ echo $houseInfo[10][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[10][2]" value="<?php if (!empty($houseInfo) && $houseInfo[10][2] >0){ echo $houseInfo[10][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[10][3]" value="<?php if (!empty($houseInfo) && $houseInfo[10][3] >0){ echo $houseInfo[10][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[10][17]" value="<?php if (!empty($houseInfo) && $houseInfo[10][17] >0){ echo $houseInfo[10][17]; }?>"  class="form-control">
										{% endif %}
									</div>
									<div  class="input-group">
										<span class="input-group-addon">11-12 升级需要数量 <?php echo $duiType[0];?></span>
										<input type="text" name="houseInfo[11][0]" value="<?php if (!empty($houseInfo) && $houseInfo[11][0] >0){ echo $houseInfo[11][0]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[1];?></span>
										<input type="text" name="houseInfo[11][1]" value="<?php if (!empty($houseInfo) && $houseInfo[11][1] >0){ echo $houseInfo[11][1]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[2];?></span>
										<input type="text" name="houseInfo[11][2]" value="<?php if (!empty($houseInfo) && $houseInfo[11][2] >0){ echo $houseInfo[11][2]; }?>"  class="form-control">
										<span class="input-group-addon">+<?php echo $duiType[3];?></span>
										<input type="text" name="houseInfo[11][3]" value="<?php if (!empty($houseInfo) && $houseInfo[11][3] >0){ echo $houseInfo[11][3]; }?>"  class="form-control">
										{% if hostType == 'yansheng' %}
										<span class="input-group-addon">+苦瓜汁</span>
										<input type="text" name="houseInfo[11][17]" value="<?php if (!empty($houseInfo) && $houseInfo[11][17] >0){ echo $houseInfo[11][17]; }?>"  class="form-control">
										{% endif %}
									</div>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		{% endif %}
		{% if op == 'dogInfo' %}
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'dogInfo' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=dogInfo">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">宠物升级</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<div  class="input-group">
										<span class="input-group-addon">1-2 升级</span>
										<input type="text" name="dogInfo[experience][1]" value="<?php if (!empty($dogInfo) && $dogInfo["experience"][1] >0){ echo $dogInfo["experience"][1]; }?>"  class="form-control">
										<span class="input-group-addon">经验</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">2-3 升级</span>
										<input type="text" name="dogInfo[experience][2]" value="<?php if (!empty($dogInfo) && $dogInfo["experience"][2] >0){ echo $dogInfo["experience"][2]; }?>"  class="form-control">
										<span class="input-group-addon">经验</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">3-4 升级</span>
										<input type="text" name="dogInfo[experience][3]" value="<?php if (!empty($dogInfo) && $dogInfo["experience"][3] >0){ echo $dogInfo["experience"][3]; }?>"  class="form-control">
										<span class="input-group-addon">经验</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">4-5 升级</span>
										<input type="text" name="dogInfo[experience][4]" value="<?php if (!empty($dogInfo) && $dogInfo["experience"][4] >0){ echo $dogInfo["experience"][4]; }?>"  class="form-control">
										<span class="input-group-addon">经验</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">5-6 升级</span>
										<input type="text" name="dogInfo[experience][5]" value="<?php if (!empty($dogInfo) && $dogInfo["experience"][5] >0){ echo $dogInfo["experience"][5]; }?>"  class="form-control">
										<span class="input-group-addon">经验</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">6-7 升级</span>
										<input type="text" name="dogInfo[experience][6]" value="<?php if (!empty($dogInfo) && $dogInfo["experience"][6] >0){ echo $dogInfo["experience"][6]; }?>"  class="form-control">
										<span class="input-group-addon">经验</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">7-8 升级</span>
										<input type="text" name="dogInfo[experience][7]" value="<?php if (!empty($dogInfo) && $dogInfo["experience"][7] >0){ echo $dogInfo["experience"][7]; }?>"  class="form-control">
										<span class="input-group-addon">经验</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">8-9 升级</span>
										<input type="text" name="dogInfo[experience][8]" value="<?php if (!empty($dogInfo) && $dogInfo["experience"][8] >0){ echo $dogInfo["experience"][8]; }?>"  class="form-control">
										<span class="input-group-addon">经验</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">9-10 升级</span>
										<input type="text" name="dogInfo[experience][9]" value="<?php if (!empty($dogInfo) && $dogInfo["experience"][9] >0){ echo $dogInfo["experience"][9]; }?>"  class="form-control">
										<span class="input-group-addon">经验</span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">宠物信息</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<div  class="input-group">
										<span class="input-group-addon">拥有上限</span>
										<input type="text" name="dogInfo[uplimit]" value="<?php if (!empty($dogInfo) && $dogInfo['uplimit'] >0){ echo $dogInfo['uplimit']; }?>"  class="form-control">
										<span class="input-group-addon">只宠物</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">经验值1 = </span>
										<input type="text" name="dogInfo[num]" value="<?php if (!empty($dogInfo) && $dogInfo['num'] >0){ echo $dogInfo['num']; }?>"  class="form-control">
										<span class="input-group-addon">袋狗粮</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">普通狗粮</span>
										<select name="dogInfo[info][1][pid]" class="form-control">
										{% for keys,lists in product %}
											<option value="{{ lists.id }}" {% if dogInfo is defined %}<?php if ($dogInfo["info"][1]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
												{{ lists.title }}
											</option>
										{% endfor %}
										</select>
										<span class="input-group-addon">数量</span>
										<input type="text" name="dogInfo[info][1][num]" value="<?php if (!empty($dogInfo) && $dogInfo["info"][1]['num'] >0){ echo $dogInfo["info"][1]['num']; }?>"  class="form-control">

										<span class="input-group-addon">个名称</span>
										<input type="text" name="dogInfo[info][1][tName]" value="<?php if (!empty($dogInfo) && !empty($dogInfo["info"][1]['tName'])){ echo $dogInfo["info"][1]['tName']; }?>"  class="form-control">
										<span class="input-group-addon">简介</span>
										<input type="text" name="dogInfo[info][1][depict]" value="<?php if (!empty($dogInfo) &&  !empty($dogInfo["info"][1]['depict'])){ echo $dogInfo["info"][1]['depict']; }?>"  class="form-control">
									</div>
									<div  class="input-group">
										<span class="input-group-addon">优质狗粮</span>
										<select name="dogInfo[info][2][pid]" class="form-control">
										{% for keys,lists in product %}
											<option value="{{ lists.id }}" {% if dogInfo is defined %}<?php if ($dogInfo["info"][2]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
												{{ lists.title }}
											</option>
										{% endfor %}
										</select>
										<span class="input-group-addon">数量</span>
										<input type="text" name="dogInfo[info][2][num]" value="<?php if (!empty($dogInfo) && $dogInfo["info"][2]['num'] >0){ echo $dogInfo["info"][2]['num']; }?>"  class="form-control">
										<span class="input-group-addon">个名称</span>
										<input type="text" name="dogInfo[info][2][tName]" value="<?php if (!empty($dogInfo) && !empty($dogInfo["info"][2]['tName'])){ echo $dogInfo["info"][2]['tName']; }?>"  class="form-control">
										<span class="input-group-addon">简介</span>
										<input type="text" name="dogInfo[info][2][depict]" value="<?php if (!empty($dogInfo) && !empty($dogInfo["info"][2]['depict'])){ echo $dogInfo["info"][2]['depict']; }?>"  class="form-control">
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">宠物属性</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<div  class="input-group">
										<span class="input-group-addon">体力初始</span>
										<input type="text" name="dogInfo[power][1]" value="<?php if (!empty($dogInfo) && $dogInfo["power"][1] >0){ echo $dogInfo["power"][1]; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">喂食概率增加</span>
										<input type="text" name="dogInfo[power][0]" value="<?php if (!empty($dogInfo) && $dogInfo["power"][0] >0){ echo $dogInfo["power"][0]; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">体力升级增加</span>
										<input type="text" name="dogInfo[power][2]" value="<?php if (!empty($dogInfo) && $dogInfo["power"][2] >0){ echo $dogInfo["power"][2]; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">体力训练扣除</span>
										<input type="text" name="dogInfo[power][3]" value="<?php if (!empty($dogInfo) && $dogInfo["power"][3] >0){ echo $dogInfo["power"][3]; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">幸运值初始</span>
										<input type="text" name="dogInfo[lucky][1]" value="<?php if (!empty($dogInfo) && $dogInfo["lucky"][1] >0){ echo $dogInfo["lucky"][1]; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">喂食或升级概率增加</span>
										<input type="text" name="dogInfo[lucky][2]" value="<?php if (!empty($dogInfo) && $dogInfo["lucky"][2] >0){ echo $dogInfo["lucky"][2]; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">攻击值初始最小</span>
										<input type="text" name="dogInfo[attack][1][min]" value="<?php if (!empty($dogInfo) && $dogInfo["attack"][1]['min'] >0){ echo $dogInfo["attack"][1]['min']; }?>"  class="form-control">
										<span class="input-group-addon">点,最大</span>
										<input type="text" name="dogInfo[attack][1][max]" value="<?php if (!empty($dogInfo) && $dogInfo["attack"][1]['max'] >0){ echo $dogInfo["attack"][1]['max']; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">攻击升级最小增加</span>
										<input type="text" name="dogInfo[attack][2][min]" value="<?php if (!empty($dogInfo) && $dogInfo["attack"][2]['min'] >0){ echo $dogInfo["attack"][2]['min']; }?>"  class="form-control">
										<span class="input-group-addon">点,最大增加</span>
										<input type="text" name="dogInfo[attack][2][max]" value="<?php if (!empty($dogInfo) && $dogInfo["attack"][2]['max'] >0){ echo $dogInfo["attack"][2]['max']; }?>"  class="form-control">
										<span class="input-group-addon">点 升级成功，训练概率成功</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">防御值初始最小</span>
										<input type="text" name="dogInfo[defense][1][min]" value="<?php if (!empty($dogInfo) && $dogInfo["defense"][1]['min'] >0){ echo $dogInfo["defense"][1]['min']; }?>"  class="form-control">
										<span class="input-group-addon">点,最大</span>
										<input type="text" name="dogInfo[defense][1][max]" value="<?php if (!empty($dogInfo) && $dogInfo["defense"][1]['max'] >0){ echo $dogInfo["defense"][1]['max']; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">防御升级最小增加</span>
										<input type="text" name="dogInfo[defense][2][min]" value="<?php if (!empty($dogInfo) && $dogInfo["defense"][2]['min'] >0){ echo $dogInfo["defense"][2]['min']; }?>"  class="form-control">
										<span class="input-group-addon">点,最大增加</span>
										<input type="text" name="dogInfo[defense][2][max]" value="<?php if (!empty($dogInfo) && $dogInfo["defense"][2]['max'] >0){ echo $dogInfo["defense"][2]['max']; }?>"  class="form-control">
										<span class="input-group-addon">点 升级成功，训练概率成功</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">速度值初始最小</span>
										<input type="text" name="dogInfo[speed][1][min]" value="<?php if (!empty($dogInfo) && $dogInfo["speed"][1]['min'] >0){ echo $dogInfo["speed"][1]['min']; }?>"  class="form-control">
										<span class="input-group-addon">点,最大</span>
										<input type="text" name="dogInfo[speed][1][max]" value="<?php if (!empty($dogInfo) && $dogInfo["speed"][1]['max'] >0){ echo $dogInfo["speed"][1]['max']; }?>"  class="form-control">
										<span class="input-group-addon">点</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">速度升级最小增加</span>
										<input type="text" name="dogInfo[speed][2][min]" value="<?php if (!empty($dogInfo) && $dogInfo["speed"][2]['min'] >0){ echo $dogInfo["speed"][2]['min']; }?>"  class="form-control">
										<span class="input-group-addon">点,最大增加</span>
										<input type="text" name="dogInfo[speed][2][max]" value="<?php if (!empty($dogInfo) && $dogInfo["speed"][2]['max'] >0){ echo $dogInfo["speed"][2]['max']; }?>"  class="form-control">
										<span class="input-group-addon">点 升级成功，训练概率成功</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">生命升级最小增加</span>
										<input type="text" name="dogInfo[powerUlimit][2][min]" value="<?php if (!empty($dogInfo) && $dogInfo["powerUlimit"][2]['min'] >0){ echo $dogInfo["powerUlimit"][2]['min']; }?>"  class="form-control">
										<span class="input-group-addon">点,最大增加</span>
										<input type="text" name="dogInfo[powerUlimit][2][max]" value="<?php if (!empty($dogInfo) && $dogInfo["powerUlimit"][2]['max'] >0){ echo $dogInfo["powerUlimit"][2]['max']; }?>"  class="form-control">
										<span class="input-group-addon">点 升级成功，训练概率成功</span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">宠物技能</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<div  class="input-group">
										<span class="input-group-addon">自动收获时效</span>
										<input type="text" name="dogInfo[skill][1]" value="<?php if (!empty($dogInfo) && $dogInfo["skill"][1] >0){ echo $dogInfo["skill"][1]; }?>"  class="form-control">
										<span class="input-group-addon">小时,自动播种时效</span>
										<input type="text" name="dogInfo[skill][2]" value="<?php if (!empty($dogInfo) && $dogInfo["skill"][2] >0){ echo $dogInfo["skill"][2]; }?>"  class="form-control">
										<span class="input-group-addon">小时,升级增加</span>
										<input type="text" name="dogInfo[skill][3]" value="<?php if (!empty($dogInfo) && $dogInfo["skill"][3] >0){ echo $dogInfo["skill"][3]; }?>"  class="form-control">
										<span class="input-group-addon">小时</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">玫瑰值上限</span>
										<input type="text" name="dogInfo[skill][0]" value="<?php if (!empty($dogInfo) && $dogInfo["skill"][0] >0){ echo $dogInfo["skill"][0]; }?>"  class="form-control">
										<span class="input-group-addon">随机增加最小</span>
										<input type="text" name="dogInfo[skill][4]" value="<?php if (!empty($dogInfo) && $dogInfo["skill"][4] >0){ echo $dogInfo["skill"][4]; }?>"  class="form-control">
										<span class="input-group-addon">随机增加最大</span>
										<input type="text" name="dogInfo[skill][5]" value="<?php if (!empty($dogInfo) && $dogInfo["skill"][5] >0){ echo $dogInfo["skill"][5]; }?>"  class="form-control">
									</div>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		{% endif %}
		{% if op == 'landInfo' %}
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'landInfo' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=landInfo">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">土地升级</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<div  class="input-group">
										{% for key,row in landType %}
										{% if key >1 %}
										<div  class="input-group">
											<span class="input-group-addon">升级 为{{ row }}</span>

											<span class="input-group-addon">钻石需</span>
											<input type="text" name="landUpInfo[{{ key }}][0][num]" value="<?php if (!empty($landUpInfo) && !empty($landUpInfo[$key][0]['num'])){ echo $landUpInfo[$key][0]['num']; } ?>"  class="form-control">
											<span class="input-group-addon">颗</span>
										</div>
										<div  class="input-group">
											<select name="landUpInfo[{{ key }}][1][pid]" class="form-control">>
												{% for keys,lists in product %}
												<option value="{{ lists.id }}" {% if landUpInfo is defined %}<?php if ($landUpInfo[$key][1]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
													{{ lists.title }}
												</option>
												{% endfor %}
											</select>
											<span class="input-group-addon">需</span>
											<input type="text" name="landUpInfo[{{ key }}][1][num]" value="<?php if (!empty($landUpInfo) && !empty($landUpInfo[$key][1]['num'])){ echo $landUpInfo[$key][1]['num']; } ?>"  class="form-control">
											<span class="input-group-addon">颗</span>
											<select name="landUpInfo[{{ key }}][2][pid]" class="form-control">>
												{% for keys,lists in product %}
												<option value="{{ lists.id }}" {% if landUpInfo is defined %}<?php if ($landUpInfo[$key][2]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
													{{ lists.title }}
												</option>
												{% endfor %}
											</select>
											<span class="input-group-addon">需</span>
											<input type="text" name="landUpInfo[{{ key }}][2][num]" value="<?php if (!empty($landUpInfo) && !empty($landUpInfo[$key][2]['num'])){ echo $landUpInfo[$key][2]['num']; } ?>"  class="form-control">
											<span class="input-group-addon">颗</span>
										</div>
										{% endif %}
										{% endfor%}
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">种子产生</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<div  class="input-group">
										<div  class="input-group">
											<span class="input-group-addon">每次种植</span>
											<input type="text" name="landFruit[seed]" value="<?php if (!empty($landFruit) && !empty($landFruit["seed"])){ echo $landFruit["seed"]; } ?>"  class="form-control">
											<span class="input-group-addon">种子</span>
										</div>
										<div  class="input-group">
											<span class="input-group-addon">普通土地：产生最少</span>
											<input type="text" name="landFruit[num][0][min]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][0]["min"])){ echo $landFruit["num"][0]["min"]; } ?>"  class="form-control">
											<span class="input-group-addon">无不良 产生最少</span>
											<input type="text" name="landFruit[num][0][med]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][0]["med"])){ echo $landFruit["num"][0]["med"]; } ?>"  class="form-control">
											<span class="input-group-addon">颗 产生最多</span>
											<input type="text" name="landFruit[num][0][max]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][0]["max"])){ echo $landFruit["num"][0]["max"]; } ?>"  class="form-control">
											<span class="input-group-addon">颗</span>
										</div>
										<div  class="input-group">
											<span class="input-group-addon">红土地：产生最少</span>
											<input type="text" name="landFruit[num][1][min]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][1]["min"])){ echo $landFruit["num"][1]["min"]; } ?>"  class="form-control">
											<span class="input-group-addon">无不良 产生最少</span>
											<input type="text" name="landFruit[num][1][med]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][1]["med"])){ echo $landFruit["num"][1]["med"]; } ?>"  class="form-control">
											<span class="input-group-addon">颗 产生最多</span>
											<input type="text" name="landFruit[num][1][max]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][1]["max"])){ echo $landFruit["num"][1]["max"]; } ?>"  class="form-control">
											<span class="input-group-addon">颗</span>
										</div>
										<div  class="input-group">
											<span class="input-group-addon">黑土地：产生最少</span>
											<input type="text" name="landFruit[num][2][min]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][2]["min"])){ echo $landFruit["num"][2]["min"]; } ?>"  class="form-control">
											<span class="input-group-addon">无不良 产生最少</span>
											<input type="text" name="landFruit[num][2][med]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][2]["med"])){ echo $landFruit["num"][2]["med"]; } ?>"  class="form-control">
											<span class="input-group-addon">颗 产生最多</span>
											<input type="text" name="landFruit[num][2][max]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][2]["max"])){ echo $landFruit["num"][2]["max"]; } ?>"  class="form-control">
											<span class="input-group-addon">颗</span>
										</div>
										<div  class="input-group">
											<span class="input-group-addon">金土地：产生最少</span>
											<input type="text" name="landFruit[num][3][min]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][3]["min"])){ echo $landFruit["num"][3]["min"]; } ?>"  class="form-control">
											<span class="input-group-addon">无不良 产生最少</span>
											<input type="text" name="landFruit[num][3][med]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][3]["med"])){ echo $landFruit["num"][3]["med"]; } ?>"  class="form-control">
											<span class="input-group-addon">颗 产生最多</span>
											<input type="text" name="landFruit[num][3][max]" value="<?php if (!empty($landFruit) && !empty($landFruit["num"][3]["max"])){ echo $landFruit["num"][3]["max"]; } ?>"  class="form-control">
											<span class="input-group-addon">颗</span>
										</div>

									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">土地种子概率信息</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									{% for key,row in landType %}
										{% for keys,lists in product %}
										<div  class="input-group">
											<span class="input-group-addon">{{ row }}-{{ lists.title }}</span>
											<input type="hidden" name="landInfo[{{ key }}][{{ keys }}][id]" value="{{ lists.id }}"  class="form-control">
											<input type="text" name="landInfo[{{ key }}][{{ keys }}][chance]" value="<?php if (!empty($landInfo) && !empty($landInfo[$key][$keys]['chance'])){ echo $landInfo[$key][$keys]['chance']; } ?>"  class="form-control">
											<span class="input-group-addon">%</span>
										</div>
										{% endfor %}
									{% endfor %}
								</div>
							</div>
							{% for r in landSuper %}
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">{{ r }}级种子概率</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									{% for key,row in landType %}
										{% if key >0 %}
										{% for keys,lists in product %}
										<div  class="input-group">
											<span class="input-group-addon">{{ row }}-{{ lists.title }}</span>
											<input type="hidden" name="landInfo[{{ r }}][{{ key }}][{{ keys }}][id]" value="{{ lists.id }}"  class="form-control">
											<input type="text" name="landInfo[{{ r }}][{{ key }}][{{ keys }}][chance]" value="<?php if (!empty($landInfo) && !empty($landInfo[$r][$key][$keys]['chance'])){ echo $landInfo[$r][$key][$keys]['chance']; } ?>"  class="form-control">
											<span class="input-group-addon">%</span>
										</div>
										{% endfor %}
										{% endif %}
									{% endfor %}
								</div>
							</div>
							{% endfor %}
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		{% endif %}
		{% if op == 'statueInfo' %}
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'statueInfo' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=statueInfo">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">神像信息</label>
								<div class="col-xs-12 col-sm-10 col-md-12 col-lg-10">
									{% for key,row in statueType %}
										<div  class="input-group">
											<span class="input-group-addon">{{ row }}</span>
											<input type="text" name="statueInfo[{{ key }}][tName]" value="<?php if (!empty($statueInfo) && !empty($statueInfo[$key]["tName"])){ echo $statueInfo[$key]["tName"]; } ?>"  class="form-control">
											<span class="input-group-addon">简介</span>
											<input type="text" name="statueInfo[{{ key }}][depict]" value="<?php if (!empty($statueInfo) && !empty($statueInfo[$key]["depict"])){ echo $statueInfo[$key]["depict"]; } ?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">宝石</span>
											<select name="statueInfo[{{ key }}][tId]" class="form-control">
												{% for keys,lists in goods %}
												<option value="{{ lists.tId }}" <?php if(!empty($statueInfo) && $statueInfo[$key]["tId"] ==$lists->tId ){ echo "selected";}?>>
														{{ lists.tName }}
													</option>
												{% endfor %}
											</select>
											<span class="input-group-addon">需数量</span>
											<input type="text" name="statueInfo[{{ key }}][price]" value="<?php if (!empty($statueInfo) && !empty($statueInfo[$key]["price"])){ echo $statueInfo[$key]["price"]; } ?>"  class="form-control">
											<span class="input-group-addon">效果时间</span>
											<input type="text" name="statueInfo[{{ key }}][time]" value="<?php if (!empty($statueInfo) && !empty($statueInfo[$key]["time"])){ echo $statueInfo[$key]["time"]; } ?>"  class="form-control">
										</div>
									{% endfor %}
								</div>
							</div>
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		{% endif %}
		{% if op == 'recharge' %}
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'recharge' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=recharge">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">充值信息</label>
								<div class="col-xs-12 col-sm-10 col-md-12 col-lg-10">
									<div  class="input-group">
										<span class="input-group-addon">1 充值</span>
										<input type="hidden" name="recharge[1][id]" value="1"  class="form-control">
										<input type="text" name="recharge[1][diamonds]" value="<?php if (!empty($recharge) && !empty($recharge[1]["diamonds"])){ echo $recharge[1]["diamonds"]; } ?>"  class="form-control">
										<span class="input-group-addon">钻石，需要</span>
										<input type="text" name="recharge[1][money]" value="<?php if (!empty($recharge) && !empty($recharge[1]["money"])){ echo $recharge[1]["money"]; } ?>"  class="form-control">
										<span class="input-group-addon">金币,赠送</span>
										<input type="text" name="recharge[1][give]" value="<?php if (!empty($recharge) && !empty($recharge[1]["give"])){ echo $recharge[1]["give"]; } ?>"  class="form-control">
										<span class="input-group-addon">钻石</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">2 充值</span>
										<input type="hidden" name="recharge[2][id]" value="2"  class="form-control">
										<input type="text" name="recharge[2][diamonds]" value="<?php if (!empty($recharge) && !empty($recharge[2]["diamonds"])){ echo $recharge[2]["diamonds"]; } ?>"  class="form-control">
										<span class="input-group-addon">钻石，需要</span>
										<input type="text" name="recharge[2][money]" value="<?php if (!empty($recharge) && !empty($recharge[2]["money"])){ echo $recharge[2]["money"]; } ?>"  class="form-control">
										<span class="input-group-addon">金币,赠送</span>
										<input type="text" name="recharge[2][give]" value="<?php if (!empty($recharge) && !empty($recharge[2]["give"])){ echo $recharge[2]["give"]; } ?>"  class="form-control">
										<span class="input-group-addon">钻石</span>
									</div>
									<div  class="input-group">
										<span class="input-group-addon">3 充值</span>
										<input type="hidden" name="recharge[3][id]" value="3"  class="form-control">
										<input type="text" name="recharge[3][diamonds]" value="<?php if (!empty($recharge) && !empty($recharge[3]["diamonds"])){ echo $recharge[3]["diamonds"]; } ?>"  class="form-control">
										<span class="input-group-addon">钻石，需要</span>
										<input type="text" name="recharge[3][money]" value="<?php if (!empty($recharge) && !empty($recharge[3]["money"])){ echo $recharge[3]["money"]; } ?>"  class="form-control">
										<span class="input-group-addon">金币,赠送</span>
										<input type="text" name="recharge[3][give]" value="<?php if (!empty($recharge) && !empty($recharge[3]["give"])){ echo $recharge[3]["give"]; } ?>"  class="form-control">
										<span class="input-group-addon">钻石</span>
									</div>
								</div>
							</div>
<!--							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">返佣设置</label>
								<div class="col-xs-12 col-sm-10 col-md-12 col-lg-10" id="rebate">
									<?php if(empty($rebate)){?>
									<div  class="input-group" >
										<span class="input-group-addon">第1代</span>
										<input type="text" name="rebate[1][num]" value="1"  class="form-control">
										<span class="input-group-addon">%</span>
										<span class="input-group-addon" onclick="addLevel()"><i class="glyphicon glyphicon-plus"></i></span>
									</div>
									<?php }else{?>
									{% for key,list in rebate %}
									<div  class="input-group" >
										<span class="input-group-addon">第{{ key }}代</span>
										<input type="text" name="rebate[{{ key }}][num]" value="<?php if (!empty($list) && !empty($list["num"])){ echo $list["num"]; } ?>"  class="form-control">
										<span class="input-group-addon">%</span>
										<span class="input-group-addon" onclick="addLevel()"><i class="glyphicon glyphicon-plus"></i></span>
									</div>
									{% endfor %}
									<?php }?>
								</div>
							</div>-->
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<script>
			var i = 1;
			var attrHtml = '<div class="input-group" data-item="##">\
								<span class="input-group-addon">第##代</span>\
								<input type="text" name="rebate[##][num]" value="0" id="num" class="form-control">\
								<span class="input-group-addon">%</span>';
			attrHtml +='<span class="input-group-addon" onclick="delLevel(this)"><i class="glyphicon glyphicon-minus"></i></span>\
						</div>';
			$(function () {
				i = $("#rebate div").last().attr("data-item");
			});
			function addLevel() {
				++i;
				if(i>10){
					return false;
				}
				$("#rebate").append(attrHtml.replace(/##/g, i));
			}
			function delLevel(obj) {
				var num = $(obj).parent().index() + 1;
				var all = $("#rebate div").length;
				if (num < all) {
					alert("请按顺序删除，不能断层");
					return;
				} else {
					i--;
					$(obj).parent().remove();
				}
			}
			</script>
		{% endif %}
		{% if op == 'background'%}
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'background' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=background">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">背景信息</label>
								<div class="col-xs-12 col-sm-10 col-md-12 col-lg-10">
									<div class="col-xs-12 col-sm-10 col-md-10 col-lg-10">
										<div  class="input-group">
											<span class="input-group-addon"><?php echo $backgroundType[2];?>需</span>
											<select name="background[2][1][pid]" class="form-control">
											{% for keys,lists in product %}
												<option value="{{ lists.id }}" {% if background is defined %}<?php if ($background[2][1]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
													{{ lists.title }}
												</option>
											{% endfor %}
											</select>
											<span class="input-group-addon">数量</span>
											<input type="text" name="background[2][1][num]" value="<?php if (!empty($background) && $background[2][1]['num'] >0){ echo $background[2][1]['num']; }?>"  class="form-control">
											<span class="input-group-addon">+</span>
											<select name="background[2][2][pid]" class="form-control">
											{% for keys,lists in product %}
												<option value="{{ lists.id }}" {% if background is defined %}<?php if ($background[2][2]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
													{{ lists.title }}
												</option>
											{% endfor %}
											</select>
											<span class="input-group-addon">数量</span>
											<input type="text" name="background[2][2][num]" value="<?php if (!empty($background) && $background[2][2]['num'] >0){ echo $background[2][2]['num']; }?>"  class="form-control">
											<span class="input-group-addon">+钻石</span>
											<input type="text" name="background[2][3][num]" value="<?php if (!empty($background) && $background[2][3]['num'] >0){ echo $background[2][3]['num']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon"><?php echo $backgroundType[3];?>需</span>
											<select name="background[3][1][pid]" class="form-control">
											{% for keys,lists in product %}
												<option value="{{ lists.id }}" {% if background is defined %}<?php if ($background[3][1]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
													{{ lists.title }}
												</option>
											{% endfor %}
											</select>
											<span class="input-group-addon">数量</span>
											<input type="text" name="background[3][1][num]" value="<?php if (!empty($background) && $background[3][1]['num'] >0){ echo $background[3][1]['num']; }?>"  class="form-control">
											<span class="input-group-addon">+</span>
											<select name="background[3][2][pid]" class="form-control">
											{% for keys,lists in product %}
												<option value="{{ lists.id }}" {% if background is defined %}<?php if ($background[3][2]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
													{{ lists.title }}
												</option>
											{% endfor %}
											</select>
											<span class="input-group-addon">数量</span>
											<input type="text" name="background[3][2][num]" value="<?php if (!empty($background) && $background[3][2]['num'] >0){ echo $background[3][2]['num']; }?>"  class="form-control">
											<span class="input-group-addon">+钻石</span>
											<input type="text" name="background[3][3][num]" value="<?php if (!empty($background) && $background[3][3]['num'] >0){ echo $background[3][3]['num']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon"><?php echo $backgroundType[4];?>需</span>
											<select name="background[4][1][pid]" class="form-control">
											{% for keys,lists in product %}
												<option value="{{ lists.id }}" {% if background is defined %}<?php if ($background[4][1]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
													{{ lists.title }}
												</option>
											{% endfor %}
											</select>
											<span class="input-group-addon">数量</span>
											<input type="text" name="background[4][1][num]" value="<?php if (!empty($background) && $background[4][1]['num'] >0){ echo $background[4][1]['num']; }?>"  class="form-control">
											<span class="input-group-addon">+</span>
											<select name="background[4][2][pid]" class="form-control">
											{% for keys,lists in product %}
												<option value="{{ lists.id }}" {% if background is defined %}<?php if ($background[4][2]['pid'] == $lists->id){?>selected<?php }?>{% endif %}>
													{{ lists.title }}
												</option>
											{% endfor %}
											</select>
											<span class="input-group-addon">数量</span>
											<input type="text" name="background[4][2][num]" value="<?php if (!empty($background) && $background[4][2]['num'] >0){ echo $background[4][2]['num']; }?>"  class="form-control">
											<span class="input-group-addon">+钻石</span>
											<input type="text" name="background[4][3][num]" value="<?php if (!empty($background) && $background[4][3]['num'] >0){ echo $background[4][3]['num']; }?>"  class="form-control">
										</div>
									</div>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		{% endif %}
		{% if op == 'package'%}
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'package' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=package">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">推荐注册礼包信息</label>
								<div class="col-xs-12 col-sm-10 col-md-12 col-lg-10">
									<div class="col-xs-12 col-sm-10 col-md-10 col-lg-10">
										<div  class="input-group">
											<span class="input-group-addon">种子</span>
											<input type="text" name="package[seed]" value="<?php if (!empty($package) && $package['seed'] >0){ echo $package['seed']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['diamonds']?></span>
											<input type="text" name="package[diamonds]" value="<?php if (!empty($package) && $package["diamonds"] >0){ echo $package['diamonds']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['cfert']?></span>
											<input type="text" name="package[cfert]" value="<?php if (!empty($package) && $package["cfert"] >0){ echo $package['cfert']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['hcide']?></span>
											<input type="text" name="package[hcide]" value="<?php if (!empty($package) && $package["hcide"] >0){ echo $package['hcide']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['icide']?></span>
											<input type="text" name="package[icide]" value="<?php if (!empty($package) && $package["icide"] >0){ echo $package['icide']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['wcan']?></span>
											<input type="text" name="package[wcan]" value="<?php if (!empty($package) && $package["wcan"] >0){ echo $package['wcan']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon"><?php echo $tableType['emerald']?></span>
											<input type="text" name="package[emerald]" value="<?php if (!empty($package) && $package["emerald"] >0){ echo $package['emerald']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['purplegem']?></span>
											<input type="text" name="package[purplegem]" value="<?php if (!empty($package) && $package["purplegem"] >0){ echo $package['purplegem']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['sapphire']?></span>
											<input type="text" name="package[sapphire]" value="<?php if (!empty($package) && $package["sapphire"] >0){ echo $package['sapphire']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['topaz']?></span>
											<input type="text" name="package[topaz]" value="<?php if (!empty($package) && $package["topaz"] >0){ echo $package['topaz']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">礼包说明</span>
											<input type="text" name="package[info]" value="<?php if (!empty($package) && $package["info"] >0){ echo $package['info']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">是否需有推荐人</span>
											<select name="package[status]" class="form-control">
												<option value="1" <?php if (!empty($package) && $package["status"] ==1){ echo "selected"; }?>>需要</option>
												<option value="0" <?php if (!empty($package) && $package["status"] !=1){ echo "selected"; }?>>不需要</option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">补偿礼包信息</label>
								<div class="col-xs-12 col-sm-10 col-md-12 col-lg-10">
									<div class="col-xs-12 col-sm-10 col-md-10 col-lg-10">
										<div  class="input-group">
											<span class="input-group-addon">种子</span>
											<input type="text" name="indemnify[seed]" value="<?php if (!empty($indemnify) && $indemnify['seed'] >0){ echo $indemnify['seed']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['diamonds']?></span>
											<input type="text" name="indemnify[diamonds]" value="<?php if (!empty($indemnify) && $indemnify["diamonds"] >0){ echo $indemnify['diamonds']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['cfert']?></span>
											<input type="text" name="indemnify[cfert]" value="<?php if (!empty($indemnify) && $indemnify["cfert"] >0){ echo $indemnify['cfert']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['hcide']?></span>
											<input type="text" name="indemnify[hcide]" value="<?php if (!empty($indemnify) && $indemnify["hcide"] >0){ echo $indemnify['hcide']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['icide']?></span>
											<input type="text" name="indemnify[icide]" value="<?php if (!empty($indemnify) && $indemnify["icide"] >0){ echo $indemnify['icide']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['wcan']?></span>
											<input type="text" name="indemnify[wcan]" value="<?php if (!empty($indemnify) && $indemnify["wcan"] >0){ echo $indemnify['wcan']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon"><?php echo $tableType['emerald']?></span>
											<input type="text" name="indemnify[emerald]" value="<?php if (!empty($indemnify) && $indemnify["emerald"] >0){ echo $indemnify['emerald']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['purplegem']?></span>
											<input type="text" name="indemnify[purplegem]" value="<?php if (!empty($indemnify) && $indemnify["purplegem"] >0){ echo $indemnify['purplegem']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['sapphire']?></span>
											<input type="text" name="indemnify[sapphire]" value="<?php if (!empty($indemnify) && $indemnify["sapphire"] >0){ echo $indemnify['sapphire']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['topaz']?></span>
											<input type="text" name="indemnify[topaz]" value="<?php if (!empty($indemnify) && $indemnify["topaz"] >0){ echo $indemnify['topaz']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">礼包说明</span>
											<input type="text" name="indemnify[info]" value="<?php if (!empty($indemnify) && $indemnify["info"] >0){ echo $indemnify['info']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">状态</span>
											<select name="indemnify[status]" class="form-control">
												<option value="1" <?php if (!empty($indemnify) && $indemnify["status"] ==1){ echo "selected"; }?>>启用</option>
												<option value="0" <?php if (!empty($indemnify) && $indemnify["status"] !=1){ echo "selected"; }?>>关闭</option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">新人礼包信息</label>
								<div class="col-xs-12 col-sm-10 col-md-12 col-lg-10">
									<div class="col-xs-12 col-sm-10 col-md-10 col-lg-10">
										<div  class="input-group">
											<span class="input-group-addon">种子</span>
											<input type="text" name="newGiftPack[seed]" value="<?php if (!empty($newGiftPack) && $newGiftPack['seed'] >0){ echo $newGiftPack['seed']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['diamonds']?></span>
											<input type="text" name="newGiftPack[diamonds]" value="<?php if (!empty($newGiftPack) && $newGiftPack["diamonds"] >0){ echo $newGiftPack['diamonds']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['cfert']?></span>
											<input type="text" name="newGiftPack[cfert]" value="<?php if (!empty($newGiftPack) && $newGiftPack["cfert"] >0){ echo $newGiftPack['cfert']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['hcide']?></span>
											<input type="text" name="newGiftPack[hcide]" value="<?php if (!empty($newGiftPack) && $newGiftPack["hcide"] >0){ echo $newGiftPack['hcide']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['icide']?></span>
											<input type="text" name="newGiftPack[icide]" value="<?php if (!empty($newGiftPack) && $newGiftPack["icide"] >0){ echo $newGiftPack['icide']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['wcan']?></span>
											<input type="text" name="newGiftPack[wcan]" value="<?php if (!empty($newGiftPack) && $newGiftPack["wcan"] >0){ echo $newGiftPack['wcan']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon"><?php echo $tableType['emerald']?></span>
											<input type="text" name="newGiftPack[emerald]" value="<?php if (!empty($newGiftPack) && $newGiftPack["emerald"] >0){ echo $newGiftPack['emerald']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['purplegem']?></span>
											<input type="text" name="newGiftPack[purplegem]" value="<?php if (!empty($newGiftPack) && $newGiftPack["purplegem"] >0){ echo $newGiftPack['purplegem']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['sapphire']?></span>
											<input type="text" name="newGiftPack[sapphire]" value="<?php if (!empty($newGiftPack) && $newGiftPack["sapphire"] >0){ echo $newGiftPack['sapphire']; }?>"  class="form-control">
											<span class="input-group-addon">+<?php echo $tableType['topaz']?></span>
											<input type="text" name="newGiftPack[topaz]" value="<?php if (!empty($newGiftPack) && $newGiftPack["topaz"] >0){ echo $newGiftPack['topaz']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">礼包说明</span>
											<input type="text" name="newGiftPack[info]" value="<?php if (!empty($newGiftPack) && $newGiftPack["info"] >0){ echo $newGiftPack['info']; }?>"  class="form-control">
											<input type="hidden" name="newGiftPack[starttime]" value="{{ time() }}"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">状态</span>
											<select name="newGiftPack[status]" class="form-control">
												<option value="1" <?php if (!empty($newGiftPack) && $newGiftPack["status"] ==1){ echo "selected"; }?>>启用</option>
												<option value="0" <?php if (!empty($newGiftPack) && $newGiftPack["status"] !=1){ echo "selected"; }?>>关闭</option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		{% endif %}
		{% if op == 'sign'%}
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'sign' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=sign">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">签到信息</label>
								<div class="col-xs-12 col-sm-10 col-md-12 col-lg-10">
									<div class="col-xs-12 col-sm-10 col-md-10 col-lg-10">
										<div  class="input-group">
											<span class="input-group-addon">每天签到次数</span>
											<input type="text" name="sign[daySize]" value="<?php if (!empty($sign) && $sign['daySize'] >0){ echo $sign['daySize']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">种子</span>
											<input type="text" name="sign[seed]" value="<?php if (!empty($sign) && $sign['seed'] >0){ echo $sign['seed']; }?>"  class="form-control">
											<span class="input-group-addon"><?php echo $tableType['diamonds']?></span>
											<input type="text" name="sign[diamonds]" value="<?php if (!empty($sign) && $sign["diamonds"] >0){ echo $sign['diamonds']; }?>"  class="form-control">
											<span class="input-group-addon"><?php echo $tableType['cfert']?></span>
											<input type="text" name="sign[cfert]" value="<?php if (!empty($sign) && $sign["cfert"] >0){ echo $sign['cfert']; }?>"  class="form-control">
											<span class="input-group-addon"><?php echo $tableType['hcide']?></span>
											<input type="text" name="sign[hcide]" value="<?php if (!empty($sign) && $sign["hcide"] >0){ echo $sign['hcide']; }?>"  class="form-control">
											<span class="input-group-addon"><?php echo $tableType['icide']?></span>
											<input type="text" name="sign[icide]" value="<?php if (!empty($sign) && $sign["icide"] >0){ echo $sign['icide']; }?>"  class="form-control">
											<span class="input-group-addon"><?php echo $tableType['wcan']?></span>
											<input type="text" name="sign[wcan]" value="<?php if (!empty($sign) && $sign["wcan"] >0){ echo $sign['wcan']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon"><?php echo $tableType['emerald']?></span>
											<input type="text" name="sign[emerald]" value="<?php if (!empty($sign) && $sign["emerald"] >0){ echo $sign['emerald']; }?>"  class="form-control">
											<span class="input-group-addon"><?php echo $tableType['purplegem']?></span>
											<input type="text" name="sign[purplegem]" value="<?php if (!empty($sign) && $sign["purplegem"] >0){ echo $sign['purplegem']; }?>"  class="form-control">
											<span class="input-group-addon"><?php echo $tableType['sapphire']?></span>
											<input type="text" name="sign[sapphire]" value="<?php if (!empty($sign) && $sign["sapphire"] >0){ echo $sign['sapphire']; }?>"  class="form-control">
											<span class="input-group-addon"><?php echo $tableType['topaz']?></span>
											<input type="text" name="sign[topaz]" value="<?php if (!empty($sign) && $sign["topaz"] >0){ echo $sign['topaz']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">奖励类型</span>
											<select name="sign[types]" class="form-control">
<!--												<option value="1" <?php if (!empty($sign) && $sign["types"] ==1){ echo "selected"; }?>>全部奖励</option>-->
												<option value="2" <?php if (!empty($sign) && $sign["types"] ==2){ echo "selected"; }?>>随机奖励</option>
											</select>
										</div>
										<div  class="input-group">
											<span class="input-group-addon">状态</span>
											<select name="sign[status]" class="form-control">
												<option value="1" <?php if (!empty($sign) && $sign["status"] ==1){ echo "selected"; }?>>启用</option>
												<option value="0" <?php if (!empty($sign) && $sign["status"] !=1){ echo "selected"; }?>>关闭</option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		{% endif %}
		{% if op == 'steal' %}
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'steal' %}active in{% else %} {% endif %}{% endif%}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=steal">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">好友互偷</label>
								<div class="col-xs-12 col-sm-10 col-md-12 col-lg-10">
									<div class="col-xs-12 col-sm-10 col-md-10 col-lg-10">
										{% for l,v in userType %}
										<div  class="input-group">
											<span class="input-group-addon">会员{{ v }}级可偷取</span>
											<select name="steal[goods][{{ v }}][]" class="form-control" multiple="true" style="height:210px;">
												{% for keys,lists in product %}
													<option value="{{ lists.id }}" {% if steal is defined %}<?php if(@in_array($lists->id,$steal['goods'][$v])){?>selected<?php }?>{% endif %}>
														{{ lists.title }}
													</option>
												{% endfor %}
											</select>
										</div>
										{% endfor%}
										<div  class="input-group">
											<span class="input-group-addon">偷取成功最少</span>
											<input type="text" name="steal[success][min]" value="<?php if (!empty($steal) && $steal["success"]['min'] >0){ echo $steal['success']['min']; }?>"  class="form-control">
											<span class="input-group-addon">最多</span>
											<input type="text" name="steal[success][max]" value="<?php if (!empty($steal) && $steal["success"]['max'] >0){ echo $steal['success']['max']; }?>"  class="form-control">
											<span class="input-group-addon">扣除宠物体力</span>
											<input type="text" name="steal[success][power]" value="<?php if (!empty($steal) && $steal["success"]['power'] >0){ echo $steal['success']['power']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">偷取失败扣除宠物体力</span>
											<input type="text" name="steal[error][power]" value="<?php if (!empty($steal) && $steal["error"]['power'] >0){ echo $steal['error']['power']; }?>"  class="form-control">
											<span class="input-group-addon">增加被偷方宠物经验</span>
											<input type="text" name="steal[error][experience]" value="<?php if (!empty($steal) && $steal["error"]['experience'] >0){ echo $steal['error']['experience']; }?>"  class="form-control">
										</div>
										<div  class="input-group">
											<span class="input-group-addon">偷取概率</span>
											<input type="text" name="steal[chance][0]" value="<?php if (!empty($steal) && $steal["chance"][0] >0){ echo $steal['chance'][0]; }?>"  class="form-control">
											<span class="input-group-addon">%宠物提高概率</span>
											<input type="text" name="steal[chance][1]" value="<?php if (!empty($steal) && $steal["chance"][1] >0){ echo $steal['chance'][1]; }?>"  class="form-control">
											<span class="input-group-addon">%降低概率</span>
											<input type="text" name="steal[chance][2]" value="<?php if (!empty($steal) && $steal["chance"][2] >0){ echo $steal['chance'][2]; }?>"  class="form-control">
											<span class="input-group-addon">%</span>
										</div>
										<div  class="input-group">
											<span class="input-group-addon">每天偷取</span>
											<input type="text" name="steal[dayInfo][1]" value="<?php if (!empty($steal) && $steal["dayInfo"][1] >0){ echo $steal['dayInfo'][1]; }?>"  class="form-control">
											<span class="input-group-addon">次单个好友被偷上限</span>
											<input type="text" name="steal[dayInfo][2]" value="<?php if (!empty($steal) && $steal["dayInfo"][2] >0){ echo $steal['dayInfo'][2]; }?>"  class="form-control">
											<span class="input-group-addon">次数</span>
										</div>
										<div  class="input-group">
											<span class="input-group-addon">状态</span>
											<select name="steal[status]" class="form-control">
												<option value="1" <?php if (!empty($sign) && $sign["status"] ==1){ echo "selected"; }?>>启用</option>
												<option value="0" <?php if (!empty($sign) && $sign["status"] !=1){ echo "selected"; }?>>关闭</option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="panel-footer text-left">
								<input class="form-control"  type="hidden" name="id" value="{% if item != '' %}{{ item.id }}{% endif %}">
								<button class="btn btn-success" type="submit">提交</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		{% endif %}
		{% if op == 'crystal'%}
        		<div class="tab-content">
        			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'crystal' %}active in{% else %} {% endif %}{% endif%}">
        				<div class="panel">
        					<div class="panel-body">
        						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=crystal">
        							<div class="form-group">
        								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">兑换信息</label>
        								<div class="col-xs-12 col-sm-10 col-md-12 col-lg-10">
        									<div class="col-xs-12 col-sm-10 col-md-10 col-lg-10">
        										<div  class="input-group">
                                                	<span class="input-group-addon">需</span>
                                                	<select name="crystal[pid1]" class="form-control">
                                                	{% for keys,lists in product %}
                                                	<option value="{{ lists.id }}" {%if crystal is defined %}{% if lists.id == crystal['pid1'] %}selected{%endif%}{% endif %} >
                                                		{{ lists.title }}
                                                		</option>
                                                	{% endfor %}
                                                	</select>
                                                	<span class="input-group-addon">数量</span>
                                                	<input type="text" name="crystal[num1]" value=" {%if crystal is defined %}{{crystal['num1']}}{% endif %}"  class="form-control">
                                                	<span class="input-group-addon">+</span>
                                                	<select name="crystal[pid2]" class="form-control">
                                                    {% for keys,lists in product %}
                                                         <option value="{{ lists.id }}" {%if crystal is defined %}{% if lists.id == crystal['pid2'] %}selected{%endif%}{% endif %} >
                                                         {{ lists.title }}
                                                         </option>
                                                    {% endfor %}
                                                    </select>
                                                    <span class="input-group-addon">数量</span>
                                                    <input type="text" name="crystal[num2]" value="{%if crystal is defined %}{{crystal['num2']}}{% endif %}"  class="form-control">
                                                </div>

                                                <div class="input-group">
													<select name="crystal[pid3]" class="form-control">
													   {% for keys,lists in product %}
														  <option value="{{ lists.id }}" {%if crystal is defined %}{% if lists.id == crystal['pid3'] %}selected{%endif%}{% endif %}>
														   {{ lists.title }}
														  </option>
													   {% endfor %}
													   </select>
													   <span class="input-group-addon">数量</span>
													   <input type="text" name="crystal[num3]" value="{%if crystal is defined %}{{crystal['num3']}}{% endif %}"  class="form-control">
													   <span class="input-group-addon">获得水晶</span>
													   <input type="text" name="crystal[crystal]" value="{%if crystal is defined %}{{crystal['crystal']}}{% endif %}"  class="form-control">
                                                </div>
                                        	</div>

        								</div>
        							</div>
        							 <div class="form-group">
                                                                                       <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
                                                                                       <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                                                          <select name="crystal[status]" class="form-control">
                                                                                               <option value="1" {% if crystal is defined %}{% if crystal['status'] == 1 %}selected{% endif %}{% endif %}>启用</option>
                                                                                               <option value="9" {% if crystal is defined %}{% if crystal['status'] == 9 %}selected{% endif %}{% endif %}>禁用</option>
                                                                                          </select>
                                                                                       </div>
                                                                                 </div>
        							<div class="panel-footer text-left">
        								<button class="btn btn-success" type="submit">提交</button>
        							</div>
        						</form>
        					</div>
        				</div>
        			</div>
        		</div>
        		{% endif %}
        		{% if op == 'downgrade' %}
				<div class="tab-content">
        			<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'downgrade' %}active in{% else %} {% endif %}{% endif%}">
        				<div class="panel">
        					<div class="panel-body">
        						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=downgrade">
        							<div class="form-group">
										<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">限定房屋等级启用</label>
										 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
											<div class="input-group">
												<input type="text" name="downgrade[grade]" value="{%if downgrade is defined %}{{downgrade['grade']}}{% endif %}"  class="form-control">
											 </div>
										</div>
									</div>
									{% for key,row in downgrade['land'] %}
									<div class="form-group">
										<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">{% if key >0%}{{ key }}{% endif %}级房屋</label>
										 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
											<div class="input-group">
												<span class="input-group-addon">升级</span>
												<input type="text" name="downgrade[land][{{ key }}][day]" value="{%if row['day'] is defined %}{{row['day']}}{% endif %}"  class="form-control">
												<span class="input-group-addon">天后不升级掉到</span>
												<input type="text" name="downgrade[land][{{ key }}][grade]" value="{%if row['grade'] is defined %}{{row['grade']}}{% endif %}"  class="form-control">
												<span class="input-group-addon">级</span>
											 </div>
										</div>
									</div>
									{% endfor %}
        							 <div class="form-group">
										   <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
										   <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
											  <select name="downgrade[status]" class="form-control">
												   <option value="1" {% if downgrade is defined %}{% if downgrade['status'] == 1 %}selected{% endif %}{% endif %}>启用</option>
												   <option value="0" {% if downgrade is defined %}{% if downgrade['status'] == 0 %}selected{% endif %}{% endif %}>关闭</option>
											  </select>
										   </div>
									 </div>
        							<div class="panel-footer text-left">
										<button class="btn btn-success" type="submit">提交</button>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
        		{% endif %}
        		{% if op == 'EMG' %}
        		<div class="tab-content">
					<div id="demo-lft-tab-1" class="tab-pane fade {% if op is defined%}{% if op == 'EMG' %}active in{% else %} {% endif %}{% endif%}">
						<div class="panel">
							<div class="panel-body">
								<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/orchard/config?op=EMG">
									<div class="form-group">
										<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">appkey</label>
										 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
												<input type="text" name="EMG[appkey]" value="{%if EMG is defined %}{{EMG['appkey']}}{% endif %}"  class="form-control">
										</div>
									</div>
									<div class="form-group">
										<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">appSecret</label>
										 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
												<input type="text" name="EMG[appSecret]" value="{%if EMG is defined %}{{EMG['appSecret']}}{% endif %}"  class="form-control">
										</div>
									</div>
									<div class="form-group">
										<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">域名</label>
										 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
												<input type="text" name="EMG[httpUrl]" value="{%if EMG is defined %}{{EMG['httpUrl']}}{% endif %}"  class="form-control">
										</div>
									</div>
									<div class="panel-footer text-left">
										<button class="btn btn-success" type="submit">提交</button>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
        		{% endif %}
	</div>
