class AccountManager {
	public accountArr;
	public constructor() {
		this.accountArr = [];
		if(AccountManager._instance){
			throw new Error("AccountManager使用单例");
		}
	}

	private static _instance:AccountManager = null;
	public static get instance():AccountManager{
		if(!this._instance) {
			this._instance = new AccountManager();
		}
		return this._instance;
	}

	public initAccount (e) {
		var t = JSON.parse(e);
		this.accountArr = t.account;
		for (var n = this.accountArr.length - 1; n >= 0; n--){
			this.accountArr[n].id || this.accountArr.splice(n, 1);
		}
		this.accountArr.sort(function(e, t) {
			return t.updateTime - e.updateTime
		})
	}

	public updateAccount (e, t) {
		if (e) {
			var i = this.accountArr;
			for (let n = 0; n < i.length; n++) {
				var a = i[n];
				if (a.id == e){
					return a.pw = t, void (a.updateTime = DateTimer.instance.now);
				}
			}
			this.accountArr.push(new AccountVo(e,t))
		}
	}

	public removeAccount (e) {
		for (var t = 0; t < this.accountArr.length; t++){
			if (this.accountArr[t].id == e){
				return void this.accountArr.splice(t, 1);
			}
		}
	}

	public saveToString () {
		this.accountArr.sort(function(e, t) {
			return t.updateTime - e.updateTime
		});
		this.accountArr.length > 3 && (this.accountArr.length = 3);
		return JSON.stringify({
			v: 2,
			account: this.accountArr
		})
	}
}

class AccountVo{
	public id;
	public pw;
	public updateTime;
	public constructor(e, t){
		this.id = e,
		this.pw = t,
		this.updateTime = DateTimer.instance.now
	}
}