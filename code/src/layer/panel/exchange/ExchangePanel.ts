class ExchangePanel extends PanelBase {
	public constructor() {
		super(ExchangePanel);
		this.tabIdexToOpen = -1,
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new ExchangePanelSkin
	}
	public tabIdexToOpen;
	public isFullScreen;
	public isVisibleAnimate;
	private tab:Tab;
	private groupTab:Tab;
	private list:eui.List;

	protected createChildren():void {
		super.createChildren();
		this.commonPanel.setPanelWidth(640),
		this.commonPanel.setPanelHeight(740),
		this.commonPanel.setTitleIcon("panel_icon_exchange_png"),
		this.commonPanel.setTitle("panel_title_exchange_png"),

		HttpClient.instance.post("API_URL", {c: "gift", a: 'getList'}).then((response:any)=>{
			ExchangeDataManager.instance.serverInit(response.data);
			this.initTab();
			if(this.tabIdexToOpen >= 0){
				this.tab.setSelectIndex(this.tabIdexToOpen);
				this.tabIdexToOpen = -1;
			}else{
				this.tab.selectIndex == 0 && this.onTabItemClickCallback(0)
			}
		}, (response:any)=>{
			Util.message.show(response.msg);
		});
	}
	public initTab () {
		var e = [];
		ExchangeDataManager.instance.materialData.length > 0 && e.push("材料"),
		ExchangeDataManager.instance.godData.length > 0 && e.push("神像"),
		ExchangeDataManager.instance.skinData.length > 0 && e.push("背景"),
		ExchangeDataManager.instance.petFoodData.length > 0 && e.push("狗粮"),
		ExchangeDataManager.instance.propsData.length > 0 && e.push("勋章"),
		this.tab = new Tab(e,this.onTabItemClickCallback.bind(this)),
		this.tab.bottom = 0,
		this.groupTab.addChild(this.tab)
	}

	private onTabItemClickCallback (e) {
		this.list.scrollV = 0;
		var n;
		switch (e) {
			case ExchangePanel.TAB_RES:
				this.list.itemRenderer = ExchangeResItem,
				n = ExchangeDataManager.instance.materialData;
				break;
			case ExchangePanel.TAB_GOD:
				this.list.itemRenderer = ExchangeGodItem,
				n = ExchangeDataManager.instance.godData;
				break;
			case ExchangePanel.TAB_SKIN:
				this.list.itemRenderer = ExchangeSkinItem,
				n = ExchangeDataManager.instance.skinData;
				break;
			case ExchangePanel.TAB_PETFOOD:
				this.list.itemRenderer = ExchangePetFoodItem,
				n = ExchangeDataManager.instance.petFoodData
		}
		this.updateTabPageByData(n)
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
	}

	private updateTabPageByData (e) {
		this.list.dataProvider = new eui.ArrayCollection(e)
	}

	public static TAB_RES = 0;
	public static TAB_GOD = 1;
	public static TAB_SKIN = 2;
	public static TAB_PETFOOD = 3;
	public static TAB_PROPS = 4;
		
}