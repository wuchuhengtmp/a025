class PetNet {
	public constructor() {
		if (PetNet._instance) throw new Error("PetNet使用单例")
	}

	private static _instance:PetNet = null;
	public static get instance():PetNet{
		if(!this._instance) {
			this._instance = new PetNet();
		}
		return this._instance;
	}

	public getInfo (func?) {
		let param = {
			c: "dog",
			a: "index"
		};
		HttpClient.instance.post("API_URL", param, true).then((response:any)=>{
			if(response.code == 0){
				PetDataManager.instance.serverInit(response.data.list);
				PetDataManager.instance.setCurrent(response.data.current);
				PetDataManager.instance.setFeed(response.data.food);
			}else{
				Util.message.show(response.msg);
			}
			typeof(func) == "function" && func(response);
		});
	}

	public getFree (func?) {
		let param = {
			c: "dog",
			a: "addDog"
		};
		HttpClient.instance.post("API_URL", param).then((response:any)=>{
			var food = response.data.food;
			WareHouseDataManager.instance.addPropsWhenShopBuy(new GoodsVo({
				cId: 14,
				type: 10,
				tName: "狗粮",
				num: 1,
				depict: "狗粮"
			}), food);
			Util.message.show(response.msg);
			typeof(func) == "function" && func(response);
		}, (response:any)=>{
			Util.message.show(response.msg);
		});
	}

	public feed(foodId, num, func?){
		let param = {
			c: "dog",
			a: "feedDogFood",
			type: foodId*1 + 1,
			nums: num,
		};
		HttpClient.instance.post("API_URL", param, true).then((response:any)=>{
			if(response.code == 0){
				PetDataManager.instance.updateData(response.data.dog);
				EventManager.instance.dispatch(EventName.DOG_UPDATE, PetDataManager.instance.curPet);
				AudioManager.instance.playEffect(AudioTag.SUCCESS)
			}else{
				Util.message.show(response.msg);
				AudioManager.instance.playEffect(AudioTag.FAIL)
			}
			typeof(func) == "function" && func(response);
		});
	}

	public trainning(func?){
		let param = {
			c: "dog",
			a: "trainDog"
		};
		HttpClient.instance.post("API_URL", param).then((response:any)=>{
			PetDataManager.instance.updateData(response.data.dog);
			EventManager.instance.dispatch(EventName.DOG_UPDATE, PetDataManager.instance.curPet);
			typeof(func) == "function" && func(response);
		}, (response:any)=>{
			Util.message.show(response.msg);
		});
	}

	public saveTrainning(func?){
		let param = {
			c: "dog",
			a: "trainDogOk"
		};
		HttpClient.instance.post("API_URL", param).then((response:any)=>{
			PetDataManager.instance.updateData(response.data.dog);
			EventManager.instance.dispatch(EventName.DOG_UPDATE, PetDataManager.instance.curPet);
			typeof(func) == "function" && func(response);
		}, (response:any)=>{
			Util.message.show(response.msg);
		});
	}

	// public upgrade (t) {} 无用

	public drop (id, func?) {
		let param = {
			c: "dog",
			a: "addDog",
			type: "delete",
			id: id
		};
		HttpClient.instance.post("API_URL", param).then((response:any)=>{
			Util.message.show(response.msg);
			PetDataManager.instance.updateData(response.data.dog)
			EventManager.instance.dispatch(EventName.DOG_UPDATE, PetDataManager.instance.curPet);
			typeof(func) == "function" && func(response);
		}, (response:any)=>{
			Util.message.show(response.msg);
		});
	}

	// public switchPet (t) {} 无用

	public useSKill (t, func) {
		var action;
		if(t == 'harvest'){
			action = 'autoHarvest';
		}else if (t == 'planting'){
			action = 'autoSow';
		}
		var param = {
			c: 'dog',
			a: action,
		};
		HttpClient.instance.post("API_URL", param).then((response:any)=>{
			Util.message.show(response.msg);
			if(t == "roseHeart"){
				WareHouseDataManager.instance.addPropsWhenShopBuy(new GoodsVo({
					cId: 99,
					type: 4,
					tName: "玫瑰之心",
					num: 1,
					depict: "玫瑰之心"
				}), 1)
			}
			typeof(func) == "function" && func(response);
		}, (response:any)=>{
			Util.message.show(response.msg);
		});
	}

	public pauseSKill (t, n, func) {
		var action;
		if(t == 'harvest'){
			action = 'autoHarvest';
		}else if (t == 'planting'){
			action = 'autoSow';
		}
		var param = {
			c: 'dog',
			a: action, 
			types: 'stop'
		}
		HttpClient.instance.post("API_URL", param).then((response:any)=>{
			Util.message.show(response.msg);
			typeof(func) == "function" && func(response);
		}, (response:any)=>{
			Util.message.show(response.msg);
		})
	}

	public skillInfo (func) {
		var param = {
			c: 'dog',
			a: 'getDogSkillInfo',
		};
		HttpClient.instance.post("API_URL", param).then((response:any)=>{
			typeof(func) == "function" && func(response);
		}, (response:any)=>{
			Util.message.show(response.msg);
		});
	}

	public rename(name, func?){}
}