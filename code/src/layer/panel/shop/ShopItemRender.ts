class ShopItemRender extends ItemRendererBase {
	public constructor() {
		super();
		this.skinName = new ShopItemSkin
	}

	protected onAdded () {
		super.onAdded();
		EventManager.instance.addEvent(EventName.SHOP_QUERY_LIMIT, this.updateLimitShow, this)
	}

	protected onRemoved () {
		super.onRemoved();
		EventManager.instance.removeEvent(EventName.SHOP_QUERY_LIMIT, this.updateLimitShow, this)
	}

	protected createChildren():void {
		super.createChildren();
		this.initIcon();
		this.btnBuy[Const.NO_AUDIO_TAG] = true;
	}

	private initIcon() {
		this.iconCard = new WareHouseItem;
		this.iconCard.x = 16;
		this.iconCard.y = 25;
		this.addChild(this.iconCard);
	}
	
	protected dataChanged() {
		this.vo = this.data;
		this.iconCard.data = this.vo;
		this.labelName.text = this.vo.name;
		this.labelDesc.text = this.vo.desc;
		this.labelPrice.text = this.vo.buyPrice + "";
		
		if(this.vo.stock){
			var e = this.vo.stock;
			this.iconCard.setLabelText("x" + e);
			this.labelName.text = this.vo.name + "x" + e;
			this.labelPrice.text = Math.floor(1e3 * this.vo.buyPrice * e / 1e3) + "";
		}
		this.updateLimitShow();
	}

	private updateLimitShow () {
		if(this.labelLimit){
			if(this.vo && 1 == this.vo.id){
				this.vo.buyOut < 0 && (this.vo.buyOut = 0);
				this.labelLimit.text = "剩余:" + Util.getBigNumberShow(this.vo.limitNum);
			}else{
				this.labelLimit.text = "";
			}
		}
	}
	
	protected onTouchTap(evt:egret.Event){
		var name = evt.target;
		if(name == this.btnBuy){
			this.vo.type == GoodsType.PET ? this.buyPet() : this.confirmBuyTool();
		}
	}

	private confirmBuyTool () {
		var t = this.vo.buyPrice;
		var n = Util.int(Player.instance.diamond / t);
		if(this.vo.stock){
			t = this.vo.buyPrice * this.vo.stock;
			n = Util.int(Player.instance.diamond / t);
		}
		console.log(this.vo);
		CountAlert.instance.show(1, n, (n)=>{
			var i = this.vo.name;
			var a = n;
			this.vo.stock && (a = n * this.vo.stock);
			return "购买" + a + "个" + i + "需要" + n * t + "金币";
		}, (t)=>{
			this.buyTool(t)
		})
	}

	private buyPet () {
		if(Player.instance.diamond < this.vo.buyPrice){
			Util.alert.show("金币不足", "金币不足，是否去兑换金币？", ()=>{UIManager.instance.popPanel(PayPanel)}, true);
		}else{
			Util.alert.show('购买宠物', '购买一只' + this.vo.name + '需要' + this.vo.buyPrice + '金币', ()=>{
				HttpClient.instance.post("API_URL", {c: "order", a: "pay", tId: this.vo.id, nums: 1}).then((response:any)=>{
					AudioManager.instance.playEffect(AudioTag.SUCCESS)
					Util.message.show(response.msg, null, this.messageY);
					Player.instance.diamond = Math.floor(response.data.diamonds);
					PetDataManager.instance.hasPet() || EventManager.instance.dispatch(EventName.NEW_DOG_HOUSE);
				}, (response:any)=>{
					AudioManager.instance.playEffect(AudioTag.FAIL)
					Util.message.show(response.msg, null, this.messageY);
				});
			}, true);
		}
	}

	private buyTool (t) {
		if(t > 0){
			if(this.vo && 1 == this.vo.id && this.vo.limitNum < (t * this.vo.stock)){
				Util.message.show("剩余数量不足", null, this.messageY);
			}else{
				if(Player.instance.diamond < this.vo.buyPrice * t){
					Util.alert.show("金币不足", "金币不足，是否去兑换金币？", ()=>{UIManager.instance.popPanel(PayPanel)}, true);
				}else{
					HttpClient.instance.post("API_URL", {c: "order", a: "pay", tId: this.vo.id, nums: t}).then((response:any)=>{
						AudioManager.instance.playEffect(AudioTag.SUCCESS)
						Util.message.show(response.msg, null, this.messageY);
						Player.instance.diamond = Math.floor(response.data.diamonds);
						this.vo.type == GoodsType.PROPS && WareHouseDataManager.instance.addPropsWhenShopBuy(this.vo, t);
						if(this.vo.stock){
							this.vo.limitNum -= t*this.vo.stock;
							this.vo.limitNum < 0 && (this.vo.limitNum = 0);
						}
						this.updateLimitShow();
						EventManager.instance.dispatch(EventName.SHOP_QUERY_LIMIT);
					}, (response:any)=>{
						AudioManager.instance.playEffect(AudioTag.FAIL)
						Util.message.show(response.msg, null, this.messageY);
					});
				}
			}
		}
	}
	
	private labelName:eui.Label;
	private labelDesc:eui.Label;
	private labelPrice:eui.Label;
	private labelLimit:eui.Label;
	private btnBuy:eui.Button;
	private vo:any;
	private iconCard:WareHouseItem;
	private messageY = 230;
}