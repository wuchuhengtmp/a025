class HttpClient {
	public constructor() {
		// 此处不能使用单例模式
		// if (HttpClient._instance){
		// 	throw new Error("BuildingDataManager使用单例")
		// }
	}

	private static _instance:HttpClient = null;
	public static get instance():HttpClient{
		this._instance = new HttpClient();
		return this._instance;
	}

	private loader = new egret.URLLoader();
	private request = new egret.URLRequest();

	public get(url:string, param?:any){
		this.loader.dataFormat = egret.URLLoaderDataFormat.VARIABLES;
		
		url = this.getUrl(url);
		url += "?" + this.handleParam(param);
		this.request.url = url;
		this.request.data = {type: 'op'};
		// 追加TOKEN
		this.addToken();
		this.request.method = egret.URLRequestMethod.GET;

		return new Promise((resolve, reject)=>{
			this.loader.addEventListener(egret.Event.COMPLETE, ()=>{
				let reponse = this.handleResponse();
				if(reponse === false){
					return;
				} else if (reponse.code == 0){
					resolve(reponse);
				} else if(reponse.code == 1 || reponse.code == -1){
					reject(reponse);
				}else {
					Util.confirmGotoLogin("网络请求错误");
					Util.message.show(reponse.msg);
					return;
				}
			}, this);
			this.loader.load(this.request);
		});
	}

	public post(url:string, param:Object, all?:boolean){
		this.loader.dataFormat = egret.URLLoaderDataFormat.VARIABLES;
		url = this.getUrl(url);
		this.request.url = url;
		this.request.data = new egret.URLVariables(this.handleParam(param));
		// 追加TOKEN
		this.addToken();		
		this.request.method = egret.URLRequestMethod.POST;

		return new Promise((resolve, reject)=>{
			this.loader.addEventListener(egret.Event.COMPLETE, ()=>{
				let reponse = this.handleResponse();
				if(reponse === false){
					return;
				} else if (reponse.code == 0 || all){
					resolve(reponse);
				} else if(reponse.code == 1 || reponse.code == -1){
					reject(reponse);
				}else {
					Util.message.show(reponse.msg);
					return;
				}
			}, this);
			this.loader.addEventListener(egret.IOErrorEvent.IO_ERROR, this.onPostIOError, this)
			this.loader.load(this.request);
		});
	}

	// 网络请求错误
	private onPostIOError (e) {
		egret.warn("post error : ", e);
		var t = e.currentTarget._status;
		502 == t ? Util.message.show("网络繁忙，请重试") : Util.confirmGotoLogin("网络错误")
	}

	// 处理请求参数
	private handleParam(param:any):string{
		let str = "";
		for(var i in param){
			str += "&" + i + "=" +param[i];
		}
		if(egret.Capabilities.runtimeType == egret.RuntimeType.NATIVE){
			str += "&agent=app";
		}
		return str.replace(/^(\&*)/g, '');
	}

	// 处理返回数据
	private handleResponse():any{
		let reponse = null;
		try{
			reponse = JSON.parse(this.loader.data);
		}catch(e){
			egret.warn(e);
			Util.confirmGotoLogin("网络请求错误");
			return false;
		}
		if(reponse.hasOwnProperty("sysTime")){
			DateTimer.instance.updateServerTime(1e3 * reponse.sysTime);
		}
		if(reponse.code == "403"){
			Util.confirmGotoLogin(reponse.msg);
			return false;
		}else if(reponse.code == "301"){
			Util.alert.show(reponse.msg, '确定要打开吗？', ()=>{
				this.openUrl(reponse.data);
			}, true);
			return false;
		}else{
			return reponse;
		}
	}
	/**
	 * 打开链接
	 * @param type 0：webview打开 1：调用浏览器 尚未完成
	 */
	public openUrl(url:string, blank?:boolean){		
		if(this.getUrl(url) !== false){
			if(egret.Capabilities.runtimeType == egret.RuntimeType.NATIVE){
				// 开发APP使用
				//egret.ExternalInterface.call("openUrlInWebView", this.getUrl(url));
				window.open(this.getUrl(url), '_blank');
			}else{
				if(blank){
					window.open(this.getUrl(url), '_blank');
				}else{
					var iframeDiv = document.getElementById('iframeDiv');
					var iframeWrapper = document.getElementById('iframe_wrapper');
					document.querySelector('#iframeDiv iframe').setAttribute('src',this.getUrl(url));
					iframeDiv.style.display = 'block';
					iframeWrapper.style.top = document.getElementsByClassName('header')[0].clientHeight - 3 +'px';
					iframeWrapper.style.width = iframeDiv.clientWidth -20 +'px';
					document.getElementById('title').style.top = - document.querySelector('.header .front').clientHeight *0.95 + 'px';
					iframeWrapper.style.height = iframeDiv.clientHeight - document.getElementsByClassName('header')[0].clientHeight -document.getElementsByClassName('bottom')[0].clientHeight + 'px';
				}
			}
		}
	}

	public getUrl(url:string){
		if(url.indexOf("http") >= 0){
			return url;
		}else if(url.indexOf("API_URL")>=0){
			return url.replace("API_URL",Const.API_URL);
		}else if(Const.OTHERE_URL[url]){
			return Const.OTHERE_URL[url];
		}else{
			egret.warn("链接不存在");
			return false;
		}
	}

	private addToken():any{
		let userInfo:any = LocalStorage.get("userInfo");
		if(userInfo && userInfo.token){
			let aToken = new egret.URLRequestHeader("TOKEN", userInfo.token);
			this.request.requestHeaders.push(aToken)
			return ['TOKEN', userInfo.token];
		}else{
			return false;
		}
	}

	public getToken():string{
		let token = '';
		let userInfo:any = LocalStorage.get("userInfo");
		if(userInfo && userInfo.token){
			token = userInfo.token;
		}
		return token;
	}

	private getTicket(){
		let userInfo:any = LocalStorage.get("userInfo");
		if(userInfo && userInfo.ticket){
			return userInfo.ticket;
		}else{
			return false;
		}
	}
}