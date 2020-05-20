class ItemRendererBase extends eui.ItemRenderer implements eui.ItemRenderer {
	public constructor() {
		super();
		this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this);
		this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAdded, this);
		this.addEventListener(egret.Event.REMOVED_FROM_STAGE, this.onRemoved, this);
	}

	protected onAdded () {
		this.removeEventListener(egret.Event.ADDED_TO_STAGE, this.onAdded, this)
	}

	protected onRemoved () {
		this.removeEventListener(egret.Event.REMOVED_FROM_STAGE, this.onRemoved, this),
		this.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this),
		UIUtils.removeButtonScaleEffects(this)
	}

	protected createChildren () {
		super.createChildren(),
		UIUtils.addButtonScaleEffects(this)
	}

	protected onTouchTap (e) {}
}