class Plant extends eui.Group {
	private lastResURL:string;
	private vo:any;
	private imgLand:eui.Image;
	private imgPlant:eui.Image;
	private stateGroup:eui.Group;
	private box:egret.Rectangle;
	private boundingBox:egret.Rectangle;
	private nextPhaseTimer:egret.Timer;
	public constructor(t) {
		super();
		this.lastResURL = "",
		this.touchChildren = this.touchEnabled = !1,
		this.touchThrough = !0,
		this.changeData(t),
		this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAdded, this),
		this.addEventListener(egret.Event.REMOVED_FROM_STAGE, this.onRemoved, this)
	}

	public changeData (e) {
		var t = this;
		this.vo = e;
		if (this.vo.plantId <= 0){
			return UIUtils.removeSelf(this);
		}
		if(!this.imgPlant){
			this.imgLand = new eui.Image(RES.getRes("land_manure_png"));
			this.imgLand.x = -Const.LAND_HALF_W;
			this.imgLand.y = -Const.LAND_HALF_H;
			this.addChild(this.imgLand);
			this.imgLand.visible = false;
			this.imgPlant = new eui.Image;
			this.addChild(this.imgPlant);
			this.stateGroup = new eui.Group;
			this.stateGroup.touchChildren = false;
			this.stateGroup.touchEnabled = false;
		}
		var n = URLConfig.getPlant(e.plantId, e.phase);
		if(this.lastResURL != n){
			this.lastResURL = n,
			this.imgPlant.source = null,
			RES.getResByUrl(n, (n)=>{
				this.imgPlant.source = n;
				var i = n.textureWidth, a = n.textureHeight;
				this.imgPlant.x = -i / 2 - 10;
				e.phase == PlantPhase.seed ? t.imgPlant.y = -a : t.imgPlant.y = -a + 10;
				this.box = new egret.Rectangle(-i / 3,.75 * -a,.66 * i,.75 * a)
			}, this)
		}

		if(this.nextPhaseTimer){ 
			this.nextPhaseTimer.reset();
			this.nextPhaseTimer.stop();
		}
		if(this.vo && Util.isElinArr(this.vo.phase, [PlantPhase.seed, PlantPhase.seeding, PlantPhase.growup])){
			if(this.nextPhaseTimer){
				this.nextPhaseTimer.delay = this.vo.currPhaseNeedTime;
				this.nextPhaseTimer.reset();
				this.nextPhaseTimer.repeatCount = 1;
			}else{
				this.nextPhaseTimer = new egret.Timer(this.vo.currPhaseNeedTime, 1);
				this.nextPhaseTimer.addEventListener(egret.TimerEvent.TIMER_COMPLETE, this.onNextPhaseTimerOver, this)
			}
			this.nextPhaseTimer.start()
		}
	}

	private onNextPhaseTimerOver (e) {
		if(this.vo.phase == PlantPhase.seed){
			this.vo.phase = PlantPhase.seeding;
		}else{
			if(this.vo.phase == PlantPhase.seeding){
				this.vo.phase = PlantPhase.growup;
			}else{
				this.vo.phase == PlantPhase.growup && (this.vo.phase = PlantPhase.ripe);
			}
		}
		this.changeData(this.vo);
		HttpClient.instance.post("API_URL", {c: "land", a: "getLandInfo", landId: this.vo.landId}).then((response:any)=>{
			LandDataManager.instance.updateLandData(response.data.landId, response.data.farmItem);
		}, (response:any)=>{
			Util.message.show(response.msg, null, null, 1500);
		});
	}

	private onAdded (e) {
		GameLayerManager.instance.plantStateLayer.addChild(this.stateGroup)
	}

	private onRemoved (e) {
		UIUtils.removeSelf(this.stateGroup)
	}

	private getBoundingBox () {
		return this.box ? (this.boundingBox ? (this.boundingBox.x = this.box.x + this.x, this.boundingBox.y = this.box.y + this.y, this.boundingBox.width = this.box.width, this.boundingBox.height = this.box.height) : this.boundingBox = new egret.Rectangle(this.box.x + this.x,this.box.y + this.y,this.box.width,this.box.height), this.boundingBox) : null
	}

	public updateDisease () {
		var e = [];
		this.vo.stateGrass && e.push(1);
		this.vo.stateBug && e.push(2);
		this.vo.stateWater && e.push(3);
		this.setDisease(e);
		this.imgLand.visible = this.vo.stateManure;
	}

	private setDisease (e) {
		if (this.stateGroup.removeChildren(), Util.isElinArr(this.vo.phase, [PlantPhase.growup, PlantPhase.seeding])) {
			for (var t = e.length, n = 0; t > n; n++) {
				var i = new eui.Image("plant_state" + e[n] + "_png");
				i.x = 33 * n;
				3 == t && 1 == n && (i.y = -10);
				this.stateGroup.addChild(i)
			}
			var a = 33 * t;
			this.stateGroup.x = this.x - a / 2 - 13;
			this.vo.phase == PlantPhase.growup ? this.stateGroup.y = -100 + this.y : this.stateGroup.y = -70 + this.y
		}
	}

	private showReapAnim () {
		var t = URLConfig.getPlant(this.vo.plantId, PlantPhase.ripe);
		var n = new eui.Image(t);
		this.addChild(n);
		RES.getResByUrl(t, (t)=>{
			n.source = t;
			var i = t.textureWidth;
			var a = t.textureHeight;
			n.x = -i / 2 - 10;
			n.y = -a + 10;
			egret.Tween.get(n).to({
				y: n.y - 50,
				alpha: 0
			}, 300).call(UIUtils.removeSelf, this, [n])
		}, this)
	}
}

var PlantPhase;
!function(e) {
	e[e.empty = -1] = "empty",
	e[e.seed = 0] = "seed",
	e[e.seeding = 1] = "seeding",
	e[e.growup = 2] = "growup",
	e[e.ripe = 3] = "ripe",
	e[e.die = 4] = "die"
}(PlantPhase || (PlantPhase = {}));

class PlantPhaseName {
	public constructor() {}	
	public static getName (e) {
		var t = "";
		switch (e) {
			case PlantPhase.empty:
				break;
			case PlantPhase.seed:
				t = "种子期";
				break;
			case PlantPhase.seeding:
				t = "发芽期";
				break;
			case PlantPhase.growup:
				t = "生长期";
				break;
			case PlantPhase.ripe:
				t = "成熟期";
				break;
			case PlantPhase.die:
				t = "枯萎"
		}
		return t;
	}
}