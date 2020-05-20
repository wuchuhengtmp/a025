class WareHouseNet {
	public constructor() {
		if (WareHouseNet._instance) throw new Error("WareHouseNet使用单例")
	}

	private static _instance:WareHouseNet = null;
	public static get instance():WareHouseNet{
		if(!this._instance) {
			this._instance = new WareHouseNet();
		}
		return this._instance;
	}
	public list (func) {
		var param = {
			c: 'user',
			a: 'warehouse'
		};
		HttpClient.instance.post("API_URL", param, true).then((response:any)=>{
			if(response.code == 0){
				WareHouseDataManager.instance.serverInit(response.data);
			}			
			typeof(func) == "function" && func(response);
		})
	}
}