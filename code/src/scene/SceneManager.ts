class SceneManager {
	private globalColor;
	private currScene;
	public constructor() {
		this.globalColor = 11128622;
		if(SceneManager._instance){
			throw new Error("SceneManager使用单例");
		}
	}

	private static _instance:SceneManager = null;
	public static get instance():SceneManager{
		if(!this._instance) {
			this._instance = new SceneManager();
		}
		return this._instance;
	}

	public runScene (e, t?) {
		this.removeScene();
		var n = new e;
		this.currScene = n;
		GameLayerManager.instance.gameLayer.addChild(n);
		t = t || this.globalColor
		if (null != t) {
			var i = new eui.Rect(Const.stageW,Const.stageH,2029544);
			GameLayerManager.instance.gameLayer.addChild(i);
			egret.Tween.get(i).to({
				alpha: 0
			}, 350).call(UIUtils.removeSelf, this, [i])
		}
	}

	public removeScene () {
		this.currScene && (UIUtils.removeSelf(this.currScene), this.currScene = null)
	}

	public getCurrentScene () {
		return this.currScene
	}
}