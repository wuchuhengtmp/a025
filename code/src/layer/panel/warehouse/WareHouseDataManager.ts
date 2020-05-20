class WareHouseDataManager {
	public fruitData:any;
	public materialData:any;
	public fragmentData:any;
	public gemData:any;
	public propsData:any;
	public skinData:any;
	private allData:any;
	public constructor() {
		this.fruitData = [];
		this.materialData = [];
		this.fragmentData = [];
		this.gemData = [];
		this.propsData = [];
		this.skinData = [];
		this.allData = [];
		if (WareHouseDataManager._instance) throw new Error("WareHouseDataManager使用单例")
	}

	private static _instance:WareHouseDataManager = null;
	public static get instance():WareHouseDataManager{
		if(!this._instance) {
			this._instance = new WareHouseDataManager();
		}
		return this._instance;
	}

	public serverInit (e) {
		this.fruitData = [];
		this.materialData = [];
		this.fragmentData = [];
		this.gemData = [];
		this.propsData = [];
		this.skinData = [];
		this.allData = [];
		for (var t = 0; t < e.length; t++) {
			var n = new GoodsVo(e[t]);
			this.allData.push(n);
			n.type == GoodsType.FRUIT ? this.fruitData.push(n) : n.type == GoodsType.MATERIAL ? this.materialData.push(n) : n.type == GoodsType.FRAGMENT ? this.fragmentData.push(n) : n.type == GoodsType.GEM ? this.gemData.push(n) : n.type == GoodsType.PROPS || n.type == GoodsType.PETFOOD ? this.propsData.push(n) : n.type == GoodsType.SKIN && this.skinData.push(n)
		}
	}

	public findSkinIsBuyed (e) {
		for (var t = 0; t < this.skinData.length; t++) {
			var n = this.skinData[t];
			if (n.id == e && n.num > 0) return true;
		}
		return false;
	}

	public addPropsWhenShopBuy (e, t) {
		for (var n, i = 0; i < this.propsData.length; i++) {
			var a = this.propsData[i];
			if (a.id == e.id && a.type ==e.type) {
				n = a;
				break
			}
		}
		n ? n.num += t : (n = e.clone(), n.num = t, this.propsData.push(n))
	}
	public subProp (e, t, type?) {
		void 0 === t && (t = 1);
		for (var n = 0; n < this.propsData.length; n++) {
			var i = this.propsData[n];
			if(type){
				if (i.id == e && i.type == type) {
					i.num -= t;
					break
				}
			}else{
				if (i.id == e) {
					i.num -= t;
					break
				}
			}
			
		}
	}
	public getPropNum (e):number {
		for (var t = 0; t < this.propsData.length; t++) {
			var n = this.propsData[t];
			if (n.id == e) return n.num
		}
		return 0
	}
	public getPropData (e) {
		for (var t = 0; t < this.propsData.length; t++) {
			var n = this.propsData[t];
			if (n.id == e) return n
		}
		return null
	}
	public getGemData (e) {
		for (var t = 0; t < this.gemData.length; t++) {
			var n = this.gemData[t];
			if (n.id == e) return n
		}
		return null
	}
	public getFruitData (e) {
		for (var t = 0; t < this.fruitData.length; t++) {
			var n = this.fruitData[t];
			if (n.id == e) return n
		}
		return null
	}
	public changeGoodsNum (e, t, n) {
		for (var i = 0, a = this.allData; i < a.length; i++) {
			var s = a[i];
			if (s.type == e && s.id == t) return s.num += n, Player.instance.addRes(s, n), s
		}
		return null
	}
	public getGoodsVo (e, t) {
		for (var n = 0, i = this.allData; n < i.length; n++) {
			var a = i[n];
			if (a.type == e && a.id == t) return a
		}
		return null
	}
	public getGoodsVoCount (e, t) {
		for (var n = 0, i = this.allData; n < i.length; n++) {
			var a = i[n];
			if (a.type == e && a.id == t){
				return a.num;
			}
		}
		return 0
	}
}