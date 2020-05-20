class Main extends eui.UILayer {

	/**
	 * 加载进度界面
	 * Process interface loading
	 */
	private loadingView: LoadingUI;
	protected createChildren(): void {
		super.createChildren();
		let version = new RES.VersionController;
		RES.registerVersionController(version);
        // 判断设备类型 适配屏幕
		
		if(egret.Capabilities.isMobile){
			if(this.stage.stageHeight / this.stage.stageWidth < 1.5625){
				this.stage.setContentSize(640, 1e3);
			}
			this.stage.scaleMode = egret.StageScaleMode.FIXED_WIDE;
        }else{
            this.stage.scaleMode = egret.StageScaleMode.SHOW_ALL;
			this.stage.orientation = "auto";
        }
		//inject the custom material parser
		//注入自定义的素材解析器
		let assetAdapter = new AssetAdapter();
		egret.registerImplementation("eui.IAssetAdapter",assetAdapter);
		egret.registerImplementation("eui.IThemeAdapter",new ThemeAdapter());
		//Config loading process interface
		//设置加载进度界面
		this.loadingView = new LoadingUI();
		this.loadingView.visible = false;
		this.stage.addChild(this.loadingView);
		// initialize the Resource loading library
		//初始化Resource资源加载库
		RES.addEventListener(RES.ResourceEvent.CONFIG_COMPLETE, this.onConfigComplete, this);
		RES.loadConfig("resource/default.res.json", "resource/");
	}


	/**
	 * 配置文件加载完成,开始预加载皮肤主题资源和preload资源组。
	 * Loading of configuration file is complete, start to pre-load the theme configuration file and the preload resource group
	 */
	private onConfigComplete(event:RES.ResourceEvent):void {
		RES.removeEventListener(RES.ResourceEvent.CONFIG_COMPLETE, this.onConfigComplete, this);
		// load skin theme configuration file, you can manually modify the file. And replace the default skin.
		//加载皮肤主题配置文件,可以手动修改这个文件。替换默认皮肤。
		let theme = new eui.Theme("resource/default.thm.json", this.stage);
		theme.addEventListener(eui.UIEvent.COMPLETE, this.onThemeLoadComplete, this);

		RES.addEventListener(RES.ResourceEvent.GROUP_COMPLETE, this.onResourceLoadComplete, this);
		RES.addEventListener(RES.ResourceEvent.GROUP_LOAD_ERROR, this.onResourceLoadError, this);
		RES.addEventListener(RES.ResourceEvent.GROUP_PROGRESS, this.onResourceProgress, this);
		RES.addEventListener(RES.ResourceEvent.ITEM_LOAD_ERROR, this.onItemLoadError, this);
		RES.loadGroup("loading");
	}
	
	private isThemeLoadEnd: boolean = false;

	/**
	 * 主题文件加载完成,开始预加载
	 * Loading of theme configuration file is complete, start to pre-load the 
	 */
	private onThemeLoadComplete(): void {
		this.isThemeLoadEnd = true;
		this.createScene();
	}
	private isResourceLoadEnd: boolean = false;

	/**
	 * preload资源组加载完成
	 * preload resource group is loaded
	 */
	private onResourceLoadComplete(event:RES.ResourceEvent):void {
		if (event.groupName == "loading") {
			this.stage.removeChild(this.loadingView);
			RES.removeEventListener(RES.ResourceEvent.GROUP_COMPLETE, this.onResourceLoadComplete, this);
			RES.removeEventListener(RES.ResourceEvent.GROUP_LOAD_ERROR, this.onResourceLoadError, this);
			RES.removeEventListener(RES.ResourceEvent.GROUP_PROGRESS, this.onResourceProgress, this);
			RES.removeEventListener(RES.ResourceEvent.ITEM_LOAD_ERROR, this.onItemLoadError, this);
			this.isResourceLoadEnd = true;
			this.createScene();
		}
	}

	private createScene(){
		if(this.isThemeLoadEnd && this.isResourceLoadEnd){
			this.startCreateScene();
		}
	}

	/**
	 * 资源组加载出错
	 *  The resource group loading failed
	 */
	private onItemLoadError(event:RES.ResourceEvent):void {
		egret.warn("Url:" + event.resItem.url + " has failed to load");
	}

	/**
	 * 资源组加载出错
	 * Resource group loading failed
	 */
	private onResourceLoadError(event:RES.ResourceEvent):void {
		//TODO
		egret.warn("Group:" + event.groupName + " has failed to load");
		//忽略加载失败的项目
		//ignore loading failed projects
		this.onResourceLoadComplete(event);
	}

	/**
	 * preload资源组加载进度
	 * loading process of preload resource
	 */
	private onResourceProgress(event:RES.ResourceEvent):void {
		if (event.groupName == "preload") {
			this.loadingView.setProgress(event.itemsLoaded, event.itemsTotal);
		}
	}

	/**
	 * 创建场景界面
	 * Create scene interface
	 */
	protected startCreateScene(): void {
		Const.stage = this.stage;
		Const.stageW = this.stage.stageWidth;
		Const.stageH = this.stage.stageHeight;
		GameLayerManager.instance.init(this);
		DateTimer.instance.run();
		AudioManager.instance;
		PreLoading.instance.load("preload", LoginScene);
		if(egret.Capabilities.runtimeType == 'web'){
			let refId = Util.getQueryString('ref');
			if(refId){
				Const.refId = refId;
			}
		}
	}
}