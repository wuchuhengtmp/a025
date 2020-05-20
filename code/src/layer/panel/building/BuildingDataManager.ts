class BuildingDataManager {
	public constructor() {
		if (BuildingDataManager._instance){
			throw new Error("BuildingDataManager使用单例")
		}
	}

	private static _instance:BuildingDataManager = null;
	public static get instance():BuildingDataManager{
		if(!this._instance) {
			this._instance = new BuildingDataManager();
		}
		return this._instance;
	}
	public levelUpCostData;
	public serverInit (e) {
		this.levelUpCostData = [];
		for (var t = 0; t < e.length; t++) {
			var n = new CostVo(e[t]);
			this.levelUpCostData.push(n)
		}
	}
}