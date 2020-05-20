class ExchangeDataManager {
	public constructor() {
		if (ExchangeDataManager._instance){
			throw new Error("ExchangeDataManager使用单例")
		}
	}

	private static _instance:ExchangeDataManager = null;
	public static get instance():ExchangeDataManager{
		if(!this._instance) {
			this._instance = new ExchangeDataManager();
		}
		return this._instance;
	}
	
	public godData;
	public materialData;
	public skinData;
	public petFoodData;
	public propsData;
	public serverInit (e) {
		this.godData = [];
		this.materialData = [];
		this.skinData = [];
		this.petFoodData = [];
		this.propsData = [];
		for (var t = 0; t < e.length; t++) {
			var n = new GoodsVo(null).setExchangeData(e[t]);
			if (n.type == GoodsType.GOD){
				this.godData.push(n);
			} else if (n.type == GoodsType.MATERIAL){
				this.materialData.push(n);
			} else if (n.type == GoodsType.SKIN){
				13 != n.id && this.skinData.push(n);
			} else if (n.type == GoodsType.PETFOOD) {
				this.petFoodData.push(n);
				n.costIdx = n.cost.length - 1;
				for (var i = 0; i < n.cost.length; i++) {
					var a = e[t].cost[i];
					n.stock = a.stock;
				}
			} else {
				n.type == GoodsType.PROPS && this.propsData.push(n);
			}
		}
	}
}