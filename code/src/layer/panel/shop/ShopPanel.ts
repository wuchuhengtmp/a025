class ShopPanel extends PanelBase {
	public constructor() {
		super(BuildingPanel);
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new ShopSkin;
	}
	
	public isFullScreen;
	public isVisibleAnimate;
	public commonPanel;
	public tabIdexToOpen;
	private tab:Tab;
	private groupTab:Tab;
	private list:eui.List;
	private itemArr:any;
	private groupItem:eui.Group;
	private btnGame:eui.Button;

	protected createChildren() {
		super.createChildren();
		this.commonPanel.setPanelWidth(640);
		this.commonPanel.setPanelHeight(740);
		this.commonPanel.setTitleIcon("panel_icon_shop_png");
		this.commonPanel.setTitle("panel_title_shop_png");
		this.showDiamond();
		this.initList();

		if(this.tabIdexToOpen < 0){
			this.tabIdexToOpen = this.data || 0;
		}

		HttpClient.instance.post("API_URL", {c: "game", a: 'getTools'}).then((response:any)=>{
			ShopDataManager.instance.serverInit(response.data);
			this.initTab();
			if(this.tabIdexToOpen >= 0){
				this.tab.setSelectIndex(this.tabIdexToOpen);
				this.tabIdexToOpen = -1;
			}else{
				 0 == this.tab.selectIndex && this.onTabItemClickCallback(0);
			}
		}, (response:any)=>{
			Util.message.show(response.msg);
		});
	}

	public initList () {
		this.list.itemRenderer = ShopItemRender;
		this.list.dataProvider = null;
	}

	private initTab(){
		var e = [];
		ShopDataManager.instance.hotData.length > 0 && e.push("热销"),
		ShopDataManager.instance.propsData.length > 0 && e.push("道具"),
		ShopDataManager.instance.boxData.length > 0 && e.push("宝箱"),
		ShopDataManager.instance.dogData.length > 0 && e.push("宠物"),
		this.tab = new Tab(e,this.onTabItemClickCallback.bind(this)),
		this.tab.bottom = 0,
		this.groupTab.addChild(this.tab)
	}

	private onTabItemClickCallback (e) {
		var n = null;
		switch (e) {
			case this.TAB_SEED:
				n = ShopDataManager.instance.hotData;
				break;
			case this.TAB_PROP:
				n = ShopDataManager.instance.propsData;
				break;
			case this.TAB_BOX:
				n = ShopDataManager.instance.boxData;
				if(n.length>0){
					break;
				}
			case this.TAB_PET:
				n = ShopDataManager.instance.dogData
		}
		this.updateTabPageByData(n)
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
		switch (t.target) {
			case this.btnGame:
				HttpClient.instance.openUrl("market_url");
		}
	}

	private updateTabPageByData (e) {
		this.list.dataProvider = new eui.ArrayCollection(e)
	}

	private showDiamond () {}

	public TAB_SEED = 0;
	public TAB_PROP = 1;
	public TAB_BOX = 2;
	public TAB_PET = 3;
}