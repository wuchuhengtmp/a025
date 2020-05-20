class SkinItem extends ItemRendererBase {
	public constructor() {
		super();
		this.skinName = new SkinItemSkin
	}
	
	protected onAdded () {
		super.onAdded();
		EventManager.instance.addEvent(EventName.USER_SKIN_CHANGE, this.updateShow, this)
	}

	protected onRemoved () {
		super.onRemoved();
		EventManager.instance.removeEvent(EventName.USER_SKIN_CHANGE, this.updateShow, this)
	}
	private imgTitle;
	private imgIcon;
	private vo;
	protected createChildren () {
		super.createChildren();
		this.imgTitle.visible = !1
	}

	protected dataChanged () {
		this.vo = this.data,
		this.updateShow()
	}

	protected updateShow () {
		this.imgIcon.source = URLConfig.getSkin(this.vo.id),
		this.vo.id == Player.instance.skinId ? this.imgTitle.visible = !0 : this.imgTitle.visible = !1
	}

	protected onTouchTap (e) {
		if(this.vo.id != Player.instance.skinId){
			HttpClient.instance.post("API_URL", {c: "background", a: "switchBackground", backId: this.vo.id}).then((response:any)=>{
				Util.message.show(response.msg);
				Player.instance.skinId = this.vo.id;
				EventManager.instance.dispatch(EventName.USER_SKIN_CHANGE)
			}, (response:any)=>{
				Util.message.show(response.msg);
			});
		}
	}
}