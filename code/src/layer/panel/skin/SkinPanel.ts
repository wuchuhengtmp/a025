class SkinPanel extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new SkinPanelSkin;
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
		this.commonPanel.setTitleIcon("panel_icon_skin_png");
		this.commonPanel.setTitle("panel_title_skin_png");
		this.initList()
	}

	public onRemoved () {
		super.onRemoved();
	}

	public initList () {
		var e = WareHouseDataManager.instance.skinData;
		e.sort((e, t)=>{
			return e.id - t.id
		});
		this.list.dataProvider = new eui.ArrayCollection(e);
		this.list.itemRenderer = SkinItem;
	}
}