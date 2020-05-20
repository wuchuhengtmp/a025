<div class="tab-base">

	<?php $this->flashSession->output(); ?>
	<!--Nav Tabs-->
	<ul class="nav nav-tabs">
		<li class="active">
			<a data-toggle="tab" href="#">站点设置</a>
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
					<form class="form-horizontal form-padding" method = 'post'>
						<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">站点名称</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input type="text" name="pageTitle" placeholder="请输入前台显示的站点名称" class="form-control" value="{%if configInfo['pageTitle'] is defined%}{{configInfo['pageTitle']}}{%endif%}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">网站描述</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<?=Dhc\Component\MyTags::tpl_ueditor("info",$configInfo['info'])?>
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">网站logo</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<?=Dhc\Component\MyTags::tpl_upload_images("logo",$configInfo['logo'])?>
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
