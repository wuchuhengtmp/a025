class PanelCommon{
	public constructor(panel) {
		this.imgBg = panel.imgBg;
		this.panel = panel.panel;
		this.imgTitle = panel.imgTitle;
		this.imgIcon = panel.imgIcon;
		this._btnClose = panel.btnClose
	}

	private imgBg:eui.Image;
	private panel:eui.Group;
	private imgIcon:eui.Image;
	private imgTitle:eui.Image;
	private _btnClose:eui.Button;

	public setPanelWidth(num?:number){
		if(Util.isEmpty(num)){
			num = 540;
		}
		this.imgBg.width = num;
	}

	public setPanelHeight(num?:number){
		if(Util.isEmpty(num)){
			num = 540;
		}
		this.imgBg.height = num;
		this.panel.height = num;
	}

	public setTitleIcon(img?:string){
		if(img){
			this.imgIcon.visible = !0, this.imgIcon.source = img;
		}else{
			this.imgIcon.visible = false;
		}
	}

	public setTitle(img?:string){
		if(img){
			this.imgTitle.visible = true;
			this.imgTitle.source = img
		}else{
			this.imgTitle.visible = false
		}
	}

	public setIconOffsetX(num?:number){
		this.imgIcon.horizontalCenter = -182.5 + num;
	}

	public get btnClose(){
		return this._btnClose
	}
}