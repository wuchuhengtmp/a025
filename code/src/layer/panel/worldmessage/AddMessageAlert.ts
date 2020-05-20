class AddMessageAlert extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0;
		this.isVisibleAnimate = !0;
		this.isDelayDestroy = !0;
		this.skinName = new WorldMessageSkin;
	}

	private static _instance:AddMessageAlert = null;
	public static get instance():AddMessageAlert{
		if(!this._instance) {
			this._instance = new AddMessageAlert();
		}
		return this._instance;
	}

	private okCallback;
	private noCallback;
	private btnOk;
	private btnNo;
	private labelTxt;
	private etMessage:eui.EditableText;
	private clickTarget;
	private inpNum;
	private btnAdd;
	private btnSub;
	//e 提示消息 t文本框默认值 i 确认按钮回调 a取消按钮回调
	public show (e, t, i?, a?) {
		var s = this;
		void 0 === i && (i = null);
		void 0 === a && (a = null);
		this.okCallback = i;
		this.noCallback = a;
		t=t||"请输入消息内容";
		this.etMessage.prompt=t;
		GameLayerManager.instance.popLayer.addChild(this);
		this.btnNo.enabled = this.btnOk.enabled = !0;
		this.labelTxt.textFlow = FontUtil.html(e);
	}

	public onRemoved () {
		super.onRemoved();
		this.isDelayDestroy = !0;
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
		this.clickTarget == this.btnOk ? this.okCallback && this.okCallback(this.etMessage.text) : this.noCallback && this.noCallback();
	}
}