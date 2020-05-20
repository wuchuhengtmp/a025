class God {
	private img:eui.Image;
	private vo:any;
	private timer:any;
	public constructor(img, data) {
		this.img = img;
		this.changeData(data)
	}
	
	public onTouchBegan (e) {
		Const.stage.once(egret.TouchEvent.TOUCH_END, this.onTouchEnd, this);
		var t = new egret.Point(e.stageX, e.stageY);
		GodCdTip.show(this.vo, t), egret.Tween.get(this.img).to({
			scaleX: .9,
			scaleY: .9
		}, 50)
	}

	public onTouchEnd () {
		GodCdTip.hide(), egret.Tween.get(this.img).to({
			scaleX: 1,
			scaleY: 1
		}, 50)
	}

	private changeData (data) {
		if (data) {
			this.vo = data;
			this.timer && (this.timer.reset(), this.timer.stop());
			var endTime = this.vo.vaidtime - DateTimer.instance.now;
			if(endTime > 0){
				if(this.timer){
					this.timer.delay = endTime;
					this.timer.reset();
					this.timer.repeatCount = 1;
				}else{
					this.timer = new egret.Timer(endTime, 1);
					this.timer.addEventListener(egret.TimerEvent.TIMER_COMPLETE, this.onGodEndTime, this)
				}
				this.timer.start();
			}
			this.updateShow()
		}
	}
	private onGodEndTime () {
		this.updateShow()
	}

	private updateShow () {
		var e = URLConfig.getGod(this.vo.godId, 0);
		this.vo.isActive && (e = URLConfig.getGod(this.vo.godId, 1)), this.img.source = e
	}

	public get boundingBox () {
		return new egret.Rectangle(this.img.x, this.img.y, 60, this.img.height)
	}

}