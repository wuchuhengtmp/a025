class FoodItem extends eui.Component implements  eui.UIComponent {
	public constructor() {
		super();
		this.skinName = new FoodItemSkin;
		this.touchChildren = false;
	}

	private imgSelect;
	private labelNum;
	private _data;
	private imgIcon;
	private labelName;
	protected createChildren():void {
		super.createChildren();
		this.imgSelect.alpha = 0;
		this.labelNum.text = "";
	}

	public set data(data){
		this._data = data;
		this.updateView();
	}

	public get data(){
		return this._data;
	}

	public updateView () {
		this.labelNum.text = this.data.num + "";
		this.imgIcon.source = URLConfig.getIcon(this.data.icon);
	}

	public set select(data){
		egret.Tween.removeTweens(this.imgSelect);
		if(data){
			this.imgSelect.visible = true;
			this.labelName.text = this.data.name;
			// AnimUtil.blink(this.imgSelect, 350)
		}else{
			this.labelName.text = "";
			this.imgSelect.visible = false;
		}
	}
	
}