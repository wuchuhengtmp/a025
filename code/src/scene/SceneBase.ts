class SceneBase extends eui.Component implements eui.Component{
	protected resGroup;
	public constructor() {
		super();
		this.width = Const.stageW,
		this.height = Const.stageH,
		this.touchEnabled = !0,
		this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this),
		this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAdded, this),
		this.addEventListener(egret.Event.REMOVED_FROM_STAGE, this.onRemoved, this)
	}

	protected onAdded () {
		this.removeEventListener(egret.Event.ADDED_TO_STAGE, this.onAdded, this)
	}

	protected onRemoved () {
		this.removeEventListener(egret.Event.REMOVED_FROM_STAGE, this.onRemoved, this),
		this.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this),
		UIUtils.removeButtonScaleEffects(this),
		this.destroy()
	}

	protected destroy () {
		this.resGroup && RES.destroyRes(this.resGroup)
	}

	protected createChildren () {
		super.createChildren();
		UIUtils.addButtonScaleEffects(this)
	}

	protected onTouchTap (e) {}
}