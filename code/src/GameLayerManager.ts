class GameLayerManager {
	public constructor() {
		if(GameLayerManager._instance){
			throw new Error("GameLayerManager 使用单例 ");
		}
	}

	private static _instance:GameLayerManager = null;
	public static get instance():GameLayerManager{
		if(!this._instance) {
			this._instance = new GameLayerManager();
		}
		return this._instance;
	}

	// 游戏层
	private _gameLayer:eui.Group;
	public get gameLayer(){
		return this._gameLayer;
	}
	// 游戏弹出层
	private _uiLayer:eui.Group;
	public get uiLayer(){
		return this._uiLayer;
	}
	// 弹窗层
	public _popLayer:eui.Group;
	public get popLayer(){
		return this._popLayer;
	}
	// 消息层
	private _tipsLayer:eui.Group;
	public get tipsLayer(){
		return this._tipsLayer;
	}
	public plantStateLayer:eui.Group;

	public init(main:Main){
		// 添加场景层组
		this._gameLayer = new eui.Group();
		this._uiLayer = new eui.Group();
		this._popLayer = new eui.Group();
		this._tipsLayer = new eui.Group();
		main.addChild(this._gameLayer);
		main.addChild(this._uiLayer);
		main.addChild(this._popLayer);
		main.addChild(this._tipsLayer);
		this._gameLayer.width = this._uiLayer.width = this._popLayer.width = this._tipsLayer.width = Const.stageW;
		this._gameLayer.height = this._uiLayer.height = this._popLayer.height = this._tipsLayer.height = Const.stageH;
		this._uiLayer.touchThrough = this._popLayer.touchThrough = this._tipsLayer.touchThrough = true;
		this._tipsLayer.touchChildren = this._tipsLayer.touchEnabled = this._popLayer.touchEnabled = !1;
	}

	public gameScene:GameScene;
	public loginScene:LoginScene;
	public forgetScene:ForgetScene;
	public regScene:RegScene;
	public createRoleScene:CreateRoleScene;
	public alert:Alert;
	public message:Message

	public showBothScene (e) {
		var t = 250, n = new e;
		n.x = Const.stageW;
		this.gameLayer.addChild(n);
		egret.Tween.get(n).to({
			x: 0
		}, t);
		var i = SceneManager.instance.getCurrentScene();
		egret.Tween.get(i).to({
			x: -Const.stageW
		}, t);
		egret.Tween.get(this.popLayer).to({
			x: -Const.stageW
		}, t)
	}

	public showSingleScene () {
		if (this.gameLayer.numChildren > 1) {
			var e = 250, t = this.gameLayer.getChildAt(1);
			egret.Tween.get(t).to({
				x: Const.stageW
			}, e).call(UIUtils.removeSelf, this, [t]);

			var n = SceneManager.instance.getCurrentScene();
			egret.Tween.get(n).to({
				x: 0
			}, e);
			egret.Tween.get(this.popLayer).to({
				x: 0
			}, e);
		}
	}

	// // 显示游戏场景
	// public showGameScene(){
	// 	// 判断用户角色是否创建
	// 	let needCreate = LocalStorage.get("needCreate");
	// 	if(needCreate && needCreate == 1){
	// 		LocalStorage.remove("userInfo");
	// 		LocalStorage.remove("needCreate");
	// 		this.showLoginScene();
	// 		return;
	// 	}
	// 	// 判断用户是否登陆
	// 	let userInfo = Util.checkAuth();
	// 	if(userInfo === false || Util.isEmpty(userInfo.token)){
	// 		this.showLoginScene();
	// 		return;
	// 	}
	// 	// 初始化数据
	// 	Util.message.show("正在加载数据……", ()=>{
	// 		Util.confirmGotoLogin("抱歉，网络请求超时,请重新登录！");
	// 	}, null, 6000);
	// 	HttpClient.instance.post("API_URL", {c: 'home', a: 'index'}).then((response:any)=>{
	// 		Util.message.show(response.msg);
	// 		// 初始化数据
	// 		Player.instance.serverInit(response.data.user);
	// 		LandDataManager.instance.serverInit(response.data.farm);
	// 		GodDataManager.instance.serverInit(response.data.joss);
	// 		WareHouseDataManager.instance.serverInit(response.data.tool);
	// 		Player.instance.dogData = response.data.dog;

	// 		this.popLayer.removeChildren();
	// 		this.uiLayer.removeChildren();
	// 		this.gameLayer.removeChildren();

	// 		this.gameScene = new GameScene();
	// 		this.gameScene.width = Const.stageW;
	// 		this.gameScene.height = Const.stageH;
	// 		this.gameLayer.addChild(this.gameScene);
	// 	}, (response:any)=>{
	// 		Util.message.show(response.msg);
	// 		this.showLoginScene();
	// 	})
	// }

	// // 显示登陆场景
	// public showLoginScene(){
	// 	this.popLayer.removeChildren();
	// 	this.uiLayer.removeChildren();
	// 	this.gameLayer.removeChildren();
	// 	this.loginScene = new LoginScene();
	// 	this.loginScene.width = Const.stageW;
	// 	this.loginScene.height = Const.stageH;
	// 	this.gameLayer.addChild(this.loginScene);
	// }
	// // 显示注册场景
	// public showRegScene(){
	// 	this.popLayer.removeChildren();
	// 	this.uiLayer.removeChildren();
	// 	this.gameLayer.removeChildren();
	// 	this.regScene = new RegScene();
	// 	this.regScene.width = Const.stageW;
	// 	this.regScene.height = Const.stageH;
	// 	this.gameLayer.addChild(this.regScene);
	// }
	// // 显示忘记密码场景
	// public showForgetScene(){
	// 	this.popLayer.removeChildren();
	// 	this.uiLayer.removeChildren();
	// 	this.gameLayer.removeChildren();
	// 	this.forgetScene = new ForgetScene();
	// 	this.forgetScene.width = Const.stageW;
	// 	this.forgetScene.height = Const.stageH;
	// 	this.gameLayer.addChild(this.forgetScene);
	// }
	// // 显示创建角色场景
	// public showCreateRoleScene(){
	// 	this.popLayer.removeChildren();
	// 	this.uiLayer.removeChildren();
	// 	this.gameLayer.removeChildren();
	// 	this.createRoleScene = new CreateRoleScene();
	// 	this.createRoleScene.width = Const.stageW;
	// 	this.createRoleScene.height = Const.stageH;
	// 	this.gameLayer.addChild(this.createRoleScene);
	// }
}