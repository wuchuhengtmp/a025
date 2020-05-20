class GameView extends PanelBase {
	private isOther:boolean;
	private currLandIndex:number;
	private landPlantMap:HashMap;
	private lastTouchX:number;
	private startTouchX:number;
	private lastTouchTime:number;
	private instance:GameView;
	public isVisibleAnimate:boolean;

	public landGroup:eui.Group;
	public plantGroup:eui.Group;
	public stateGroup:eui.Group;
	public imgLandLight:eui.Image;
	public landCenterPosArr:any;

	public constructor(obj) {
		super(obj);
		this.isOther = false;
		this.currLandIndex = -1;
		this.landPlantMap = new HashMap;
		this.lastTouchX = -1;
		this.startTouchX = -1;
		this.lastTouchTime = -1;
		this.instance = this;
		this.isVisibleAnimate = false;
		this.isOther = OtherPlayer.instance.opening;
		this.skinName = "GameViewSkin";
	}

	public onAdded () {
		super.onAdded();
		if(!this.isOther){
			UpdateTicker.instance.add(this),
			this.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBeganHandler, this);
			this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTapHandler, this);
			this.stage.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onStageTouchTapHandler, this);
			EventManager.instance.addEvent(EventName.PLANT_REFRESH, this.onLandPlantRefresh, this);
			EventManager.instance.addEvent(EventName.PLANT_REAP, this.onPlantReap, this);
			EventManager.instance.addEvent(EventName.LAND_OPT_TIP, this.onLandOptTip, this);
			EventManager.instance.addEvent(EventName.LAND_REFRESH, this.onLandRefresh, this);
			EventManager.instance.addEvent(EventName.COOLMENU_HIDE, this.hideLandLight, this);
			EventManager.instance.addEvent(EventName.ROSE_HEART_USE, this.showRoseHeartEffect, this);
		}
		UIUtils.addLongTouch(this, this.onLongTouchLand.bind(this), this.onLongTouchLandEnd.bind(this));
	}

	public onRemoved () {
		super.onRemoved();
		if(!this.isOther){
			UpdateTicker.instance.remove(this);
			this.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onTouchBeganHandler, this);
			this.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTapHandler, this);
			this.stage.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.onStageTouchTapHandler, this);
			EventManager.instance.removeEvent(EventName.PLANT_REFRESH, this.onLandPlantRefresh, this);
			EventManager.instance.removeEvent(EventName.PLANT_REAP, this.onPlantReap, this);
			EventManager.instance.removeEvent(EventName.LAND_OPT_TIP, this.onLandOptTip, this);
			EventManager.instance.removeEvent(EventName.LAND_REFRESH, this.onLandRefresh, this);
			EventManager.instance.removeEvent(EventName.COOLMENU_HIDE, this.hideLandLight, this);
			EventManager.instance.removeEvent(EventName.ROSE_HEART_USE, this.showRoseHeartEffect, this);
		}
		UIUtils.removeLongTouch(this)
	}

	public update (e) {}

	private onStageTouchTapHandler () {
		this.hideLandLight()
	}

	private onTouchTapHandler (e) {
		e.stopPropagation();
		var t = this.checkPlantOrLandClick(e.localX, e.localY);
		if (t >= 0){
			this.clickLand(t);
		} else {
			this.hideLandLight();
			for (var n = Player.instance.houseLv, i = n; 12 > i; i++) {
				var a = this.landCenterPosArr[i];
				if (Math.abs(a.x - e.localX) < Const.LAND_HALF_H && Math.abs(a.y - e.localY) < Const.LAND_HALF_H) {
					UIManager.instance.popPanel(BuildingPanel);
					break
				}
			}
		}
	}

	private onTouchBeganHandler (e) {
		CoolMenu.instance.hide();
		PlantCdTip.hide();
		this.lastTouchX = e.stageX;
		this.startTouchX = e.stageX;
		this.lastTouchTime = egret.getTimer()
	}

	private checkPlantOrLandClick (e, t) {
		var n = -1, i = new egret.Point(e,t);
		for (let a = 0; a < this.plantGroup.numChildren; a++) {
			var s:any = this.plantGroup.getChildAt(a);
			var o = s.getBoundingBox();
			if (o.containsPoint(i)) {
				n = s.vo.landId;
				break
			}
		}
		if (0 > n){
			for (var r = Player.instance.houseLv, a = 0; r > a; a++) {
				var h = this.landCenterPosArr[a];
				if (Math.abs(h.x - e) < Const.LAND_HALF_H && Math.abs(h.y - t) < Const.LAND_HALF_H) {
					n = a;
					break
				}
			}
		}
		return n
	}

	private sparkLandLight () {
		var e = this.imgLandLight.visible;
		egret.Tween.get(this.imgLandLight).set({
			visible: !0,
			alpha: 0
		}).to({
			alpha: 1
		}, 50).to({
			alpha: 0
		}, 50).to({
			alpha: 1
		}, 50).to({
			alpha: 0
		}, 50).to({
			alpha: 1
		}, 50).to({
			alpha: 0
		}, 1e3).set({
			alpha: 1,
			visible: e
		})
	}

	private showLandLight (e) {
		this.imgLandLight.visible = !0,
			this.imgLandLight.x = e.x - Const.LAND_HALF_W,
			this.imgLandLight.y = e.y - Const.LAND_HALF_H - 2
	}

	private hideLandLight () {
		this.imgLandLight.visible = !1
	}

	private showRoseHeartEffectOne (e) {
		var t = new eui.Image("flowers_png");
		t.width = 30, t.height = 30;
		var n = t.x = e.x - 23;
		var i = e.y - 30;
		var a = e.y - 300;
		var s = Math.floor(30 * Math.random() + 100);
		var o = Math.floor(360 * Math.random());
		var r = s * Math.sin(o * Math.PI / 180);
		var h = s * Math.cos(o * Math.PI / 180);
		var c = n + r;
		var l = a + h;
		var d = Math.floor(360 * Math.random());
		var u = Math.floor(200 * Math.random() + 50);
		var g = Math.floor(200 * Math.random() + 100);
		var p = Math.floor(360 * Math.random());
		this.addChild(t);
		egret.Tween.get(t).set({
			x: n,
			y: a,
			alpha: 0,
			rotation: d
		}).to({
			x: c,
			y: l,
			alpha: .8
		}, u, egret.Ease.quadOut).wait(300).to({
			x: n,
			y: i,
			scaleX: .5,
			scaleY: .5,
			alpha: 1,
			rotation: p
		}, g, egret.Ease.quadIn).call(()=>{
			UIUtils.removeSelf(t)
		})
	}

	private showRoseHeartEffect (e) {
		for (var t = this, n = Util.int(e.data), i = this.landCenterPosArr[n], a = 0; 10 > a; a++){
			this.showRoseHeartEffectOne(i);
		}
		
		egret.Tween.get(this).wait(850).call(()=>{
			t.sparkLandLight()
		})
	}

	private clickLand (e) {
		this.currLandIndex = e, Const.clickLandIndex = e;
		var t = LandDataManager.instance.landData[e];
		var n = this.landCenterPosArr[e];
		var i = n.clone();
		i.x += this.x - 7;
		i.y += this.y - 25;
		CoolMenu.instance.hide();
		// 读取道具锄头的数量
		var a = 0;
		for (let s = 3; s >= 2; s--) {
			var o = WareHouseDataManager.instance.getPropNum(s);
			if (o > 0) {
				a = s;
				break
			}
		}
		if (t && t.phase != PlantPhase.empty){
			if (t.phase == PlantPhase.die)
				a ? CoolMenu.instance.show([MenuType.HOE + "_" + a], i) : CoolMenu.instance.show([MenuType.UPROOT], i);
			else if (t.phase == PlantPhase.ripe)
				CoolMenu.instance.show([MenuType.GAIN], i);
			else {
				var r = [MenuType.MANURE];
				if (t.phase == PlantPhase.seed) {
					// 读取道具玫瑰之心
					var h = WareHouseDataManager.instance.getPropNum(99);
					h > 0 && r.push(MenuType.ROSE_HEART)
				}
				t.stateBug && r.push(MenuType.DIE_BUG);
				t.stateGrass && r.push(MenuType.DIE_GRASS);
				t.stateWater && r.push(MenuType.PUT_WATER);
				a ? r.push(MenuType.HOE + "_" + a) : r.push(MenuType.UPROOT);
				CoolMenu.instance.show(r, i);
			}
		}else{
			CoolMenu.instance.show([MenuType.PLANT], i);
		}
		this.showLandLight(n);
		AudioManager.instance.playEffect(AudioTag.BUTTON);
	}

	private onLongTouchLand (e) {
		var t = this.checkPlantOrLandClick(e.stageX - this.x, e.stageY - this.y);
		if (t >= 0) {
			var n = LandDataManager.instance.landData;
			if (0 == n.length)
				return;
			this.isOther && (n = OtherPlayer.instance.landData);
			var i = n[t];
			if (i) {
				var a = this.landCenterPosArr[t].clone();
				a.x += this.x;
				a.y += this.y - 25;
				PlantCdTip.show(i, a);
			}
		}
	}

	private onLongTouchLandEnd (e) {
		PlantCdTip.hide()
	}

	protected createChildren () {
		super.createChildren();
		this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAdded, this),
		this.addEventListener(egret.Event.REMOVED_FROM_STAGE, this.onRemoved, this)

		this.imgLandLight.touchEnabled = !1,
		this.hideLandLight(),
		this.landGroup.touchEnabled = this.landGroup.touchChildren = !1,
		this.plantGroup.touchEnabled = this.plantGroup.touchChildren = !1,
		this.stateGroup.touchEnabled = this.stateGroup.touchChildren = !1,
		this.stateGroup.name = "stateGroup",
		GameLayerManager.instance.plantStateLayer = this.stateGroup,
		this.initLandCenterPos(),
		this.initOpenLand(),
		this.updateAllPlant();
	}

	private initLandCenterPos () {
		this.landCenterPosArr = [];
		for (var e = Const.LAND_HALF_W, t = Const.LAND_HALF_H, n = 0; 12 > n; n++) {
			var i = new egret.Point;
			i.x = -(n % 3) * (e - 10) + Util.int(n / 3) * e;
			i.y = n % 3 * (t + 3) + Util.int(n / 3) * t;
			this.landCenterPosArr.push(i);
		}
	}

	private initOpenLand () {
		for (var e = 0; 12 > e; e++) {
			var t = new eui.Image;
			t.x = this.landCenterPosArr[e].x - Const.LAND_HALF_W,
				t.y = this.landCenterPosArr[e].y - Const.LAND_HALF_H,
				this.landGroup.addChild(t),
				this.updateOneLand(e)
		}
	}

	private updateOneLand (e) {
		var t = Player.instance.houseLv
		var n = LandDataManager.instance.landData;
		if (0 != n.length) {
			this.isOther && (t = OtherPlayer.instance.houseLv, n = OtherPlayer.instance.landData);
			var i = -1;
			t > e && (i = n[e].landLv);
			var a:any = this.landGroup.getChildAt(e);
			a.source = "land" + i + "_png"
		}
	}

	private updateAllPlant () {
		var e = LandDataManager.instance.landData;
		if (0 != e.length) {
			var t = Player.instance.houseLv;
			this.isOther && (e = OtherPlayer.instance.landData, t = OtherPlayer.instance.houseLv);
			this.plantGroup.removeChildren();
			var n = Math.min(e.length, t);
			for (let i = 0; n > i; i++){
				this.updateOnePlant(i)
			}				
		}
	}

	private updateOnePlant (e) {
		var t = LandDataManager.instance.landData;
		if (0 != t.length) {
			this.isOther && (t = OtherPlayer.instance.landData);
			var n = this.landPlantMap.get(e), i = t[e];
			if(i && i.plantId > 0){
				if(n){
					n.changeData(i)
				}else{
					n = new Plant(i);
					n.x = this.landCenterPosArr[e].x;
					n.y = this.landCenterPosArr[e].y;
					this.landPlantMap.add(e, n);
				}
				n.updateDisease();
				this.plantGroup.addChild(n);
			} else {
				UIUtils.removeSelf(n);
			}
		}
	}

	private onLandRefresh (e) {
		if (null != e.data) {
			var t = e.data;
			this.updateOneLand(t)
		} else
			var n = Player.instance.houseLv;
			for (let i = 0; n > i; i++){
				this.updateOneLand(i);
			}
	}

	private onLandPlantRefresh (e) {
		if (null != e.data) {
			var t = e.data;
			this.updateOnePlant(t)
		} else
			this.updateAllPlant()
	}

	private onPlantReap (e) {
		var t = (e.data, Const.clickLandIndex);
		var n = this.landPlantMap.get(t);
		n.showReapAnim()
	}

	private onLandOptTip (e) {
		this.showFlyTipInOptLand(e.data)
	}

	private showTipInOptLand (e) {
		var t = Const.clickLandIndex, n = this.landCenterPosArr[t];
		n = this.landGroup.localToGlobal(n.x - 50, n.y - 30);
		Util.message.show(e, null, n.y);
	}

	private showFlyTipInOptLand (e) {
		var t = Const.clickLandIndex;
		var n = this.landCenterPosArr[t];
		n = this.landGroup.localToGlobal(n.x, n.y);
		var i = RES.getRes(URLConfig.getIcon(e.icon));
		var a = new eui.Image(i);
		a.x = n.x;
		a.y = n.y;
		a.anchorOffsetX = i.textureWidth / 2;
		a.anchorOffsetY = i.textureHeight / 2;
		GameLayerManager.instance.tipsLayer.addChild(a);
		FlyAnim.instance.fly(a, Const.headIconPos, 700);
	}

	public showGuide () {
		this.clickLand(0)
	}
}