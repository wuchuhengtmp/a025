<div class="alert alert-{{ data['type'] }}">
	<h4>
		<span class="fa fa-warning fa-2x"></span>
		{% if data['type'] == "success" %}成功
		{% elseif data['type'] == "info" %}提示
		{% elseif data['type'] == "warning" %}警告
		{% elseif data['type'] == "danger" %}错误
		{% endif %}
	</h4>
	<p style="font-size: 16px">{% if data['message'] is not empty %}{{ data['message'] }}{% endif %}</p>
	<p>
		<a href="{{ data['redirect'] }}" class="alert-link">[点击这里跳转]</a>&nbsp;&nbsp;{{ link_to("/admin/index/index", "[首页]", "class":"alert-link") }}
	</p>
	{% if data['redirect'] is not empty and data['type'] != "danger" %}
	<script>
		var redirect = '{{ data['redirect'] }}';
		var delayTime = {% if data['type'] == "success" %}1500{% else %}2500{% endif %};
		setTimeout(function(){
			window.location.href = redirect;
		}, delayTime);
	</script>
	{% endif %}
</div>
