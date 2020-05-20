class Util {
	public static get alert():Alert{
		return Alert.instance;
	}

	public static get message():Message{
		return Message.instance;
	}

	public static confirmGotoLogin(msg:string){
		let sceneName = SceneManager.instance.getCurrentScene().name;
		if(sceneName != 'LoginScene'){
			Util.alert.show(msg + ",请重新登录", null, ()=>{
				GameLayerManager.instance.popLayer.removeChildren();
				SceneManager.instance.runScene(LoginScene);
			},  ()=>{
				GameLayerManager.instance.popLayer.removeChildren();
				SceneManager.instance.runScene(LoginScene);
			});
		}else{
			Util.message.show(msg);
		}
	}
	
	public static isEmpty(str:any){
		if(typeof(str) == "undefined"){
			return true;
		}
		if(typeof(str) == "number" && str != 0 && str != NaN){
			return false;
		}
		if(typeof(str) == "string" && str.length > 0){
			return false;
		}
		if(typeof(str) == "object"){
			for (var key in str) {
				return false;
			}
		}
		if(typeof(str) == "boolean"){
			return str;
		}
		return true;
	}

	// 检查手机号
	public static isMobile(mobile){
		let regMobile = /^1[0-9]{10}$/;
		if(regMobile.test(mobile)){
			return true;
		}else{
			return false;
		}
	}
	
	// 检查邮箱
	public static isEmail(email){
		let regMobile = /\w[-\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\.)+[A-Za-z]{2,14}/;
		if(regMobile.test(email)){
			return true;
		}else{
			return false;
		}
	}
	
	// 检查身份证号码
	public static isIdCard(idCard){
		let regMobile = /\d{15}|\d{17}[0-9Xx]/;
		if(regMobile.test(idCard)){
			return true;
		}else{
			return false;
		}
	}

	// 判断用户权限
	public static checkAuth(){
		let userInfo = LocalStorage.get("userInfo");
		if(userInfo && userInfo.token){
			return userInfo;
		}else{
			return false;
		}
	}

	public static getBigNumberShow(num:number):string {
		return 1e5 > num ? num + "" : (num /= 1e4, num.toFixed(1) + "万");
	}

	public static isNumber(val) {
		var s = val.constructor.toString();
		return s.indexOf("Number") > 0;
	}

	public static isString(val) {
		var s = val.constructor.toString();
		return s.indexOf("String") > 0;
	}

	public static isArray(val) {
		var s = val.constructor.toString();
		return s.indexOf("Array") > 0;
	}

	public static int(val) {
		return parseInt(val);
	}

	public static limit (e,t,n){
		return Math.max(t,Math.min(n,e))
	}

	public static rang (min:number, max:number) {
		return Math.round(Math.random() * (max - min) + min)
	}

	public static showTimeFormat (e) {
		e = Util.int(e / 1e3);
		var t = Util.int(e / 86400);
		e %= 86400;
		var n = Util.int(e / 3600);
		e %= 3600;
		var i = Util.int(e / 60);
		e %= 60;
		var a = Util.int(e);
		return 0 >= t && 0 >= n && 0 >= i ? a + "秒" : 0 >= t && 0 >= n ? i + "分" + (a > 9 ? a : "0" + a) + "秒" : 0 >= t ? n + "时" + (i > 0 ? i : "0" + i) + "分" + (a > 9 ? a : "0" + a) + "秒" : t + "天" + (n > 0 ? n : "0" + n) + "时" + (i > 0 ? i : "0" + i) + "分" + (a > 9 ? a : "0" + a) + "秒"
	}

	public static isElinArr (e, t) {
		return t.indexOf(e) > -1;
	}

	public static ang2rad (e) {
		return e / 180 * Math.PI;
	}

	public static pointRotation (e, t, n) {
		var i = Math.cos(this.ang2rad(n));
		var a = Math.sin(this.ang2rad(n));
		var s = t.x + (e.x - t.x) * i - (e.y - t.y) * a;
		var o = t.y + (e.y - t.y) * i + (e.x - t.x) * a;
		return new egret.Point(s, o);
	}

	public static getQueryString(name) { 
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i"); 
		var r = window.location.search.substr(1).match(reg); 
		if (r != null){
			return r[2];
		}else{
			return null; 
		}
	}

	public static formatDateTime(inputTime) {
		if(inputTime.toString().length == 10){
			inputTime *= 1000;	
		}
		var date = new Date(inputTime);
		var y = date.getFullYear();
		let m:any = date.getMonth() + 1;
		m = m < 10 ? ('0' + m) : m;
		var d:any = date.getDate();
		d = d < 10 ? ('0' + d) : d;
		var h:any = date.getHours();
		h = h < 10 ? ('0' + h) : h;
		var minute:any = date.getMinutes();
		var second:any = date.getSeconds();
		minute = minute < 10 ? ('0' + minute) : minute;
		second = second < 10 ? ('0' + second) : second;
		return y + '-' + m + '-' + d+' '+h+':'+minute+':'+second;
	}; 
}