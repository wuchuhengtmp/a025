class WorldMessageItem extends ItemRendererBase {
	public constructor() {
		super();
		this.skinName = new WorldMessageItemSkin;
	}

	protected partAdded(partName:string,instance:any):void {
		super.partAdded(partName,instance);
	}

	private labelTime:eui.Label;
	private labelMsg:eui.Label;
	private labelOwnerName:eui.Label;
	protected createChildren():void {
		super.createChildren();
	}

	protected dataChanged() {
		var e = this.data;
		this.labelTime.text = e.time.replace("\ ", "\n");
		var t = e.desc.replace("\\n", "\n");
		this.labelMsg.text = t;
		if(e.type==1){
			this.labelTime.textColor=16747520;
			this.labelMsg.textColor=16747520;
		}
		else if(e.type==2)
		{
			this.labelTime.textColor=16724016;
			this.labelMsg.textColor=16724016;
		}
		else if(e.type==3){
			this.labelTime.textColor=15629033;
			this.labelMsg.textColor=15629033;
		}
	}
}