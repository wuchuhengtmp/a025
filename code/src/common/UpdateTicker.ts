class UpdateTicker {
	private allUpdateObjArr:any;
	public constructor() {
		this.allUpdateObjArr = []
	}

	private static _instance:UpdateTicker = null;
	public static get instance():UpdateTicker{
		if(!this._instance) {
			this._instance = new UpdateTicker();
		}
		return this._instance;
	}

	private static _onesec:any;
	public get onesec(){
		return UpdateTicker._onesec || (UpdateTicker._onesec = new UpdateTicker), UpdateTicker._onesec
	}

	public add (e) {
		Util.isElinArr(e, this.allUpdateObjArr) || this.allUpdateObjArr.push(e)
	}

	public remove (e) {
		for (var t = this.allUpdateObjArr.length, n = 0; t > n; n++){
			e == this.allUpdateObjArr[n] && this.allUpdateObjArr.splice(n, 1)
		}
	}

	public update (e) {
		for (var t = 0; t < this.allUpdateObjArr.length; t++){
			this.allUpdateObjArr[t].update(e)
		}
	}
}