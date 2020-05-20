class PetListItem extends ItemRendererBase {
	public constructor() {
		super();
		this.skinName = new PetListItemSkin;
	}
	private vo:any;
	private iconCard:WareHouseItem;
	private groupHead:eui.Group;
	private labelName:eui.Label;
	private labelLv:eui.Label;
	private labelHp:eui.Label;
	private proHp:eui.ProgressBar;
	private labelExp:eui.Label;
	private proExp:eui.ProgressBar;
	private labelLucky:eui.Label;
	private labelSpeed:eui.Label;
	private labelAp:eui.Label;
	private labelDp:eui.Label;
	private labelScore:eui.Label;
	private imgActive:eui.Image;
	private btnSwitch:eui.Button;
	private btnDrop:eui.Button;

	public onAdded () {
		super.onAdded();
	}

	public onRemoved () {
		super.onRemoved();
	}

	protected createChildren():void {
		super.createChildren();
		this.initIcon();
	}

	private initIcon () {
		this.iconCard = new WareHouseItem;
		this.groupHead.addChild(this.iconCard);
	}

	protected dataChanged () {
		var data = this.data;
		this.iconCard.data = new GoodsVo({
			tId: 8,
			type: GoodsType.PET,
			tName: data.name,
			depict: "我的宠物"
		}),
		this.labelName.text = data.name,
		this.labelLv.text = "Lv." + data.lv,
		this.labelHp.text = "" + data.hp + "/" + data.hpMax,
		this.proHp.value = Math.ceil(100 * data.hp / data.hpMax),
		this.labelExp.text = "" + data.exp + "/" + data.expMax,
		this.proExp.value = Math.ceil(100 * data.exp / data.expMax),
		this.labelLucky.text = "" + data.luckyMax,
		this.labelSpeed.text = "" + data.speedMin + "~" + data.speedMax,
		this.labelAp.text = "" + data.apMin + "~" + data.apMax,
		this.labelDp.text = "" + data.dpMin + "~" + data.dpMax,
		this.labelScore.text = "" + data.score,
		this.imgActive.visible = PetDataManager.instance.curId == data.id,
		this.btnSwitch.visible = PetDataManager.instance.curId != data.id,
		this.btnDrop.visible = PetDataManager.instance.curId != data.id,
		this.vo = data;
	}

	private confirmDrop () {
		Util.alert.show("确认抛弃？", '确认抛弃这只宠物吗？', ()=>{
			HttpClient.instance.post("API_URL", {c: "dog", a: "dogSelect", type: 'delete', id: this.vo.id}).then((response:any)=>{
				Util.message.show(response.msg);
				EventManager.instance.dispatch(EventName.PETLIST_GETINFO)
			}, (response:any)=>{
				Util.message.show(response.msg);
			})
		}, true);
	}

	private switchPet () {
		HttpClient.instance.post("API_URL", {c: "dog", a: "dogSelect", type: 'select', id: this.vo.id}).then((response:any)=>{
			Util.message.show(response.msg);
			PetDataManager.instance.setCurrent(this.vo.id);
			EventManager.instance.dispatch(EventName.DOG_UPDATE, PetDataManager.instance.curPet);
			EventManager.instance.dispatch(EventName.PETLIST_GETINFO)
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	public onTouchTap (evt:egret.Event) {
		var target = evt.target;
		target == this.btnDrop ? this.confirmDrop() : target == this.btnSwitch && this.switchPet()
	}
	
}