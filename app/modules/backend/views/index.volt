<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	{% include "index/title.volt" %}
	{{ stylesheet_link("/assets/lib/bootstrap/css/bootstrap.css", false) }}
	{{ stylesheet_link("/assets/lib/nifty/css/nifty.css", false) }}
	{{ stylesheet_link("/assets/lib/font-awesome/css/font-awesome.min.css", false) }}
	<script src="/assets/lib/require.js"></script>
	<script src="/assets/lib/main.js"></script>
</head>
<body>

<div id="container" class="effect aside-float aside-bright navbar-fixed footer-fixed mainnav-fixed mainnav-lg">
	{% include "index/login.volt" %}
</div>
</body>
</html>
