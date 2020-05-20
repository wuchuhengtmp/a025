class UIManager {
	public constructor() {
		this.panels = [];
	}

	private static _instance:UIManager = null;
	public static get instance():UIManager{
		if(!this._instance) {
			this._instance = new UIManager();
		}
		return this._instance;
	}

	private currPanelName;
	private currPanel;
	private panels;
	public popPanel (currPanel, data?, n?) {
		void 0 === data && (data = null);
		void 0 === n && (n = null);
		this.currPanelName = null;
		if ("object" == typeof currPanel){
			this.currPanel = currPanel;
		} else {
			if ("function" != typeof currPanel){
				throw "显示面板传参错误";
			}
			this.currPanel = new currPanel;
		}
		this.currPanel.data = data;
		this.currPanel.animate_startPos = n;
		this.panels.push(this.currPanel);
		GameLayerManager.instance.popLayer.addChild(this.currPanel);
	}

	public popOrHidePanel (currPanel, data?, n?) {
		void 0 === data && (data = null),
		void 0 === n && (n = null);
		for (var i = 0; i < this.panels.length; i++) {
			var a = this.panels[i];
			if (a instanceof currPanel)
				return void a.hide()
		}
		this.popPanel(currPanel, data, n)
	}

	public isPanelShow (currPanel) {
		for (var t = 0; t < this.panels.length; t++) {
			var n = this.panels[t];
			if (n instanceof currPanel){
				return true;
			}
		}
		return false;
	}

	public hidePanel (currPanel) {
		currPanel || (currPanel = this.currPanel);
		if (currPanel) {
			var t = this.panels.indexOf(currPanel);
			-1 != t && this.panels.splice(t, 1)
		}
	}

	public closeLastPanel () {
		this.currPanel && (this.currPanel.isDelayDestroy = true, this.currPanel.hide())
	}

	private popSimpleTip (e, t, n, i) {
		void 0 === i && (i = 16);
		Util.message.show(e, null, i);
	}

	private popTip (e, t) {
		void 0 === t && (t = 0);
		e && (0 === t && (t = 1e3 * e.length / 13, 600 > t && (t = 600)), Util.message.show(e, null, null, t))
	}
}

class FlyAnim {
	private targetArr:any;
	public constructor() {
		this.targetArr = [];
		UpdateTicker.instance.add(this)
	}

	private static _instance:FlyAnim = null;
	public static get instance():FlyAnim{
		if(!this._instance) {
			this._instance = new FlyAnim();
		}
		return this._instance;
	}
	
	public fly (e, t, n, i?) {
		void 0 === i && (i = null);
		var a = new FlyVo(e, t, n, i);
		this.targetArr.push(a)
	}
	
	public update (e) {
		for (var t = this.targetArr.length - 1; t >= 0; t--) {
			var n = this.targetArr[t];
			n.update(e);
			n.isOver && this.targetArr.splice(t, 1)
		}
	}
}

class FlyVo {
	private time;
	private isOver;
	private target;
	private endPos;
	private startPos;
	private controlPos;
	private callback;
	private totalTime;
	public constructor(e, t, n, i) {
		void 0 === i && (i = null);
		this.time = 0;
		this.isOver = !1;
		this.target = e;
		this.endPos = t;
		this.startPos = new egret.Point(e.x, e.y);
		var a = t.x - this.startPos.x
		var s = t.y - this.startPos.y
		var o = new egret.Point(this.startPos.x + .7 * a, this.startPos.y + .7 * s);
		this.controlPos = Util.pointRotation(t, o, 90);
		this.callback = i;
		this.totalTime = n;
		this.time = 0;
	}

	public set factor(e){
		this.target.x = (1 - e) * (1 - e) * this.startPos.x + 2 * e * (1 - e) * this.controlPos.x + e * e * this.endPos.x;
		this.target.y = (1 - e) * (1 - e) * this.startPos.y + 2 * e * (1 - e) * this.controlPos.y + e * e * this.endPos.y;
	}
	
	public update (e) {
		var t = this;
		this.time += e;
		var n = Util.limit(this.time / this.totalTime, 0, 1);
		this.factor = n;
		if(n >= 1){
			this.isOver = !0;
			egret.Tween.get(this.target).to({
				scaleX: 1.5 * this.target.scaleX,
				scaleY: 1.5 * this.target.scaleY,
				alpha: 0
			}, 300).call(()=>{
				UIUtils.removeSelf(t.target);
				t.callback && t.callback();
			})
		}
	}
}