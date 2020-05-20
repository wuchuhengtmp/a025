class BuildingLandItem extends ItemRendererBase {
	public constructor() {
		super();
		this.skinName = new BuildingLandItemSkin;
	}

	public onAdded () {
		super.onAdded();
		EventManager.instance.addEvent(EventName.LAND_REFRESH, this.onLandUp, this);
	}

	public onRemoved () {
		super.onRemoved();
		EventManager.instance.removeEvent(EventName.LAND_REFRESH, this.onLandUp, this);
	}

	public onLandUp () {
		this.updateStart()
	}

	private card;
	private btnUp;
	private vo;
	private groupCost;
	private landType;
	private labelTitle;
	private groupStar;
	protected createChildren () {
		super.createChildren();
		this.btnUp[Const.NO_AUDIO_TAG] = true;
	}

	public initIcon () {
		if(!this.card){
			this.card = new BuildingCostItem(this.vo, -1),
			this.card.x = 30,
			this.card.y = 0,
			this.card.rotation = 8,
			this.addChild(this.card)
		}
	}

	public initCost () {
		this.groupCost.removeChildren();
		var e = this.vo.cost;
		var t = e.length;
		for (let n = 0; t > n; n++) {
			var i = new CostItem(e[n].gvo,e[n].gnum);
			i.visibleAdd(t - 1 > n),
			i.itemWidth(86),
			i.labelTotalOffsetY(-5),
			i.iconOffsetY(-3),
			i.x = 88 * n + 18,
			i.y = -15,
			this.groupCost.addChild(i)
		}
	}

	public dataChanged () {
		this.landType = this.data,
		this.vo = LandDataManager.instance.landUpData[this.landType - 1],
		this.labelTitle.text = "升级" + this.vo.name + "消耗",
		this.initIcon(),
		this.initCost(),
		this.updateStart()
	}

	private updateStart () {
		var e = LandDataManager.instance.getLandCountByLv(this.landType, !0);
		for (let t = 0; 12 > t; t++) {
			var n = this.groupStar.getChildAt(t);
			e > t ? n.source = "building_land_num" + this.landType + "_png" : n.source = "building_land_num0_png"
		}
	}

	public onTouchTap (e) {
		var n = e.target;
		if (n == this.btnUp) {
			// for (var i = 0, a = this.vo.cost; i < a.length; i++) {
			// 	var s = a[i];
			// 	if (s.gvo.isDiamond && Player.instance.diamond < s.gnum){
			// 		return Util.alert.show("金币不足", "金币不足，是否去兑换金币？", ()=>{
			// 			UIManager.instance.popPanel(PayPanel)
			// 		}, null)
			// 	}
			// }
			HttpClient.instance.post("API_URL", {c: "user", a: "saveLandUp", type: this.landType * 1 + 1}).then((response:any)=>{
				AudioManager.instance.playEffect(AudioTag.SUCCESS);
				Util.message.show(response.msg);
				var n = response.data.landId;
				LandDataManager.instance.landData[n].landLv++;
				EventManager.instance.dispatch(EventName.LAND_REFRESH, n);
				// for (var i = 0; i < this.vo.cost.length; i++) {
				// 	var a = this.vo.cost[i];
				// 	a.gvo.num -= a.gnum;
				// 	var s = this.groupCost.getChildAt(i);
				// 	s.updateShow()
				// }
				// Player.instance.batchSubRes(this.vo.cost)
			}, (response:any)=>{
				AudioManager.instance.playEffect(AudioTag.FAIL);
				Util.message.show(response.msg);
			});
		}
	}
	
}