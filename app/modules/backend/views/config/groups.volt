<?php $this->flashSession->output(); ?>
<div class="nav-tabs-custom">
	<div class="tab-base">
		<!--Nav Tabs-->
		<ul class="nav nav-tabs">
		<li class="active">
				<a data-toggle="tab" href="#demo-lft-tab-2" aria-expanded="true">前台图片编辑</a>
			</li>
		</ul>
		<!--Tabs Content-->
		<div class="tab-content">
			<div id="demo-lft-tab-2" class="tab-pane fade active in">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/config/groups">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">（电脑）农贸市场</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									{% if item['market'] is defined %}
									<?=Dhc\Component\MyTags::tpl_upload_images("market",$item['market'])?>
									{% else %}
									<?=Dhc\Component\MyTags::tpl_upload_images("market")?>
									{% endif %}
								</div>
							</div>
							<div class="form-group">
                            	<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">（手机）农贸市场</label>
                            	<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                            		{% if item['SmallMarket'] is defined %}
                            		<?=Dhc\Component\MyTags::tpl_upload_images("SmallMarket",$item['SmallMarket'])?>
                            		{% else %}
                            		<?=Dhc\Component\MyTags::tpl_upload_images("SmallMarket")?>
                            		{% endif %}
                            	</div>
                            </div>
							<div class="form-group">
                            		<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">(电脑)农场公告</label>
                            		<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                            		{% if item['news'] is defined %}
                            		<?=Dhc\Component\MyTags::tpl_upload_images("news",$item['news'])?>
                            		{% else %}
                            		<?=Dhc\Component\MyTags::tpl_upload_images("news")?>
                            		{% endif %}
                            	</div>
                            </div>
                            <div class="form-group">
                                   <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">（手机）农场公告</label>
                                      <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                   {% if item['SmallNews'] is defined %}
                                      <?=Dhc\Component\MyTags::tpl_upload_images("SmallNews",$item['SmallNews'])?>
                                   {% else %}
                                     <?=Dhc\Component\MyTags::tpl_upload_images("SmallNews")?>
                                   {% endif %}
                                 </div>
                            </div>
                           <div class="form-group">
                                     <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">(电脑)攻略资料</label>
                                     <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                     {% if item['strategy'] is defined %}
                                          <?=Dhc\Component\MyTags::tpl_upload_images("strategy",$item['strategy'])?>
                                     {% else %}
                                          <?=Dhc\Component\MyTags::tpl_upload_images("strategy")?>
                                     {% endif %}
                                </div>
                            </div>
                            <div class="form-group">
                               <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">(手机)攻略资料</label>
                               <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                  {% if item['SmallStrategy'] is defined %}
                                     <?=Dhc\Component\MyTags::tpl_upload_images("SmallStrategy",$item['SmallStrategy'])?>
                                  {% else %}
                                     <?=Dhc\Component\MyTags::tpl_upload_images("SmallStrategy")?>
                                  {% endif %}
                               </div>
                            </div>
                            <div class="form-group">
                                     <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">(电脑)帮助中心</label>
                                     <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                     {% if item['helpCenter'] is defined %}
                                          <?=Dhc\Component\MyTags::tpl_upload_images("helpCenter",$item['helpCenter'])?>
                                     {% else %}
                                          <?=Dhc\Component\MyTags::tpl_upload_images("helpCenter")?>
                                     {% endif %}
                                </div>
                            </div>
                            <div class="form-group">
                                   <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">(手机)帮助中心</label>
                                        <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                   {% if item['SmallHelpCenter'] is defined %}
                                        <?=Dhc\Component\MyTags::tpl_upload_images("SmallHelpCenter",$item['SmallHelpCenter'])?>
                                   {% else %}
                                        <?=Dhc\Component\MyTags::tpl_upload_images("SmallHelpCenter")?>
                                   {% endif %}
                                </div>
                            </div>
                            <div class="form-group">
                                     <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">(电脑)关于我们</label>
                                     <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                     {% if item['aboutUs'] is defined %}
                                          <?=Dhc\Component\MyTags::tpl_upload_images("aboutUs",$item['aboutUs'])?>
                                     {% else %}
                                          <?=Dhc\Component\MyTags::tpl_upload_images("aboutUs")?>
                                     {% endif %}
                                </div>
                            </div>
                            <div class="form-group">
                                 <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">(手机)关于我们</label>
                                 <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                 {% if item['SmallAboutUs'] is defined %}
                                        <?=Dhc\Component\MyTags::tpl_upload_images("SmallAboutUs",$item['SmallAboutUs'])?>
                                 {% else %}
                                        <?=Dhc\Component\MyTags::tpl_upload_images("SmallAboutUs")?>
                                 {% endif %}
                               </div>
                            </div>
                             <div class="form-group">
                                   <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">（电脑）用户中心</label>
                                     <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                     {% if item['userCenter'] is defined %}
                                            <?=Dhc\Component\MyTags::tpl_upload_images("userCenter",$item['userCenter'])?>
                                     {% else %}
                                          <?=Dhc\Component\MyTags::tpl_upload_images("userCenter")?>
                                     {% endif %}
                                   </div>
                             </div>
                             <div class="form-group">
                                    <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">(手机)用户中心</label>
                                    <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                    {% if item['SmallUserCenter'] is defined %}
                                    <?=Dhc\Component\MyTags::tpl_upload_images("SmallUserCenter",$item['SmallUserCenter'])?>
                                    {% else %}
                                    <?=Dhc\Component\MyTags::tpl_upload_images("SmallUserCenter")?>
                                    {% endif %}
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
