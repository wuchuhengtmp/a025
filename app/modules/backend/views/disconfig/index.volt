<div class="tab-base">
	<ul class="nav nav-tabs">
		<li class="active">
			<a href="./index">推广设置</a>
		</li>
	</ul>

	<div class="tab-content">
		<div class="tab-pane fade active in">
			<form class="form-horizontal" method="post">
				<div class="panel">
					<div class="panel-heading">
						<h3 class="panel-title">农场</h3>
					</div>
					<div class="panel-body">
						<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">推广比例</label>
							<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
								<div class="input-group" data-level="1">
									{#<span class="input-group-addon" style="cursor: pointer" onclick="addRow()"><i class="fa fa-plus"></i></span>#}
									<span class="input-group-addon">一级</span>
									<input type="text" name="rebate[1][common][1]" value="{% if rebate['1']['common'][1] is defined %}{{ rebate['1']['common'][1] }}{% endif %}" class="form-control">
									<span class="input-group-addon">%</span>
								</div>
								<div class="input-group" data-level="2">
									<span class="input-group-addon">二级</span>
									<input type="text" name="rebate[1][common][2]" value="{% if rebate['1']['common'][2] is defined %}{{ rebate['1']['common'][2] }}{% endif %}" class="form-control">
									<span class="input-group-addon">%</span>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="panel">
					<div class="panel-heading">
						<h3 class="panel-title">庄园</h3>
					</div>
					<div class="panel-body">
						<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">推广比例</label>
							<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
								<div class="input-group" data-level="1">
									{#<span class="input-group-addon" style="cursor: pointer" onclick="addRow()"><i class="fa fa-plus"></i></span>#}
									<span class="input-group-addon">一级</span>
									<input type="text" name="rebate[2][common][1]" value="{% if rebate['2']['common'][1] is defined %}{{ rebate['2']['common'][1] }}{% endif %}" class="form-control">
									<span class="input-group-addon">%</span>
								</div>
								<div class="input-group" data-level="2">
									<span class="input-group-addon">二级</span>
									<input type="text" name="rebate[2][common][2]" value="{% if rebate['2']['common'][2] is defined %}{{ rebate['2']['common'][2] }}{% endif %}" class="form-control">
									<span class="input-group-addon">%</span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="panel">
                		<div class="panel-heading">
                				<h3 class="panel-title">渠道佣金</h3>
                		</div>
                		<div class="panel-body">
                			{% if yansheng  =='yansheng' %}
                			<div class="form-group">
								<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">推广比例</label>
								<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
									<div class="input-group" data-level="1">
										{#<span class="input-group-addon" style="cursor: pointer" onclick="addRow()"><i class="fa fa-plus"></i></span>#}
										<span class="input-group-addon">一级</span>
										<input type="text" name="rebate[3][common][1]" value="{% if rebate['3']['common'][1] is defined %}{{ rebate['3']['common'][1] }}{% endif %}" class="form-control">
										<span class="input-group-addon">%</span>
									</div>
									<div class="input-group" data-level="2">
										<span class="input-group-addon">二级</span>
										<input type="text" name="rebate[3][common][0]" value="{% if rebate['3']['common'][0] is defined %}{{ rebate['3']['common'][0] }}{% endif %}" class="form-control">
										<span class="input-group-addon">%</span>
									</div>
								</div>
							</div>
							{% endif %}
                			<div class="form-group">
                			<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                            	<label class="radio-inline">
                            		<input type="radio" name="types" value="0" {%if channel_billing_type is defined %}{%if channel_billing_type != 0 %}checked{%endif%}{%endif%}> 次月一号领取
                            	</label>
                            	<label class="radio-inline">
                            		<input type="radio" name="types" value="1"{%if channel_billing_type is defined %}{%if channel_billing_type == 1 %}checked{%endif%}{%endif%}>   立即领取
                            	</label>
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
