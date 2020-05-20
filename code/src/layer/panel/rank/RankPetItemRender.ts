class RankPetItemRender extends ItemRendererBase {
	public constructor() {
		super();
		this.skinName = new RankPetItemRenderSkin;
	}

	private uvo;
	private imgRank;
	private labelRank;
	private labelName;
	private labelLv;
	private labelScore;
	private labelOwnerName;
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
		this.labelScore.text = e.score + "";
		this.labelOwnerName.text = e.ownerName + "";
	}
	
}