class PetDataManager {
	public petData;
	public curId;
	public foodData;
	public constructor() {
		if (PetDataManager._instance){
			throw new Error("LogDataManager使用单例")
		}
	}

	private static _instance:PetDataManager = null;
	public static get instance():PetDataManager{
		if(!this._instance) {
			this._instance = new PetDataManager();
		}
		return this._instance;
	}

	public serverInit (e) {
		this.petData = [];
		if (e){
			for (var t = 0; t < e.length; t++){
				this.petData.push(new PetVo(e[t]))
			}
		}				
	}

	public hasPet () {
		return !!this.petData && this.petData.length > 0
	}

	public setCurrent (e) {
		e && (this.curId = e)
	}

	public setFeed (e) {
		if (e) {
			this.foodData = [];
			for (var t = 0; t < e.length; t++) {
				var n = e[t];
				var i = n.foodType;
				var a = n.foodId;
				var s = WareHouseDataManager.instance.getGoodsVo(i, a) || GoodsVo.newFromTypeAndId(i, a);
				this.foodData.push(s);
			}
		}
	}

	public updateData (e) {
		for (var t = 0; t < this.petData.length; t++){
			if (this.petData[t].id == e.id) {
				this.petData[t] = new PetVo(e);
				break
			}
		}
	}

	public get curPet(){
		if (!this.curId){
			return null;
		}
		for (var e = 0; e < this.petData.length; e++){
			if (this.petData[e].id == this.curId){
				return this.petData[e];
			}
		}	
		return null
	}

	public updateCurrent (e) {
		var t = this.curPet;
		t && e && (e.id && e.id != t.id || (null != e.hp && (t.hp = e.hp), EventManager.instance.dispatch(EventName.DOG_UPDATE, t)))
	}
}

class PetVo {
	public id;
	public typeId;
	public name;
	public lv;
	public exp;
	public expMax;
	public hp;
	public hpMax;
	public luckyMax;
	public speedMin;
	public speedMax;
	public apMin;
	public apMax;
	public dpMin;
	public dpMax;
	public isMaxLv;
	public canRename;
	public featureWord;
	public score;
	public constructor(data) {
		this.id = data.id;
		// TODO 狗的类型 未知
		this.typeId = data.typeId || 1;
		this.name = data.dogName;
		this.lv = data.dogLevel;
		this.exp = data.experience;
		this.expMax = data.experienceUlimit;
		this.hp = data.power;
		this.hpMax = data.powerUlimit;
		this.luckyMax = data.otherInfo.lucky;
		this.speedMin = data.otherInfo.speed.min;
		this.speedMax = data.otherInfo.speed.max;
		this.apMin = data.otherInfo.attack.min;
		this.apMax = data.otherInfo.attack.max;
		this.dpMin = data.otherInfo.defense.min;
		this.dpMax = data.otherInfo.defense.max;
		this.isMaxLv = data.isMaxLv;
		// TODO 狗狗重命名 暂未开启
		// this.canRename = data.canRename;
		this.canRename = false;
		// TODO 未使用的属性
		this.featureWord = data.featureWord;
		this.score = data.score;
	}
}