{% if login is defined %}
	{% if login === 'login' %}
<div class="boxed">
	<div id="content-container">
		<div id="page-content">
		{{ content() }}
		</div>
	</div>
	<nav id="mainnav-container">
		<div id="mainnav">
			<div id="mainnav-menu-wrap">
				<div class="nano">
					<div class="nano-content" style="padding-top: 0">
						<ul id="mainnav-menu" class="list-group">
							<li>
								<a href="{{apppath}}/article/category?op=list">
									<i class="fa fa-home"></i>
									<span class="menu-title"><strong>控制台首页</strong></span>
								</a>
							</li>
							<li class="list-header">基础功能</li>
							{% if article is defined %}
							<li>
								<a href="#">
									<i class="fa fa-file-text"></i>
									<span class="menu-title"><strong>文章管理</strong></span>
									<i class="arrow"></i>
								</a>
								<ul class="collapse">
									<li><a href="{{apppath}}/article/category?op=list">文章分类</a></li>
									<li><a href="{{apppath}}/article/article?op=list">文章列表</a></li>
									<li><a href="{{apppath}}/article/raiders?op=list">攻略心得</a></li>
								</ul>

							</li>
							{% endif %}
							<li>
								<a href="#">
									<i class="fa fa-line-chart"></i>
									<span class="menu-title"><strong>大盘管理</strong></span>
									<i class="arrow"></i>
								</a>
								<ul class="collapse">
									<li><a href="{{apppath}}/product/plist?op=list&page=1">交易大厅</a></li>
									{% if product is defined %}
									<li><a href="{{apppath}}/product/product/page">产品列表</a></li>
									{% endif %}
									<li><a href="{{apppath}}/product/pdata/page">交易数据</a></li>
									<li><a href="{{apppath}}/product/logs">日志管理</a></li>
									<li><a href="{{apppath}}/product/give?status=3">赠送记录</a></li>
									<li><a href="{{apppath}}/product/config">功能设置</a></li>
									<li><a href="{{apppath}}/product/orderReturn">订单退回</a></li>
									{% if user_type =='chuangjin'%}
									<li><a href="{{apppath}}/product/landfixed">土地修复</a></li>
									{% endif%}
									<li><a href="{{apppath}}/user/commission">佣金统计</a></li>
									{#<li><a href="{{apppath}}/userwithdraw/over?page=1">提现完成</a></li>#}
									<li><a href="{{apppath}}/product/frozen">冻结产品比对</a></li>
									<li><a href="{{apppath}}/user/idcard?page=1">身份证审核</a></li>
								</ul>
							</li>
							{% if user is defined %}
							<li>
								<a href="{{apppath}}/user/list?op=list">
									<i class="fa fa-user-circle-o"></i>
									<span class="menu-title"><strong>用户管理</strong></span>
								</a>
							</li>
							<li>
                            	<a href="{{apppath}}/user/online">
                            		<i class="fa fa-user-circle-o"></i>
                            		<span class="menu-title"><strong>在线人数统计</strong></span>
                            	</a>
                            </li>
							{% endif %}
							<li>
								{% if warehouse is defined %}
								{#仓库货存#}
								<a href="{{apppath}}/warehouse/list?op=manage">
									<i class="fa fa-pie-chart"></i>
									<span class="menu-title"><strong>数据统计</strong></span>
								</a>
							</li>
								{% endif %}
							{% if userwithdraw is defined %}
						            <li>
                                         <a href="#">
                                             <i class="fa fa-dollar"></i>
                                                <span class="menu-title"><strong>提现管理</strong></span>
                                             <i class="arrow"></i>
                                         </a>
                                         <ul class="collapse">
                                             <li><a href="{{ apppath }}/userwithdraw/list?op=list">提现管理</a></li>
                                             <li><a href="{{apppath}}/userwithdraw/over?page=1">提现完成</a></li>
                                             {%if user_type =='shennongzhuangyuan'%}
                                             <li><a href="{{apppath}}/userwithdraw/virtual?page=1">虚拟币提现</a></li>
                                             {%endif%}
                                         </ul>
                                    </li>
						{#提现	<li>

								<a href="{{ apppath }}/userwithdraw/list?op=list">
									<i class="fa fa-dollar"></i>
									<span class="menu-title"><strong> 提现管理</strong></span>
								</a>

							</li>#}
								{% endif %}

								{% if jurisdiction is defined %}
							<li>
								{#用户权限#}
								<a href="#">
									<i class="fa fa-balance-scale"></i>
									<span class="menu-title"><strong>权限与支付</strong></span>
									<i class="arrow"></i>
								</a>
								<ul class="collapse">
								<li>
									<a href="{{ apppath }}/jurisdiction/list">
									<i class="fa fa-unlock-alt"></i>权限管理</a>
								</li>
								<li><a href="{{ apppath }}/recharge/show">
									<i class="fa fa-unlock-alt"></i>支付设置</a>
								</li>
								<li><a href="{{ apppath }}/recharge/recharge">
                                	<i class="fa fa-unlock-alt"></i>支付列表</a>
                                </li>
								</ul>
							</li>
							{% endif %}
							{% if config is defined %}
							<li class="list-header">系统管理</li>
							<li>
								<a href="#">
									<i class="fa fa-cog"></i>
									<span class="menu-title"><strong>系统设置</strong></span>
									<i class="arrow"></i>
								</a>
								<ul class="collapse">
									<li><a href="{{apppath}}/config/index">站点设置</a></li>
									<li><a href="#">附件设置</a></li>
									<li><a href="{{apppath}}/config/sitMessage">短信设置</a></li>
								</ul>
							</li>
							<li>
								<a href="#">
									<i class="fa fa-desktop"></i>
									<span class="menu-title"><strong>前台设置</strong></span>
									<i class="arrow"></i>
								</a>
								<ul class="collapse">
									<li><a href="{{apppath}}/config/slide?op=list">首页幻灯</a></li>
								</ul>
								<ul class="collapse">
                                	<li><a href="{{apppath}}/config/groups">图片设置</a></li>
                                </ul>
								<ul class="collapse">
									<li><a href="{{apppath}}/config/service">服务中心</a></li>
								</ul>
								<ul class="collapse">
                                	<li><a href="{{apppath}}/config/copyright">公司信息</a></li>
                                </ul>
                                <ul class = "collapse">
                               	 <li><a href="{{apppath}}/config/gameinfo">游戏信息</a></li>
                                </ul>
                                {% if user_type == 'shennongzhuangyuan'%}
                                <ul class = "collapse">
                                   <li><a href="{{apppath}}/config/userwithdraw">提现设置</a></li>
                                </ul>
                                {%endif%}
							</li>
							{% if spread is defined%}
							<li>
								<a href="{{ apppath }}/disconfig/index">
									<i class="fa fa-dollar"></i>
									<span class="menu-title"><strong> 推广设置</strong></span>
								</a>
							</li>
							{%endif%}
							{% endif %}
							{% if orchard is defined %}
							<li class="list-header">游戏管理</li>
							<li>
								<a href="#">
									<i class="fa fa-cog"></i>
									<span class="menu-title"><strong>基础管理</strong></span>
									<i class="arrow"></i>
								</a>
								<ul class="collapse">
									<li><a href="{{apppath}}/orchard/config">参数设置</a></li>
									<li><a href="{{apppath}}/orchard/goods">商品设置</a></li>
									<li><a href="{{apppath}}/orchard/user">会员管理</a></li>
									<li><a href="{{apppath}}/orchard/logs">日志管理</a></li>
									<li><a href="{{apppath}}/orchard/order?op=display&payStatus=1">订单管理</a></li>
									<li><a href="{{apppath}}/orchard/orchard">果园管理</a></li>
									<li><a href="{{apppath}}/orchard/dog">宠物管理</a></li>
								</ul>
							</li>
							{% endif %}
							{% if core is defined%}
							<li class="list-header">核心功能</li>
                            	<li>
                            		<a href="#">
                            			<i class="fa fa-cog"></i>
                            			<span class="menu-title"><strong>核心功能</strong></span>
                            			<i class="arrow"></i>
                            		</a>
                            		<ul class="collapse">
                            			<li><a href="{{apppath}}/user/list?op=recharge">金币充值</a></li>
                            			<li><a href="{{apppath}}/orchard/user?op=admin">游戏钻石</a></li>
                            			<li><a href="{{apppath}}/warehouse/list?op=addp">产品充值</a></li>
                            		</ul>
                            	</li>
							{% endif%}
						</ul>
					</div>
				</div>
			</div>
		</div>
	</nav>
</div>
	{% endif %}
{% endif %}
