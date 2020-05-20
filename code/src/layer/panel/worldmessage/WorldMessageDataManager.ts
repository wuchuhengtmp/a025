class WorldMessageDataManager {
	public msgPageMax;
	public constructor() {
		if (WorldMessageDataManager._instance){
			throw new Error("WorldMessageDataManager使用单例")
		}
	}

	private static _instance:WorldMessageDataManager = null;
	public static get instance():WorldMessageDataManager{
		if(!this._instance) {
			this._instance = new WorldMessageDataManager();
		}
		return this._instance;
	}
	public msgData;
	public serverInit (e) {
		this.msgData = [];
		if (e){
			for (var t = 0; t < e.length; t++){
				this.msgData.push(new WorldMessageVo(e[t]))
			}
		}
	}
}

class WorldMessageVo{
	public time;
	public desc;
	public type;
	public constructor(e) {
		this.time = e.time;
		this.desc = e.msg;
		this.type=e.type;
	}
}