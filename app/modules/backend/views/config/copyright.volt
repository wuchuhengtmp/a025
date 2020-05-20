<div class="tab-base">

	<?php $this->flashSession->output(); ?>
	<!--Nav Tabs-->
	<ul class="nav nav-tabs">
		<li class="active">
			<a data-toggle="tab" href="#">公司信息</a>
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
                    		<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">公司名称【前台】</label>
                    		<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                    			<input type="text" name="companyName"  class="form-control" value="{%if copyright['companyName'] is defined%}{{copyright['companyName']}}{%endif%}">
                    		</div>
                    	</div>
                    	<div class="form-group">
                            <label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">公司简称【前台】</label>
                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                               <input type="text" name="companyWord"  class="form-control" value="{%if copyright['companyWord'] is defined%}{{copyright['companyWord']}}{%endif%}">
                            </div>
                        </div>

                    	<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">公司介绍【前台】</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<?php echo Dhc\Component\MyTags::tpl_ueditor('companyinfo',$copyright['companyinfo'])?>
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">版权信息【前台】</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input type="text" name="copyright"  class="form-control" value="{%if copyright['copyright'] is defined%}{{copyright['copyright']}}{%endif%}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">备案号【前台】</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<input type="text" name="record"  class="form-control" value="{%if copyright['record'] is defined%}{{copyright['record']}}{%endif%}">
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
