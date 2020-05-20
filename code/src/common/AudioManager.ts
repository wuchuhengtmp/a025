class AudioManager {
	public isOpen;
	private effectTimeMap;
	private channel;
	public constructor() {
		this.isOpen = true;
		this.effectTimeMap = new HashMap;
		var e = egret.localStorage.getItem(Const.AUDIO_SAVE_KEY);
		if(e){
			this.isOpen = ("1" == e) ? true : false
		}else{
			this.isOpen = true;
		}
	}

	private static _instance:AudioManager = null;
	public static get instance():AudioManager{
		this._instance = new AudioManager();
		return this._instance;
	}

	public setIsOpen (e) {
		this.isOpen = e;
		egret.localStorage.setItem(Const.AUDIO_SAVE_KEY, e ? "1" : "0");
		if (e) {
			if (this.channel){
				return;
			}
			AudioManager.instance.playEffect(AudioTag.BGSOUND, true);

			var t = RES.getRes("bgm_mp3");
			t && (this.channel = t.play(0, -1));
		} else{
			if(Const.BGSOUND){
				Const.BGSOUND.stop();
			}
			this.channel && this.channel.stop();
			this.channel = null;
		}
	}

	public playEffect (e, loop?) {
		var t = this;
		if (this.isOpen) {
			-1 == e.indexOf("_mp3") && (e += "_mp3");
			var n = this.effectTimeMap.get(e, 0);
			if (!(Date.now() - n < 0)) {
				var i = RES.getRes(e);
				if(i){
					if(loop){
						Const.BGSOUND = i.play(0, 0);
					}else{
						i.play(0, 1);
					}
					this.effectTimeMap.set(e, 1e3 * i.length + Date.now());
				}else{
					RES.getResAsync(e, function(n) {
						n && egret.callLater(function() {
							n.play(0, 1);
							t.effectTimeMap.set(e, 1e3 * n.length + Date.now());
						}, t)
					}, this)
				}
			}
		}
	}
}

class AudioTag {
	public static BUTTON = "button";
	public static FAIL = "fail";
	public static SUCCESS = "success";
	public static GAIN = "gain";
	public static LEVELUP = "levelup";
	public static OPEN_BOX = "open_box";
	public static PET = "pet";
	public static SHOVEL = "shovel";
	public static SOW = "sow";
	public static BGSOUND = "bgsound";
}