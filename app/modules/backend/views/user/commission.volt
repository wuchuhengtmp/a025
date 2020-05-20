<!--用户列表-->
<div class="nav-tabs-custom">
	<div class="tab-base">
		<ul class="nav nav-tabs">
			<li class="{%if show == 'details'%}active{%endif%}"><a href="?op=details">返佣明细</a>
			</li>
			<li class="{%if show == 'display'%}active{%endif%}"><a href="?op=display">返佣统计</a>
			</li>
		</ul>
		<div class="tab-content">
          {%if show == 'details'%}
               <div class="tab-pane fade active in">
                     <div class="panel">
                     <div class="panel-control">
                          <span class="label label-info">总业绩{{total_money}}￥ - 总佣金{{total_amount}}￥</span>
                     </div>
                     <div class="panel-heading">
                          <h4 class="panel-title">筛选</h4>
                     </div>
                     <div class="panel-body">
                     <form class="form-horizontal">
                         <div class="form-group">
                             <label class="col-xs-12 col-sm-3 col-md-1 control-label">关键字</label>
                                  <div class="col-xs-12 col-sm-9 col-md-6">
                                       <input type="text" name="keyword" value="{{ keyword }}" placeholder="请输入UID 查找用户" class="form-control">
                                  </div>
                         </div>
                         <div class="form-group">
                              <label class="col-xs-12 col-sm-4 col-md-2 col-lg-1 control-label">时间</label>
                                   <div class="col-xs-12 col-sm-8 col-md-8 col-lg-6">
                                        <?=Dhc\Component\MyTags::TimePiker("time",array('starttime'=>$starttime,'endtime'=>$endtime))?>
                                   </div>
                         </div>
                              <div class="form-group">
                                   <label class="col-xs-12 col-sm-3 col-md-1 control-label"></label>
                                       <div class="col-xs-12 col-sm-9 col-md-6">
                                  			 <button class="btn btn-info fa fa-search" type="submit">搜索</button>
                              			</div>
                              </div>
                     </form>
                     </div>
               </div>

                     <div class="panel-body">
                          <div class="table-responsive">
                     <table class="table table-hover">
                         <thead>
                             <tr>
                                  <th>UID</th>
                                  <th>来源UID</th>
                                  <th>来源昵称</th>
                                  <th>来源账号</th>
                                  <th>消费金额</th>
                                  <th>分佣比例</th>
                                  <th>获得佣金</th>
                                  <th>获得时间</th>
                                  <th>结算时间</th>
                             </tr>
                         </thead>
                     <tbody>
                          {%if disList is defined%}
                        		{%for row in disList['list']%}
                        			<tr>
                        				<td>{{row['uid']}}</td>
                        				<td>{{row['cUid']}}</td>
                        				<td>
                        				{%for names in realname%}
                        					{%if names['id'] == row['cUid']%}
                        						{{names['realname']}}
                        					{%endif%}
                        				{%endfor%}
                        				</td>
                        				<td>
                        				{%for names in realname%}
                                            {%if names['id'] == row['cUid']%}
                                                 {{names['user']}}
                                            {%endif%}
                                        {%endfor%}
                        				</td>
                        				<td>{{row['gold']}}</td>
                        				<td>{{row['rebate']}}</td>
                        				<td>{{row['amount']}}</td>
                        				<td>{{ date("Y-m-d H:i:s",row['createTime']) }}</td>
                        				<td>
                        				{% if row['effectTime'] !== '0'%}
                        					{{ date("Y-m-d H:i:s",row['effectTime']) }}
                        				{%endif%}
                        				</td>
                        			</tr>
                        		{%endfor%}
                          {%endif%}
                     </tbody>
                     </table>
                         <div class="panel-body text-center">
                              <ul class="pagination">
                              {% if disList['total_pages'] > 1 %}
                              <li><a href="?keyword={{ keyword }}&page=1{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if show is defined%}&op={{show}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
                              {%if disList['before']!=1%}
                              <li><a href="?keyword={{ keyword }}&page={{ disList['before'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if show is defined%}&op={{show}}{%endif%}">上一页</a></li>
                              {%endif%}
                              <li><a href="?keyword={{ keyword }}&page={{ disList['next'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if show is defined%}&op={{show}}{%endif%}">下一页</a></li>
                              <li><a href="?keyword={{ keyword }}&page={{ disList['last'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if show is defined%}&op={{show}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>
							  {% endif %}
                              </ul>
                         </div>
               </div>
              </div>
          {%endif%}
          {%if show  == 'display'%}
                <div  class="tab-pane fade active in">
                                        						<div class="panel-body">
                                        							<div class="table-responsive">
                                        								<table class="table table-hover">
                                        									<thead>
                                        									<tr>
                                        										<th>UID</th>
                                        										<th>下级业绩</th>
                                        										<th>佣金共计</th>
                                        										<th>可获取</th>
                                        										<th>未领取</th>
                                        									</tr>
                                        									</thead>
                                        									<tbody>
                                        									{%if userList is defined%}
																				{%for rows in userList%}
																				{% if rows is not scalar %}
																					{% for row in rows%}
																						<tr>
																							<td>{{row['uid']}}</td>
																							<td>{{row['gold']}}</td>
																							<td>{{row['amount']}}</td>
																							<td>{{row['yes']}}</td>
																							<td>{{row['no']}}</td>
																						</tr>
																					{%endfor%}
																					{%endif%}
																				{%endfor%}
																			{%endif%}
                                        									</tbody>
                                        								</table>
                                        								<div class="panel-body text-center">
                                        									<ul class="pagination">
                                        									{% if userList['total_pages'] > 1 %}
                                        										<li><a href="?keyword={{ keyword }}&page=1{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if show is defined%}&op={{show}}{%endif%}" class="demo-pli-arrow-right">首页</a></li>
                                        										{%if userList['before']!=1%}
                                        										<li><a href="?keyword={{ keyword }}&page={{ userList['before'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if show is defined%}&op={{show}}{%endif%}">上一页</a></li>
                                        										{%endif%}
                                        										<li><a href="?keyword={{ keyword }}&page={{ userList['next'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if show is defined%}&op={{show}}{%endif%}">下一页</a></li>
                                        										<li><a href="?keyword={{ keyword }}&page={{ userList['last'] }}{%if starttime is defined%}&time[start]={{starttime}}&time[end]={{endtime}}{%endif%}{%if show is defined%}&op={{show}}{%endif%}" class="demo-pli-arrow-right">尾页</a></li>

                        													{% endif %}
                                        									</ul>
                                        								</div>
                                        							</div>
                                        						</div>
                        						</div>
                        {%endif%}
		</div>
	</div>
</div>
