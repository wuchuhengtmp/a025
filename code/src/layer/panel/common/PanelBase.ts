class PanelBase extends eui.Component implements  eui.UIComponent {
	private bgMask;
	public isVisibleAnimate;
	public isFullScreen;
	public isDelayDestroy;
	private _isResLoaded;
	private createChildrened;
	private _viewParent;
	private _data;
	private _resGroup;
	private _startPos;
	private panelCommon;
	public commonPanel;
	private closeBtn;
	private btnClose;
	
	private uiSkinName;
	protected constructor(obj) {
		super();
		this.bgMask = null;
		this.isVisibleAnimate = true;
		this.isFullScreen = false;
		this.isDelayDestroy = false;
		this._isResLoaded = false;
		this.createChildrened = false;
		this._viewParent = obj;
		this.touchEnabled = true;
		this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this),
		this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAdded, this),
		this.addEventListener(egret.Event.REMOVED_FROM_STAGE, this.onRemoved, this)
	}

	public get data(){
		return this._data
	}

	public set data(data){
		this._data = data;
	}

	protected onAdded () {
		this.createChildrened && this.onShow()
	}

	protected onRemoved () {
		if(this.isDelayDestroy){
			this.isDelayDestroy = false;
		}else{
			this.removeEventListener(egret.Event.ADDED_TO_STAGE, this.onAdded, this);
			this.removeEventListener(egret.Event.REMOVED_FROM_STAGE, this.onRemoved, this);
			this.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this);
			UIUtils.removeButtonScaleEffects(this);
			this.destroy();
		}
	}

	protected destroy () {
		RES.destroyRes(this._resGroup)
	}

	public set viewParent(view){
		this._viewParent = view;
		this._resGroup && this.uiSkinName || this._viewParent.addChild(this)
	}

	public init (e) {
		if(e){
			this._resGroup = e;
			this._isResLoaded = false;
			egret.setTimeout(this.showPreLoading, this, 50);
			RES.addEventListener(RES.ResourceEvent.GROUP_COMPLETE, this.onGroupResourceLoaded, this);
			RES.addEventListener(RES.ResourceEvent.GROUP_LOAD_ERROR, this.onGroupResourceLoaded, this);
			RES.loadGroup(e);
		}else{
			this.onGroupResourceLoadedThenAddToStage();
		}
	}

	private showPreLoading () {
		this._isResLoaded || PanelLoading.instance.show()
	}

	public set animate_startPos(e){
		e && (this._startPos = e)
	}

	private onGroupResourceLoaded (e) {
		if(e.groupName == this._resGroup){
			this._isResLoaded = true;
			PanelLoading.instance.hide();
			RES.removeEventListener(RES.ResourceEvent.GROUP_COMPLETE, this.onGroupResourceLoaded, this);
			RES.removeEventListener(RES.ResourceEvent.GROUP_LOAD_ERROR, this.onGroupResourceLoaded, this);
			this.onGroupResourceLoadedThenAddToStage();
		}
	}

	private onGroupResourceLoadedThenAddToStage () {
		this.skinName = null,
		this.uiSkinName && (this.skinName = this.uiSkinName);
		this._viewParent ? this._viewParent.addChild(this) : GameLayerManager.instance.popLayer.addChild(this)
	}

	protected refreshAnyTime () {}

	protected createChildren () {
		super.createChildren();
		this.panelCommon && (this.commonPanel = new PanelCommon(this.panelCommon));
		this.isFullScreen && (this.width = Const.stageW, this.height = Const.stageH);
		UIUtils.addButtonScaleEffects(this);
		this.onShow();
		this.createChildrened = true;
	}

	protected onTouchTap(e) {
		var t = e.target;
		(t == this.closeBtn || t == this.btnClose || this.commonPanel && t == this.commonPanel.btnClose) && this.onHide()
	}

	protected onShow () {
		this.bgMask && (this.bgMask.alpha = 0)
		if (this.isVisibleAnimate) {
			this.x = Const.stageW / 2;
			this.y = Const.stageH / 2;
			this._startPos && (this.x = this._startPos.x, this.y = this._startPos.y);
			var e = (Const.stageW - this.width) / 2, t = (Const.stageH - this.height) / 2;
			this.scaleX = this.scaleY = 0;
			egret.Tween.get(this).to({
				x: e,
				y: t,
				scaleX: 1,
				scaleY: 1
			}, 250, egret.Ease.backOut).call(this.onShowAnimateOver, this)
		} else {
			this.onShowAnimateOver()
		}
	}

	private onShowAnimateOver () {
		this.bgMask && egret.Tween.get(this.bgMask).to({
			alpha: 1
		}, 100)
	}

	protected onHideAnimateOver () {}

	protected onHide () {
		this.bgMask && (this.bgMask.alpha = 0);
		UIManager.instance.hidePanel(this);
		if (this.isVisibleAnimate) {
			var e = Const.stageW / 2, t = Const.stageH / 2;
			this._startPos && (e = this._startPos.x, t = this._startPos.y);
			egret.Tween.get(this).to({
				x: e,
				y: t,
				scaleX: 0,
				scaleY: 0
			}, 250, egret.Ease.backIn).call(this.onHideAnimateOver, this).call(UIUtils.removeSelf, this, [this])
		} else{
			this.onHideAnimateOver();
			UIUtils.removeSelf(this);
		}
	}

	public hide () {
		this.onHide()
	}
}