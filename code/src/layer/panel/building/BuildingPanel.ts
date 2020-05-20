class BuildingPanel extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new BuildingSkin;
		// AudioManager.instance.playEffect(AudioTag.BUTTON);
	}
	
	public commonPanel;
	private tab:Tab;
	private groupTab:Tab;
	private groupMain;
	private houseUp;
	private landUp;

	protected createChildren():void {
		super.createChildren();
		this.commonPanel.setPanelWidth(640),
		this.commonPanel.setPanelHeight(744),
		this.commonPanel.setTitleIcon("panel_icon_building_png"),
		this.commonPanel.setTitle("panel_title_building_png"),
		RES.getResAsync("building_up_ok_png", ()=>{}, this),
		this.initTab()
	}

	private initTab(){
		var e = ["房屋升级", "土地升级"];
		this.tab = new Tab(e,this.onTabItemClickCallback.bind(this));
		this.tab.bottom = 0;
		this.groupTab.addChild(this.tab);
		this.tab.setSelectIndex(this.data || 0);
	}

	private onTabItemClickCallback (e) {
		this.groupMain.removeChildren();
		if(e == 0){
			this.houseUp = new BuildingHouse;
			this.groupMain.addChild(this.houseUp);
		}else{
			this.landUp = new BuildingLand;
			this.groupMain.addChild(this.landUp);
		}
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
	}
}