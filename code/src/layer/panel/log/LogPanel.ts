class LogPanel extends PanelBase {
	private pageIndex;
	private pageMax;
	private scroller:eui.Scroller;
	private list:eui.List;
	private scrollerTouchStart;
	private btnPrev:eui.Button;
	private btnNext:eui.Button;
	private btnClear:eui.Button;
	private labelPage:eui.Label
	public constructor() {
		super(null);
		this.pageIndex = 1,
		this.pageMax = 1,
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new LogPanelSkin
	}
	protected createChildren():void {
		super.createChildren();
		this.commonPanel.setPanelWidth(590),
		this.commonPanel.setPanelHeight(830),
		this.commonPanel.setIconOffsetX(65),
		this.commonPanel.setTitleIcon("panel_icon_log_png"),
		this.commonPanel.setTitle("panel_title_log_png"),
		this.initList(),
		this.changePage(1, !0)
	}

	public onRemoved () {
		super.onRemoved();
		this.scroller.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onScrollerTouchBegan, this)
	}

	private initList () {
		this.list.dataProvider = null,
		this.list.itemRenderer = LogItem,
		this.scroller.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onScrollerTouchBegan, this)
	}

	private onScrollerTouchBegan (e) {
		this.scrollerTouchStart = e.stageX,
		this.stage.once(egret.TouchEvent.TOUCH_END, this.onScrollerTouchEnded, this, !0, Number.MAX_VALUE)
	}

	private onScrollerTouchEnded (e) {
		var t = e.stageX - this.scrollerTouchStart;
		t > 150 ? this.changePage(-1) : -150 > t && this.changePage(1)
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
		var n = t.target;
		switch (n) {
			case this.btnPrev:
				this.changePage(-1);
				break;
			case this.btnNext:
				this.changePage(1);
				break;
			case this.btnClear:
				this.clearLog()
		}
	}

	private clearLog () {
		HttpClient.instance.post("API_URL", {c: "log", a: "emlogs"}).then((response:any)=>{
			Util.message.show(response.msg);
			LogDataManager.instance.logPageMax = 1;
			LogDataManager.instance.serverInit(null);
			this.labelPage.text = "1/1";
			this.list.dataProvider = null;
		}, (response:any)=>{
			Util.message.show(response.msg);
		});
	}

	private changePage (e, t?) {
		0 === t && (t = !1);
		this.pageMax = LogDataManager.instance.logPageMax;
		if (t){
			this.pageIndex = e;
		} else {
			if (this.pageIndex <= 1 && 0 > e)
				return;
			if (this.pageIndex >= this.pageMax && e > 0)
				return;
			this.pageIndex += e
		}
		this.labelPage.text = this.pageIndex + "/" + this.pageMax;
		HttpClient.instance.post("API_URL", {c: 'log', a: 'list', page: this.pageIndex}).then((response:any)=>{
			LogDataManager.instance.logPageMax = response.data.totalPage;
			LogDataManager.instance.serverInit(response.data.list);
			this.pageMax = LogDataManager.instance.logPageMax,
			this.labelPage.text = this.pageIndex + "/" + this.pageMax;
			var t = LogDataManager.instance.logData;
			this.list.dataProvider = new eui.ArrayCollection(t);
		}, (response:any)=>{
			Util.message.show(response.msg, null, 300);
		});
	}
}