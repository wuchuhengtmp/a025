class FriendAddPanel extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0;
		this.isVisibleAnimate = !0;
		this.skinName = new FriendAddPanelSkin;
	}
	private findUserVo;
	private btnSearch:eui.Button;
	private btnAdd:eui.Button;
	private btnEnter:eui.Button;
	private inpID:eui.TextInput;
	private labelName:eui.Label;
	private labelLv:eui.Label;
	private labelMoney:eui.Label;
	protected createChildren():void {
		super.createChildren();
		this.labelName.text = "";
		this.labelLv.text = "";
		this.labelMoney.text = "";
	}

	protected onTouchTap(evt:egret.Event){
		super.onTouchTap(evt);
		var name = evt.target;
		switch (name) {
			case this.btnSearch:
				this.searchUser();
				break;
			case this.btnAdd:
				this.addPlayer();
				break;
			case this.btnEnter:
				this.goOtherFarm();
				break;
		}
	}

	private goOtherFarm () {
		if(this.findUserVo){
			if(this.findUserVo.uid == Player.instance.uid){
				Util.message.show("这是你的农场，不用去啦！")
			}else{
				this.btnAdd.enabled = false;
				OtherPlayer.instance.enterOtherFarm(this.findUserVo.uid, ()=>{
					this.btnAdd.enabled = !0
				})
			}
		}else{
			Util.message.show("请确认农场目标")
		}
	}

	private searchUser () {
		var uid = Util.int(this.inpID.text);
		if(uid){
			this.findUserVo = null;
			HttpClient.instance.post("API_URL", {c: 'player', a: 'findPlayer', uid: uid}).then((response:any)=>{
				var data = response.data;
				if(data){
					this.findUserVo = new UserVo(data);
					this.findUserVo.uid_long = uid
				}
				if(this.findUserVo){
					this.labelName.text = this.findUserVo.name;
					this.labelLv.text = this.findUserVo.lv + "";
					this.labelMoney.text = this.findUserVo.diamond + "";
				}else{
					this.labelName.text = "";
					this.labelLv.text = "";
					this.labelMoney.text = "";
					Util.message.show("查无此人");
				}
			}, (response:any)=>{
				Util.message.show(response.msg);
			})
		}else{
			Util.message.show("请输入正确的ID")
		}
	}
	private addPlayer(){
		if(Util.isEmpty(this.findUserVo) || Util.isEmpty(this.findUserVo.uid)){
			Util.message.show("请输入ID查找玩家");
			return;
		}
		HttpClient.instance.post("API_URL", {c: 'player', a: 'addPlayer', uid: this.findUserVo.uid}).then((response:any)=>{
			Util.message.show(response.msg);
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}
}