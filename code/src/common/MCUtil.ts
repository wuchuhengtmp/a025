class MCUtil {
	public constructor() {
	}

	public static getMc (e, t, n?) {
		function i(t) {
			var n = RES.getRes(e + "_png");
			var i = RES.getRes(e + "_json");
			var a = new egret.MovieClipDataFactory(i,n);
			var s:any = new egret.MovieClip(a.generateMovieClipData(t));
			s.fac = a;
			s.touchEnabled = !1;
			return s;
		}
		var a = this;
		void 0 === t && (t = null),
		void 0 === n && (n = "");
		var s = RES.getRes(e + "_png");
		if (s) {
			var o = i(n);
			t && t(o);
			return o;
		}
		RES.getResAsync(e + "_png", ()=>{
			RES.getResAsync(e + "_json", ()=>{
				t(i(n))
			}, a)
		}, this)
		return null;
	}

	public static changeAction (e, t) {
		var n = e.fac;
		e.movieClipData = n.generateMovieClipData(t)
	}
}