class BuildingHouse extends PanelBase {
	public isFullScreen;
	public isVisibleAnimate;
	public constructor() {
		super(BuildingHouse);
		this.isFullScreen = false;
		this.isVisibleAnimate = false;
		this.skinName = new BuildingHouseSkin
	}

	private labelLv:eui.Label;
	private imgIcon:eui.Image;
	private btnUp:eui.Button;
	private groupCost:eui.Group;
	protected createChildren():void {
		super.createChildren();
		this.touchEnabled = !1
		this.showLevel();
		this.queryLevelUpCondition()
		EventManager.instance.addEvent(EventName.USER_RES_CHANGE, this.queryLevelUpCondition, this);
		EventManager.instance.addEvent(EventName.USER_DIAMOND_CHANGE, this.queryLevelUpCondition, this);
		
		this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this);
		this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAdded, this);
		this.addEventListener(egret.Event.REMOVED_FROM_STAGE, this.onRemoved, this);
	}

	public destroy () {
		super.destroy(),
		EventManager.instance.removeEvent(EventName.USER_RES_CHANGE, this.queryLevelUpCondition, this),
		EventManager.instance.removeEvent(EventName.USER_DIAMOND_CHANGE, this.queryLevelUpCondition, this)
	}

	
	private showLevel(){
		let houseLv:number = Player.instance.houseLv;
		var houseLvUp = Util.limit(houseLv*1 + 1, 1, 12);
		this.labelLv.text = "LV." + houseLv;
		this.imgIcon.source = URLConfig.getHouse(houseLvUp);
		if(houseLv >= 12){
			this.btnUp.enabled = !1;
			this.btnUp.label = "满级"
		}else{
			this.btnUp.enabled = !0;
			this.btnUp.label = "升级"
		}
	}

	private queryLevelUpCondition () {
		HttpClient.instance.post('API_URL', {c: 'user', a: 'houseInfo'}).then((response:any)=>{
			BuildingDataManager.instance.serverInit(response.data.dataInfo);
			this.updateCostList();
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	private updateCostList () {
		this.groupCost.removeChildren();
		let e = BuildingDataManager.instance.levelUpCostData;
		let t = e.length;
		let n = new eui.Group;
		n.verticalCenter = n.horizontalCenter = 0;
		this.groupCost.addChild(n);
		for (var i = 0; t > i; i++) {
			var a = new BuildingCostItem(e[i].gvo, e[i].gnum);
			a.x = i * (126 + 25 * (4 - t)), n.addChild(a);
		}
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
		var i = t.target;
		if (i == this.btnUp) {
			var a = BuildingDataManager.instance.levelUpCostData;
			for (let o = 0; o < a.length; o++) {
				var r = a[o];
				if (r.gvo.num < r.gnum){
					if(r.gvo.isDiamond){
						Util.alert.show("金币不足", "金币不足，是否去兑换金币？", ()=>{
							UIManager.instance.popPanel(PayPanel)
						}, true)
					}else{
						Util.alert.show(r.gvo.name + "不足", r.gvo.name + "不足，是否去兑换中心兑换？", ()=>{
							UIManager.instance.popPanel(ExchangePanel, ExchangePanel.TAB_RES)
						}, true)
					}
					return;
				}
			}
			HttpClient.instance.post("API_URL", {c: "user", a: "upHouse"}).then((response:any)=>{
				AudioManager.instance.playEffect(AudioTag.LEVELUP);
				UIManager.instance.popOrHidePanel(BuildingPanel);
				this.showLevelUpEffect(),
				Player.instance.houseLv++,
				this.showLevel(),
				EventManager.instance.dispatch(EventName.USER_HOUSE_CHANGE),
				LandDataManager.instance.openNewLand();

				var t = BuildingDataManager.instance.levelUpCostData;
				Player.instance.batchSubRes(t),
				this.queryLevelUpCondition()
			}, (response:any)=>{
				AudioManager.instance.playEffect(AudioTag.FAIL);
				Util.message.show(response.msg);
			});
		}
	}

	private showLevelUpEffect () {
		var e = new eui.Group, t = new eui.Image("building_up_ok_png");
		t.x = -273,
		t.y = -134.5,
		e.addChild(t),
		e.x = Const.stageW / 2,
		e.y = Const.stageH / 2,
		e.scaleX = e.scaleY = 0,
		GameLayerManager.instance.tipsLayer.addChild(e),
		egret.Tween.get(e).to({
			scaleX: 1,
			scaleY: 1,
			y: e.y - 100
		}, 350, egret.Ease.backOut).wait(1e3).to({
			alpha: 0
		}, 350).call(UIUtils.removeSelf, this, [e])
	}
}