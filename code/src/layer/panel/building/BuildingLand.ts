class BuildingLand extends PanelBase{
	public isFullScreen;
	public isVisibleAnimate;
	public constructor() {
		super(BuildingLand);
		this.isFullScreen = false;
		this.isVisibleAnimate = false;
		this.skinName = new BuildingLandSkin
	}
	
	public list:eui.List;
	protected createChildren():void {
		super.createChildren();
		this.initList();
		HttpClient.instance.post('API_URL', {c:'user', a: 'landUpInfo'}).then((response:any)=>{
			LandDataManager.instance.setLandLevelUpData(response.data);
			this.list.dataProvider = new eui.ArrayCollection([1, 2, 3]);
		});
	}

	private initList () {
		this.list.itemRenderer = BuildingLandItem;
		this.list.dataProvider = null;
	}
}