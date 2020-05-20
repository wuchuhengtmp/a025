class Message extends eui.Component implements  eui.UIComponent {
	private msg:string;
	public constructor() {
		super();
		this.skinName = MessageSkin;
	}

	private static _instance:Message = null;
	public static get instance():Message{
		if(!this._instance) {
			this._instance = new Message();
		}
		return this._instance;
	}

	protected partAdded(partName:string,instance:any):void {
		super.partAdded(partName,instance);
	}
	protected createChildren():void {
		super.createChildren();
		this.horizontalCenter = 0;
		this.scaleX = this.scaleY = 0;
		this.y = 380;
	}
	public show(str:string, callFun?:Function, posiY?:number, time?:number){
		GameLayerManager.instance.tipsLayer.addChild(this);
		if(posiY){
			this.y = posiY;
		}else{
			this.y = 380;
		}
		time || (time = 1200);
		egret.Tween.removeTweens(this);
		this.msg = str;
		egret.Tween.get(this).to({scaleX: 1, scaleY: 1}, 200, egret.Ease.backOut).wait(time).to({scaleX: 0, scaleY: 0}, 200, egret.Ease.backIn).call(()=>{
			if(typeof(callFun) == "function"){
				callFun();
			}
		});
	}
}