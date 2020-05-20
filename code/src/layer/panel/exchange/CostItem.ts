class CostItem extends eui.Component implements  eui.UIComponent {
	
	private vo:any;
	private cost:any;
	private showDesc:any;
	public constructor(vo:any, cost) {
		super();
		this.vo = vo;
		this.cost = cost;
		this.showDesc = true;
		this.skinName = CostItemSkin;
	}

	private imgIcon:eui.Image;
	private imgAdd:eui.Image;
	private labelCost:eui.Label;
	private labelTotal:eui.Label;
	protected createChildren():void {
		super.createChildren();
		this.updateShow();
		this.showDesc && UIUtils.addShortTouch(this, this.onLongTouchBegan.bind(this), this.onLongTouchEnd.bind(this))
	}

	public updateShow(){
		if (this.vo) {
			var icon = URLConfig.getIcon(this.vo.icon);
			if(this.imgIcon.source != icon){
				this.imgIcon.source = icon;
			}
			this.labelCost.text = this.cost;
			this.labelTotal.text = this.vo.num + "";
		}
	}

	public visibleAdd (bool:boolean) {
		this.imgAdd.visible = bool;
	}
	
	public itemWidth (width:number) {
		this.imgAdd.x = width - 20;
	}
	
	public labelTotalOffsetY (offsetY:number) {
		this.labelTotal.y = 72 + offsetY;
	}
	
	public iconOffsetY (OffsetY:number) {
		this.imgIcon.verticalCenter = 1 + OffsetY;
	}

	public get iconX () {
		return this.imgIcon.x
	}
	
	public get iconY () {
		return this.imgIcon.y
	}
	
	public get iconW () {
		return this.imgIcon.width
	}
	
	public get iconH () {
		return this.imgIcon.height
	}
	
	public get iconScale () {
		return this.imgIcon.scaleX
	}
	
	public get icon () {
		return this.imgIcon
	}
	
	public get costLabel () {
		return this.labelCost
	}

	
	private onLongTouchBegan(evt:egret.Event){
		this.vo && this.showDesc && GoodsTip.show(this.vo, this.localToGlobal(23, this.height / 2));
	}
	private onLongTouchEnd(evt:egret.Event){
		this.showDesc && GoodsTip.hide();
	}
}