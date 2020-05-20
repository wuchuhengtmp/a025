<div class="tab-base">
	<?php $this->flashSession->output(); ?>
	<!--Nav Tabs-->
	<ul class="nav nav-tabs">
		<li class="active">
			<a data-toggle="tab" href="#">提现设置</a>
		</li>
	</ul>

	<!--Tabs Content-->
	<div class="tab-content">
		<div class="tab-pane fade active in">
			<div class="panel">

				<div class="panel-body">
					<form class="form-horizontal form-padding" method = 'post'>
						<div class="form-group">
                        	<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">提现类型</label>
                        	<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
                        		<select class="form-control" id="demo-vs-definput" name="type">
                        			<option value="3" {%if withdraw['type'] is defined%}{% if withdraw['type'] == 3 %}selected{% endif %}{%endif%}>虚拟币</option>
                        			<option value="4"{%if withdraw['type'] is defined%}{% if withdraw['type'] == 4 %}selected{% endif %}{%endif%}>银行卡</option>
                        		</select>
                        	</div>
                        </div>
                        <div class="form-group">
                        	<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">虚拟币比例</label>
                        		<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3">
                        			<div class="input-group" data-level="1">
                        			<input type="text" name="rebate" value="{%if withdraw['rebate'] is defined %}{{withdraw['rebate']}}{%endif%}" class="form-control">
                        			<span class="input-group-addon">%</span>
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
