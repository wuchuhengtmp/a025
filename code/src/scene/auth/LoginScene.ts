class LoginScene extends SceneBase {
	public constructor() {
		super();
		//this.authLogin();
		this.isAccountListShow = false;
		this.skinName = LoginSceneSkin;
		DataManager.init();
	}

	private formGroup:eui.Group;
	// private groupAppTip:eui.Group;
	private groupAccount:eui.Group;
	private listAccount:eui.List;
	// private btnAppDownload:eui.Button;
	private username:eui.Label;
	private password:eui.Label;
	private remberMobileCheckBox:eui.CheckBox;
	private remberPasswordCheckBox;
	private btnLogin:eui.Button;
	private regBtn:eui.Button;
	private btnForgetPassword:eui.Button;
	private btnDownloadApp:eui.Button;
	private imgSelectArrow:eui.Image;
	private btnAppDownlod:eui.Image;
	private isAccountListShow;
	protected createChildren():void {
		this.authLogin();
		super.createChildren();
		this.imgSelectArrow.rotation = 180;
		this.remberMobileCheckBox.selected = true;
		this.remberPasswordCheckBox.selected = true;
		this.remberPasswordCheckBox.imgTxt.source = "login_txt_remain_pw_png";
		this.remberMobileCheckBox.selected = "false" !=	LocalStorage.get(Const.REMAIN_UN_SEL_KEY);
		this.remberPasswordCheckBox.selected = "false" != LocalStorage.get(Const.REMAIN_PW_SEL_KEY);
		this.initAccount();
		
		// if(egret.Capabilities.runtimeType == egret.RuntimeType.WEB){
		// 	this.btnAppDownload.visible = false;
		// 	this.groupAppTip.visible = false;
		// }else{
		// 	this.btnAppDownload.visible = false;
		// 	this.groupAppTip.visible = false;
		// }

		this.username.addEventListener(egret.Event.FOCUS_IN, this.onInputFocusIn, this);
		this.password.addEventListener(egret.Event.FOCUS_IN, this.onInputFocusIn, this);
		EventManager.instance.addEvent(EventName.ACCOUNT_SELECT, this.onAccountListSelect, this);

		if(!Const.BGSOUND){
			AudioManager.instance.playEffect(AudioTag.BGSOUND, true);
		}
	}

	protected destroy () {
		super.destroy();
		this.username.removeEventListener(egret.Event.FOCUS_IN, this.onInputFocusIn, this),
		this.password.removeEventListener(egret.Event.FOCUS_IN, this.onInputFocusIn, this),
		EventManager.instance.removeEvent(EventName.ACCOUNT_SELECT, this.onAccountListSelect, this)
	}

	protected onAccountListSelect (e) {
		var t = e.data;
		this.username.text = t.id,
		this.password.text = t.pw,
		this.password.displayAsPassword = !0,
		this.password.inputType = egret.TextFieldInputType.PASSWORD,
		this.changeShowAccountList()
	}

	protected onInputFocusIn () {
		this.isAccountListShow && this.changeShowAccountList()
	}

	protected initAccount () {
		this.groupAccount.visible = false;
		var e = LocalStorage.get(Const.REMAIN_UN_KEY) || "";
		var t = LocalStorage.get(Const.REMAIN_PW_KEY) || "";
		var n = e;
		var i = t;
		if (e && 0 == e.indexOf("{")) {
			AccountManager.instance.initAccount(e);
			if (AccountManager.instance.accountArr.length > 0) {
				var a = AccountManager.instance.accountArr[0];
				n = a.id;
				i = a.pw;
			}
		} else{
			AccountManager.instance.updateAccount(n, i);
		}				
		this.username.text = n;
		this.password.text = i;
		this.password.displayAsPassword = true;
		this.password.inputType = egret.TextFieldInputType.PASSWORD;
		this.listAccount.dataProvider = new eui.ArrayCollection(AccountManager.instance.accountArr);
		this.listAccount.itemRenderer = AccountItem;
	}

	protected onTouchTap(evt:egret.Event){
		let target = evt.$target;
		switch(target){
			case this.regBtn:
				SceneManager.instance.runScene(RegScene);
				break;
			case this.btnForgetPassword:
				SceneManager.instance.runScene(ForgetScene);
				break;
			case this.btnLogin:
				this.login();
				break;
			case this.imgSelectArrow:
				this.changeShowAccountList();
				break;
			case this.btnAppDownlod:
				HttpClient.instance.openUrl("APP_DOWNLOAD",true);
				break;
			case this.btnDownloadApp:
				HttpClient.instance.openUrl("APP_DOWNLOAD",true);
				break;
		}
	}

	private changeShowAccountList () {
		this.isAccountListShow = !this.isAccountListShow;
		var e = this.isAccountListShow ? 0 : 180;
		egret.Tween.get(this.imgSelectArrow).to({
			rotation: e
		}, 200)
		this.groupAccount.visible = this.isAccountListShow
	}

	private saveAccount (e, t) {
		if(this.remberMobileCheckBox.selected){
			this.remberPasswordCheckBox.selected || (t = "");
			AccountManager.instance.updateAccount(e, t);
		}else{
			AccountManager.instance.removeAccount(e);
		}
		LocalStorage.set(Const.REMAIN_UN_KEY, AccountManager.instance.saveToString());
		LocalStorage.set(Const.REMAIN_UN_SEL_KEY, this.remberMobileCheckBox.selected ? "true" : "false");
		LocalStorage.set(Const.REMAIN_PW_SEL_KEY, this.remberPasswordCheckBox.selected ? "true" : "false");
	}

	private authLogin(){
		var p=egret.getOption("pn");
		Const.ReferUrl= document.referrer;
		if(!Util.isEmpty(p)){
			HttpClient.instance.post('API_URL', {
			c: "auth",
			a: "loginPlugin",
			username: p
		}).then((response:any)=>{
			// 存储登陆信息	
			LocalStorage.set("userInfo", response.data.userInfo);

			// 初始化信息
			Player.instance.hasGift = response.data.gift_package;
			Player.instance.needSign =response.data.need_sign;
			Player.instance.hasIndemnify = response.data.indemnify;
			Player.instance.hasNewGift = response.data.new_package;
			Player.instance.userId = response.data.userInfo.uid;
			
			this.enterGame(response.data.frist == 1);
		})
		}
	}

	private login(){
		let messageY = 300;

		if(!Util.isMobile(this.username.text)){
			Util.message.show("请输入正确11位手机号！", null, messageY);
			return;
		}
		if(Util.isEmpty(this.password.text.length)){
			Util.message.show("请输入密码！", null, messageY);
			return;
		}
		this.btnLogin.enabled = false;
		egret.Tween.get(this.btnLogin).wait(1000).call(()=>{
			this.btnLogin.enabled = true;
		})
		HttpClient.instance.post('API_URL', {
			c: "auth",
			a: "login",
			username: this.username.text,
			password: this.password.text
		}).then((response:any)=>{
			Util.message.show(response.msg, null, messageY);
			// 存储登陆信息	
			LocalStorage.set("userInfo", response.data.userInfo);

			// 初始化信息
			Player.instance.hasGift = response.data.gift_package;
			Player.instance.needSign =response.data.need_sign;
			Player.instance.hasIndemnify = response.data.indemnify;
			Player.instance.hasNewGift = response.data.new_package;
			Player.instance.userId = response.data.userInfo.uid;
			
			this.enterGame(response.data.frist == 1);
			this.saveAccount(this.username.text, this.password.text);
		}, (reponse)=>{
			this.btnLogin.enabled = true;
			Util.message.show(reponse.msg, null, messageY);
		})
	}

	private enterGame (frist) {
		if(frist){
			SceneManager.instance.runScene(CreateRoleScene);
		}else{
			HttpClient.instance.post("API_URL", {c: 'home', a: 'index'}).then((response:any)=>{
				// 初始化数据
				Player.instance.serverInit(response.data.user);
				LandDataManager.instance.serverInit(response.data.farm);
				GodDataManager.instance.serverInit(response.data.joss);
				WareHouseDataManager.instance.serverInit(response.data.tool);
				SceneManager.instance.runScene(GameScene);
			}, (response:any)=>{
				Util.message.show(response.msg);
			});
		}
	}

	// private tipAppDownload () {
	// 	var e = this.groupAppTip;
	// 	if (this.btnAppDownload.visible) {
	// 		var t = Util.int(LocalStorage.get("app_download_tip_count") || "0") || 0;
	// 		if(t < 5){
	// 			t++;
	// 			LocalStorage.set("app_download_tip_count", "" + t);
	// 			e.visible = !0;
	// 			e.scaleX = e.scaleY = 0;
	// 			egret.Tween.get(e).wait(800).to({
	// 				scaleX: 1,
	// 				scaleY: 1
	// 			}, 300, egret.Ease.backOut).wait(2e3).to({
	// 				scaleX: 0,
	// 				scaleY: 0
	// 			}, 300).set({
	// 				visible: !1
	// 			})
	// 		}else{
	// 			e.visible = !1
	// 		}
	// 	} else {
	// 		e.visible = !1
	// 	}
	// }
}