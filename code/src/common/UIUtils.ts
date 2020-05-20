class UIUtils {
	public constructor() {
	}
	public static shortTouchEndCallback:any;
	public static longTouchDelayId:any;
	public static longTouchTrigger:any;
	public static longTouchEndCallback:any;
	public static addButtonScaleEffects (t, n?) {
		n === 0 && (n = false);
		if (t){
			if (n){
				t.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onButtonTouchBegan, t);
			} else if(egret.is(t, egret.getQualifiedClassName(eui.Button))){
				t.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onButtonTouchBegan, t);
			}else{
				var i = t.numChildren;
				for (let a = 0; i > a; a++) {
					var s = t.getChildAt(a);
					this.addButtonScaleEffects(s);
				}
			}
		}
	}

	public static onButtonTouchBegan (evt:egret.Event) {
		var target = evt.target;
		egret.Tween.get(target).to({
			scaleX: .9,
			scaleY: .9
		}, 50).to({
			scaleX: 1,
			scaleY: 1
		}, 50);
		target[Const.NO_AUDIO_TAG] || AudioManager.instance.playEffect(AudioTag.BUTTON);
	}

	public static removeButtonScaleEffects (t, n?) {
		n === 0 && (n = false);
		if (t){
			if (n){
				t.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onButtonTouchBegan, t);
			} else if(egret.is(t, egret.getQualifiedClassName(eui.Button))){
				t.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onButtonTouchBegan, t);
			}else{
				var i = t.numChildren;
				for (let a = 0; i > a; a++) {
					var s = t.getChildAt(a);
					this.removeButtonScaleEffects(s);
				}
			}
		}
	}

	public static addShortTouch (t, n, i) {
		t.shortTouchCallback = n, t.shortTouchEndCallback = i, t.addEventListener(egret.TouchEvent.TOUCH_BEGIN, UIUtils._onShortTouchBegan, t)
	}

	private static _onShortTouchBegan (t) {
		var n = t.currentTarget;
		n.shortTouchCallback && n.shortTouchCallback(t), Const.stage.once(egret.TouchEvent.TOUCH_END, UIUtils._onShortTouchEnd, this, !0, Number.MAX_VALUE)
	}

	private static _onShortTouchEnd (e) {
		e.stopImmediatePropagation(), e.stopPropagation();
		this.shortTouchEndCallback && this.shortTouchEndCallback(e)
	}

	public static addLongTouch (t, n, i) {
		t.longTouchCallback = n;
		t.longTouchEndCallback = i;
		t.longTouchTrigger = !1;
		t.addEventListener(egret.TouchEvent.TOUCH_BEGIN, UIUtils._onLongTouchBegan, t)
	}

	private static _onLongTouchBegan (t) {
		var n = this, i = t.currentTarget;
		Const.stage.once(egret.TouchEvent.TOUCH_END, UIUtils._onLongTouchEnd, this, true, Number.MAX_VALUE);
		egret.clearTimeout(this.longTouchDelayId);
		this.longTouchDelayId = egret.setTimeout(()=>{
			i.longTouchTrigger = true;
			i.longTouchCallback && i.longTouchCallback(t);
			i.once(egret.TouchEvent.TOUCH_TAP, UIUtils ._stopTapEvent, n, !0, Number.MAX_VALUE)
		}, this, 350)
	}

	private static _stopTapEvent (e) {
		e.stopImmediatePropagation(), e.stopPropagation()
	}

	private static _onLongTouchEnd (t) {
		t.stopImmediatePropagation(), t.stopPropagation();
		var n = this;
		n.longTouchTrigger ? n.longTouchEndCallback && n.longTouchEndCallback(t) : egret.clearTimeout(this.longTouchDelayId), n.longTouchTrigger = !1
	}

	public static removeLongTouch (t) {
		t.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this._onLongTouchBegan, t)
	}

	public static removeSelf (target) {
		target && target.parent && target.parent.removeChild(target)
	}

	public static  setInputRang (t, n, i, a, s?) {
		void 0 === a && (a = null);
		void 0 === s && (s = !0);
		t.minValue = n;
		t.maxValue = i;
		t.valueChangeCallback = a;
		this.removeInputRang(t);
		t.addEventListener(egret.Event.CHANGE, this.__inpChangeEvent, t);
		t.addEventListener(egret.Event.FOCUS_OUT, this.__inpChangeEvent, t);
		s && t.once(egret.Event.REMOVED_FROM_STAGE, ()=>{
			this.removeInputRang(t);
		}, this)
	}

	public static removeInputRang (t) {
		if(t){
			t.removeEventListener(egret.Event.CHANGE, this.__inpChangeEvent, t);
			t.removeEventListener(egret.Event.FOCUS_OUT, this.__inpChangeEvent, t);
		}
	}

	private static  __inpChangeEvent (e) {
		var t = e.currentTarget;
		if (t.text || e.type != egret.Event.CHANGE) {
			var n = Util.int(t.text) || 0
			var i = t.minValue
			var a = t.maxValue
			var s = t.valueChangeCallback;
			n = Util.limit(n, i, a);
			t.text = n + "";
			s && s(n);
		}
	}
}