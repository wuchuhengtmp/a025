class FastInput {
	public constructor(e, t, n, i, a, s) {
		this.exNum = 1,
		this.longTouchAddEx = 0,
		this.inpNum = e,
		this.btnAdd = t,
		this.btnSub = n,
		this.minVal = i,
		this.maxVal = a,
		this.valueChangeCallback = s,
		UIUtils.addLongTouch(this.btnSub, this.startSubExNum.bind(this), this.endSubExNum.bind(this)),
		UIUtils.addLongTouch(this.btnAdd, this.startAddExNum.bind(this), this.endAddExNum.bind(this)),
		this.btnAdd.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this),
		this.btnSub.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this),
		this.exNum = this.minVal,
		this.inpNum.text = this.minVal + "",
		UIUtils.setInputRang(this.inpNum, this.minVal, this.maxVal, (e)=>{
			this.exNum = e;
			this.valueChangeCallback && this.valueChangeCallback(e)
		})
	}

	private onTouchTap (e) {
		var t = e.target;
		t == this.btnAdd ? this.changeExNumber(1) : t == this.btnSub && this.changeExNumber(-1)
	}

	private set value(e){
		this.changeExNumber(e, !0);
	}

	private get value(){
		return this.exNum;
	}

	private changeExNumber (e, t?) {
		void 0 === t && (t = !1);
		t ? this.exNum = e : this.exNum += e;
		this.exNum = Util.limit(this.exNum, this.minVal, this.maxVal);
		this.inpNum.text = this.exNum + "";
		this.valueChangeCallback && this.valueChangeCallback(this.exNum);
	}

	private startSubExNum () {
		this.longTouchAddEx = -1;
		UpdateTicker.instance.add(this);
	}

	private endSubExNum () {
		this.longTouchAddEx = 0,
		UpdateTicker.instance.remove(this)
	}

	private startAddExNum () {
		this.longTouchAddEx = 1,
		UpdateTicker.instance.add(this)
	}

	private endAddExNum () {
		this.longTouchAddEx = 0,
		UpdateTicker.instance.remove(this)
	}

	private update (e) {
		this.changeExNumber(this.longTouchAddEx);
		if(this.exNum <= this.minVal || this.exNum >= this.maxVal){
			UpdateTicker.instance.remove(this),
			this.longTouchAddEx = 0
		}
	}

	private destroy () {
		UIUtils.removeInputRang(this.inpNum),
		UIUtils.removeLongTouch(this.btnAdd),
		UIUtils.removeLongTouch(this.btnSub),
		this.btnAdd.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this),
		this.btnSub.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this),
		UpdateTicker.instance.remove(this)
	}


	private exNum;
	private longTouchAddEx;
	private inpNum;
	private btnAdd;
	private btnSub;
	private minVal;
	private maxVal;
	private valueChangeCallback;
	private startSubExNum;
	private endSubExNum;
	private startAddExNum;
	private endAddExNum;
}