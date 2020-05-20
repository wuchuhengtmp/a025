class GodDataManager {
	public godData;
	public constructor() {
		this.godData = new HashMap
		if (GodDataManager._instance) throw new Error("GodDataManager使用单例")
	}

	private static _instance:GodDataManager = null;
	public static get instance():GodDataManager{
		if(!this._instance) {
			this._instance = new GodDataManager();
		}
		return this._instance;
	}

	public serverInit (e) {
		this.godData = new HashMap;
		for (var t in e){
			this.godData.put(t, new GodVo(t, e[t]))
		}			
	}

	public activeGod (e, t) {
		var n = this.godData.get(e, new GodVo(e, null));
		n.isActive ? n.endTime += t : n.endTime = DateTimer.instance.now + t;
		EventManager.instance.dispatch(EventName.GOD_ACTIVE, e)
	}
}

class GodVo {
	private endTime;
	private godId;
	private name;
	private desc;
	public constructor(e, t) {
		this.endTime = 0;
		this.godId = e;
		t && (this.name = t.name, this.desc = t.depict, this.endTime = 1e3 * t.vaidtime);
	}
	
	public get isActive(){
		var e = this.endTime * 1  - DateTimer.instance.now;
		return e > 0 ? true : false
	}
}