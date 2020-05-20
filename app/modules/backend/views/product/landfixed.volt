<!--用户列表-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="active">土地修复</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-4" class="tab-pane fade active in">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="?landfixed">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户id</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="uid"  value="{% if item is defined %}{{ item.user }}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">土地id</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" type="text" name="landId"  value="{% if item is defined %}{{ item.coing }}{% endif %}">
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
	</div>
</div>
