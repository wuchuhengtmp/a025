class FriendItemRender extends ItemRendererBase {
	public constructor() {
		super();
		this.skinName = new FriendItemRenderSkin;
	}

	private uvo;
	private labelName;
	private labelLv;
	private labelMoney;
	private btnHome;
	private opGroup:eui.Group;
	private btnReject;
	private btnAdd;
	private messageY = 200;
	protected createChildren():void {
		super.createChildren();
	}

	public dataChanged () {
		if(this.data){
			var data = this.data;
			this.uvo = data;
			this.labelName.text = data.userName.length > 7 ? data.userName.substr(0, 7) + "..." : data.userName;
			this.labelLv.text = data.grade + "";
			this.labelMoney.text = data.diamonds || 0;
			if(data.status == 0){
				this.opGroup.visible = true;
				this.btnHome.visible = false;
			}else{
				this.opGroup.visible = false;
				this.btnHome.visible = true;
			}
		}
	}

	public onTouchTap (e) {
		var taeget = e.target;
		switch(taeget){
			case this.btnHome:
				this.goOtherFarm();
				break;
			case this.btnAdd:
				this.add();
				break;
			case this.btnReject:
				this.reject();
				break;
		}
	}

	private goOtherFarm () {
		if(this.uvo){
			if(this.uvo.uid == Player.instance.uid){
				Util.message.show("这是你的农场，不用去啦！")
			}else{
				this.btnHome.enabled = false;
				OtherPlayer.instance.enterOtherFarm(this.uvo.uid, ()=>{
					this.btnHome.enabled = true;
				})
			}
		}else{
			Util.message.show("请确认农场目标")
		}
	}

	private add(){
		HttpClient.instance.post('API_URL', {c: 'player', a: 'saveHail', id: this.uvo.id, type: 'add'}).then((response:any)=>{
			Util.message.show(response.msg);
			this.opGroup.visible = false;
			this.btnHome.visible = true;
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	private reject(){
		HttpClient.instance.post('API_URL', {c: 'player', a: 'saveHail', id: this.uvo.id, type: 'reject'}).then((response:any)=>{
			Util.message.show(response.msg, ()=>{
				UIUtils.removeSelf(this);
			});
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}
}