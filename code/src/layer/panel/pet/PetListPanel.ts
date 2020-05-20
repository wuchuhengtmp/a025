class PetListPanel extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0;
		this.isVisibleAnimate = !0;
		this.skinName = new PetListPanelSkin;
	}
	private list:eui.List;
	protected createChildren():void {
		super.createChildren();
		this.commonPanel.setPanelWidth(640),
		this.commonPanel.setPanelHeight(740),
		this.commonPanel.setTitleIcon("petlist_icon_png"),
		this.commonPanel.setTitle("petlist_title_png"),
		this.initList(),
		this.getInfo()
	}

	public onAdded () {
		super.onAdded();
		EventManager.instance.addEvent(EventName.PETLIST_GETINFO, this.getInfo, this)
	}

	public onRemoved () {
		super.onRemoved();
		EventManager.instance.removeEvent(EventName.PETLIST_GETINFO, this.getInfo, this)
	}

	public getInfo () {		
		PetNet.instance.getInfo((response)=>{
			var data = PetDataManager.instance.petData;
			this.list.dataProvider = new eui.ArrayCollection(data)
		})
	}

	private initList () {
		this.list.itemRenderer = PetListItem
	}
}