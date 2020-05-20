class GoodsVo {
	private data:any;
	public id:number;
	public type:number;
	public name:string;
	public num:number;
	public desc:string;
	private buyPrice:number;
	public stock:number;
	public pack:number;
	public costIdx:number;
	private workshop:number;
	public cost:any;
	public limitNum:any;// 新增显示种子最大购买数量
	public constructor(data) {
		this.num = 0;
		this.desc = "";
		this.buyPrice = 0;
		this.stock = 0;
		this.pack = 1;
		this.costIdx = 0;
		this.workshop = 0;
		if(data){
			this.id = data.cId || data.tId;
			this.type = data.type;
			this.name = data.tName || data.name;
			this.num = data.num * 1;
			this.desc = data.info || data.depict;
			this.pack = data.pack * 1;
			this.workshop = data.workshop || 0;
			this.data = data;
			this.getLocalCfg();
		}
	}

	public clone () {
		var goodsVo = new GoodsVo(null);
		return goodsVo.id = this.id, goodsVo.name = this.name, goodsVo.num = this.num, goodsVo.type = this.type, goodsVo.desc = this.desc, goodsVo.buyPrice = this.buyPrice, goodsVo.cost = this.cost, goodsVo.stock = this.stock, goodsVo.pack = this.pack, goodsVo.limitNum = this.limitNum, goodsVo.data = this.data, goodsVo;
	}

	public get icon(){
		return this.type + "_" + this.id;
	}

	public setShopData (data) {
		if(data){
			this.id = data.tId;
			this.type = data.type;
			this.name = data.tName;
			this.buyPrice = data.price;
			this.desc = data.depict || "未填写";
			this.data = data;
			this.pack = data.pack;
			this.limitNum = data.total;
			this.getLocalCfg();
		}
		return this;
	}

	public setExchangeData (e) {
		if (e) {
			this.id = e.tId;
			this.type = e.type;
			this.name = e.tName || e.name;
			this.desc = e.depict || e.depict || "未填写";
			this.stock = e.stock || 1;
			this.costIdx = e.costIdx;
			this.workshop = e.workshop || 0;
			if (e.cost) {
				var t = e.cost;
				this.cost = [];
				for (var n = 0; n < t.length; n++){
					this.cost.push(new CostVo(t[n]))
				}						
			}
			this.getLocalCfg()
		}
		return this;
	}

	public static newFromTypeAndId(t, n, i?){
		0 === i && (i = 0);
		var a = new GoodsVo(null);
		a.id = n;
		a.type = t;
		a.num = i;		
		a.getLocalCfg();
		return a;
	}

	public get isDiamond(){
		return 999 == this.type && 999 == this.id ? !0 : !1
	}

	public get maxEx(){
		var e = 0;
		if (this.cost) {
			for (var t = Const.EX_MAX_NUMBER, n = 0; n < this.cost.length; n++) {
				var i = this.cost[n]
					, a = Util.int(i.gvo.num / i.gnum);
				t > a && (t = a)
			}
			e = t
		}
		return e
	}

	public get isWood(){
		return this.type == GoodsType.MATERIAL && 1 == this.id
	}

	public get isStone(){
		return this.type == GoodsType.MATERIAL && 2 == this.id
	}

	public get isSteel(){
		return this.type == GoodsType.MATERIAL && 3 == this.id
	}

	public getLocalCfg(){
		var n = DataManager.getConfigByName("goods");
		if (n){
			for (var t = 0; t < n.length; t++) {
				var i = n[t];
				if (i.sn == this.id && i.type == this.type) {
					this.name = i.name;
					this.desc = i.desc;
					break
				}
			}
		}
	}
}

class CostVo {
	public gnum:number;
	public gvo:GoodsVo;
	public constructor(e) {
		this.gnum = 0;
		if(e){
			this.gvo = new GoodsVo(e);
			this.gnum = e.price * 1;
			this.gvo.type != 999 || this.gvo.id != 999 || this.gvo.num || (this.gvo.num = Player.instance.diamond * 1);
		}
	}
}

class DataManager{
	public static tab = new HashMap;
	public constructor() {}

	public static init () {
		this.initGoodsConfig();
		this.initShopConfig();
	}

	public static initGoodsConfig () {
		var e = RES.getRes("Content_json");
		this.tab.add("goods", e)
	}

	public static initShopConfig () {
		var e = RES.getRes("Shop_json");
		this.tab.add("shop", e)
	}

	public static getConfigByName (e) {
		return this.tab.get(e)
	}
}

class GoodsType{
	public static FRUIT = 1;
	public static MATERIAL = 2;
	public static GEM = 3;
	public static PROPS = 4;
	public static GOD = 5;
	public static PET = 6;
	public static SKIN = 7;
	public static PETFOOD = 10;
	public static FRAGMENT = 11;
	public static CURRENCY = 999;
	public static OTHER = 1e3;
}