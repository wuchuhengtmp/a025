class WarehousePanel extends PanelBase {
	public constructor() {
		super(BuildingPanel);
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new WareHouseSkin;
	}
	
	public isFullScreen;
	public isVisibleAnimate;
	public commonPanel;
	private tab:Tab;
	private groupTab:Tab;
	private itemArr:any;
	private groupItem:eui.Group;
	private btnGame:eui.Button;

	protected createChildren():void {
		super.createChildren();
		this.commonPanel.setPanelWidth(640);
		this.commonPanel.setPanelHeight(740);
		this.initItems();
		this.initTab();
		WareHouseNet.instance.list(()=>{
			0 == this.tab.selectIndex && this.onTabItemClickCallback(0);
		})
	}

	public onAdded () {
		super.onAdded();
		EventManager.instance.addEvent(EventName.WAREHOUSE_LIST_CHANGE, this.updateList, this)
	}

	public onRemoved () {
		super.onRemoved();
		EventManager.instance.removeEvent(EventName.WAREHOUSE_LIST_CHANGE, this.updateList, this)
	}

	private updateList () {
		this.onTabItemClickCallback(this.tab.selectIndex)
	}

	private initTab(){
		var e = ["果实", "材料", "宝石", "道具"];
		this.tab = new Tab(e,this.onTabItemClickCallback.bind(this));
		this.tab.bottom = 0;
		this.groupTab.addChild(this.tab);
	}

	private onTabItemClickCallback (e) {
		var t = null;
		if(e === 0){
			t = WareHouseDataManager.instance.fruitData;
		}else if(e === 1){
			t = WareHouseDataManager.instance.materialData.concat(WareHouseDataManager.instance.fragmentData);
		}else if(e === 2){
			t = WareHouseDataManager.instance.gemData;
		}else if(e === 3){
			t = WareHouseDataManager.instance.propsData
		}
		var n = [];
		var i = 0;
		for (let a = t; i < a.length; i++) {
			var s = a[i];
			s.num > 0 && n.push(s)
		}
		this.updateTabPageByData(n)
	}

	private initItems () {
		this.itemArr = [];
		for (var e = 0; 36 > e; e++) {
			var t = new WareHouseItem;
			t.x = 18 + e % 6 * 86;
			t.y = 13 + 80 * Util.int(e / 6);
			this.groupItem.addChild(t);
			this.itemArr.push(t);
		}
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
		switch (t.target) {
			case this.btnGame:
				HttpClient.instance.openUrl("market_url");
		}
	}

	private updateTabPageByData (e) {
		for (var t = this.itemArr.length, n = e.length, i = 0; t > i; i++) {
			var a = null;
			n > i && (a = e[i]);
			var s = this.itemArr[i];
			a ? s.data = a : s.data = null
		}
	}
}