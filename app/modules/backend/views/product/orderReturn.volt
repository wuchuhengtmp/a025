<?php $this->flashSession->output(); ?>
<!--商品信息-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="active">
				<a href="{{ apppath }}/product/logs?page={{logsList.current}}" aria-expanded="true">挂单批量退回</a>
			</li>
		</ul>
		<div id="demo-lft-tab-1" class="tab-pane fade active in">
		<div class="tab-content">
        			<div class="panel-body">
        				<form class="form-horizontal form-padding " method="post" action="{{ apppath }}/product/orderReturn">
        					<div class="form-group">
        						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">会员ID</label>
        						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
        							<input class="form-control" type="text" name="uid" value="{% if keywords is defined %}{{ uid }}{% endif %}" placeholder="会员ID">
        						</div>
        					</div>
        					<div class="form-group">
                                 <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">产品id*</label>
                                <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
									<select name="sid" class="form-control">
									 	{%for row in product%}
                                        <option value="{{row['id']}}" {%if sid is defined%}{%if sid == row['id']%}selected{%endif%}{%endif%} >
                                                {{row['title']}}
                                        </option>
                                        {%endfor%}
                                    </select>
                                </div>
                            </div>
        					<div class="form-group">
                                <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">订单价格*</label>
                                <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                    <input class="form-control" type="text" name="price" value="{% if price is defined %}{{ price }}{% endif %}" placeholder="订单价格">
                                </div>
                            </div>
        					<div class="form-group">
        						<label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">订单类型*</label>
        						<div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
        							<select name="type" class="form-control">
        								<option value="1" {% if type is defined %}{% if type === 1 %}selected{% endif %}{% endif %}>
                                            	购买
                                         </option>
        								<option value="0" {% if type is defined %}{% if type === 0 %}selected{% endif %}{% endif %}>
        										出售
        								</option>

        							</select>
        						</div>
        					</div>

        					<div class="text-lg-center">
        						<button class="btn btn-info fa fa-edit" type="submit">订单退回</button>
        					</div>
        				</form>
        			</div>
			</div>
		</div>
	</div>
</div>
<!--日志模块结束--!>

