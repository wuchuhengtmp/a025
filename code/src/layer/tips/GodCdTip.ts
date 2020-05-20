class GodCdTip extends eui.Component implements  eui.UIComponent {
	public constructor() {
		super();
		this.skinName = "GodCdTipSkin";
	}

	private static _instance:GodCdTip = null;
	private labelName:eui.Label;
	private labelDesc:eui.Label;
	private labelTime:eui.Label;
	private barTime:eui.ProgressBar;
	public static show(e, n):void {
		var i = this._instance;
		i || (i = new GodCdTip, this._instance = i);
		i.labelName.text = e.name + " (" + (e.isActive ? "激活中" : "未激活") + ")";
		i.labelDesc.text = e.desc;
		var a = e.endTime - DateTimer.instance.now;
		a > 0 ? i.labelTime.text = Util.showTimeFormat(a) + "后到期" : i.labelTime.text = "神像未激活";
		var s = a / 864e5;
		i.barTime.value = Util.limit(100 * s, 0, 100);

		egret.callLater(()=>{
			i.anchorOffsetX = i.width / 2, i.anchorOffsetY = i.height / 2;
			var e = n.x;
			var t = n.y - i.height / 2 - 16;
			n.x < i.width / 2 ? e = i.width / 2 : n.x > Const.stageW - i.width / 2 && (e = Const.stageW - i.width / 2);
			n.y < .2 * Const.stageH && (t = n.y + i.height / 2 + 20);
			i.x = e;
			i.y = t
		}, this);

		i.scaleX = i.scaleY = 0;
		GameLayerManager.instance.tipsLayer.addChild(i);
		egret.Tween.get(i).to({
			scaleX: 1,
			scaleY: 1
		}, 150)
	}

	public static hide () {
		var e = this._instance;
		e && e.stage && egret.Tween.get(e).to({
			scaleX: 0,
			scaleY: 0
		}, 150).call(UIUtils.removeSelf, e, [e])
	}
}