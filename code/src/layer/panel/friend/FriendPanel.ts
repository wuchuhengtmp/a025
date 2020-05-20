class FriendPanel extends PanelBase {
	public constructor() {
		super(null);
		this.pageIndex = 1,
		this.pageMax = 1,
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new FriendPanelSkin
	}

	private pageIndex;
	private pageMax;
	private list;
	private scroller;
	private scrollerTouchStart;
	private tab;
	private groupTab;
	private groupTitleUser;
	private btnPrev;
	private btnNext;
	private labelPage;
	private btnAdd;

	protected createChildren() {
		super.createChildren();
		this.commonPanel.setPanelWidth(594);
		this.commonPanel.setPanelHeight(842);
		this.commonPanel.setTitleIcon("panel_icon_friend_png");
		this.commonPanel.setTitle("panel_title_friend_png");
		this.initList();
		this.initTab();
	}

	private initTab () {
		var e = ["我的好友"];
		this.tab = new Tab(e, ()=>{});
		this.tab.setItemBaseHeight(50);
		this.tab.bottom = 0;
		this.groupTab.addChild(this.tab);
	}

	public onRemoved () {
		super.onRemoved();
		if(!this.isDelayDestroy){
			this.scroller.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onScrollerTouchBegan, this);
		}
	}

	private initList () {
		this.list.dataProvider = null;
		this.scroller.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onScrollerTouchBegan, this);
		this.groupTitleUser.visible = true;
		this.list.itemRenderer = FriendItemRender;
		this.pageIndex = 1,
		this.changePage(1, true)
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
			case this.btnAdd:
				UIManager.instance.popPanel(FriendAddPanel)
				break;
		}
	}
		
	public changePage (e, t?) {
		if (void 0 === t && (t = !1), t)
			this.pageIndex = e;
		else {
			if (this.pageIndex <= 1 && 0 > e)
				return;
			if (this.pageIndex >= this.pageMax && e > 0)
				return;
			this.pageIndex += e
		}
		this.labelPage.text = this.pageIndex + "/" + this.pageMax,
		this.updateListPage(this.pageIndex)
	}

	private updateListPage (page) {
		HttpClient.instance.post("API_URL", {c: 'player', a: "hailList", page: page}).then((response:any)=>{
			this.pageMax = Math.ceil(response.data.totalPage);
			this.labelPage.text = this.pageIndex + "/" + this.pageMax;
			this.list.dataProvider = new eui.ArrayCollection(response.data.list);
		}, (response:any)=>{
			Util.message.show(response.msg, null, 300);
		});
	}

	public refreshAnyTime () {
		this.changePage(this.pageIndex, !0)
	}
}