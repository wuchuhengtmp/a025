class PetSkillPanel extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !1,
		this.isVisibleAnimate = !1,
		this.skinName = new PetSkillPanelSkin
	}
	
	private btnSkillHarvest;
	private btnSkillPlanting;
	private btnSkillRoseHeart;
	private skillUpdateTimer;
	private labelRoseNum;
	private groupRoseNum;
	private skillInfo;
	private labelHarvestTime;
	private labelPlantingTime;
	private labelRoseHeart;
	private proRoseHeart;
	private labelGrowTime;
	private proPlanting;
	private proHarvest;
	public onTouchTap (e) {
		var t = e.target;
		switch (t) {
			case this.btnSkillHarvest:
				this.onBtnSkill("harvest");
				break;
			case this.btnSkillPlanting:
				this.onBtnSkill("planting");
				break;
			case this.btnSkillRoseHeart:
				this.onBtnSkill("roseHeart")
		}
	}

	public netGetSkillInfo () {
		PetNet.instance.skillInfo((response:any)=>{
			this.setSkillInfo(response.data.skillInfo)
		})
	}

	private onBtnSkill (e) {
		var n = this.skillInfo;
		if (n && n[e]) {
			var i = n[e];
			if(i.canUse){
				PetNet.instance.useSKill(e, (response:any)=>{
					this.setSkillInfo(response.data.skillInfo);
				})
			}else{
				PetNet.instance.pauseSKill(e, !i.paused, (response:any)=>{
					this.setSkillInfo(response.data.skillInfo);
				})
			}
		}
	}

	private updateRoseItem (e) {
		var t = e.num;
		this.labelRoseNum.text = t + "";
		this.groupRoseNum.visible = t > 0;
		this.btnSkillRoseHeart.visible = t > 0;
	}

	private setSkillInfo (e) {
		if (e) {
			this.updateRoseItem(e.roseHeart);
			this.skillInfo = [];
			for (var t in e) {
				var n = e[t], i = "", a = "", s = !0;
				this.skillInfo[t] = n;
				if("harvest" === t || "planting" === t){
					if(n.canUse){
						i = "";
						s = !0;
						a = "使用";
					}else{
						if(n.leftTime <= 0){
							s = !1;
							i = "今天不能再使用";
						}else{
							i = "";
							a = n.paused ? "▶" : "‖";
						}
					}
				}

				switch (t) {
					case "harvest":
						this.labelHarvestTime.text = i;
						this.btnSkillHarvest.visible = s;
						this.btnSkillHarvest.label = a;
						break;
					case "planting":
						this.labelPlantingTime.text = i;
						this.btnSkillPlanting.visible = s;
						this.btnSkillPlanting.label = a;
						break;
					case "roseHeart":
						var o = n.point, r = n.pointMax;
						this.labelRoseHeart.text = "" + o + "/" + r,
						this.proRoseHeart.value = Math.ceil(100 * o / r);
						break;
					case "growTime":
						this.labelGrowTime.text = n.desc;
				}
			}
			this.resetSkillTimes()
		}
	}

	private resetSkillTimes () {
		if(!this.skillUpdateTimer){
			this.skillUpdateTimer = new egret.Timer(1e3,Number.MAX_VALUE);
			this.skillUpdateTimer.addEventListener(egret.TimerEvent.TIMER, this.onUpdateSKillTimes, this);
			this.skillUpdateTimer.reset();
			this.skillUpdateTimer.start();
		}
	}

	private onUpdateSKillTimes(){
		if (this.skillInfo) {
			var e = !1;
			for (var t in this.skillInfo) {
				var n = this.skillInfo[t], i = n.leftTime, a = n.maxTime, s = n.paused;
				if (i > 0) {
					s || (i -= 1);
					if(i <= 0){
						i = 0;
						e = !0;
					}
					var o = "剩余时间：" + Util.showTimeFormat(1e3 * i)
					var r = Math.ceil(100 * i / a);
					switch (t) {
						case "harvest":
							this.labelHarvestTime.text = o,
							this.proHarvest.value = r;
							break;
						case "planting":
							this.labelPlantingTime.text = o,
							this.proPlanting.value = r
					}
					n.leftTime = i
				}
			}
			e && this.netGetSkillInfo();
		}
	}

	public destroy () {
		super.destroy();
		this.skillUpdateTimer && (this.skillUpdateTimer.removeEventListener(egret.TimerEvent.TIMER, this.onUpdateSKillTimes, this),
		this.skillUpdateTimer.reset(),
		this.skillUpdateTimer.stop())
	}
	
}