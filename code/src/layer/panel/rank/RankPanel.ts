class RankPanel extends PanelBase {
	public constructor() {
		super(null);
		this.pageIndex = 1,
		this.pageMax = 1,
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new RankPanelSkin
	}

	private pageIndex;
	private pageMax;
	private list;
	private scroller;
	private scrollerTouchStart;
	private tab;
	private groupTab;
	private groupTitleUser;
	private groupTitlePet;
	private btnPrev;
	private btnNext;
	private btnAdd;
	private labelPage;
	private labelRank;

	protected createChildren() {
		super.createChildren();
		this.commonPanel.setPanelWidth(594),
		this.commonPanel.setPanelHeight(842),
		this.commonPanel.setTitleIcon("panel_icon_rank_png"),
		this.commonPanel.setTitle("panel_title_rank_png"),
		this.initList(),
		this.initTab()
	}

	public onRemoved () {
		super.onRemoved();
		if(!this.isDelayDestroy){
			this.scroller.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onScrollerTouchBegan, this);
		}
	}

	private initList () {
		this.list.dataProvider = null,
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

	private initTab () {
		var e = ["农场排名", "宠物排名", "好友排名"];
		this.tab = new Tab(e,this.onTabItemClickCallback.bind(this));
		this.tab.setItemBaseHeight(50);
		this.tab.bottom = 0;
		this.groupTab.addChild(this.tab);
	}

	private onTabItemClickCallback (e) {
		switch (e) {
			case 0:
				this.groupTitleUser.visible = !0,
				this.groupTitlePet.visible = !1,
				this.list.itemRenderer = RankPlayItemRender;
				break;
			case 1:
				this.groupTitleUser.visible = !1,
				this.groupTitlePet.visible = !0,
				this.list.itemRenderer = RankPetItemRender
				break;
			case 2:
				this.groupTitleUser.visible = !0,
				this.groupTitlePet.visible = !1,
				this.list.itemRenderer = RankFriendItemRender;
				break;
		}
		this.pageIndex = 1,
		this.changePage(1, true)
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
		switch (this.list.itemRenderer) {
			case RankPlayItemRender:
				HttpClient.instance.post("API_URL", {c: 'ranking', a: "rankPlayer", page: page}).then((response:any)=>{
					RankDataManager.instance.rankPageMax = Math.ceil(response.data.totalPage);
					RankDataManager.instance.setRankList(response.data.list);
					RankDataManager.instance.setSelfRank(response.data.rank);

					this.pageMax = RankDataManager.instance.rankPageMax;
					this.labelPage.text = this.pageIndex + "/" + this.pageMax;
					var n = RankDataManager.instance.rankData;
					this.list.dataProvider = new eui.ArrayCollection(n);
					if(RankDataManager.instance.selfRank > 0){
						this.labelRank.text = "个人排名：" + RankDataManager.instance.selfRank;
					}else{
						this.labelRank.text = "个人排名：未上榜";
					}
				}, (response:any)=>{
					Util.message.show(response.msg, null, 300);
				});
				break;
			case RankPetItemRender:
				HttpClient.instance.post("API_URL", {c: 'ranking', a: "rankingPet", page: page}).then((response:any)=>{
					RankDataManager.instance.petRankPageMax = Math.ceil(response.data.totalPage);
					RankDataManager.instance.setPetRankList(response.data.list);
					RankDataManager.instance.setSelfPetRank(response.data.rank);
					
					this.pageMax = RankDataManager.instance.petRankPageMax;
					this.labelPage.text = this.pageIndex + "/" + this.pageMax;
					var n = RankDataManager.instance.petRankData;
					this.list.dataProvider = new eui.ArrayCollection(n);
					if(RankDataManager.instance.selfPetRank > 0){
						this.labelRank.text = "个人宠物排名" + RankDataManager.instance.selfPetRank;
					}else{
						this.labelRank.text = "个人宠物排名：未上榜";
					}
				}, (response:any)=>{
					Util.message.show(response.msg, null, 300);
				});
				break;
			case RankFriendItemRender:
				HttpClient.instance.post("API_URL", {c: 'ranking', a: "rankFriend", page: page}).then((response:any)=>{
					RankDataManager.instance.rankPageMax = Math.ceil(response.data.totalPage);
					RankDataManager.instance.setRankList(response.data.list);
					RankDataManager.instance.setSelfFriendRank(response.data.rank);

					this.pageMax = RankDataManager.instance.rankPageMax;
					this.labelPage.text = this.pageIndex + "/" + this.pageMax;
					var n = RankDataManager.instance.rankData;
					this.list.dataProvider = new eui.ArrayCollection(n);
					if(RankDataManager.instance.selfRank > 0){
						this.labelRank.text = "个人排名：" + RankDataManager.instance.selfFriendRank;
					}else{
						this.labelRank.text = "个人排名：未上榜";
					}
				}, (response:any)=>{
					this.list.dataProvider = new eui.ArrayCollection();
					Util.message.show(response.msg, null, 300);
				});
				break;
		}
	}

	public refreshAnyTime () {
		this.changePage(this.pageIndex, !0)
	}
}