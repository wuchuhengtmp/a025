class LandDataManager {
	public constructor() {
		this.landData = [];
		this.landUpData = [];
		if(LandDataManager._instance){
			throw new Error("LandDataManager使用单例");
		}
	}

	private static _instance:LandDataManager = null;
	public static get instance():LandDataManager{
		if(!this._instance) {
			this._instance = new LandDataManager();
		}
		return this._instance;
	}
	public landData:any;
	public landUpData:any;
	public serverInit (e) {
		this.landData = [];
		for (let t in e) {
			var n = e[t];
			this.landData.push(new LandVo(t, n))
		}
	}

	public updateLandData (e, t) {
		var n = this.landData[e];
		n && (n.updateData(t), EventManager.instance.dispatch(EventName.PLANT_REFRESH, e))
	}

	public setLandLevelUpData (e) {
		this.landUpData = [];
		for (var t = 2; t <= 4; t++) {
			var n = new GoodsVo(null).setExchangeData(e[t]);
			this.landUpData.push(n)
		}
	}

	public openNewLand () {
		var e = new LandVo(this.landData.length,null);
		this.landData.push(e), EventManager.instance.dispatch(EventName.LAND_REFRESH, e.landId)
	}

	public clearLand (e) {
		var t = this.landData[e];
		t.plantId = 0;
		t.phase = PlantPhase.empty;
	}

	public getLandCountByLv (e, t) {
		void 0 === t && (t = !1);
		for (var n = 0, i = 0; i < this.landData.length; i++) {
			var a = this.landData[i];
			t ? a.landLv >= e && n++ : a.landLv == e && n++
		}
		return n
	}
}

class LandVo {
	private landLv;
	private plantId;
	private phase;
	public landId;
	private plantName;
	private plantAllPhaseTime;
	private plantStartTime;
	private stateBug;
	private stateGrass;
	private stateWater;
	private stateManure;
	public constructor(e, t) {
		this.landLv = 0;
		this.plantId = 0;
		this.phase = -1;
		this.landId = e;
		this.updateData(t);
	}
	public updateData (e) {
		if(e){
			this.landLv = e.j;
			this.plantId = e.a;
			this.plantName = e.n;
			this.phase = e.o;
			if(7 == e.b){
				this.phase = PlantPhase.die;
			}
			if(0 == this.plantId){
				this.phase = PlantPhase.empty;
			}
			this.stateBug = 0 != e.g;
			this.stateGrass = 0 != e.f;
			this.stateWater = 0 == e.h;
			this.stateManure = 1 == e.z;
			this.plantStartTime = 1e3 * e.q;
			this.plantAllPhaseTime = e.y;
		}
	}
	
	public get currPhaseTotalTime () {
		return this.phase < 3 ? 1e3 * this.plantAllPhaseTime[this.phase] : -1
	}
	
	public get currPhaseRunTime () {
		let e = DateTimer.instance.now - this.plantStartTime;
		let t = 0;
		for (let n = 0; n < this.phase; n++){
			t += 1e3 * this.plantAllPhaseTime[n];
		}
		return e - t
	}
	
	public get currPhaseNeedTime () {
		var e = this.currPhaseTotalTime - this.currPhaseRunTime;
		if(e < 0){
			e = 0;
		}
		return e;
	}
}

