class EventManager extends egret.EventDispatcher implements egret.EventDispatcher{

	private autoReleaseArr:any;
	public constructor() {
		super();
		if(EventManager._instance){
			throw new Error("EventManager使用单例 ");
		}
		this.autoReleaseArr = [];
		this.init();
	}
	private static _instance:EventManager = null;
	public static get instance():EventManager{
		if(!this._instance) {
			this._instance = new EventManager();
		}
		return this._instance;
	}
	public init () {
		var timer = new egret.Timer(2e3);
		timer.addEventListener(egret.TimerEvent.TIMER, this.autoReleaseTick, this);
		timer.start();
	}
	private autoReleaseTick () {
		for (var e = this.autoReleaseArr.length - 1; e >= 0; e--) {
			var t = this.autoReleaseArr[e];
			t.thisObj.stage || (this.removeEvent(t.type, t.callback, t.thisObj), this.autoReleaseArr.splice(e, 1))
		}
	}

	public addEvent (type, callback, thisObj, i?) {
		void 0 === i && (i = false);
		this.addEventListener(type, callback, thisObj);
		i && thisObj instanceof egret.DisplayObject && this.autoReleaseArr.push(new EventAutoRelease(type, callback, thisObj))
	}

	public removeEvent (type, callback, thisObj) {
		this.removeEventListener(type, callback, thisObj)
	}

	public dispatch (e, t?) {
		void 0 === t && (t = null), this.dispatchEventWith(e, !1, t)
	}
}

class EventAutoRelease {
	private type:any;
	private callback:any;
	private thisObj:any;
	public constructor(type, callback, thisObj) {
		this.type = type, this.callback = callback, this.thisObj = thisObj;
	}
}

class EventName {
	public constructor() {
	}
	public static PLANT_REFRESH = "plant_refresh";
	public static LAND_REFRESH = "land_refresh";
	public static PLANT_REAP = "plant_reap";
	public static LAND_OPT_TIP = "land_opt_tip";
	public static USER_DIAMOND_CHANGE = "user_diamond_change";
	public static USER_RES_CHANGE = "user_res_change";
	public static WAREHOUSE_LIST_CHANGE = "warehouse_list_change";
	public static USER_HOUSE_CHANGE = "user_house_change";
	public static USER_SKIN_CHANGE = "user_skin_change";
	public static PETLIST_GETINFO = "petlist_update";
	public static PETFOOD_UPDATE = "petfood_update";
	public static COOLMENU_HIDE = "coolmenu_hide";
	public static GOD_ACTIVE = "god_active";
	public static DOG_UPDATE = "dog_update";
	public static NEW_DOG_HOUSE = "new_dog_house";
	public static ROSE_HEART_USE = "rose_heart_use";
	public static SHOP_QUERY_LIMIT = "shop_query_limit";
	public static WEBVIEW_LOADING_OVER = "webview_loading_over";
	public static WEBVIEW_CLOSE = "webview_close";
	public static ACCOUNT_SELECT = "account_select";
	public static BLACK_SHOP_DATA_UPDATE = "black_shop_data_update";
	public static WORK_SHOP_DATA_UPDATE = "work_shop_data_update"
}