class LogDataManager {
	public logPageMax;
	public constructor() {
		if (LogDataManager._instance){
			throw new Error("LogDataManager使用单例")
		}
	}

	private static _instance:LogDataManager = null;
	public static get instance():LogDataManager{
		if(!this._instance) {
			this._instance = new LogDataManager();
		}
		return this._instance;
	}
	public logData;
	public serverInit (e) {
		this.logData = [];
		if (e){
			for (var t = 0; t < e.length; t++){
				this.logData.push(new LogVo(e[t]))
			}
		}
	}
}

class LogVo{
	public time;
	public desc;
	public constructor(e) {
		this.time = e.time;
		this.desc = e.msg;
	}
}