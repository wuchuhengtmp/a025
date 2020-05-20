
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
		<li class="active">
            	<a data-toggle="tab" href="#demo-lft-tab-3" aria-expanded="true">提现操作</a>
        </li>
		</ul>
		<div class="tab-content">
			<div id="demo-lft-tab-3" class="tab-pane fade active in">
			 <div id="demo-lft-tab-3" class="tab-pane fade  active in ">
                                <div class="panel">
                                    <form class="panel-body form-horizontal form-padding " method="post"  action="{{apppath}}/userwithdraw/create">
                                        <!--Static-->
                                        <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">用户id*</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input type="text" class="form-control" name="uid" value="{% if item.uid is defined %}{{ item.uid }}{% endif %}">
                                              </div>
                                         </div>
                                         <div class="form-group">
                                               <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">提现用户</label>
                                               <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input type="text" class="form-control" name="realname" value="{% if item.realname is defined %}{{ item.realname }}{% endif %}">
                                               </div>
                                         </div>
                                          <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">收款开户行</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                  <input type="text" class="form-control" name="bankaccount" value="{% if item.bankaccount is defined %}{{ item.bankaccount }}{% endif %}">
                                              </div>
                                          </div>
                                        <div class="form-group">
                                            <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">银行帐号*</label>
            								<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
            									<input type="text" class="form-control" name="accountnumber" value="{% if item.accountnumber is defined %}{{ item.accountnumber }}{% endif %}">
            								</div>
                                        </div>
            							<div class="form-group">
                                           <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">提现金币数量</label>
                                           <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                               <input type="text" class="form-control" name="goldnumber" value="{% if item.goldnumber is defined %}{{ item.goldnumber }}{% endif %}">
                                           </div>
                                        </div>
                                        <div class="form-group">
                                           <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">手续费</label>
                                           <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                               <input type="text" class="form-control" name="fee" value="{% if item.fee is defined %}{{ item.fee }}{% endif %}">
                                           </div>
                                        </div>
                                        <div class="form-group">
                                                 <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">省份/直辖市</label>
                                                <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                <input type="text" class="form-control" name="province" value="{% if item.province is defined %}{{ item.province }}{% endif %}">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                             <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">市/县</label>
                                             <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                              <input type="text" class="form-control" name="city" value="{% if item.city is defined %}{{ item.city }}{% endif %}">
                                             </div>
                                        </div>
                                         <div class="form-group">
                                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">消费类型</label>
                                              <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                 <input type="text" class="form-control" name="costname" value="{% if item.costname is defined %}{{ item.costname }}{% endif %}">
                                              </div>
                                         </div>

                                        <div class="form-group">
                                                 <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">提现类型</label>
                                                   <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                                   <select class="form-control" id="demo-vs-definput" name="withdrawtype">
                                                    <option value="3" class="{% if item.withdrawtype === 1 %}selected{% endif %} ">行内转账</option>
                                                    <option value="4"class="{% if item.withdrawtype === 2 %}selected{% endif %} ">同城跨行</option>
                                                    <option value="4"class="{% if item.withdrawtype === 3 %}selected{% endif %} ">异地跨行</option>
                                                   </select>
                                              </div>
                                        </div>
                                          <div class="panel-footer text-left">
                                          		<input type="hidden" value="{% if item.id is defined %}{{ item.id }}{% endif %}" name="id">
                                          		<button class="btn btn-success" type="submit">提交</button>
                                          </div>

                                    </form>
                                </div>
                            </div>
			</div>
		</div>
	</div>
</div>


<!-- 提现模块结束--!>
