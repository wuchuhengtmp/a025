class Const {

	public static get isDebug():boolean{
		if(egret.Capabilities.runtimeType == egret.RuntimeType.WEB){
			if(location.host.indexOf("127.0") >= 0){
				return true;
			}else{
				return false
			}
		}else{
			return false;
		}
	};

	public static refId; // 推荐人ID

	public static stage:egret.Stage;
	
	public static stageW:number = 640;//舞台宽
	
	public static stageH:number = 960;//舞台高

	public static EX_MAX_NUMBER = 999;

	public static LAND_HALF_W = 97;
	
	public static LAND_HALF_H = 47

	public static needGuide:boolean = false;

	public static isGuiding:boolean = false;

	public static headIconPos = new egret.Point(100,80);

	public static clickLandIndex:number;

	public static REMAIN_ANNONCE_NORMAL_ID_KEY = "annonce_normal_id";

	public static AUDIO_SAVE_KEY = "farm.audio";

	public static BGSOUND;

	public static NO_AUDIO_TAG = "noAudio";

	public static REMAIN_UN_KEY = "farm.un";

	public static REMAIN_PW_KEY = "farm.pw";
	
	public static REMAIN_UN_SEL_KEY = "farm.un_select";

	public static REMAIN_PW_SEL_KEY = "farm.pw_select";

	public static API_URL:string = Const.API_HOST + "/game.api"; // 接口地址
	public static ReferUrl:string="";

	// 图片验证码地址
	public static get VERIFY_IMG():string{
		return Const.API_HOST + "/game.api?c=util&a=getVerify&ver=" + DateTimer.instance.now;
	}
	
	public static get API_HOST():string{
		let host = '';
		if(egret.Capabilities.runtimeType == egret.RuntimeType.WEB){
			if(Const.isDebug){
				host = "http://farm.bcnrc.com/wapi";
			}else{
				host = 'http://farm.bcnrc.com';
			}
		}else{
			if(Const.isDebug){
				host = "http://farm.bcnrc.com";
			}else{
				host = "http://farm.bcnrc.com";
			}
		}
		return host;
	}

	public static get OTHERE_URL(){
		return {
			"new_url":			"http://farm.bcnrc.com/index/noticelist", // 公告
			"strategy_url":		"http://farm.bcnrc.com/web/index/gonglue", //攻略
			"userCenter_url":	"http://farm.bcnrc.com/web/index/gonglue", // 用户中心
			"market_url":		"http://farm.bcnrc.com", // 市场 已修改为金币转账
			"PAY_URL":		"http://farm.bcnrc.com", // 充值 已去掉，修改为充值时长
			"PET_INFO":		"http://farm.bcnrc.com/web/index/gonglue", // 宠物介绍
			"APP_DOWNLOAD":		'http://farm.bcnrc.com/lznc.apk', // APP下载
		}
	}
}