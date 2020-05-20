<footer id="footer">
	<div class="show-fixed pull-right">{{webinfo['pageTitle']}} - 控制台</div>
	<p class="pad-lft">{{copyright['copyright']}}</p>
</footer>
<script>
	requirejs(['nifty'], function () {
		$(document).trigger('nifty.ready');
	});
</script>
