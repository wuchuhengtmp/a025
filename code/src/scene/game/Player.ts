class Player {
	public constructor() {
		this.houseLv = 1;
		this.skinId = 1;
		this.avatar = 1
	}

	private static _instance:Player = null;
	public static get instance():Player{
		if(!this._instance) {
			this._instance = new Player();
		}
		return this._instance;
	}

	public serverInit (user) {
		this.mobile=user.mobile;
		this.userId = user.userId || this.userId;
		this.uid = user.userId;
		this.wood = user.wood * 1;
		this.steel = user.steel * 1;
		this.stone = user.stone * 1;
		this._diamond = user.diamond * 1;
		this.name = user.nickName;
		this.houseLv = user.houseLv * 1;
		this.skinId = user.skinId * 1;
		this.avatar = user.avatar * 1;
		this.money = user.amount * 1;
	}

	// 用户金币
	private _diamond:number;
	public get diamond() {
		return this._diamond
	}

	public set diamond(num) {
		this._diamond = num;
		EventManager.instance.dispatch(EventName.USER_DIAMOND_CHANGE, this._diamond);
	}

	// 用户签到
	private _needSign:boolean;
	public get needSign() {
		return this._needSign
	}

	public set needSign(e) {
		this._needSign = e;
	}

	public batchSubRes (e) {
		for (var t = e.length, n = 0; t > n; n++) {
			var i = e[n];
			this.addRes(i.gvo, -i.gnum, !1),
			i.gvo.isDiamond && (this.diamond -= i.gnum)
		}
		EventManager.instance.dispatch(EventName.USER_RES_CHANGE)
	}

	public addRes (t, n, i?) {
		void 0 === i && (i = !0), t.type == GoodsType.MATERIAL && (1 == t.id ? Player.instance.wood += n : 2 == t.id ? Player.instance.stone += n : 3 == t.id && (Player.instance.steel += n), i && EventManager.instance.dispatch(EventName.USER_RES_CHANGE))
	}
	public mobile:string;
	// uid
	public uid:number;
	// 用户UID
	public userId:number;
	// 姓名
	public name:string;
	// 房屋（用户）等级
	public houseLv:number;
	// 皮肤ID
	public skinId:number;
	// 头像ID
	public avatar:number;
	// 是否有礼物
	public hasGift:boolean;
	// 是否有赔偿
	public hasIndemnify:boolean;
	// 是否有新手礼包
	public hasNewGift:boolean;
	// 用户木头
	public wood:number;
	// 用户石头
	public stone:number;
	// 用户钢材
	public steel:number;
	// 用户金币
	public money:number;
	// 神像数据
	public godData:any;
	// 狗数据
	public dogData:any;

}