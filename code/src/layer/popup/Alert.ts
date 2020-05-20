class Alert extends eui.Component implements  eui.UIComponent {
	public constructor() {
		super();
		this.skinName = AlertSkin;
	}

	private static _instance:Alert = null;
	public static get instance():Alert{
		if(!this._instance) {
			this._instance = new Alert();
		}
		return this._instance;
	}
	
	protected partAdded(partName:string,instance:any):void {
		super.partAdded(partName,instance);
	}

	private groupPanel:eui.Group;
	private bgMask:eui.Rect;
	private btnOk:eui.Button;
	private btnNo:eui.Button;
	private labelTxt:eui.Label;
	private labelTxt2:eui.Label;

	private titleY:number;
	private okFun:any;
	private noFun:any;
	private lock:boolean = false;
	protected createChildren():void {
		super.createChildren();
		this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onTouchTap, this);
		this.titleY = this.labelTxt.y
	}

	private onTouchTap(evt:egret.Event){
		switch(evt.target){
			case this.bgMask:
				!this.noFun && this.hide();
				break;
			case this.groupPanel:
				!this.noFun && this.hide();
				break;
			case this.btnOk:
				this.hide(this.okFun);
				break;
			case this.btnNo:
				this.hide(this.noFun);
				break;
		}
	}
	
	public show(msg:string, tips?:string, okFun?:Function, noFun?:any){
		this.lock = false;
		GameLayerManager.instance.popLayer.addChild(this);
		this.labelTxt.text = msg;
		tips ? (this.labelTxt.y = this.titleY, this.labelTxt2.text = tips) : (this.labelTxt.y = this.titleY + 40, this.labelTxt2.text = "");
		noFun ? (this.btnNo.visible = !0, this.btnOk.x = 216, this.btnNo.x = 411, this.noFun = noFun) : (this.btnNo.visible = !1, this.btnOk.x = 318);
		this.okFun = okFun;
		
		this.groupPanel.scaleX = this.groupPanel.scaleY = 0;
		egret.Tween.get(this.groupPanel).to({
            scaleX: 1,
            scaleY: 1
        }, 250, egret.Ease.backOut);
	}

	private hide(func?){
		egret.Tween.get(this.groupPanel).to({
            scaleX: 0,
            scaleY: 0
        }, 250, egret.Ease.backIn).call(()=>{
			if(!this.lock){
				this.lock = true;
				if(typeof(func) == "function"){
					func && func();
				}
			}
			if(GameLayerManager.instance.popLayer.contains(this)){
				GameLayerManager.instance.popLayer.removeChild(this);
			}
		})
	}
}