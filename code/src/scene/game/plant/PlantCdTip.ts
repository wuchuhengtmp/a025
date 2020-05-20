class PlantCdTip extends eui.Component implements  eui.UIComponent {
	public constructor() {
		super();
		this.skinName = new PlantCdTipSkin
	}
	
	private static _instance;
	public static show (e, n) {
		if (e && !(e.plantId <= 0)) {
			var i = PlantCdTip._instance;
			if (i || (i = new PlantCdTip, PlantCdTip._instance = i), i.labelName.text = e.plantName + " (" + PlantPhaseName.getName(e.phase) + ")", i.labelTime.text = e.phase == PlantPhase.ripe ? "已经成熟" : e.phase == PlantPhase.die ? "已经收获" : Util.showTimeFormat(e.currPhaseNeedTime) + "后" + PlantPhaseName.getName(e.phase + 1), e.phase == PlantPhase.ripe || e.phase == PlantPhase.die) i.barTime.value = 100;
			else {
				var a = e.currPhaseRunTime / e.currPhaseTotalTime;
				i.barTime.value = Util.limit(100 * a, 0, 100)
			}
			egret.callLater(()=>{
				i.anchorOffsetX = i.width / 2, i.anchorOffsetY = i.height / 2;
				var e = n.x,
					t = n.y - i.height / 2 - 16;
				n.x < i.width / 2 ? e = i.width / 2 : n.x > Const.stageW - i.width / 2 && (e = Const.stageW - i.width / 2), n.y < .2 * Const.stageH && (t = n.y + i.height / 2 + 20), i.x = e, i.y = t
			}, this);
			i.scaleX = i.scaleY = 0;
			GameLayerManager.instance.tipsLayer.addChild(i), egret.Tween.get(i).to({
				scaleX: 1,
				scaleY: 1
			}, 150)
		}
	}

	public static hide () {
		var e = PlantCdTip._instance;
		e && e.stage && egret.Tween.get(e).to({
			scaleX: 0,
			scaleY: 0
		}, 150).call(UIUtils.removeSelf, e, [e])
	}
	
}