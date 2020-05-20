class EditScene extends SceneBase {
	public constructor() {
		super();
		this.skinName = EditSceneSkin;
	}

	protected partAdded(partName:string,instance:any):void {
		super.partAdded(partName,instance);
	}

	private messageY:number = 100;
	private formGroup:eui.Group;
	private verifyImg:eui.Image;
	private verifyImgTime:number;
	private ssid;

	private username:eui.TextInput;
	private realname:eui.TextInput;
	private password:eui.TextInput;
	private rePassword:eui.TextInput;
	private verifyCode:eui.TextInput;
	private smsCode:eui.TextInput;

	private backBtn:eui.Button;
	private submitBtn:eui.TextInput;
	private IsChangePwd:boolean;
	protected createChildren():void {
		super.createChildren();
		this.updateVerifyImg();
		this.realname.text=Player.instance.name;
		this.username.text=Player.instance.mobile;
		this.username.enabled=false;
		this.formGroup.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onClick, this);
	}

	private onClick(evt:egret.Event){
		let target = evt.$target;
		switch(target){
			case this.backBtn:
				SceneManager.instance.runScene(GameScene);
				break;
			case this.submitBtn:
				this.submit();
				break;
			case this.verifyImg:
				this.updateVerifyImg();
				break;
		}
	}

	private submit(){
		if(!this.checkForm()){
			return;
		}
		HttpClient.instance.post('API_URL', {
			'c':'auth',
			'a':'edit',
			'uid':Player.instance.userId,
			'username':this.username.text,
			'nickname': this.realname.text,
			'password': this.password.text,
			'rePassword': this.rePassword.text,
			'verifyCode': this.verifyCode.text,
			'ssid': this.ssid,
		}).then((response:any)=>{
			Util.message.show(response.msg, null, this.messageY);
			LocalStorage.remove("userInfo");
			SceneManager.instance.runScene(LoginScene);
		}, (response:any)=>{
			Util.message.show(response.msg, null, this.messageY);
		});
	}

	private checkForm(type?:string):boolean{
		this.IsChangePwd=false;
		if(Util.isEmpty(this.realname.text)){
			Util.message.show("请输入游戏昵称！", null, this.messageY);
			return false;
		}
		if(!Util.isEmpty(this.rePassword.text)&&this.password.text !== this.rePassword.text){
			Util.message.show("两次输入的密码不一致，请核对密码！", null, this.messageY);
			return false;
		}
		else{
			this.IsChangePwd=true;
		}
		if(Util.isEmpty(this.verifyCode.text)){
			Util.message.show("请输入图片验证码！", null, this.messageY);
			return false;
		}
		return true;
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