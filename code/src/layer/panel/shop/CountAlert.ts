class CountAlert extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0;
		this.isVisibleAnimate = !0;
		this.isDelayDestroy = !0;
		this.skinName = new CountAlertSkin;
	}

	private static _instance:CountAlert = null;
	public static get instance():CountAlert{
		if(!this._instance) {
			this._instance = new CountAlert();
		}
		return this._instance;
	}

	private valueChangeCallback;
	private okCallback;
	private noCallback;
	private btnOk;
	private btnNo;
	private labelTxt;
	private fastInp;
	private clickTarget;
	private inpNum;
	private btnAdd;
	private btnSub;
	public show (e, t, n, i?, a?) {
		var s = this;
		void 0 === i && (i = null);
		void 0 === a && (a = null);
		this.valueChangeCallback = n;
		this.okCallback = i;
		this.noCallback = a;
		GameLayerManager.instance.popLayer.addChild(this);
		this.btnNo.enabled = this.btnOk.enabled = !0;
		this.labelTxt.textFlow = FontUtil.html(this.valueChangeCallback(e));
		this.fastInp = new FastInput(this.inpNum,this.btnAdd,this.btnSub,e,t,(e)=>{
			s.labelTxt.textFlow = FontUtil.html(s.valueChangeCallback(e))
		})
	}

	public onRemoved () {
		super.onRemoved();
		this.isDelayDestroy = !0;
		this.fastInp.destroy();
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
		var n = t.target;
		this.clickTarget = null;
		if(n == this.btnNo || n == this.btnOk){
			this.clickTarget = t.target;
			this.btnNo.enabled = this.btnOk.enabled = false;
			this.onHide();
		}
	}

	public onHideAnimateOver () {
		this.clickTarget == this.btnOk ? this.okCallback && this.okCallback(this.fastInp.value) : this.noCallback && this.noCallback();
	}
}