class RoleInfoPanel extends PanelBase{
	public constructor() {
		super(null);
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new RoleInfoPanelSkin
	}

	private imgHead:eui.Image;
	private logoutBtn:eui.Button;
	private editBtn:eui.Button;
	private labelId:eui.Label;
	private labelName:eui.Label;
	private labelLv:eui.Label;
	private labelDiamond:eui.Label;
	protected createChildren():void {
		super.createChildren();
		this.imgHead.source = URLConfig.getHead(Player.instance.avatar),
		this.labelId.text = Player.instance.userId + "",
		this.labelName.text = Player.instance.name,
		this.labelLv.text = "LV." + Player.instance.houseLv,
		this.labelDiamond.text = Player.instance.diamond + ""
	}

	public onTouchTap(evt:egret.Event){
		super.onTouchTap(evt);
		switch(evt.$target){
			case this.logoutBtn:
				this.logout();
				break;
			case this.editBtn:
				this.hide();
				SceneManager.instance.runScene(EditScene);
				break;
		}
	}

	private logout(){
		LocalStorage.remove("userInfo");
		this.hide();
		SceneManager.instance.runScene(LoginScene);
	}
}