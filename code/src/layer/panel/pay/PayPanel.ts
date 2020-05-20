class PayPanel extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new PayPanelSkin
	}

	private btnPay:eui.Button;
	//private labelMoney:eui.Label;
	
	private groupPayItem1:eui.Group;
	private groupPayItem2:eui.Group;
	private groupPayItem3:eui.Group;
	
	private groupGift1:eui.Group;
	private groupGift2:eui.Group;
	private groupGift3:eui.Group;
	private labelGift1:eui.Label;
	private labelGift2:eui.Label;
	private labelGift3:eui.Label;

	private labelRen1:eui.Label;
	private labelRen2:eui.Label;
	private labelRen3:eui.Label;
	private labelZhuan1:eui.BitmapLabel;
	private labelZhuan2:eui.BitmapLabel;
	private labelZhuan3:eui.BitmapLabel;

	private payData:any;
	private messageY = 300;
	protected createChildren():void {
		super.createChildren();
		this.groupPayItem1.touchChildren = false;
		this.groupPayItem2.touchChildren = false;
		this.groupPayItem3.touchChildren = false;
		this.groupPayItem1.touchEnabled = true;
		this.groupPayItem2.touchEnabled = true;
		this.groupPayItem3.touchEnabled = true;

		for (var n = 1; 3 >= n; n++){
			this["groupGift" + n].visible = !1;
		}
		//this.labelMoney.text = "读取中……";
		HttpClient.instance.post("API_URL", {c: 'recharge', a: 'getInfo'}).then((response:any)=>{
			var n = response.data.goods;
			//this.asyncMoney(response.data.coing);
			this.payData = n;
			var month=[1,3,6];
			var my=[15,40,80];
			for (let i = 0; i < n.length; i++) {
				let labelZhuan = this["labelZhuan" + (i + 1)];
				let labelRen = this["labelRen" + (i + 1)];
				// labelZhuan.text = n[i].diamonds + "元";
				// labelRen.text = n[i].money + "个月";
				labelZhuan.text=my[i]+"元";
				labelRen.text=month[i]+"个月";
				if(n[i].give){
					this["groupGift" + (i + 1)].visible = !0;
					this["labelGift" + (i + 1)].text = "" + n[i].give + "金币"
				}
			}
		}, (response:any)=>{
			Util.message.show(response.msg, null, this.messageY);
		});
	}

	public onTouchTap (evt:egret.Event) {
		super.onTouchTap(evt);
		switch (evt.target) {
			case this.groupPayItem1:
				this.pay(0);
				break;
			case this.groupPayItem2:
				this.pay(1);
				break;
			case this.groupPayItem3:
				this.pay(2);
				break;
			case this.btnPay:
				HttpClient.instance.openUrl("PAY_URL");
		}
	}

	private pay(item){

		if(1==1)
		{
			Util.message.show("充值时长暂未开放，如有疑问请联系客服！");
			return;
		}
		var t = this;
		AudioManager.instance.playEffect(AudioTag.BUTTON);
		if(!this.payData[item]){
			Util.message.show("充值失败，请联系客服！");
			return;
		}
		Util.alert.show("确定充值" + t.payData[item].diamonds + "金币吗？", '金币只能在游戏内使用', ()=>{
			HttpClient.instance.post("API_URL", {c: "recharge", a: "payDiamonds", id: t.payData[item].id}).then((response:any)=>{
				AudioManager.instance.playEffect(AudioTag.SUCCESS)
				Util.message.show(response.msg);
				Player.instance.diamond  = response.data.diamonds * 1;
				//t.labelMoney.text = "账户余额：" + response.data.coing + "金币";
				EventManager.instance.dispatch(EventName.USER_DIAMOND_CHANGE);
			}, (response:any)=>{
				AudioManager.instance.playEffect(AudioTag.FAIL)
				Util.message.show(response.msg);
			})
		}, true);
	}

	private asyncMoney (coing) {
		Player.instance.money = coing;
		var e = Player.instance.money || 0;
		//this.labelMoney.text = "账户余额：" + e + "金币"
	}
}