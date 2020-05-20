class ExchangePetFoodItem extends ItemRendererBase {
	public constructor() {
		super();
		this.exNum = 1;
		this.longTouchAddEx = 0;
		this.skinName = new ExchangePetFoodItemSkin;
	}
	private exNum;
	private longTouchAddEx;
	private vo;

	private iconCard:WareHouseItem;
	private groupCost:eui.Group;
	private btnSub:eui.Button;
	private btnAdd:eui.Button;
	private btnMax:eui.Button;
	private btnEx:eui.Button;
	private inpNum:eui.TextInput;
	private messageY = 230;

	protected createChildren():void {
		super.createChildren();
		this.initIcon();
		this.btnEx[Const.NO_AUDIO_TAG] = true;
		UIUtils.addLongTouch(this.btnSub, this.startSubExNum.bind(this), this.endSubExNum.bind(this));
		UIUtils.addLongTouch(this.btnAdd, this.startAddExNum.bind(this), this.endAddExNum.bind(this));
	}
	
	private initIcon () {
		this.iconCard = new WareHouseItem;
		this.iconCard.x = 20;
		this.iconCard.y = 30;
		this.addChild(this.iconCard);
	}

	protected dataChanged(){
		this.vo = this.data;
		this.iconCard.data = this.vo;
		this.iconCard.setLabelText("x" + this.vo.stock);
		this.groupCost.removeChildren();
		var e = this.vo.cost[0]
		var t = new CostItem(e.gvo, e.gnum);
		t.visibleAdd(!1),
		t.x = 30,
		t.y = -10,
		this.groupCost.addChild(t)
	}

	public onTouchTap(evt:egret.Event){
		let target = evt.target;
		switch (target) {
			case this.btnEx:
				this.onBuy();
				break;
			case this.btnMax:
				this.changeExNumber(this.vo.maxEx, !0);
				break;
			case this.btnAdd:
				this.changeExNumber(1);
				break;
			case this.btnSub:
				this.changeExNumber(-1);
				break;
		}
	}

	private changeExNumber(maxEx, t?){
		if(t === true){
			this.exNum = maxEx;
		}else{
			this.exNum += maxEx;
		}
		this.exNum = Util.limit(this.exNum, 1, Const.EX_MAX_NUMBER);
		this.inpNum.text = this.exNum + ""
	}

	private startSubExNum() {
		this.longTouchAddEx = -1;
		UpdateTicker.instance.add(this);
	}

	private endSubExNum () {
		this.longTouchAddEx = 0;
		UpdateTicker.instance.remove(this);
	}

	private startAddExNum () {
		this.longTouchAddEx = 1,
		UpdateTicker.instance.add(this)
	}

	private endAddExNum () {
		this.longTouchAddEx = 0,
		UpdateTicker.instance.remove(this)
	}

	private update (e) {
		this.changeExNumber(this.longTouchAddEx);
		if(1 == this.exNum || this.exNum == Const.EX_MAX_NUMBER){
			UpdateTicker.instance.remove(this);
			this.longTouchAddEx = 0
		}
	}

	private onBuy () {
		let t = Math.max(1, Util.int(this.inpNum.text));
		t = Math.min(t, Const.EX_MAX_NUMBER);
		HttpClient.instance.post('API_URL', {c: "gift", a: "exchange", type: this.vo.type, id: this.vo.id, nums: t}).then((response:any)=>{
			AudioManager.instance.playEffect(AudioTag.SUCCESS);
			Util.message.show(response.msg, null, this.messageY);
			for (var i = 0; i < this.vo.cost.length; i++) {
				var a = this.vo.cost[i];
				a.gvo.num -= a.gnum * t;
				var s:any = this.groupCost.getChildAt(i);
				s.updateShow();
			}
			var o = response.data.extNum || 0;
			WareHouseDataManager.instance.addPropsWhenShopBuy(this.vo, t * this.vo.stock + o);
			EventManager.instance.dispatch(EventName.PETFOOD_UPDATE);
		}, (response:any)=>{
			AudioManager.instance.playEffect(AudioTag.FAIL);
			Util.message.show(response.msg, null, this.messageY);
		})
	}
}