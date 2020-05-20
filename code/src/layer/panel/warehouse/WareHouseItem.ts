class WareHouseItem extends eui.Group implements eui.Group {
	private group: eui.Group
	private imgIcon: eui.Image;
	private labelNum: eui.Label;
	private _data: any;

	public constructor() {
		super();
		this.initBg();
		this.initIcon();
		this.initNumTF();
		UIUtils.addShortTouch(this, this.onLongTouchBegan.bind(this), this.onLongTouchEnd.bind(this))
	}

	private initBg() {
		var img = new eui.Image("item_bg_png");
		this.addChild(img);
		this.width = 70;
		this.height = 70;
	}

	private initIcon() {
		this.imgIcon = new eui.Image;
		this.imgIcon.horizontalCenter = 0;
		this.imgIcon.verticalCenter = 0;
		this.addChild(this.imgIcon)
	}

	private initNumTF() {
		this.labelNum = new eui.Label;
		this.labelNum.textColor = 12149e3;
		this.labelNum.stroke = 1;
		this.labelNum.strokeColor = 16770461;
		this.labelNum.size = 18;
		this.labelNum.right = 2;
		this.labelNum.bottom = 2;
		this.addChild(this.labelNum)
	}

	private onLongTouchBegan() {
		this.data && 
		(this.data.data && ((this.data.data.costs && this.data.type == GoodsType.PROPS && (this.data.id >= 4 && this.data.id <= 7))|| this.data.type == GoodsType.FRUIT) || GoodsTip.show(this.data, this.localToGlobal(this.width / 2, this.height / 2)))
	}
	private onLongTouchEnd() {
		if (this.data && this.data.data && this.data.data.costs) {
			if (this.data.type == GoodsType.PROPS && this.data.id >= 21 && this.data.id < 30) {
				// var e = new MergeFruitPanel(this.data);
				// UIManager.instance.popPanel(e)
				// TODO 青帝之泪
			} else if (this.data.type == GoodsType.PROPS && this.data.id >= 4 && this.data.id <= 7) {
				var t = new TreasureBoxPanel(this.data);
				UIManager.instance.popPanel(t);
			} else {
				GoodsTip.hide();
			}
		}else if(this.data && this.data.data &&this.data.type == GoodsType.FRUIT){
			GoodsTip.hide();
			var t1=new FruitUseBoxPannel(this.data);
			UIManager.instance.popPanel(t1);
		}
		 else {
			GoodsTip.hide()
		}
	}

	public set data(data) {
		if (this._data != data) {
			this._data = data;
			if (data) {
				this.imgIcon.source = URLConfig.getIcon(data.icon);
				this.labelNum.text = data.num > 0 ? "x" + data.num : "";
			} else {
				this.imgIcon.source = "";
				this.labelNum.text = "";
			}
		}
	}

	public get data() {
		return this._data;
	}

	public setLabelText(e, t?) {
		void 0 === t && (t = 12149e3);
		this.labelNum.textColor = t;
		this.labelNum.text = e;
	}
}