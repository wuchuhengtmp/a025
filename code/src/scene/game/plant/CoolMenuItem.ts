class CoolMenuItem extends eui.Image {
	private type;
	public constructor(t) {
		super("menu_p_" + t + "_png");
		this.anchorOffsetX = 46;
		this.anchorOffsetY = 44;
		this.type = t;
		UIUtils.addButtonScaleEffects(this, !0);
		this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTapHandler, this);
		this.once(egret.Event.REMOVED_FROM_STAGE, this.onRemoved, this)
	}

	private onRemoved (e) {
		UIUtils.removeButtonScaleEffects(this, !0), this.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTapHandler, this)
	}
	
	private onTouchTapHandler (e) {
		this.execute(), CoolMenu.instance.hide(!0), e.stopPropagation(), e.stopImmediatePropagation()
	}

	public execute () {
		switch (this.type) {
			case MenuType.PLANT:
				this.plant();
				break;
			case MenuType.GAIN:
				this.gain();
				break;
			case MenuType.UPROOT:
				var e = LandDataManager.instance.landData[Const.clickLandIndex];
				e && e.phase != PlantPhase.die ? this.confirmUproot() : this.uproot();
				break;
			case MenuType.HOE + "_2":
			case MenuType.HOE + "_3":
			case MenuType.HOE + "_4":
				var t = Util.int(this.type.substr(this.type.length - 1, 1));
				var e = LandDataManager.instance.landData[Const.clickLandIndex];
				e && e.phase != PlantPhase.die ? this.confirmHoe(t) : this.hoe(t);
				break;
			case MenuType.DIE_BUG:
				this.dieBug();
				break;
			case MenuType.DIE_GRASS:
				this.dieGrass();
				break;
			case MenuType.PUT_WATER:
				this.putWater();
				break;
			case MenuType.MANURE:
				this.manure();
				break;
			case MenuType.ROSE_HEART:
				this.roseHeart()
		}
	}

	private confirmUproot () {
		Util.alert.show("确认铲除？", "果实未成熟，确认铲除？", this.uproot, true)
	}

	private confirmHoe (e) {
		Alert.instance.show("确认翻土？", "果实未成熟，确认翻土？", ()=>{this.hoe(e)}, true)
	}

	private plant () {
		HttpClient.instance.post("API_URL", {c: "land", a: "addSeed", landId: Const.clickLandIndex}).then((response:any)=>{
			AudioManager.instance.playEffect(AudioTag.SOW);

			var landId = response.data.landId;
			response.data.farmItem && LandDataManager.instance.updateLandData(landId, response.data.farmItem);
			LandDataManager.instance.landData[landId] = new LandVo(landId, response.data.farmItem);
			EventManager.instance.dispatch(EventName.PLANT_REFRESH, landId);
			Util.message.show("种植成功");
			this.showGemOutput(response.data);
		}, (response:any)=>{
			if(response.code == -1){
				Util.alert.show("种子不足", "种子不足，点击确定到商店购买", ()=>{
					var shopPanel = new ShopPanel;
					shopPanel.tabIdexToOpen = shopPanel.TAB_SEED;
					UIManager.instance.popPanel(shopPanel);
				}, true);
			}else{
				Util.message.show(response.msg);
			}
		})
	}

	private gain () {
		let self = this;
		HttpClient.instance.post("API_URL", {c: "land", a: "getFruit", landId: Const.clickLandIndex}).then((response:any)=>{
			AudioManager.instance.playEffect(AudioTag.GAIN);

			var landId = response.data.landId;
			response.data.farmItem && LandDataManager.instance.updateLandData(landId, response.data.farmItem);			
			EventManager.instance.dispatch(EventName.PLANT_REAP, response.data.output);
			LandDataManager.instance.landData[landId].phase = PlantPhase.die;
			EventManager.instance.dispatch(EventName.PLANT_REFRESH, landId);
			Util.message.show(response.msg);
			response.dog && PetDataManager.instance.updateCurrent(response.dog);
			response.data.cropId = response.data.farmItem.a;
			self.showGemOutput(response.data);
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	private uproot () {
		let self = this;
		HttpClient.instance.post("API_URL", {c: "land", a: "plowing", landId: Const.clickLandIndex}).then((response:any)=>{
			AudioManager.instance.playEffect(AudioTag.SHOVEL);
			Util.message.show(response.msg);

			var landId = response.data.landId;
			LandDataManager.instance.clearLand(landId);
			response.data.farmItem && LandDataManager.instance.updateLandData(landId, response.data.farmItem);
			EventManager.instance.dispatch(EventName.PLANT_REFRESH, landId);
			self.showGemOutput(response.data);
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	private hoe (tId) {
		let self = this;
		HttpClient.instance.post("API_URL", {c: "land", a: "plowing", landId: Const.clickLandIndex, tId: tId}).then((response:any)=>{
			AudioManager.instance.playEffect(AudioTag.SHOVEL);
			Util.message.show(response.msg);

			var landId = response.data.landId;
			LandDataManager.instance.clearLand(landId);
			WareHouseDataManager.instance.subProp(tId, 1);
			response.data.farmItem && LandDataManager.instance.updateLandData(landId, response.data.farmItem)
			EventManager.instance.dispatch(EventName.PLANT_REFRESH, landId);
			response.data.seed = 3;
			self.showGemOutput(response.data);
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	private dieBug () {
		if(WareHouseDataManager.instance.getPropNum(12) > 0){
			HttpClient.instance.post("API_URL", {c: "land", a: "landOp", landId: Const.clickLandIndex, mark: "icide"}).then((response:any)=>{
				Util.message.show(response.msg);

				WareHouseDataManager.instance.subProp(12, 1);
				LandDataManager.instance.updateLandData(response.data.landId, response.data.farmItem)
			}, (response:any)=>{
				Util.message.show(response.msg);
			})
		}else{
			Util.message.show("道具不足")
		}
	}

	private dieGrass () {
		if(WareHouseDataManager.instance.getPropNum(11) > 0){
			HttpClient.instance.post("API_URL", {c: "land", a: "landOp", landId: Const.clickLandIndex, mark: "hcide"}).then((response:any)=>{
				Util.message.show(response.msg);

				WareHouseDataManager.instance.subProp(11, 1);
				LandDataManager.instance.updateLandData(response.data.landId, response.data.farmItem)
				this.showGemOutput.bind(this);
			}, (response:any)=>{
				Util.message.show(response.msg);
			})
		}else{
			Util.message.show("道具不足")
		}
	}

	private putWater () {
		if(WareHouseDataManager.instance.getPropNum(10) > 0){
			HttpClient.instance.post("API_URL", {c: "land", a: "landOp", landId: Const.clickLandIndex, mark: "wcan"}).then((response:any)=>{
				Util.message.show(response.msg);

				WareHouseDataManager.instance.subProp(10, 1);
				LandDataManager.instance.updateLandData(response.data.landId, response.data.farmItem)
				this.showGemOutput.bind(this);
			}, (response:any)=>{
				Util.message.show(response.msg);
			})
		}else{
			Util.message.show("道具不足")
		}
	}

	private manure () {
		var e = WareHouseDataManager.instance.getPropNum(1);
		var	t = WareHouseDataManager.instance.getPropNum(9);
		var	n = LandDataManager.instance.landData[Const.clickLandIndex];
		var	i = n.currPhaseNeedTime;
		if(108e5 >= i){
			if(e > 0){
				this.manureNet(1);
			} else {
				if(t > 0){
					this.manureNet(2);
				}else{
					Util.alert.show("化肥不足", "化肥不足，点击确定到商店购买", ()=>{
						var shopPanel = new ShopPanel;
						shopPanel.tabIdexToOpen = shopPanel.TAB_PROP;
						UIManager.instance.popPanel(shopPanel);
					}, true)
				}
			}
		} else {
			if(t > 0){				
				this.manureNet(2);
			} else{
				if(e > 0){
					this.manureNet(1);
				} else {
					Util.alert.show("化肥不足", "化肥不足，点击确定到商店购买", ()=>{
						var shopPanel = new ShopPanel;
						shopPanel.tabIdexToOpen = shopPanel.TAB_PROP;
						UIManager.instance.popPanel(shopPanel);
					}, true)
				}
			}
		}
	}

	// 自定义网络请求
	private manureNet(tid){
		HttpClient.instance.post("API_URL", {c: "land", a: "fertilize", landId: Const.clickLandIndex, mark: "wcan"}).then((response:any)=>{
			AudioManager.instance.playEffect(AudioTag.SUCCESS);

			Util.message.show(response.msg);
			var landId = response.data.landId;
			WareHouseDataManager.instance.subProp(landId, 1);
			LandDataManager.instance.updateLandData(landId, response.data.farmItem);
			this.showGemOutput.bind(this);
		}, (response:any)=>{
			AudioManager.instance.playEffect(AudioTag.FAIL);
			Util.message.show(response.msg);
		})
	}

	private roseHeart () {
		var landId = Const.clickLandIndex;
		HttpClient.instance.post("API_URL", {c: "land", a: "addRose", landId: landId}).then((response:any)=>{
			AudioManager.instance.playEffect(AudioTag.SUCCESS);
			Util.message.show(response.msg);
			WareHouseDataManager.instance.subProp(99, 1);
			EventManager.instance.dispatch(EventName.ROSE_HEART_USE, landId);
		}, (response:any)=>{
			AudioManager.instance.playEffect(AudioTag.FAIL);
			Util.message.show(response.msg);
		})
	}

	private showGemOutput (e) {
		var t = [];
		if (e.cropId) {
			var n = GoodsVo.newFromTypeAndId(GoodsType.FRUIT, e.cropId, e.output);
			t.push(n);
		}
		if (e.baoshi) {
			var n = GoodsVo.newFromTypeAndId(GoodsType.GEM, e.baoshi, 1);
			t.push(n);
		}
		if (e.medal) {
			var i = e.medal;
			if (i.length > 0) {
				var n = GoodsVo.newFromTypeAndId(GoodsType.PROPS, 202, i[0]);
				t.push(n);
			}
			if (i.length > 1) {
				var n = GoodsVo.newFromTypeAndId(GoodsType.PROPS, 203, i[1]);
				t.push(n);
			}
		}
		if (e.seed) {
			var n = GoodsVo.newFromTypeAndId(GoodsType.PROPS, 1);
			n.num = 0;
			t.push(n);
		}
		var a = [];
		if (t.length > 0){
			for (var s = 0; s < t.length; s++){
				this.sendFlyEvent(t[s], 300 * s);
				t[s].num > 0 && a.push(t[s].name + "x" + t[s].num);
				WareHouseDataManager.instance.changeGoodsNum(n.type, n.id, n.num);
			}
		}
		e.cropId && Util.message.show("获得 " + a.join("、"));
	}

	private sendFlyEvent (e, t) {
		egret.setTimeout(()=>{
			EventManager.instance.dispatch(EventName.LAND_OPT_TIP, e)
		}, this, t)
	}
}

var MenuType = {
	PLANT: "plant",
	GAIN: "gain",
	UPROOT: "uproot",
	DIE_BUG: "die_bug",
	DIE_GRASS: "die_grass",
	PUT_WATER: "put_water",
	MANURE: "manure",
	HOE: "hoe",
	ROSE_HEART: "rose_heart"
}