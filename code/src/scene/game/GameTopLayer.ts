class GameTopLayer extends PanelBase {
	public constructor() {
		super(GameLayerManager.instance.uiLayer);
		this.top = this.horizontalCenter = 0;
		this.skinName = new GameTopSkin,
		this.top = this.horizontalCenter = 0
	}

	public onShow(){
		this.top = -this.height;
		egret.Tween.get(this).to({
			top: 0			
		}, 250)
	}

	public onHide () {
		egret.Tween.get(this).to({
			top: -this.height
		}, 250).call(UIUtils.removeSelf, this, [this])
	}

	private groupBtn:eui.Group;
	private imgHead:eui.Image;
	private imglaba:eui.Image;
	private btnShowOrHide:eui.ToggleButton;
	private btnLog:eui.Button;
	private btnRank:eui.Button;
	private btnPay:eui.Button;
	private btnSetting:eui.Button;
	private btnCommon:eui.Button;
	private btnFriend:eui.Button;
	private labelName:eui.Label;
	private labelWood:eui.Label;
	private labelStone:eui.Label;
	private labelSteel:eui.Label;
	private labelDiamond:eui.Label;
	protected createChildren():void {
		super.createChildren();
		if(OtherPlayer.instance.opening){
			this.labelName.text = OtherPlayer.instance.name + "的家园";
			this.imgHead.source = URLConfig.getHead(OtherPlayer.instance.avatar);
			this.groupBtn.visible = !1;
			this.btnShowOrHide.visible = !1;
		}else{
			this.labelName.text = Player.instance.name + "的家园";
			this.imgHead.source = URLConfig.getHead(Player.instance.avatar);
			Const.headIconPos = new egret.Point(100 + .5 * (Const.stageW - 640), 80);
			EventManager.instance.addEvent(EventName.USER_DIAMOND_CHANGE, this.showDiamond, this, !0);
			EventManager.instance.addEvent(EventName.USER_RES_CHANGE, this.showRes, this, !0);
		}
		this.showRes(),
		this.showDiamond()
	}

	private showDiamond () {
		OtherPlayer.instance.opening || (this.labelDiamond.text = Player.instance.diamond + "")
	}

	private showRes () {
		if(OtherPlayer.instance.opening){
			this.labelWood.text = OtherPlayer.instance.wood + "";
			this.labelStone.text = OtherPlayer.instance.stone + "";
			this.labelSteel.text = OtherPlayer.instance.steel + "";
			this.labelDiamond.text = OtherPlayer.instance.diamond + ""
		}else{
			this.labelWood.text = Player.instance.wood + "";
			this.labelStone.text = Player.instance.stone + "";
			this.labelSteel.text = Player.instance.steel + ""
		}
	}
	
	// 头部工具卡四个按钮
	public onTouchTap(evt:egret.Event): void{
		super.onTouchTap(evt);
		let target = evt.$target;
		switch(target){
			case this.btnLog:
				UIManager.instance.popPanel(LogPanel);
				break;
			case this.btnRank:
				UIManager.instance.popPanel(RankPanel);
				break;
			case this.btnPay:
				UIManager.instance.popPanel(PayPanel);
				break;
			case this.btnShowOrHide:
				this.showOrHideTopButton();
				break;
			case this.btnFriend:
				UIManager.instance.popPanel(FriendPanel);
				break;
			case this.btnSetting:
				UIManager.instance.popPanel(SettingPanel);
				break;
			case this.btnCommon:
				Util.message.show("敬请期待！");
				break;
			case this.imgHead:
				OtherPlayer.instance.opening || (AudioManager.instance.playEffect(AudioTag.BUTTON), UIManager.instance.popPanel(RoleInfoPanel));
				break;
			case this.imglaba:
				// AddMessageAlert.instance.show("每发布一条世界消息消耗100金币","请输入消息内容",(m)=>{
				// 	this.sendMessage(m);
				// });
				UIManager.instance.popPanel(WorldMessagePanel);
				break;
			
		}
	}
	private showOrHideTopButton () {
		if(this.btnShowOrHide.selected){
			egret.Tween.get(this.groupBtn).to({
				y: -100
			}, 250).call(()=>{
				this.groupBtn.visible = !1
			}, this)
		}else{
			this.groupBtn.visible = !0,
			egret.Tween.get(this.groupBtn).to({
				y: 0
			}, 250)
		}
	}
}