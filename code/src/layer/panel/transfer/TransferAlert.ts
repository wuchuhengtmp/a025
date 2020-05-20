class TransferAlert extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0;
		this.isVisibleAnimate = !0;
		this.isDelayDestroy = !0;
		this.skinName = new TransferAlertSkin;
	}

	private static _instance:TransferAlert = null;
	public static get instance():TransferAlert{
		if(!this._instance) {
			this._instance = new TransferAlert();
		}
		return this._instance;
	}

	private valueChangeCallback;
	private okCallback;
	private noCallback;
	private btnOk;
	private btnNo;
	private labelTxt;
	private fastInp;
	private clickTarget;
	private inpNum;
	private btnAdd;
	private btnSub;
	private imgSelectArrow:eui.Image;
	private isAccountListShow;
	private groupAccount:eui.Group;
	private selType;
	private listAccount:eui.List;
	public show (e, t, n, i?, a?) {
		this.isAccountListShow=false;
		this.imgSelectArrow.rotation = 180;
		this.groupAccount.visible=false;

		GameLayerManager.instance.popLayer.addChild(this);
		var arrTypes=[];
		arrTypes.push(new AccountVo("金币","diamonds"));
		for(var k=0;k<WareHouseDataManager.instance.propsData.length;k++)
		{
			var data=WareHouseDataManager.instance.propsData[k];
			if(data.type!=4||data.id=="1"||data.name=="种子"||data.id=="99")
			{
				continue;
			}
			arrTypes.push(new AccountVo(data.name,data.id));
		}
		this.listAccount.dataProvider = new eui.ArrayCollection(arrTypes);
		this.listAccount.itemRenderer = TransferItem;
		var tsid=LocalStorage.get("farm.transferid") || "diamonds";
		var tsname=LocalStorage.get("farm.transfername") || "金币";
		this.selType.text = tsname;
		LocalStorage.set("farm.transferid", tsid);
		LocalStorage.set("farm.transfername", tsname);
		var s = this;
		void 0 === i && (i = null);
		void 0 === a && (a = null);
		this.okCallback = i;
		this.noCallback = a;
		this.btnNo.enabled = this.btnOk.enabled = !0;
		this.valueChangeCallback = n;
		this.labelTxt.textFlow = FontUtil.html(this.valueChangeCallback(e));
		
		this.fastInp = new FastInput(this.inpNum,this.btnAdd,this.btnSub,e,t,(e)=>{
			s.labelTxt.textFlow = FontUtil.html(s.valueChangeCallback(e))
		});
		this.imgSelectArrow.addEventListener(egret.TouchEvent.TOUCH_TAP,this.changeShowTransferList,this);
		EventManager.instance.addEvent(EventName.ACCOUNT_SELECT, this.onAccountListSelect, this);
	}
	public changeShowTransferList()
	{
		this.isAccountListShow = !this.isAccountListShow;
		var e = this.isAccountListShow ? 0 : 180;
		egret.Tween.get(this.imgSelectArrow).to({
			rotation: e
		}, 200);
		this.groupAccount.visible = this.isAccountListShow;
	}
	public onAccountListSelect(e){
		var t = e.data;
		this.selType.text = t.id;
		LocalStorage.set("farm.transferid", t.pw);
		LocalStorage.set("farm.transfername", t.id);
		this.changeShowTransferList();
		this.labelTxt.textFlow = FontUtil.html(this.valueChangeCallback(this.fastInp.value));
	}
	public onRemoved () {
		super.onRemoved();
		this.isDelayDestroy = !0;
		this.fastInp.destroy();
		EventManager.instance.removeEvent(EventName.ACCOUNT_SELECT, this.onAccountListSelect, this);
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
		var n = t.target;
		this.clickTarget = null;
		if(n == this.btnNo || n == this.btnOk){
			this.clickTarget = t.target;
			this.btnNo.enabled = this.btnOk.enabled = false;
			this.onHide();
		}
	}

	public onHideAnimateOver () {
		this.clickTarget == this.btnOk ? this.okCallback && this.okCallback(this.fastInp.value) : this.noCallback && this.noCallback();
	}
}