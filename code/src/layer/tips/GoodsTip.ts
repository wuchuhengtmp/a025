class GoodsTip extends eui.Component implements  eui.UIComponent {
	public constructor() {
		super();
		this.skinName = new GoodsTipSkin;
	}

	private static _instance:GoodsTip = null;
	public static get instance():GoodsTip{
		if(!this._instance) {
			this._instance = new GoodsTip();
		}
		return this._instance;
	}

	private labelName:eui.Label;
	private labelDesc:eui.Label;
	private imgIcon:eui.Image;

	private isShow:boolean = false;
	public static show(data:any, target:any){
		let goodsTip = GoodsTip.instance;
		goodsTip.imgIcon.source = URLConfig.getIcon(data.icon);
		goodsTip.labelName.text = data.tName || data.name;
		goodsTip.labelDesc.text = data.depict || data.desc;
		egret.callLater(()=>{
			goodsTip.anchorOffsetX = goodsTip.width / 2;
			goodsTip.anchorOffsetY = goodsTip.height / 2;
			
			let x = target.x;
			let y = target.y - goodsTip.height / 2 - 16;
			if(target.x < goodsTip.width / 2){
				 x = goodsTip.width / 2;
			}else{
				if(target.x > Const.stageW  - goodsTip.width / 2){
					x = Const.stageW - goodsTip.width / 2;
				}
			}

			if(target.y < .2 * Const.stageH){
				y = target.y + goodsTip.height / 2 + 20
			}

			goodsTip.x = x;
			goodsTip.y = y;
		}, this);
		goodsTip.scaleX = goodsTip.scaleY = 0;
		GameLayerManager.instance.tipsLayer.addChild(goodsTip);
		egret.Tween.get(goodsTip).to({
			scaleX: 1,
			scaleY: 1
		}, 150);
	}

	public static hide() {	
		egret.Tween.get(GoodsTip.instance).to({
			scaleX: 0,
			scaleY: 0
		}, 150).call(()=>{
			if(GameLayerManager.instance.tipsLayer.contains(GoodsTip.instance)){
				GameLayerManager.instance.tipsLayer.removeChild(GoodsTip.instance);
			}
		});
	}
	
}