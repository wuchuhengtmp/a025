class CreateRoleScene extends SceneBase {
	public constructor() {
		super();
		this.skinName = CreateRoleSceneSkin;
		this.selectIconId = 1
		RES.getResByUrl("resource/config/random_name.json", (data)=>{
			this.randomNameData = data;
			this.randomName()
		}, this)
	}

	private messageY:number = 100;
	private randomNameData:any;
	private selectIconId:number;

	private btnOk:eui.Button;
	private btnRandom:eui.Button;
	private inpName:eui.TextInput;
	protected createChildren():void {
		super.createChildren();
		this.setSelectHeadIcon(Util.rang(1, 6e4) % 6 + 1);
		this.randomName()
		this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this);
	}

	private setSelectHeadIcon (id:number) {
		this.selectIconId = id;
		for (var t = 1; 6 >= t; t++) {
			var n = this["groupHead" + t];
			n.touchChildren = !1;
			n.name = "groupHead" + t;
			var i = n.getChildByName("imgSelect");
			i.visible = id == t
		}
	}

	protected onTouchTap (evt:egret.Event) {
		switch (evt.target) {
			case this.btnOk:
				this.createRole();
				break;
			case this.btnRandom:
				this.randomName()
		}
		var name = evt.target.name;
		if (name.indexOf("groupHead") > -1) {
			var n = Util.int(name.replace("groupHead", ""));
			this.setSelectHeadIcon(n)
		}
	}

	private randomName () {
		if (this.randomNameData) {
			var e = this.randomNameData.name1,
				t = this.randomNameData.name2,
				n = this.randomNameData.name3,
				i = e[Util.rang(0, e.length - 1)],
				a = t[Util.rang(0, t.length - 1)],
				s = Math.random() < .75 ? "" : n[Util.rang(0, n.length - 1)];
			this.inpName.text = i + a + s
		}
	}

	private createRole () {
		var inpName = this.inpName.text;
		if(inpName){
			if(inpName.length > 7){
				Util.message.show("输入的名称太长了");
				return;
			}
			HttpClient.instance.post("API_URL", {
				'c': 'home',
				'a': 'createRole',
				'avatarId': this.selectIconId,
				'nickname': inpName
			}).then((response:any)=>{
				Util.message.show(response.msg, null, this.messageY);
				LocalStorage.remove("needCreate");
				Const.needGuide = true;

				HttpClient.instance.post("API_URL", {c: 'home', a: 'index'}).then((response:any)=>{
					// 初始化数据
					Player.instance.serverInit(response.data.user);
					LandDataManager.instance.serverInit(response.data.farm);
					GodDataManager.instance.serverInit(response.data.joss);
					WareHouseDataManager.instance.serverInit(response.data.tool);
					SceneManager.instance.runScene(GameScene);
				}, (response:any)=>{
					Util.message.show(response.msg);
				})
			}, (response:any)=>{
				Util.message.show(response.msg, null, this.messageY);
			});
		}else{
			Util.message.show("请输入名称");
		}
	}
}