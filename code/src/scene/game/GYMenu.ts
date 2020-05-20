class GYMenu extends eui.Component implements  eui.UIComponent {
	public constructor() {
		super();
	}

	private static _instance:GYMenu = null;
	public static get instance():GYMenu{
		if(!this._instance) {
			this._instance = new GYMenu();
		}
		return this._instance;
	}

	protected partAdded(partName:string,instance:any):void  {
		super.partAdded(partName,instance);
	}

	private btnHome:eui.Button;
	private btnGroup:eui.Group;
	private btnNews:eui.Button;
	private btnStrategy:eui.Button;
	private btnUserCenter:eui.Button;
	private btnMarket:eui.Button;

	private isOpen:boolean;
	protected createChildren():void {
		super.createChildren();

		this.btnGroup.rotation = 90;
		this.isOpen = false;
		this.left = 0;
		this.bottom = 0;

		this.btnHome.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onToggleShow, this);
	}

	public onToggleShow(){
		AudioManager.instance.playEffect(AudioTag.BUTTON);
		this.btnHome.scaleX = this.btnHome.scaleY = 0.9
		egret.Tween.get(this.btnHome).to({
			scaleX: 1,
			scaleY: 1
		}, 250, egret.Ease.circIn);
		
		if(this.isOpen){
			this.btnGroup.removeEventListener(egret.TouchEvent.TOUCH_TAP, this.onBtnTouch, this);
			this.isOpen = false;
			this.btnGroup.rotation = 0;
			egret.Tween.get(this.btnGroup).to({
				rotation: 90
			}, 250)
		}else{
			this.btnGroup.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onBtnTouch, this);
			this.isOpen = true;
			this.btnGroup.rotation = 90;
			egret.Tween.get(this.btnGroup).to({
				rotation: 0
			}, 250, egret.Ease.circOut)
		}
	}

	private onBtnTouch(evt:egret.Event){
		this.onToggleShow();
		AudioManager.instance.playEffect(AudioTag.BUTTON);
		switch(evt.target){
			case this.btnNews:
				HttpClient.instance.openUrl("new_url");
				break;
			case this.btnStrategy:
				HttpClient.instance.openUrl("strategy_url");
				break;
			case this.btnUserCenter:
				HttpClient.instance.openUrl("userCenter_url");
				break;
			case this.btnMarket:
				//HttpClient.instance.openUrl("market_url");
				UIManager.instance.popPanel(TransferPanel);
				break;
		}
	}
	
}