class ShopDataManager {
	public constructor() {
		if (ShopDataManager._instance){
			throw new Error("ShopDataManager使用单例")
		}
	}

	private static _instance:ShopDataManager = null;
	public static get instance():ShopDataManager{
		if(!this._instance) {
			this._instance = new ShopDataManager();
		}
		return this._instance;
	}
	public propsData;
	public boxData;
	public hotData;
	public dogData;
	public serverInit (e) {
		this.propsData = [];
		this.boxData = [];
		this.hotData = [];
		this.dogData = [];
		for (var t = 0; t < e.length; t++) {
			var n = new GoodsVo(null).setShopData(e[t]);
			if (n.id == 1) {
				n.stock = 1e3;
				this.setGroup(n);
			}else{
				this.setGroup(n);
			}
			n.pack && (n.stock = n.pack);
		}
		this.sortGroup();
	}

	private sortGroup () {
		var e = [this.hotData, this.propsData, this.boxData, this.dogData];
		for (let t = 0, n = e; t < n.length; t++) {
			var i = n[t];
			i.sort((e, t)=>{
				return e.sort - t.sort
			})
		}
	}

	private setGroup (e) {
		var t = [this.hotData, this.propsData, this.boxData, this.dogData];
		var n = DataManager.getConfigByName("shop");
		for (let i = 0; i < n.length; i++) {
			var s = n[i];
			if (s.itemType == e.type && s.itemId == e.id) {
				e.sort = s.sn;
				var o = s.shopType, r = t[o - 1];
				return void r.push(e)
			}
		}
		this.propsData.push(e)
	}
}