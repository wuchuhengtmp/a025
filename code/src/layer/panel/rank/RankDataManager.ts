class RankDataManager {
	public rankPageMax;
	public petRankPageMax;
	public rankData;
	public petRankData;
	public selfRank;
	public selfPetRank;
	public selfFriendRank;
	public constructor() {
		this.rankPageMax = 1;
		this.petRankPageMax = 1;
		this.rankData = [];
		this.petRankData = [];
		this.selfRank = 0;
		this.selfPetRank = 0;
		if (RankDataManager._instance){
			throw new Error("LogDataManager使用单例")
		}
	}

	private static _instance:RankDataManager = null;
	public static get instance():RankDataManager{
		if(!this._instance) {
			this._instance = new RankDataManager();
		}
		return this._instance;
	}

	public setRankList (e) {
		if (e) {
			this.rankData = [];
			for (var t = 0; t < e.length; t++)
				this.rankData.push(new UserVo(e[t]))
		}
	}

	public setSelfRank (e) {
		this.selfRank = e
	}

	public setPetRankList (e) {
		if (e) {
			this.petRankData = [];
			for (var t = 0; t < e.length; t++)
				this.petRankData.push(new PetRankVo(e[t]))
		}
	}

	public setSelfPetRank (e) {
		this.selfPetRank = e
	}

	public setSelfFriendRank (e) {
		this.selfFriendRank = e
	}
}

class UserVo{
	private uid;
	private rank;
	private name;
	private lv;
	private diamond;
	public constructor(data) {
		if(data){
			this.uid = data.uid;
			this.rank = data.rank;
			this.name = data.userName;
			this.lv = data.level;
			this.diamond = data.diamonds;
		}
	}
}

class PetRankVo{
	private rank;
	private name;
	private ownerName;
	private lv;
	private score;
	public constructor(data) {
		if(data){
			this.rank = data.rank;
			this.name = data.dogName;
			this.ownerName = data.ownerName;
			this.lv = data.level;
			this.score = data.score;
		}
	}
}