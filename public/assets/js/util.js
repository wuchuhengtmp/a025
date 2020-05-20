var util = {
	deleteImage: function (ele) {
		requirejs(['jquery'], function ($) {
			console.log($(ele).html());
		})
	}
};
