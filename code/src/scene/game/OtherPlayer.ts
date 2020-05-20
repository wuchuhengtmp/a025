class OtherPlayer {
	
	public petObj;
	public landData:any;
	public opening:boolean;
	public constructor() {
		this.petObj = null;
		this.landData = [];
		this.opening = false;
	}

	private static _instance:OtherPlayer = null;
	public static get instance():OtherPlayer{
		if(!this._instance) {
			this._instance = new OtherPlayer();
		}
		return this._instance;
	}
	public uid:number;
	public wood:number;
	public steel:number;
	public stone:number;
	public diamond:number;
	public name:string;
	public skinId:number;
	public avatar:number;
	public houseLv:number;
	public godData:any;
	public dogData:any;

	public serverInit (data) {
		this.initUserData(data.user);
		this.initLandData(data.farm);
		this.initGodData(data.joss);
		this.initPetData(data.dog);
	}
	private initUserData (data) {
		this.uid = data.userId;
		this.wood = data.wood * 1;
		this.steel = data.steel * 1;
		this.stone = data.stone * 1;
		this.diamond = data.diamond * 1;
		this.name = data.nickName;
		this.houseLv = data.houseLv * 1;
		this.skinId = data.skinId * 1;
		this.avatar = data.avatar * 1;
	}

	private initLandData (e) {
		this.landData = [];
		for (var t = 0; t < e.length; t++) {
			var n = e[t];
			this.landData.push(new LandVo(t,n))
		}
	}

	private initGodData (e) {
		this.godData = new HashMap;
		for (var t in e){
			this.godData.put(t, new GodVo(t,e[t]))
		}
	}

	private initPetData (e) {
		if(e){
			this.petObj = new PetVo(e);
		}else{
			this.petObj = null;
		}
	}

	public enterOtherFarm (uid, t?) {
		void 0 === t && (t = null);
		HttpClient.instance.post("API_URL", {c: 'home', a: 'index', ownerId: uid}, true).then((response:any)=>{
			if(response.code == 0){
				OtherPlayer.instance.serverInit(response.data);
				this.opening = true;
				GameLayerManager.instance.showBothScene(GameScene);
			}else{
				Util.message.show(response.msg);
			}
			t && t();
		})
	}

	public backHome () {
		HttpClient.instance.post("API_URL", {c: 'home', a: 'index'}).then((response:any)=>{
			// 初始化数据
			Player.instance.serverInit(response.data.user);
			LandDataManager.instance.serverInit(response.data.farm)
			Player.instance.godData = response.data.joss;
			Player.instance.dogData = response.data.dog;
			
			this.opening = false;
			GameLayerManager.instance.showSingleScene()
		})
	}

}