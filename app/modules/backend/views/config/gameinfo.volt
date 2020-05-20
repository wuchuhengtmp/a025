<div class="tab-base">

	<?php $this->flashSession->output(); ?>
	<!--Nav Tabs-->
	<ul class="nav nav-tabs">
		<li class="active">
			<a data-toggle="tab" href="#">前台游戏信息</a>
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
                    		<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">游戏名称【前台】</label>
                    		<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                    			<input type="text" name="name"  class="form-control" value="{%if game['name'] is defined%}{{game['name']}}{%endif%}">
                    		</div>
                    	</div>
                    	<div class="form-group">
                           <label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">游戏简写【前台】</label>
                           <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                             <input type="text" name="keyWords"  class="form-control" value="{%if game['keyWords'] is defined%}{{game['keyWords']}}{%endif%}">
                           </div>
                        </div>
                        <div class="form-group">
                              <label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">前台logo【前台】</label>
                                 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                 <?=Dhc\Component\MyTags::tpl_upload_images("logo",$game['logo'])?>
                                 </div>
                         </div>

				 	    <div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">游戏介绍【前台】</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<?php echo Dhc\Component\MyTags::tpl_ueditor('gameinfo',$game['gameinfo'])?>
							</div>
						</div>
						        <div class="form-group">
                                	<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">果实赠送金币索取开关</label>
                                	<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                		<select class="form-control" id="demo-vs-definput" name="fruits">
                                			<option value="1" class="{% if game['fruits'] === 1 %}selected{%else%}{% endif %} ">开启</option>
                                			<option value="9"class="{% if game['fruits'] === 9 %}selected{%else%}{% endif %} ">关闭</option>
                                		</select>
                                	</div>

                                </div>
                                 <div class="form-group">
                                    <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">果实赠送金币索取手续费</label>
                                    <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                     <input type="text" name="fee"  class="form-control" value="{%if game['fee'] is defined%}{{game['fee']}}{%endif%}" placeholder='请填写小数(0.1=10%)'>
                                    </div>
                                 </div>
                                 <div class="form-group">
                                     <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">APP下载地址</label>
                                    <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                       <input type="text" name="appurl"  class="form-control" value="{%if game['appurl'] is defined%}{{game['appurl']}}{%endif%}" placeholder='app下载地址'>
                                     </div>
                                 </div>
                      	<div class="form-group">
                             <label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">视频连接【前台】</label>
                                 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                     <input type="text" name="url"  class="form-control" value="{%if game['url'] is defined%}{{game['url']}}{%endif%}">
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
