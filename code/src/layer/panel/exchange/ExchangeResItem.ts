class ExchangeResItem extends ItemRendererBase {
	public constructor() {
		super();
		this.exNum = 1;
		this.longTouchAddEx = 0;
		this.skinName = new ExchangeResItemSkin;
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
		UIUtils.addLongTouch(this.btnSub, this.startSubExNum.bind(this), this.endSubExNum.bind(this)),
		UIUtils.addLongTouch(this.btnAdd, this.startAddExNum.bind(this), this.endAddExNum.bind(this))
	}
	
	private initIcon () {
		this.iconCard = new WareHouseItem;
		this.iconCard.x = 20;
		this.iconCard.y = 30;
		this.addChild(this.iconCard);
	}

	protected dataChanged(){
		this.vo = this.data,
		this.iconCard.data = this.vo,
		this.groupCost.removeChildren();
		for (var e = Math.min(2, this.vo.cost.length), t = 0; e > t; t++) {
			var n = this.vo.cost[t], i = new CostItem(n.gvo,n.gnum);
			i.visibleAdd(e - 1 > t),
			i.itemWidth(80),
			i.x = 85 * t + 10,
			i.y = -10,
			this.groupCost.addChild(i)
		}
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
			Player.instance.addRes(this.vo, t);
		}, (response:any)=>{
			AudioManager.instance.playEffect(AudioTag.FAIL);
			Util.message.show(response.msg, null, this.messageY);
		})
	}
}