class FontUtil {
	public constructor() {
	}

	public static setColor (e, t) {
		return '<font color="' + t + '">' + e + "</font>";
	}

	public static setSize (e, t) {
		return '<font size="' + t + '">' + e + "</font>";
	}

	public static setColorSize (e, t, n) {
		return '<font color="' + n + '" size="' + t + '">' + e + "</font>";
	}

	public static html (e) {
		return (new egret.HtmlTextParser).parser(e);
	}
}