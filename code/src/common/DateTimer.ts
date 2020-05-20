class DateTimer {
	private static _instance:DateTimer = null;
	private _deltaTime;
	private static _last1sTime;
	private static _lastFpsTime
	public constructor() {
		this._deltaTime = 0;
		if (DateTimer._instance) throw new Error("DateTimer使用单例")
	}
	
	public static get instance():DateTimer{
		if(!DateTimer._instance) {
			DateTimer._instance = new DateTimer();
		}
		return DateTimer._instance;
	}

	public updateServerTime(time){
		this._deltaTime = Date.now() - time;
	}

	public get now(){
		return Date.now() - this._deltaTime;
	}

	public run(){
		this.run1sTicker();
		this.runTicker();
	}

	public runSyncTicker() {
        var time = new egret.Timer(15e3);
        time.addEventListener(egret.TimerEvent.TIMER, this.onSyncTimer, this);
		time.start();
    }

	public onSyncTimer(){}

	public run1sTicker(){
		var time = new egret.Timer(1e3);
        time.addEventListener(egret.TimerEvent.TIMER, this.onOneSecondTimer, this);
		time.start();
		DateTimer._last1sTime = egret.getTimer();
	}

	public onOneSecondTimer(){
		var time = egret.getTimer();
        time - DateTimer._last1sTime;
        DateTimer._last1sTime = time
	}

	public runTicker(){
		var time = new egret.Timer(33);
        time.addEventListener(egret.TimerEvent.TIMER, this.onEnterFrameTimer, this);
		time.start();
		DateTimer._lastFpsTime = egret.getTimer();
	}

	public onEnterFrameTimer() {
		var time = egret.getTimer();
		var t = time - DateTimer._lastFpsTime;
		DateTimer._lastFpsTime = time;
		UpdateTicker.instance.update(t);
    }
}