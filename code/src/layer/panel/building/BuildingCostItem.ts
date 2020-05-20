class BuildingCostItem extends eui.Component implements  eui.UIComponent {
	public constructor(gvo, gnum) {
		super();
		this.vo = gvo;
		this.cost = gnum;
		this.skinName = new BuildingCostItemSkin;
	}

	protected partAdded(partName:string,instance:any):void {
		super.partAdded(partName,instance);
	}

	private vo;
	private cost:number;

	private imgIcon:eui.Image;
	private labelTip:eui.Label;
	protected createChildren():void {
		super.createChildren();
		if(this.vo){
			this.imgIcon.source = URLConfig.getIcon(this.vo.icon)
			if(this.cost > 0){
				if(this.vo.num >= this.cost){
					this.labelTip.textColor = 12517121;
				}else{
					this.labelTip.textColor = 16711680;
				}
				this.labelTip.text = this.cost + "/" + this.vo.num
			}else{
				 this.labelTip.text = this.vo.name;
			}
			UIUtils.addShortTouch(this, this.onLongTouchBegan.bind(this), this.onLongTouchEnd.bind(this))
		}
	}

	public setLabelTip (str:string) {
		this.labelTip.text = str;
	}
	
	private onLongTouchBegan(evt:egret.Event){
		this.vo && GoodsTip.show(this.vo, this.localToGlobal(23, this.height / 2))
	}
	
	private onLongTouchEnd(evt:egret.Event){
		GoodsTip.hide()
	}
}