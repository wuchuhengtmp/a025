class PetDetailPanel extends PanelBase {
	public constructor() {
		super(null);
		this.currSelectIndex = -1,
		this.confirmTrainning = !1,
		this.longTouchAddEx = 0,
		this.exNum = 1,
		this.isFullScreen = !1,
		this.isVisibleAnimate = !1,
		this.skinName = new PetDetailPanelSkin
	}

	public onAdded () {
		super.onAdded();
		EventManager.instance.addEvent(EventName.PETFOOD_UPDATE, this.onFoodUpdate, this)
	}

	public onRemoved () {
		super.onRemoved();
		EventManager.instance.removeEvent(EventName.PETFOOD_UPDATE, this.onFoodUpdate, this)
	}

	private currSelectIndex;
	private confirmTrainning;
	private longTouchAddEx;
	private exNum;

	private btnDropTrainning:eui.Button;
	private groupAttrEx:eui.Group;
	private btnFeed:eui.Button;
	private inpNum:eui.EditableText;
	private groupFood:eui.Group;
	private btnSub:eui.Button;
	private btnAdd:eui.Button;
	protected createChildren():void {
		super.createChildren();
		this.btnDropTrainning.visible = !1,
		this.groupAttrEx.visible = !1,
		this.btnFeed[Const.NO_AUDIO_TAG] = !0,
		this.updatePetInfoView(),
		this.updateFeedCostView(),
		UIUtils.addLongTouch(this.btnSub, this.startSubExNum.bind(this), this.endSubExNum.bind(this)),
		UIUtils.addLongTouch(this.btnAdd, this.startAddExNum.bind(this), this.endAddExNum.bind(this))
	}
	
	private changeExNumber (e, t?) {
		void 0 === t && (t = !1);
		t ? this.exNum = e : this.exNum += e;
		this.exNum = Util.limit(this.exNum, 1, Const.EX_MAX_NUMBER);
		this.inpNum.text = this.exNum + "";
	}

	private startSubExNum () {
		this.longTouchAddEx = -1,
		UpdateTicker.instance.add(this)
	}

	private endSubExNum () {
		this.longTouchAddEx = 0,
		UpdateTicker.instance.remove(this)
	}

	private startAddExNum () {
		this.longTouchAddEx = 1,
		UpdateTicker.instance.add(this)
	}

	private endAddExNum () {
		this.longTouchAddEx = 0,
		UpdateTicker.instance.remove(this)
	}

	private update () {
		this.changeExNumber(this.longTouchAddEx);
		(1 == this.exNum || this.exNum == Const.EX_MAX_NUMBER) && (UpdateTicker.instance.remove(this), this.longTouchAddEx = 0)
	}

	private onFoodUpdate () {
		this.updateFeedCostView()
	}

	private updateFeedCostView () {
		var foodData = PetDataManager.instance.foodData;
		var t = true;
		for (var n = 0; n < foodData.length; n++) {
			var i = foodData[n];
			i.num = WareHouseDataManager.instance.getGoodsVoCount(i.type, i.id) || i.num;
			var a:any = this.groupFood.getChildAt(n);
			if (!a) return;
			a.data = i;
			a.name = "food";
			if(this.currSelectIndex < 0){
				if(i.num > 0 && t){
					this.currSelectIndex = n;
					t = false;
					a.select = true;
				}else{
					a.select = false;
				}
			}else{
				if(this.currSelectIndex == n){
					a.select = true;
				}else{
					a.select = false;
				}
			}
		}
	}

	private selectFood (e) {
		for (let t = 0; t < this.groupFood.numChildren; t++) {
			var n:any = this.groupFood.getChildAt(t);
			n == e ? (n.select = !0, this.currSelectIndex = t) : n.select = !1;
		}
	}
	private imgHead;
	private labelScore;
	private labelLv;
	private labelSpeed;
	private labelAp;
	private labelDp;
	private labelExp;
	private proExp;
	private labelHp;
	private labelHpMax;
	private proHp;
	private labelLucky;
	private btnTrainning;
	private editName;
	private imgEditName;
	private btnRename;
	private groupHp;
	private updatePetInfoView () {
		var e = PetDataManager.instance.curPet;
		this.imgHead.source = "dog_" + e.typeId + "_png";
		this.labelScore.text = "总评分：" + e.score;
		this.labelLv.text = "LV." + e.lv;
		this.labelSpeed.text = "" + e.speedMin + "~" + e.speedMax;
		this.labelAp.text = "" + e.apMin + "~" + e.apMax;
		this.labelDp.text = "" + e.dpMin + "~" + e.dpMax;
		this.labelExp.text = "" + e.exp + "/" + e.expMax;
		this.proExp.value = Math.ceil(100 * e.exp / e.expMax);
		this.labelHp.text = "" + e.hp + "/" + e.hpMax;
		this.labelHpMax.text = "" + e.hpMax;
		this.proHp.value = Math.ceil(100 * e.hp / e.hpMax);
		this.labelLucky.text = "" + e.luckyMax;
		this.btnTrainning.visible = e.hp > 0 || this.groupAttrEx.visible;
		this.editName.text = e.name;
		this.imgEditName.visible = !1;
		this.editName.touchEnabled = !1;
		this.btnRename.label = "改名";
		this.btnRename.visible = e.canRename;
		e.hp >= e.hpMax && egret.Tween.get(this.groupHp).set({
			scaleX: 1.05,
			scaleY: 1.05
		}).to({
			scaleX: 1,
			scaleY: 1
		}, 200, egret.Ease.backOut)
	}

	private showFeedEffect () {
		var t:any = this.groupFood.getChildAt(this.currSelectIndex)
		var n = new eui.Image(URLConfig.getIcon(t.data.icon));
		n.anchorOffsetX = 30, n.anchorOffsetY = 30;
		var i = t.localToGlobal(), a = this.imgHead.localToGlobal(60, 60);
		n.x = i.x, n.y = i.y;
		GameLayerManager.instance.tipsLayer.addChild(n);
		egret.Tween.get(n).to({
			x: a.x,
			y: a.y
		}, 300, egret.Ease.sineOut).to({
			scaleX: 1.5,
			scaleY: 1.5,
			alpha: 0
		}, 400).call(()=>{
			UIUtils.removeSelf(n);
			this.updatePetInfoView();
			this.updateFeedCostView();
		})
	}

	private getAttrCompareColor (e, t, n, i) {
		if (null != n && null != i) {
			if (t + i > e + n)
				return 56576;
			if (e + n > t + i)
				return 14483456
		} else {
			if (t > e)
				return 56576;
			if (e > t)
				return 14483456
		}
		return 1118481
	}

	private labelApEx;
	private labelDpEx;
	private labelSpeedEx;
	private labelLuckyEx;
	private labelHpMaxEx;
	private showConfirmAttrs (data) {
		if (data) {
			this.groupAttrEx.visible = !0;
			var t = PetDataManager.instance.curPet;
			this.labelApEx.text = "" + data.attack.min + "~" + data.attack.max;
			this.labelApEx.textColor = this.getAttrCompareColor(t.apMin, data.attack.min, t.apMax, data.attack.max);
			this.labelDpEx.text = "" + data.defense.min + "~" + data.defense.max;
			this.labelDpEx.textColor = this.getAttrCompareColor(t.dpMin, data.defense.min, t.dpMax, data.defense.max);
			this.labelSpeedEx.text = "" + data.speed.min + "~" + data.speed.max;
			this.labelSpeedEx.textColor = this.getAttrCompareColor(t.speedMin, data.speed.min, t.speedMax, data.speed.max);
			this.labelLuckyEx.text = "" + data.lucky;
			this.labelLuckyEx.textColor = this.getAttrCompareColor(t.luckyMax, data.lucky, 0, 0);
			this.labelHpMaxEx.text = "" + data.hp;
			this.labelHpMaxEx.textColor = this.getAttrCompareColor(t.hpMax, data.hp, 0, 0);
		}
	}

	// 训练
	private onTouchTrainning () {
		PetNet.instance.trainning((response)=>{
			this.confirmTrainning = true;
			this.btnTrainning.label = "保存";
			this.btnDropTrainning.visible = !0;
			this.showConfirmAttrs(response.data.newAttrs);
			this.updatePetInfoView();
		})
	}

	// 保存训练结果
	private saveTrainning () {
		PetNet.instance.saveTrainning((response)=>{
			this.confirmTrainning = false;
			this.groupAttrEx.visible = !1;
			this.btnTrainning.label = "训练";
			this.btnDropTrainning.visible = !1;
			this.updatePetInfoView()
		})
	}

	// 放弃训练结果
	private dropTrainning () {		
		this.confirmTrainning = false;
		this.groupAttrEx.visible = !1;
		this.btnTrainning.label = "训练";
		this.btnDropTrainning.visible = !1;
		this.updatePetInfoView()
	}

	private onTouchBtnFeed () {
		var t = PetDataManager.instance.foodData[this.currSelectIndex];
		this.exNum = Util.int(this.inpNum.text) || 1;
		PetNet.instance.feed(this.currSelectIndex, this.exNum, (response)=>{
			if (0 == response.code) {
				WareHouseDataManager.instance.subProp(t.id, this.exNum, t.type);
				this.showFeedEffect();
				if(response.data.upgrade){
					Util.message.show("宠物提升到" + PetDataManager.instance.curPet.lv + "级");
					MCUtil.getMc("dog_lvup", (t)=>{
						t.x = 110;
						t.y = 100;
						t.play();
						this.addChild(t);
						t.addEventListener(egret.Event.COMPLETE, ()=>{
							UIUtils.removeSelf(t)
						}, this)
					})
				}

				var i = response.data.roseheart;
				if(i > 0){
					MCUtil.getMc("dog_rose", (t)=>{
						t.x = Const.stageW / 2;
						t.y = Const.stageH / 2;
						t.play();
						GameLayerManager.instance.tipsLayer.addChild(t);
						t.addEventListener(egret.Event.COMPLETE, ()=>{
							UIUtils.removeSelf(t)
						}, this)
					})
				}
			} else {
				if(response.code == 1){
					Util.alert.show("狗粮不足", "狗粮不足，是否去兑换中心兑换？", ()=>{
						var e = new ExchangePanel;
						e.tabIdexToOpen = ExchangePanel.TAB_PETFOOD;
						UIManager.instance.popPanel(e);
					}, true)
				}
			}
		})
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
		var n = t.target;
		switch (n) {
			case this.btnFeed:
				this.onTouchBtnFeed();
				break;
			case this.btnTrainning:
				if(this.btnTrainning.label == "保存"){
					this.saveTrainning();
				}else{
					this.onTouchTrainning();
				}
				break;
			case this.btnDropTrainning:
				this.dropTrainning();
				break;
			case this.btnRename:
				this.onRename();
				break;
			case this.btnAdd:
				this.changeExNumber(1);
				break;
			case this.btnSub:
				this.changeExNumber(-1)
		}
		"food" == n.name && this.selectFood(n)
	}

	public onRename () {
		if(this.btnRename.label === "改名"){
			this.btnRename.label = "确认";
			this.imgEditName.visible = !0;
			this.editName.touchEnabled = !0;
		}else{
			PetNet.instance.rename(this.editName.text, (t)=>{
				this.updatePetInfoView()
			})
		}
	}

	public confirmHide (e) {
		if(this.groupAttrEx.visible){
			Util.alert.show("强制退出", "训练结果未保存，是否强制退出？", ()=>{
				this.dropTrainning();
				e && e()
			}, true)
		}else{
			e && e();
		}
	}
}