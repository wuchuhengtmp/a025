<div class="tab-base">

	<?php $this->flashSession->output(); ?>
	<!--Nav Tabs-->
	<ul class="nav nav-tabs">
		<li class="active">
			<a data-toggle="tab" href="#">短信设置</a>
		</li>
	</ul>
	<!--Tabs Content-->
	<div class="tab-content">
		<div class="tab-pane fade active in">
			<div class="panel">
				<div class="panel-heading">
				<h3 class="panel-title">请认真填写</h3>
				</div>
				<div class="panel-body">
					<form class="form-horizontal form-padding" method = 'post'>
						{%if type == 'message'%}
						<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">用户id</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
								<input type="text" name="userid"  class="form-control" value="{%if message['userid'] is defined%}{{message['userid']}}{%endif%}">
							</div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">帐号</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<input type="text" name="account"  class="form-control" value="{%if message['account'] is defined%}{{message['account']}}{%endif%}">
                           </div>
						</div>
						<div class="form-group">
							<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">密码</label>
							<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
							<input type="password" name="password" class="form-control"value="{%if message['password'] is defined%}{{message['password']}}{%endif%}">
                            </div>
						</div>
						<div class="form-group">
                        	<label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">短信签名</label>
                        	<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                        	<input type="text" name="sign" class="form-control"value="{%if message['sign'] is defined%}{{message['sign']}}{%endif%}">
                             </div>
                        </div>
                        <div class="form-group">
                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
                               <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                               <select class="form-control" id="demo-vs-definput" name="status">
                                    <option value="1"{% if message['status'] is defined %}{% if message['status'] ==='1' %}selected{%else %}{% endif %}{% endif %}>启用</option>
                                    <option value="0"{% if message['status'] is defined %}{% if message['status'] ==='0' %}selected{%else %}{% endif %}{% endif %}>禁用</option>
                               </select>
                               </div>
                         </div>
                             <input type="hidden" name="type" class="form-control" value="message">

                         <div class="form-group">
                               <label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">短信接口地址</label>
                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                  <input type="text" name="url" class="form-control" value="{%if message['url'] is defined%}{{message['url']}}{%endif%}">
                             </div>
                          </div>
                         {%elseif type=='jh'%}
                        <div class="form-group">
                            <label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">(聚合)短信模版id</label>
                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                            <input type="text" name="tpl_id" class="form-control"value="{%if message['tpl_id'] is defined%}{{message['tpl_id']}}{%endif%}">
                            </div>
                        </div>
                        <div class="form-group">
                             <label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">应用APPKEY</label>
                             <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                               <input type="text" name="key" class="form-control"value="{%if message['key'] is defined%}{{message['key']}}{%endif%}">
                             </div>
                        </div>
						<div class="form-group">
                           <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">短信类型*</label>
                           <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                             <select class="form-control" id="demo-vs-definput" name="type">
                                 <option value="message"{% if message['type'] is defined %}{% if message['type'] ==='message' %}selected{%else %}{% endif %}{% endif %}>鼎汉</option>
                                 <option value="jh"{% if message['type'] is defined %}{% if message['type'] ==='jh' %}selected{%else %}{% endif %}{% endif %}>聚合</option>
                             </select>
                           </div>
                       </div>
                       <div class="form-group">
                                                     <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">状态</label>
                                                      <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                      <select class="form-control" id="demo-vs-definput" name="status">
                                                           <option value="1"{% if message['status'] is defined %}{% if message['status'] ==='1' %}selected{%else %}{% endif %}{% endif %}>启用</option>
                                                           <option value="0"{% if message['status'] is defined %}{% if message['status'] ==='0' %}selected{%else %}{% endif %}{% endif %}>禁用</option>
                                                      </select>
                                                      </div>
                        </div>

                         <input type="hidden" name="type" class="form-control" value="jh">
                       <div class="form-group">
                            <label class="col-xs-12 col-sm-2 col-md-2 col-lg-1 control-label">短信接口地址</label>
                            <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                               <input type="text" name="url" class="form-control" value="{%if message['url'] is defined%}{{message['url']}}{%endif%}">
                            </div>
                       </div>
                       {%endif%}
                    	<div class="panel-footer text-right">
                        	<button class="btn btn-success" type="submit">提交</button>
                        </div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
