class Tab extends eui.Group implements eui.Group{
	private _selectIndex;
	private dataArr;
	private itemClickCallback;
	private itemArr;
	public constructor(t, n) {
		super();
		this._selectIndex = -1,
		this.dataArr = t,
		this.itemClickCallback = n,
		this.initItems(),
		this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this)
	}

	private initItems () {
		this.itemArr = [];
		for (var t = 0; t < this.dataArr.length; t++) {
			var n = new TabItem(this.dataArr[t]);
			this.itemArr.push(n),
			n.x = 90 * t,
			n.bottom = -1,
			this.addChild(n)
		}
		egret.callLater(()=>{
			this._selectIndex < 0 && this.setSelectIndex(0)
		}, this)
	}

	public onTouchTap (e) {
		var t = e.target;
		if (t instanceof TabItem) {
			var n = this.itemArr.indexOf(t);
			this.setSelectIndex(n);
			AudioManager.instance.playEffect(AudioTag.BUTTON);
		}
	}

	public setSelectIndex (e, t?) {
		void 0 === t && (t = !0);
		for (var n = 0, i = 0; i < this.itemArr.length; i++) {
			var a = this.itemArr[i];
			a.select = e == i,
				a.bottom = e == i ? -4 : -2,
				a.x = n,
				n += a.width + 5
		}
		t && this._selectIndex != e && this.itemClickCallback(e), this._selectIndex = e;
	}

	public get selectIndex(){
		return this._selectIndex
	}

	public setItemBaseHeight (e) {
		for (var t = 0; t < this.itemArr.length; t++) {
			var n = this.itemArr[t];
			n.baseHeight = e
		}
	}
}

class TabItem extends eui.Group implements eui.Group{
	private _select;
	private baseHeight;
	private bg;
	private label;
	private itemArr;
	public constructor(t, n?) {
		super();
		this._select = !1,
		this.baseHeight = 40,
		this.touchChildren = !1,
		this.touchEnabled = !0,
		this.bg = new eui.Image("tab_unselecte_png"),
		this.bg.scale9Grid = new egret.Rectangle(40,20,2,2),
		this.addChild(this.bg),
		this.label = new eui.Label(t),
		this.label.fontFamily = "huakang",
		this.label.size = 26,
		this.label.textColor = 7749668,
		this.addChild(this.label),
		this.label.horizontalCenter = 0,
		this.label.verticalCenter = 0,
		this.label.stroke = 0,
		this.label.strokeColor = 7031078
	}

	

	public get select(){
		return this._select
	}

	public set select(e){
		var t = this.label.width;
		if(e){
			this.label.stroke = 3,
			this.label.textColor = 16777215,
			this.bg.source = "tab_selected_png",
			this.bg.width = Math.max(105, t + 34),
			this.bg.height = this.baseHeight + 7
		}else{
			this.label.stroke = 0,
			this.label.textColor = 7749668,
			this.bg.source = "tab_unselecte_png",
			this.bg.width = Math.max(88, t + 34),
			this.bg.height = this.baseHeight
		}
	}
}