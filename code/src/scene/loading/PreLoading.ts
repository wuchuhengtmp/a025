class PreLoading extends eui.Panel implements  eui.Panel {
	public constructor() {
		super();
		if(PreLoading._instance){
			throw new Error("PreLoading使用单例");
		}
		this.width = Const.stageW;
		this.height = Const.stageH;
		this.skinName = new PreloadingSkin;
		Const.stage.dirtyRegionPolicy = egret.DirtyRegionPolicy.OFF
	}

	private static _instance:PreLoading = null;
	public static get instance():PreLoading{
		if(!this._instance) {
			this._instance = new PreLoading();
		}
		return this._instance;
	}
	private barPro;
	private resGroup;
	private enterSceneCls;
	private labelPro;
	protected createChildren () {
		super.createChildren();
		this.barPro.value = 0,
		this.beganLoadResGroup()
	}

	public load (e, t) {
		this.resGroup = e;
		this.enterSceneCls = t;
		GameLayerManager.instance.tipsLayer.addChild(this)
	}

	private beganLoadResGroup () {
		RES.addEventListener(RES.ResourceEvent.GROUP_COMPLETE, this.onResourceLoadComplete, this);
		RES.addEventListener(RES.ResourceEvent.GROUP_LOAD_ERROR, this.onResourceLoadComplete, this);
		RES.addEventListener(RES.ResourceEvent.GROUP_PROGRESS, this.onResourceProgress, this);
		RES.loadGroup(this.resGroup);
	}

	private onResourceLoadComplete (e) {
		if(e.groupName == this.resGroup){
			RES.removeEventListener(RES.ResourceEvent.GROUP_COMPLETE, this.onResourceLoadComplete, this);
			RES.removeEventListener(RES.ResourceEvent.GROUP_LOAD_ERROR, this.onResourceLoadComplete, this);
			RES.removeEventListener(RES.ResourceEvent.GROUP_PROGRESS, this.onResourceProgress, this);
			this.onResourceLoadOver();
		}
	}

	private onResourceProgress (e) {
		if (e.groupName == this.resGroup) {
			var t = e.itemsLoaded / e.itemsTotal;
			this.labelPro.text = "资源加载..." + e.itemsLoaded + "/" + e.itemsTotal;
			this.barPro.value = 100 * t;
		}
	}

	private onResourceLoadOver () {
		UIUtils.removeSelf(this);
		Const.stage.dirtyRegionPolicy = egret.DirtyRegionPolicy.ON;		
		SceneManager.instance.runScene(this.enterSceneCls);
	}
}