class TransferPanel extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0;
		this.isVisibleAnimate = !0;
		this.skinName = new TransferSkin;
	}
	private findUserVo;
	private btnSearch:eui.Button;
	private btnEnter:eui.Button;
	private inpID:eui.TextInput;
	private labelName:eui.Label;
	private labelLv:eui.Label;
	private labelMoney:eui.Label;
	private tfee:number;
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
			case this.btnEnter:
				this.goOtherFarm();
				break;
		}
	}

	private goOtherFarm () {
		if(this.findUserVo){
			if(this.findUserVo.uid == Player.instance.uid){
				Util.message.show("不能转账给自己");
			}else{
				var min=1;//最少转账金额
				var max=10000000000;
				TransferAlert.instance.show(min, max, (n)=>{
					var id=LocalStorage.get("farm.transferid") || "diamonds";
					var name=LocalStorage.get("farm.transfername") || "金币";

					var a = n;
					var maxpronum=0;
					if(id=="diamonds"){
						maxpronum=Player.instance.diamond;
						var fee=this.tfee/100.0; //手续费百分比
						a=n-n*fee;
					}
					else{
						maxpronum=WareHouseDataManager.instance.getPropNum(id);
					}

					if(n>maxpronum)
					{
						return "您最多可以转账"+maxpronum+"个"+name;
					}
					return "向" + this.findUserVo.name + "转账" + n +name+ ",实际到账"+a+name;
					
				}, (t)=>{
					var id=LocalStorage.get("farm.transferid") || "";
					var name=LocalStorage.get("farm.transfername") || "";
					this.tranferTool(t,id,name);
				});
			}
		}else{
			Util.message.show("请确认转账目标");
		}
	}

	private tranferTool(t,id,name)
	{
		Util.message.show(id+","+name);
		if(t>0&&this.findUserVo.uid)
		{
			var maxcount=0;
			if (id == "diamonds") {
				maxcount = Player.instance.diamond;
			}
			else {
				maxcount = WareHouseDataManager.instance.getPropNum(id);
			}
			if(t>maxcount)
			{
				Util.message.show("您的"+name+"数量不足，请修改转账数量");
			}
			else{
				HttpClient.instance.post("API_URL",{c:'user',a:'transfer',uid:this.findUserVo.uid,num:t,transferid:id}).then((response:any)=>{
					AudioManager.instance.playEffect(AudioTag.SUCCESS)
					Util.message.show(response.msg);
					Player.instance.diamond = Math.floor(response.data.diamonds);
					//更新仓库信息
					WareHouseNet.instance.list((responseA: any) => {
						if (responseA.code == 0) {
							EventManager.instance.dispatch(EventName.WAREHOUSE_LIST_CHANGE);
						}
					})
				},(response:any)=>{
					AudioManager.instance.playEffect(AudioTag.FAIL)
					Util.message.show(response.msg);
				});
			}
		}
	}

	private searchUser () {
		//var uid = Util.int(this.inpID.text);
		var uid = this.inpID.text;
		if(uid){
			this.findUserVo = null;
			HttpClient.instance.post("API_URL", {c: 'user', a: 'findUser', uid: uid}).then((response:any)=>{
				var data = response.data;
				this.tfee=parseFloat(data.fee);
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
			Util.message.show("请输入正确的ID或者手机号")
		}
	}
}