class PanelLoading extends eui.Panel implements  eui.Panel {
	public constructor() {
		super();
		if(PanelLoading._instance){
			throw new Error("PanelLoading使用单例");
		}
		this.width = Const.stageW;
		this.height = Const.stageH;
		this.skinName = new PanelLoadingSkin;
		Const.stage.dirtyRegionPolicy = egret.DirtyRegionPolicy.OFF
	}

	private static _instance:PanelLoading = null;
	public static get instance():PanelLoading{
		if(!this._instance) {
			this._instance = new PanelLoading();
		}
		return this._instance;
	}

	private timer;
	private cirGroup;
	private count;
	private loadingTxtIndex;
	private loadTF;
	private loadingTxt;
	public init () {
		var e = new eui.Rect(Const.stageW, Const.stageH, 1020564);
		e.alpha = .41;
		this.addChildAt(e, 0),
		this.timer = new egret.Timer(150),
		this.timer.addEventListener(egret.TimerEvent.TIMER, this.onTimer, this)
	}

	public createChildren () {
		super.createChildren();
		this.cirGroup.x = Const.stageW / 2,
		this.cirGroup.y = Const.stageH / 2,
		this.count > 0 && this.start()
	}

	private onTimer () {
		this.loadingTxtIndex++;
		this.loadingTxtIndex > this.loadingTxt.length && (this.loadingTxtIndex = 1);
		this.loadTF.text = this.loadingTxt.substr(0, this.loadingTxtIndex);
	}

	public show () {
		this.count++;
		this.cirGroup && 1 == this.count && this.start();
	}

	public hide () {
		this.count--;
		this.count <= 0 && this.stop();
	}

	private start () {
		egret.Tween.get(this.cirGroup, {
			loop: !0
		}).to({
			rotation: 360
		}, 1e3),
		this.timer.start();
		GameLayerManager.instance.tipsLayer.addChild(this);
	}

	private stop () {
		egret.Tween.removeTweens(this.cirGroup);
		this.timer.stop();
		UIUtils.removeSelf(this);
	}
}