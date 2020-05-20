class GameScene extends SceneBase {
	public constructor() {
		super();
		this.curDog = null;
		this.dogHouseTip = null;
		this.skinName = new GameSceneSkin
	}

	public imgGround:eui.Image;
	public btnBackHome:eui.Button;
	public btnSteal:eui.Image;
	public groupHouse:eui.Group;
	public groupGod:eui.Group;
	public annonceSys:eui.Group;
	public annonceLabelNormal:eui.Label;
	public btnSign:eui.Button;
	public btnGift:eui.Button;
	public btnNewGift:eui.Button;
	public btnIndemnifyGift:eui.Button;
	public groupDog:eui.Group;
	public imgFenceFront:eui.Image;
	public imgFenceBack:eui.Image;
	public imgHouse:eui.Image;
	public dogHouse:eui.Image;
	public dogHouseTip;
	public curDog;
	public imgGod1:eui.Image;
	public imgGod2:eui.Image;
	public imgGod3:eui.Image;
	public imgGod4:eui.Image;
	public annonceLabelSys:eui.Label;
	public annonceSysContent:eui.Label;
	public sysannonceScroller:eui.Scroller;

	public gameTopLayer:GameTopLayer;
	public mainMenu:MainMenu;
	public gyMenu:GYMenu;
	public gameView:GameView;
	protected createChildren():void {
		super.createChildren();

		this.imgHouse = new eui.Image;
		this.groupHouse.addChild(this.imgHouse);
		UIUtils.addButtonScaleEffects(this.imgHouse, !0);
		this.dogHouse = new eui.Image("doghouse_png");
		this.dogHouse.x =50, this.dogHouse.y = -50;
		UIUtils.addButtonScaleEffects(this.dogHouse, !0);
		this.groupHouse.addChild(this.dogHouse);
		this.dogHouse.visible = false;
		this.groupDog = new eui.Group;
		this.groupDog.x = -50, this.groupDog.bottom = -50;
		this.groupHouse.addChild(this.groupDog)
		this.updateHouse();

		Const.needGuide || this.getDogsInfo();		
		this.initGod();
		this.updateGodAll();
		this.updateGround();

		this.gameView = new GameView(this);
		this.addChild(this.gameView);
		this.gameView.x = 280, this.gameView.y = Const.stageH - 460;
		this.imgFenceFront.touchEnabled = this.imgFenceBack.touchEnabled = false;
		this.addChild(this.imgFenceFront)

		if(!OtherPlayer.instance.opening){
			this.mainMenu = MainMenu.instance;
			this.addChild(this.mainMenu);
			this.gyMenu = GYMenu.instance;
			this.addChild(this.gyMenu);
		}

		this.gameTopLayer = new GameTopLayer, this.addChild(this.gameTopLayer);

		if(OtherPlayer.instance.opening){
			this.btnBackHome.visible = true;
			this.addChild(this.btnBackHome);
			this.btnSteal.visible = true;
			this.annonceSys.visible = this.annonceLabelNormal.visible = false;
			this.btnSign.visible = this.btnGift.visible = this.btnIndemnifyGift.visible = this.btnNewGift.visible = false;
		}else{
			this.btnBackHome.visible = false;
			this.btnSteal.visible = false;
			this.btnSign.visible = Player.instance.needSign;
			this.btnGift.visible = Player.instance.hasGift;
			this.btnIndemnifyGift.visible = Player.instance.hasIndemnify;
			this.btnNewGift.visible = Player.instance.hasNewGift;
			this.btnSign.visible && egret.Tween.get(this.btnSign, {
				loop: !0
			}).to({
				scaleX: 1.2,
				scaleY: 1.2
			}, 600).to({
				scaleX: 1,
				scaleY: 1
			}, 600);
			
			this.btnIndemnifyGift.visible && egret.Tween.get(this.btnIndemnifyGift, {
				loop: !0
			}).to({
				scaleX: 1.2,
				scaleY: 1.2
			}, 600).to({
				scaleX: 1,
				scaleY: 1
			}, 600)
			
			this.btnGift.visible && egret.Tween.get(this.btnGift, {
				loop: !0
			}).to({
				scaleX: 1.2,
				scaleY: 1.2
			}, 600).to({
				scaleX: 1,
				scaleY: 1
			}, 600)
			
			this.btnNewGift.visible && egret.Tween.get(this.btnNewGift, {
				loop: !0
			}).to({
				scaleX: 1.2,
				scaleY: 1.2
			}, 600).to({
				scaleX: 1,
				scaleY: 1
			}, 600)
		}
		this.resizeSmallScreen();
		this.guide();
	}

	private guide () {
		if (Const.needGuide) {
			Const.needGuide = false;
			Const.isGuiding = true;
			var imgGuide = new eui.Image("guide_png");
			egret.setTimeout(()=>{
				this.mainMenu.showGuide(),
				this.gameView.showGuide();
				GameLayerManager.instance.popLayer.addChild(imgGuide);
			}, this, 100);
			imgGuide.bottom = 50;
			imgGuide.top = 163;
			imgGuide.alpha = 0;
			GameLayerManager.instance.popLayer.addChild(imgGuide);
			egret.Tween.get(imgGuide).to({
				alpha: 1
			}, 500);
			imgGuide.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onGuideTouchTap, this)
		}
	}

	private onGuideTouchTap (evt:egret.Event) {
		evt.stopImmediatePropagation(), evt.stopPropagation();
		var target = evt.currentTarget;
		Util.alert.show("确定完成引导吗？", '', ()=>{
			Const.isGuiding = false;
			UIUtils.removeSelf(target);
			target.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.onGuideTouchTap, this);
			egret.setTimeout(()=>{
				this.getDogsInfo();
			}, this, 500);			
		}, true)
	}

	private resizeSmallScreen () {
		if (Const.stageH < 1080) {
			var height = Const.stageH - 1080;
			this.imgGround.bottom = Util.int(this.imgGround.bottom) + height;
			this.groupHouse.bottom = Util.int(this.groupHouse.bottom) + height;
			this.groupGod.bottom = Util.int(this.groupGod.bottom) + height;
			this.imgFenceBack.bottom = Util.int(this.imgFenceBack.bottom) + height;
			this.imgFenceFront.bottom = Util.int(this.imgFenceFront.bottom) + height;
			this.imgFenceFront.left = this.imgFenceFront.right = 0;
			this.gameView.y -= height;
			this.imgGround.top = 0;
		}
	}

	private updateTimer;
	private annonceNormalVer;
	private annonceTimer;
	private annonceNormalBusy;
	private annonceSysBusy;
	private annonceNormalY;
	private annonceSysUrl;
	protected onAdded(){
		super.onAdded();
		UpdateTicker.instance.add(this);
		if(!OtherPlayer.instance.opening){
			EventManager.instance.addEvent(EventName.USER_HOUSE_CHANGE, this.updateHouse, this);
			EventManager.instance.addEvent(EventName.GOD_ACTIVE, this.onGodActive, this);
			EventManager.instance.addEvent(EventName.USER_SKIN_CHANGE, this.updateGround, this);
			EventManager.instance.addEvent(EventName.DOG_UPDATE, this.onUpdateDog, this);
			EventManager.instance.addEvent(EventName.NEW_DOG_HOUSE, this.onNewDogHouse, this);
			if(!this.updateTimer){
				this.updateTimer = new egret.Timer(30e3, Number.MAX_VALUE);
				this.updateTimer.addEventListener(egret.TimerEvent.TIMER, this.onUpdatePlantTimer, this);
			}
			this.updateTimer.reset();
			this.updateTimer.start();
			this.annonceNormalVer = Util.int(egret.localStorage.getItem(Const.REMAIN_ANNONCE_NORMAL_ID_KEY) || "0") || 0;
			if(!this.annonceTimer){
				this.annonceTimer = new egret.Timer(50e3,Number.MAX_VALUE);
				this.annonceTimer.addEventListener(egret.TimerEvent.TIMER, this.onUpdateAnnoncement, this);
			}			
			this.annonceTimer.reset();
			this.annonceTimer.start();
			this.annonceNormalBusy = !1;
			this.annonceSysBusy = !1;
			this.annonceLabelNormal.alpha = 0;
			this.annonceNormalY = this.annonceLabelNormal.y;
			this.annonceSys.visible = !1;
			this.particleFlower = null;
		}
	}

	protected onRemoved(){
		super.onRemoved();
		UpdateTicker.instance.remove(this);
		if(!OtherPlayer.instance.opening){
			EventManager.instance.removeEvent(EventName.USER_HOUSE_CHANGE, this.updateHouse, this);
			EventManager.instance.removeEvent(EventName.GOD_ACTIVE, this.onGodActive, this);
			EventManager.instance.removeEvent(EventName.USER_SKIN_CHANGE, this.updateGround, this);
			EventManager.instance.removeEvent(EventName.DOG_UPDATE, this.onUpdateDog, this);
			EventManager.instance.removeEvent(EventName.NEW_DOG_HOUSE, this.onNewDogHouse, this);
			this.updateTimer && this.updateTimer.stop();
			this.annonceTimer && this.annonceTimer.stop();
		}
	}

	protected onTouchTap (evt:egret.Event) {
		super.onTouchTap(evt);
		switch (evt.target) {
			case this.imgHouse:
				OtherPlayer.instance.opening || UIManager.instance.popPanel(BuildingPanel);
				break;
			case this.btnBackHome:
				OtherPlayer.instance.backHome();
				break;
			case this.btnSteal:
				this.stealFriend();
				break;
			case this.btnSign:
				this.onTouchBtnDailySign();
				break;
			case this.btnGift:
				this.onTouchBtnGift();
				break;
			case this.btnIndemnifyGift:
				this.onTouchBtnIndemnify();
				break;
			case this.btnNewGift:
				this.onTouchBtnNewGift();
				break;
			case this.annonceLabelSys:
				this.annonceSysBusy && this.annonceSysUrl && HttpClient.instance.openUrl(this.annonceSysUrl);
				break;
			case this.groupDog:
				OtherPlayer.instance.opening || (AudioManager.instance.playEffect(AudioTag.PET), UIManager.instance.popPanel(PetInfoPanel));
				break;
			case this.dogHouse:
				OtherPlayer.instance.opening || UIManager.instance.popPanel(PetListPanel);
				break;
		}
	}

	private onTouchBtnGift () {
		//Util.alert.show("确认领取礼包？", "推荐礼包", ()=>{
			this.getGift();
		//}, true)
	}

	private getGift () {
		HttpClient.instance.post("API_URL", {c: 'home', a: 'packageInfo', types: 'reg'}).then((response:any)=>{
			var userInfo = response.data;
			if(userInfo){
				Player.instance.wood = userInfo.wood;
				Player.instance.stone = userInfo.stone;
				Player.instance.steel = userInfo.steel;
				EventManager.instance.dispatch(EventName.USER_RES_CHANGE);
				Player.instance.diamond = userInfo.diamond;
			}
			this.btnGift.visible = false;
			Player.instance.hasGift = false;
			Util.message.show(response.msg);
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	private getIndemnifyGift () {
		HttpClient.instance.post("API_URL", {c: 'home', a: 'packageInfo', types: 'give'}).then((response:any)=>{
			var userInfo = response.data;
			if(userInfo){
				Player.instance.wood = userInfo.wood;
				Player.instance.stone = userInfo.stone;
				Player.instance.steel = userInfo.steel;
				EventManager.instance.dispatch(EventName.USER_RES_CHANGE);
				Player.instance.diamond = userInfo.diamond;
			}
			this.btnIndemnifyGift.visible = false;
			Player.instance.hasIndemnify = false;
			Util.message.show(response.msg);
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	private onTouchBtnIndemnify () {
		Util.alert.show("更新礼包", "点击确定领取更新礼包", ()=>{
			this.getIndemnifyGift()
		}, true)
	}
	
	private onTouchBtnNewGift () {
		HttpClient.instance.post("API_URL", {c: 'home', a: 'packageInfo', types: 'newGiftPack'}).then((response:any)=>{
			var userInfo = response.data;
			if(userInfo){
				Player.instance.wood = userInfo.wood;
				Player.instance.stone = userInfo.stone;
				Player.instance.steel = userInfo.steel;
				EventManager.instance.dispatch(EventName.USER_RES_CHANGE);
				Player.instance.diamond = userInfo.diamond;
			}
			this.btnNewGift.visible = false;
			Player.instance.hasNewGift = false;
			Util.message.show(response.msg);
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	private onTouchBtnDailySign () {
		HttpClient.instance.post("API_URL", {c: 'sign', a: 'sign'}).then((response:any)=>{
			var userInfo = response.data.userInfo;
			if(userInfo){
				Player.instance.wood = userInfo.wood;
				Player.instance.stone = userInfo.stone;
				Player.instance.steel = userInfo.steel;				
				EventManager.instance.dispatch(EventName.USER_RES_CHANGE)
				Player.instance.diamond = userInfo.diamonds;
			}
			this.btnSign.visible = false;
			Player.instance.needSign = false;
			Util.message.show(response.msg);
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	private update (e) {}

	private onUpdatePlantTimer () {
		HttpClient.instance.post("API_URL", {c: "land", a: "index"}).then((response:any)=>{
			var farm = response.data.farmItem;
			for (let i = 0; i < farm.length; i++){
				LandDataManager.instance.updateLandData(i, farm[i]);
			}
			if(response.data.dog){
				PetDataManager.instance.updateCurrent(response.data.dog)
			}
		});
	}
	private lnarry=[];
	private scarry=[];
	private onUpdateAnnoncement(){
		this.lnarry=[];
		this.scarry=[];
		HttpClient.instance.post('API_URL', {c: 'message', a: 'getMessage', timing: this.annonceNormalVer}).then((response:any)=>{
			var msgList = response.data.msgList;
			if (msgList){
				for (var i in msgList) {
					var item = msgList[i], ver = response.sysTime, type = item.type, msg = item.msg, subType = item.subType;
					if (1 == type) {
						this.lnarry.push(item);
						if (!this.annonceNormalBusy) {
						// 	var c = 1e4;
						// 	this.annonceLabelNormal.size = 26;
						// 	switch (subType) {
						// 		case 0:
						// 			this.annonceLabelNormal.textColor = 16711680;
						// 			break;
						// 		case 7:
						// 			var l = 15e3;
						// 			c = l;
						// 			this.annonceLabelNormal.size = 28;
						// 			this.annonceLabelNormal.textColor = 16711680;
						// 			//this.playCoins(l);
						// 			break;
						// 		default:
						// 			this.annonceLabelNormal.textColor = 9184e3;
						// 	}
						// 	this.annonceLabelNormal.text = msg;
						// 	this.annonceNormalBusy = !0;
						// 	egret.Tween.get(this.annonceLabelNormal).to({
						// 		alpha: 1
						// 	}, 300).wait(c).to({
						// 		alpha: 0,
						// 		y: this.annonceNormalY - 50
						// 	}, 500).call(()=>{
						// 		this.annonceLabelNormal.y = this.annonceNormalY;
						// 		this.annonceNormalBusy = !1;
						// 	})
							this.annonceNormalVer = ver;
							egret.localStorage.setItem(Const.REMAIN_ANNONCE_NORMAL_ID_KEY, "" + this.annonceNormalVer);
						}
					} else {
						// var corlor=15539723;
						// if(type == 2){
						// }
						// else{
						// 	corlor=9184e3;
						// }
						this.scarry.push(item);
							// this.annonceSysContent = msg,
							// this.annonceSysUrl = item.url,
							// this.annonceSysBusy || (this.annonceSysBusy = !0, this.showSystemAnnoncement(this.annonceSysContent,corlor))
					}
				}
				if(this.lnarry.length>0){this.showN(0);}
				if(this.scarry.length>0){this.showSAnnoncement(0);}
			}
		})
	}

	private showN(i) {
		var item = this.lnarry[i];
		var type = item.type, msg = item.msg, subType = item.subType;
		if (!this.annonceNormalBusy) {
			var c = 1e4;
			this.annonceLabelNormal.size = 26;
			switch (subType) {
				case 0:
					this.annonceLabelNormal.textColor = 16711680;
					break;
				case 7:
					var l = 15e3;
					c = l;
					this.annonceLabelNormal.size = 28;
					this.annonceLabelNormal.textColor = 16711680;
					//this.playCoins(l);
					break;
				default:
					this.annonceLabelNormal.textColor = 9184e3;
			}
			this.annonceLabelNormal.text = msg;
			this.annonceNormalBusy = !0;
			egret.Tween.get(this.annonceLabelNormal).to({
				alpha: 1
			}, 300).wait(c).to({
				alpha: 0,
				y: this.annonceNormalY - 50
			}, 500).call(() => {
				if(i+1<this.lnarry.length){
					this.annonceLabelNormal.y = this.annonceNormalY;
					this.annonceNormalBusy = !1;
					this.showN(i+1);
				}else{
					this.annonceLabelNormal.y = this.annonceNormalY;
					this.annonceNormalBusy = !1;
				}
			})
			// this.annonceNormalVer = ver;
			// egret.localStorage.setItem(Const.REMAIN_ANNONCE_NORMAL_ID_KEY, "" + this.annonceNormalVer);
		}
	}

	private showSAnnoncement(index) {
		var type=this.scarry[index].type;
		var msg=this.scarry[index].msg;
			var corlor=15539723;
						if(type == 2){
						}
						else{
							corlor=9184e3;
						}
		this.annonceSys.visible = true;
		this.annonceLabelSys.text = msg;
		this.annonceLabelSys.textColor = corlor;
		this.annonceSysContent = null;
		var n = this.annonceSys.width;
		var i = this.annonceLabelSys.width;
		var a = this.annonceLabelSys.height;
		var s = egret.Tween.get(this.annonceLabelSys);

		if (i <= this.sysannonceScroller.width) {
			var o = 13e3;
			this.annonceLabelSys.x = 0;
			this.annonceLabelSys.y = a;
			s = s.to({
				y: 0
			}, 300).wait(o).to({
				y: -a
			}, 300)
		} else {
			this.annonceLabelSys.y = 0;
			var r = 1e4 + 1e3 * this.annonceLabelSys.text.length / 5;
			this.annonceLabelSys.x = n,
				s = s.to({
					x: -i
				}, r)
		}

		s = s.call(() => {
			if (index+1<this.scarry.length) {
				this.showSAnnoncement(index+1);
			} else {
				this.annonceSys.visible = !1;
				this.annonceSysBusy = !1;
			}
		})
	}
	private showSystemAnnoncement(msg,color){
		this.annonceSys.visible = true;
		this.annonceLabelSys.text = msg;
		this.annonceLabelSys.textColor=color;
		this.annonceSysContent = null;
		var n = this.annonceSys.width;
		var i = this.annonceLabelSys.width;
		var a = this.annonceLabelSys.height;
		var s = egret.Tween.get(this.annonceLabelSys);

		if (i <= this.sysannonceScroller.width) {
			var o = 13e3;
			this.annonceLabelSys.x = 0;
			this.annonceLabelSys.y = a;
			s = s.to({
				y: 0
			}, 300).wait(o).to({
				y: -a
			}, 300)
		} else {
			this.annonceLabelSys.y = 0;
			var r = 1e4 + 1e3 * this.annonceLabelSys.text.length / 5;
			this.annonceLabelSys.x = n,
			s = s.to({
				x: -i
			}, r)
		}

		s = s.call(()=>{
			if(this.annonceSysContent){
				this.showSystemAnnoncement(this.annonceSysContent,color);
			}else{
				this.annonceSys.visible = !1;
				this.annonceSysBusy = !1;
			}
		})
	}

	private particleFlower:particle.GravityParticleSystem;
	private playCoins (e) {
		if (this.particleFlower){
			this.particleFlower.stop(!0);
		} else {
			var t = RES.getRes("coin_png"), n = RES.getRes("coin_json");
			this.particleFlower = new particle.GravityParticleSystem(t, n), this.addChild(this.particleFlower)
		}
		this.particleFlower.start(e)
	}

	private updateHouse (e?:any) {
		void 0 === e && (e = null);
		var houseLv = Player.instance.houseLv;
		OtherPlayer.instance.opening && (houseLv = OtherPlayer.instance.houseLv);
		e && e.data && (houseLv = e.data);
		var i = URLConfig.getHouse(houseLv);
		RES.getResByUrl(i, (e)=>{
			if (e) {
				var n = e.textureWidth
				var i = e.textureHeight;
				this.imgHouse.source = e;
				this.imgHouse.anchorOffsetX = .46 * n;
				this.imgHouse.anchorOffsetY = .8673 * i;
			}
		}, this)
	}

	private getFreeDog(){
		PetNet.instance.getFree((e)=>{
			EventManager.instance.dispatch(EventName.NEW_DOG_HOUSE)
		})
	}

	private confirmFreeDog () {
		Alert.instance.show("领取宠物", "点击确定，免费领取一只狗狗！", ()=>{
			this.getFreeDog();
		}, true)
	}

	private getDogList () {
		PetNet.instance.getInfo((response)=>{
			if(response.code == 0){
				this.updateDog(PetDataManager.instance.curPet);
				var n = PetDataManager.instance.hasPet();
				this.dogHouse.visible = n;
				!PetDataManager.instance.curPet && n && EventManager.instance.dispatch(EventName.NEW_DOG_HOUSE);
			}else{
				this.confirmFreeDog();
			}	
		})
	}

	private getDogsInfo () {
		if(OtherPlayer.instance.opening){
			if(OtherPlayer.instance.petObj){
				egret.setTimeout(()=>{
					this.updateDog(OtherPlayer.instance.petObj);
					this.dogHouse.visible = !!OtherPlayer.instance.petObj;
				}, this, 200)
			}
		}else{
			this.getDogList();
		}
	}
	
	private onNewDogHouse (e) {
		this.dogHouse.visible = !0,
		this.dogHouseTip = new BubbleTip,
		this.dogHouseTip.x = -35,
		this.dogHouseTip.y = -110,
		this.groupHouse.addChild(this.dogHouseTip),
		this.dogHouseTip.showLoop("你有狗舍啦，点击狗舍查看你的狗狗")
	}

	private onUpdateDog (e) {
		e && e.data && this.updateDog(e.data);
	}

	private removedog () {
		this.curDog && (this.curDog.stopAction(), this.groupDog.removeChild(this.curDog));
	}

	private addDog (e) {
		this.curDog = new Pet(e);
		this.groupDog.addChild(this.curDog);
	}

	private updateDog (e) {
		if (e) {
			var t = e.typeId;
			this.curDog && t == this.curDog.dogId || (this.removedog(), this.addDog(t)), this.curDog.updateState(e)
		}
	}

	private godMap;
	private initGod () {
		this.godMap = new HashMap;
		let godData = GodDataManager.instance.godData;
		OtherPlayer.instance.opening && (godData = OtherPlayer.instance.godData);
		for (var t = 1; t <= 4; t++) {
			var data = godData.get(t);
			var god = new God(this["imgGod" + t], data);
			this.godMap.add(t, god);
		}
		this.groupGod.touchChildren = !1;
		OtherPlayer.instance.opening || this.groupGod.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onGodTouchBegan, this);
	}

	private onGodTouchBegan(evt){
		var t = evt.localX;
		var n = evt.localY;
		var i = this.godMap.values();
		for (let a = 0; a < i.length; a++) {
			var s = i[a];
			s.boundingBox.contains(t, n) && s.onTouchBegan(evt)
		}
	}
	
	private updateGodAll () {
		for (var e = 1; 4 >= e; e++)
			this.updateGodOne(e)
	}

	private updateGodOne (e) {
		var t = this.godMap.get(e);
		var godData = OtherPlayer.instance.opening ? OtherPlayer.instance.godData : GodDataManager.instance.godData;
		var i = godData.get(e);
		t.changeData(i);
	}
	
	private onGodActive (e) {
		e && e.data ? this.updateGodOne(Util.int(e.data)) : this.updateGodAll()
	}

	private updateGround(){
		var skinId = Player.instance.skinId;
		OtherPlayer.instance.opening && (skinId = OtherPlayer.instance.skinId);
		this.imgGround.source = URLConfig.getGround(skinId);
		this.imgFenceFront.source = URLConfig.getGroundFenceFront(skinId);
		this.imgFenceBack.source = URLConfig.getGroundFenceBack(skinId);
		if(Const.stageH > 960){
			this.imgGround.scale9Grid = new egret.Rectangle(0, 1, 1, 1);
			this.imgGround.top = 0;
		}else{
			this.imgGround.scale9Grid = null;
			this.imgGround.top = 0 / 0;
		}
	}

	private stealFriend(){
		HttpClient.instance.post("API_URL", {c: 'land', a: 'friendsSteal', ownerId: OtherPlayer.instance.uid}).then((response:any)=>{
			Util.message.show(response.msg);
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}
}