class AccountItem extends ItemRendererBase{

	private rectColor;
	private labelId;
	public constructor() {
		super();
		this.skinName = new AccountItemSkin;
	}

	protected onTouchBegin (t) {
		super.onTouchTap(t);
		egret.Tween.get(this.rectColor).to({
			alpha: 1
		}, 50).to({
			alpha: 0
		}, 50)
	}

	protected createChildren () {
		super.createChildren();
	}

	protected dataChanged () {
		var e = this.data;
		this.labelId.text = e.id
	}

	protected onTouchTap (e) {
		EventManager.instance.dispatch(EventName.ACCOUNT_SELECT, this.data);
	}
}