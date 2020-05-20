class ExchangeSkinItem extends ItemRendererBase {
	public constructor() {
		super();
		this.skinName = new ExchangeSkinItemSkin;
	}
	private vo;
	private imgBuyed;
	private btnEx;
	private imgTitle;
	private imgIcon;
	private groupCost;
	private messageY = 230;
	protected createChildren():void {
		super.createChildren();
		this.btnEx[Const.NO_AUDIO_TAG] = true;
	}

	protected dataChanged(){
		this.vo = this.data;
		var isBuyed = WareHouseDataManager.instance.findSkinIsBuyed(this.vo.id);
		this.imgBuyed.visible = isBuyed;
		this.btnEx.visible = !isBuyed;
		this.imgTitle.source = "ex_skin_title" + this.vo.id + "_png";
		this.imgIcon.source = URLConfig.getSkin(this.vo.id);
		this.groupCost.removeChildren();
		for (var t = Math.min(3, this.vo.cost.length), n = 0; t > n; n++) {
			var i = this.vo.cost[n];
			var a = new CostItem(i.gvo,i.gnum);
			a.visibleAdd(t - 1 > n);
			a.itemWidth(86);
			a.labelTotalOffsetY(-7);
			a.x = 100 * n;
			a.y = -20;
			this.groupCost.addChild(a)
		}
	}

	protected onTouchTap (e) {
		var t = e.target;
		t == this.btnEx && this.onBuy()
	}

	private onBuy () {
		var e = this, t = 0;
		for (let n = this.vo.cost; t < n.length; t++) {
			var i = n[t];
			if (i.gvo.isDiamond && Player.instance.diamond < i.gnum){
				Util.alert.show("金币不足", "金币不足，是否去兑换金币？", ()=>{
					UIManager.instance.popPanel(PayPanel)
				}, null)
				return;
			}
		}

		HttpClient.instance.post('API_URL', {c: "gift", a: "exchange", type: this.vo.type, id: this.vo.id, nums: 1}).then((response:any)=>{
			AudioManager.instance.playEffect(AudioTag.SUCCESS);
			Util.message.show(response.msg, null, this.messageY);
			for (var i = 0; i < this.vo.cost.length; i++) {
				var a = this.vo.cost[i];
				a.gvo.num -= a.gnum * t;
				a.gvo.isDiamond && (Player.instance.diamond -= a.gnum)
			}
			e.vo.num = 1;
			WareHouseDataManager.instance.skinData.push(e.vo);
			e.dataChanged();
		}, (response:any)=>{
			AudioManager.instance.playEffect(AudioTag.FAIL);
			Util.message.show(response.msg, null, this.messageY);
		})
	}
}