<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{% if show is defined %}{% if show === 'list' %}active{% else %} {% endif %}{% endif %}">
				<a data-toggle="tab" href="#demo-lft-tab-1" aria-expanded="{% if show is defined %}{% if show === 'list' %}true{% else %} false{% endif %}{% endif %}">支付配置</a>
			</li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-1" class="tab-pane fade {% if show is defined %}{% if show === 'list' %}active in{% else %} {% endif %}{% endif %}">
				<div class="panel">
					<div class="panel-body">
						<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/recharge/show">
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">商户号*</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="merchant_no" value="{% if item.merchant_no is defined %}{{ item.merchant_no }}{% else %}{% endif %}">
								</div>
							</div>
							<div class="form-group">
								<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">终端号*</label>
								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<input class="form-control" id="demo-vs-definput" type="text" name="terminal_id" value="{% if item.terminal_id is defined %}{{ item.terminal_id }}{% else %}{% endif %}">
								</div>
							</div>
							<div class="form-group">
                            	<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">支付类型*</label>
                            		<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                            			<select class="form-control" id="demo-vs-definput" name="payType">
                            				<option value="fuyou"{% if item.payType is defined %}{% if item.payType ==='fuyou' %}selected{%else %}{% endif %}{% endif %}>富有支付</option>
                            				<option value="wft"{% if item.payType is defined %}{% if item.payType ==='wft' %}selected{%else %}{% endif %}{% endif %}>威富通</option>
                            				<option value="YB"{% if item.payType is defined %}{% if item.payType ==='YB' %}selected{%else %}{% endif %}{% endif %}>易宝支付</option>
                            			</select>
                            		</div>
                            </div>
                            <div class="form-group">
                                 <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">签名*</label>
                                     <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                       <input class="form-control" id="demo-vs-definput" type="text" name="access_token" value="{% if item.access_token is defined %}{{ item.access_token }}{% else %}{% endif %}">
                                     </div>
                            </div>
                            <div class="form-group">
                                  <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">启用状态</label>
                                     <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                         <select class="form-control" id="demo-vs-definput" name="status">
                                          <option value="1"{% if item.status is defined%}{% if item.status ==='1'%}selected{% else %}{% endif %}{% endif %}>启用</option>
                                          <option value="0"{% if item.status is defined%}
                                          {% if item.status ==='0'%}selected{% else %}{% endif %}{% endif %}>停用</option>
                                      </select>
                                     </div>
                                  </div>
							<div class="panel-footer text-left">
							<input type='hidden' name='id' value ="{% if item.id is defined %}{{item.id}}{% else%}{% endif%}">
								<button class="btn btn-success" type="submit">保存</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
