<div class="tab-base">
	<?php $this->flashSession->output(); ?>
	<!--Nav Tabs-->
	<ul class="nav nav-tabs">
		<li class="active">
			<a data-toggle="tab" href="#">功能设置</a>
		</li>
	</ul>
	<!--Tabs Content-->
	<div class="tab-content">
		<div class="tab-pane fade active in">
			<div class="panel">
				{#<div class="panel-heading">#}
				{#<h3 class="panel-title">Sample Toolbar</h3>#}
				{#</div>#}
				<div class="panel-body">
					<form class="form-horizontal form-padding" method = 'post' action="{{ apppath }}/product/config">
						<div class="tab-content">
                        			<div id="demo-lft-tab-1" class="tab-pane fade active in">
                        				<div class="panel">
                        					<div class="panel-body">
                        							<div class="form-group">
                        								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">交易限制</label>
                        								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                        									<div  class="input-group">
                        										<span class="input-group-addon">交易等级</span>
                        										<span class="input-group-addon">买</span>
                        										<input type="text" name="buyLevel" value="{% if config is defined%}{{config['buyLevel']}}{% endif%}" placeholder = '默认为4级' class="form-control">
                        										<span class="input-group-addon">级</span>
                        										<span class="input-group-addon">卖</span>
                        										<input type="text" name="sellLevel" value="{% if config is defined%}{{config['sellLevel']}}{% endif%}" placeholder = '默认为4级' class="form-control">
                        										<span class="input-group-addon">级</span>
                        									</div>
                        								</div>
                        							</div>
                        							<div class="form-group">
                                                        <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">交易时间</label>
                                                        <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                            <div  class="input-group">
																<span class="input-group-addon">交易时间</span>
																<span class="input-group-addon">开市</span>
																<input type="text" name="openTime" value="{% if config['openTime'] is defined%}{{config['openTime']}}{% endif%}"  placeholder = '默认为9时' class="form-control">
																<span class="input-group-addon">时</span>
																<span class="input-group-addon">闭市</span>
                                                                <input type="text" name="closeTime" value="{% if config['closeTime'] is defined%}{{config['closeTime']}}{% endif%}"   placeholder = '默认为24时' class="form-control">
                                                            	<span class="input-group-addon">时</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    {%if user_type == 'huangjin'%}
                        							<div class="form-group">
                                                         <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">赠送限制</label>
                                                         <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                             			    <div  class="input-group">
                                                                 <span class="input-group-addon">赠送等级</span>
                                                                 <span class="input-group-addon">赠送</span>
                                                                 <input type="text" name="giveLevel" value="{% if config['giveLevel'] is defined%}{{config['giveLevel']}}{% endif%}"  placeholder = '默认为4级' class="form-control">
                                                                 <span class="input-group-addon">级</span>
                                                                 <span class="input-group-addon">接收</span>
                                                              	 <input type="text" name="acceptLevel" value="{% if config['acceptLevel'] is defined%}{{config['acceptLevel']}}{% endif%}"  placeholder = '默认为4级' class="form-control">
                                                           		 <span class="input-group-addon">级</span>
                                                            </div>
                                                            <div  class="input-group">
                                                            	<span class="input-group-addon">数量限制</span>
                                                            	<span class="input-group-addon">最少</span>
                                                            	<input type="text" name="giveNumberLeast" value="{% if config['giveNumberLeast'] is defined%}{{config['giveNumberLeast']}}{% endif%}"  placeholder = '默认为10个' class="form-control">
                                                            	<span class="input-group-addon">个</span>
                                                            	<span class="input-group-addon">最多</span>
                                                            	<input type="text" name="giveNumberMost" value="{% if config['giveNumberMost'] is defined%}{{config['giveNumberMost']}}{% endif%}"  placeholder = '默认为1000个' class="form-control">
                                                            	<span class="input-group-addon">个</span>
                                                            </div>
                                                            <div  class="input-group">
                                                                <span class="input-group-addon">索取金币</span>
                                                                <span class="input-group-addon">单价最低</span>
                                                                <input type="text" name="giveGoldLeast" value="{% if config['giveGoldLeast'] is defined%}{{config['giveGoldLeast']}}{% endif%}"  placeholder = '单价默认为该产品涨停价' class="form-control">
                                                                <span class="input-group-addon">个</span>
                                                                <span class="input-group-addon">单价最高</span>
                                                                <input type="text" name="giveGoldMost" value="{% if config['giveGoldMost'] is defined%}{{config['giveGoldMost']}}{% endif%}"  placeholder = '单价默认不限制' class="form-control">
                                                                <span class="input-group-addon">个</span>
                                                             </div>
                                                             <div  class="input-group">
																  <span class="input-group-addon">次数限制</span>
																  <span class="input-group-addon">单日赠送</span>
																  <input type="text" name="giveFrequency" value="{% if config['giveFrequency'] is defined%}{{config['giveFrequency']}}{% endif%}"  placeholder = '默认单日赠送为3次' class="form-control">
																  <span class="input-group-addon">次</span>
															 </div>
														 </div>
                                                    </div>
                                                  {% endif%}
                                                    <div class="form-group">
                                                       <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">交易开关</label>
                                                           <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                           	  <select name="tradeStatus" class="form-control">
                                                             	<option value="9" {% if config['tradeStatus'] is defined%} {% if config['tradeStatus'] == 9 %}selected{%endif%} {%endif%}>
                                                                   关闭
                                                                </option>
                                                              	<option value="1" {% if config['tradeStatus'] is defined%} {% if config['tradeStatus'] == 1 %}selected{%endif%} {%endif%}>
                                                                   开启
                                                                </option>
                                                            </select>
                                                          </div>
                                                     </div>
                                                     <div class="form-group">
                                                          <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">种植开关</label>
                                                           <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                                <select name="orchardStatus" class="form-control">
                                                                <option value="9" {% if config['orchardStatus'] is defined%} {% if config['orchardStatus'] == 9 %}selected{%endif%} {%endif%}>
                                                                   关闭
                                                                </option>
                                                                <option value="1" {% if config['orchardStatus'] is defined%} {% if config['orchardStatus'] == 1 %}selected{%endif%} {%endif%}>
                                                                   开启
                                                                </option>
                                                                </select>
                                                           </div>
                                                     </div>
											</div>
                        				</div>
                        			</div>
                        </div>
						<div class="panel-footer text-right">
                        			<button class="btn btn-success" type="submit">提交</button>
                        </div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
