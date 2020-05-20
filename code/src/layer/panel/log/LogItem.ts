class LogItem extends ItemRendererBase {
	public constructor() {
		super();
		this.skinName = new LogItemSkin;
	}

	protected partAdded(partName:string,instance:any):void {
		super.partAdded(partName,instance);
	}

	private imgIcon:eui.Image;
	private imgIcon2:eui.Image;
	private labelTime:eui.Label;
	private labelLog:eui.Label;
	private labelOwnerName:eui.Label;
	protected createChildren():void {
		super.createChildren();
	}

	private textToCropIcon (e) {
		var t = "";
		if(e.indexOf("萝卜") >= 0){
			t = "1_80004";
		}else if(e.indexOf("苹果") >= 0){
			t = "1_80005";
		}else if(e.indexOf("辣椒") >= 0){
			t = "1_80006";
		}else if(e.indexOf("西瓜") >= 0){
			t = "1_80007";
		}else if(e.indexOf("南瓜") >= 0){
			t = "1_80012";
		}else if(e.indexOf("草莓") >= 0){
			t = "1_80013";
		}else if(e.indexOf("玫瑰") >= 0){
			t = "1_80011";
		}else if(e.indexOf("核桃") >= 0){
			t = "1_80008";
		}else if(e.indexOf("可可") >= 0){
			t = "1_80009";
		}else if(e.indexOf("人参") >= 0){
			t = "1_80010";
		}else if(e.indexOf("雪莲花") >= 0){
			t = "1_80015";
		}else if(e.indexOf("开心果") >= 0){
			t = "1_80014";
		}else if(e.indexOf("猕猴桃")){
			t = "1_80099";
		}
		return t;
	}

	private textToGemIcon (e) {
		var t = "";
		if(e.indexOf("绿宝石") >= 0){
			t = "3_13";
		}else if(e.indexOf("紫宝石") >= 0){
			t = "3_14";
		}else if(e.indexOf("蓝宝石") >= 0){
			t = "3_15";
		}else if(e.indexOf("黄宝石") >= 0){
			t = "3_16";
		}
		return t;
	}

	protected dataChanged() {
		var e = this.data;
		this.labelTime.text = e.time.replace("\ ", "\n");
		var t = e.desc.replace("\\n", "\n");
		this.labelLog.text = t;
		var n = "", i = "";
		if(t.indexOf("收获") >= 0 || t.indexOf("奖励") >= 0){
			n = this.textToCropIcon(t);
		}
		if(t.indexOf("意外") >= 0){
			i = this.textToGemIcon(t)
		}
		if(n && i){
			this.imgIcon2.source = URLConfig.getIcon(n);
			this.imgIcon.source = URLConfig.getIcon(i);
		}else{
			if(n){
				this.imgIcon.source = URLConfig.getIcon(n)
			}else if(i){
				this.imgIcon.source = URLConfig.getIcon(i)
			}
		}
	}
}