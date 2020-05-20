class  LocalStorage {
	public constructor() {
	}

	public static set (key:string, data?:any):any{
		return egret.localStorage.setItem(key, JSON.stringify(data));
	}

	public static get (key):any {
		if(egret.localStorage.getItem(key)){
			try{
				return JSON.parse(egret.localStorage.getItem(key));
			}catch(e){
				egret.warn(e);
				this.remove(key);
				return '';
			}
		}else{
			return false
		}
	}
	public static remove (key):any {
		return egret.localStorage.removeItem(key);
	}
}