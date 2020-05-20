class Pet extends egret.DisplayObjectContainer {

	private curDogMcFac:egret.MovieClipDataFactory;
	private curDogMc:egret.MovieClip;
	private curDogMcBusy:boolean;
	private HUNGRY_HP:number;
	private bubble:BubbleTip;
	private curDogId:number;
	private bubbleTexts;
	private dogData;
	private dogState;
	public constructor(typeId) {
		super();
		this.curDogMcFac = null;
		this.curDogMc = null;
		this.curDogMcBusy = false;
		this.HUNGRY_HP = 10;
		this.curDogId = 1;
		var n = "dog" + typeId;
		let data = RES.getRes("dog1_json")
		let txtr = RES.getRes("dog1_png")
		this.curDogMcFac = new egret.MovieClipDataFactory(data,txtr);
		this.curDogMc = new egret.MovieClip;
		this.addChild(this.curDogMc);

		let tips = new BubbleTip;
		tips.y = -250;
		tips.x = -157;
		this.addChild(tips);
		this.bubble = tips;
		this.curDogMcBusy = false;

		let o = new Date(Date.now());
		let r = o.getMonth() + 1;
		let h = o.getDate();
		3 === r && 8 === h ? this.bubbleTexts = RES.getRes("petBubble_woman_json") : this.bubbleTexts = RES.getRes("petBubble_json")
	}

	public get dogId(){
		return this.curDogId
	}

	private stopAction () {
		egret.Tween.removeTweens(this)
	}

	public updateState (e) {
		this.dogData = e;
		if (e.lv) {
			var t = .5 + .05 * e.lv;
			t > 1 && (t = 1), this.curDogMc.scaleX = this.curDogMc.scaleY = t, this.bubble.y = -250 * t
		}
		let n = e.hp || 0;
		let	i = n <= this.HUNGRY_HP ? "hungry" : "idle";
		this.updateAction(1, i)
	}

	private updateAction (e, t) {
		this.dogState = t;
		if (!this.curDogMcBusy) {
			var i = this.curDogMc;
			this.curDogMcBusy = true;
			if ("hungry" == t) {
				var a = {
					1: 12,
					2: 15,
					3: 15
				};
				i.movieClipData = this.curDogMcFac.generateMovieClipData("hungry");
				var s = i.frameRate;
				i.anchorOffsetX = 0;
				i.anchorOffsetY = 0;
				i.x = 0;
				i.y = 0;
				egret.Tween.get(this).call(()=>{
					i.gotoAndPlay("0", 1);
				}).wait(1e3 * a[e] / s).call(()=>{
					this.curDogMcBusy = !1;
					this.updateAction(e, this.dogState);
				})
			} else if ("idle" == t) {
				i.movieClipData = this.curDogMcFac.generateMovieClipData("idle");
				var s = i.frameRate;
				var o = {
						1: [36, 12, 2, 12, 31],
						2: [60, 6, 2, 6, 29],
						3: [66, 6, 2, 6, 48]
					};
				var r = o[e];
				egret.Tween.get(this).call(()=>{
					2 == e && (i.anchorOffsetX = 0, i.anchorOffsetY = 0), i.gotoAndPlay("0", 1)
				}).wait(1e3 * r[0] / s).call(()=>{
					i.gotoAndPlay("1", -1)
				}).to({
					x: 230,
					y: 100
				}, 4e3).call(()=>{
					i.gotoAndPlay("2", 1)
				}).wait(1e3 * r[2] / s).call(()=>{
					i.gotoAndPlay("3", -1)
				}).to({
					x: 0,
					y: 0
				}, 4e3).call(()=>{
					2 == e && (i.anchorOffsetX = -1.5, i.anchorOffsetY = 16), i.gotoAndPlay("4", 1);
				}).wait(1e3 * r[4] / s).call(()=>{
					this.curDogMcBusy = !1;
					this.updateAction(e, this.dogState);
				})
			}
			this.updateBubbleShow();
		}
	}

	private updateBubbleShow () {
		var e = this.dogData.hp || 0;
		var t = "idle";
		e <= this.HUNGRY_HP ? t = "hungry" : e >= this.dogData.hpMax && (t = "full");
		var n = this.bubbleTexts[t];
		var i = n[Math.floor(Math.random() * n.length)];
		this.bubble.showLoop(i);
	}
}