class RankPlayItemRender extends ItemRendererBase {
	public constructor() {
		super();
		this.skinName = new RankPlayItemRenderSkin;
	}

	private uvo;
	private imgRank;
	private labelRank;
	private labelName;
	private labelLv;
	private labelMoney;
	private btnHome;
	private messageY = 200;
	protected createChildren():void {
		super.createChildren();
	}

	public dataChanged () {
		var e = this.data;
		this.uvo = e;
		if(e.rank <= 3){
			this.imgRank.visible = !0;
			this.labelRank.visible = !1;
			this.imgRank.source = "rank" + e.rank + "_png";
		}else{
			this.imgRank.visible = !1;
			this.labelRank.visible = !0;
			this.labelRank.text = e.rank + "";
		}
		this.labelName.text = e.name.length > 7 ? e.name.substr(0, 7) + "..." : e.name;
		this.labelLv.text = e.lv + "";
		this.labelMoney.text = e.diamond + "";
	}

	public onTouchTap (e) {
		var t = e.target;
		if(t == this.btnHome){
			if(this.uvo.uid == Player.instance.uid){
				Util.message.show("这是你的农场，不用去啦！", null, this.messageY);
			}else{
				OtherPlayer.instance.enterOtherFarm(this.uvo.uid)
			}
		}
	}
}