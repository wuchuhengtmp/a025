class CoolMenu extends eui.Group {
	public constructor() {
		super();
		this.touchEnabled = false;
		if (CoolMenu._instance) throw new Error("CoolMenu使用单例")
	}

	private static _instance:CoolMenu = null;
	public static get instance():CoolMenu{
		if(!this._instance) {
			this._instance = new CoolMenu();
		}
		return this._instance;
	}

	private fromPos;
	public show(e, t) {
		this.fromPos = t;
		this.removeChildren();
		if (e && Util.isArray(e) && 0 != e.length){
			if (0 == e.length){
				new CoolMenuItem(e[0]).execute()
			} else {
				var n = e.length, i = -90;
				t.x < 150 && n > 2 ? i = 0 : t.x > Const.stageW - 150 && n > 2 && (i = 180);
				var a = 50, s = 110;
				n >= 2 ? (2 == n ? a = 55 : 3 == n ? a = 72 : (4 == n && (s = 95), a = 360 / n, (t.x < 150 || t.x > Const.stageW - 150) && (a = 270 / n, 5 == n && (s = 125))), i -= (n - 1) * a / 2) : s = 60;
				for (var o = 0; n > o; o++) {
					var r = new CoolMenuItem(e[o]),
					h = Util.ang2rad(i + o * a),
					c = Math.cos(h) * s + t.x,
					l = Math.sin(h) * s + t.y;
					r.x = t.x, r.y = t.y, this.addChild(r), egret.Tween.get(r).to({
						x: c,
						y: l
					}, 200, egret.Ease.backOut)
				}
				GameLayerManager.instance.popLayer.addChild(this);
				Const.stage.once(egret.TouchEvent.TOUCH_BEGIN, this.onStageTouch, this, !1, -1)
			}
		}
	}

	private onStageTouch (e) {
		Const.isGuiding || this.hide(true)
	}

	public hide (e?) {
		var t = this;
		if (void 0 === e && (e = !1), Const.stage.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onStageTouch, this), e && this.numChildren > 0) {
			for (var n = 0; n < this.numChildren; n++) {
				var i = this.getChildAt(n);
				egret.Tween.get(i).to({
					x: this.fromPos.x,
					y: this.fromPos.y
				}, 200, egret.Ease.backIn)
			}
			egret.setTimeout(()=>{
				UIUtils.removeSelf(t)
			}, this, 200), EventManager.instance.dispatch(EventName.COOLMENU_HIDE)
		} else UIUtils.removeSelf(this)
	}
}