class ForgetScene extends SceneBase {
	public constructor() {
		super();
		this.skinName = ForgetSceneSkin;
	}

	private messageY:number = 100;
	private formGroup:eui.Group;
	private verifyImg:eui.Image;
	private verifyImgTime:number;
	private ssid;

	private username:eui.TextInput;
	private password:eui.TextInput;
	private rePassword:eui.TextInput;
	private verifyCode:eui.TextInput;
	private smsCode:eui.TextInput;

	private getVerifyBtn:eui.Button;
	private backBtn:eui.Button;
	private submitBtn:eui.TextInput;
	protected createChildren():void {
		super.createChildren();
		this.updateVerifyImg();
		this.verifyImg.source = Const.VERIFY_IMG;
		this.formGroup.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this);
	}

	public onTouchTap(evt:egret.Event){
		let target = evt.$target;
		switch(target){
			case this.backBtn:
				SceneManager.instance.runScene(LoginScene);
				break;
			case this.getVerifyBtn:
				this.getVerify();
				break;
			case this.submitBtn:
				this.submit();
				break;
			case this.verifyImg:
				this.updateVerifyImg();
				break;
		}
	}

	private getVerify(){
		if(!this.checkForm("sms")){
			return;
		}
		this.getVerifyBtn.enabled = false;
		HttpClient.instance.post('API_URL', {
			'c':'auth',
			'a':'forget',
			'username':this.username.text,
			'password': this.password.text,
			'rePassword': this.rePassword.text,
			'verifyCode': this.verifyCode.text,
			'ssid': this.ssid,
			'type': 'verifycode'
		}).then((response:any)=>{
			this.getVerifyBtn.enabled = true;
			this.updataCountdown();
			Util.message.show(response.msg, null, this.messageY);
		}, (response:any)=>{
			if(response.data){
				this.updataCountdown(response.data);
			}
			this.getVerifyBtn.enabled = true;
			this.updateVerifyImg();
			Util.message.show(response.msg, null, this.messageY);
		});
	}
	/**
	 * 更新获取按钮倒计时
	 * @param time 设置开始时间
	 */
	private updataCountdown(time?:number){
		time ? this.verifyImgTime = time : this.verifyImgTime = 60;
		var timer:egret.Timer = new egret.Timer(1000, this.verifyImgTime);
		this.getVerifyBtn.touchEnabled = false;
		this.getVerifyBtn.label = this.verifyImgTime + '';
		timer.addEventListener(egret.TimerEvent.TIMER, ()=>{
			this.verifyImgTime--;
			this.getVerifyBtn.label = this.verifyImgTime + '';
		}, this);
		timer.addEventListener(egret.TimerEvent.TIMER_COMPLETE,()=>{
			this.verifyImgTime = 60;
			this.getVerifyBtn.touchEnabled = true;
			this.getVerifyBtn.label = "获取";
		}, this);
		timer.start();
	}

	private submit(){
		if(!this.checkForm()){
			return;
		}
		HttpClient.instance.post('API_URL', {
			'c':'auth',
			'a':'forget',
			'username':this.username.text,
			'password': this.password.text,
			'rePassword': this.rePassword.text,
			'verifyCode': this.verifyCode.text,
			'ssid': this.ssid,
			'smsCode': this.smsCode.text
		}).then((response:any)=>{
			Util.message.show(response.msg, null, this.messageY);
			SceneManager.instance.runScene(LoginScene);
		}, (response:any)=>{
			Util.message.show(response.msg, null, this.messageY);
		});
	}

	private checkForm(type?:string):boolean{
		if(!Util.isMobile(this.username.text)){
			Util.message.show("请输入正确的11位手机号！", null, this.messageY);
			return false;
		}
		if(Util.isEmpty(this.password.text)){
			Util.message.show("请输入密码！", null, this.messageY);
			return false;
		}
		if(Util.isEmpty(this.rePassword.text)){
			Util.message.show("请再次输入密码！", null, this.messageY);
			return false;
		}
		if(this.password.text !== this.rePassword.text){
			Util.message.show("两次输入的密码不一致，请核对密码！", null, this.messageY);
			return false;
		}
		if(Util.isEmpty(this.verifyCode.text)){
			Util.message.show("请输入图片验证码！", null, this.messageY);
			return false;
		}
		if(type == "sms"){
			return true;
		}else{
			if(Util.isEmpty(this.smsCode.text)){
				Util.message.show("请输入短信验证码！", null, this.messageY);
				return false;
			}
			return true;
		}
	}

	private updateVerifyImg(){
		HttpClient.instance.post('API_URL', {
			'c':'util',
			'a':'getAppSsid'
		}).then((response:any)=>{
			this.ssid = response.data.ssid;
			this.verifyImg.source = Const.VERIFY_IMG + '&ssid=' + this.ssid;
		}, (response:any)=>{
			Util.message.show('图片验证码获取失败，请稍后重试', null, this.messageY);
		})
	}
	
}