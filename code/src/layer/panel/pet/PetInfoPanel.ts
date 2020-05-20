class PetInfoPanel extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0;
		this.isVisibleAnimate = !0;
		this.skinName = new PetInfoPanelSkin;
	}
	private tab:Tab;
	private groupTab;
	private comDetail:PetDetailPanel;
	private comSkill:PetSkillPanel;
	private btnIntroLink;
	protected createChildren(){
		super.createChildren();
		this.initTab();
		this.commonPanel.setPanelWidth(640);
		this.commonPanel.setPanelHeight(740);
		this.commonPanel.setTitleIcon("petlist_icon_png");
		this.commonPanel.setTitle("dogtitle_png");
	}

	private initTab () {
		var e = ["信息", "技能"];
		this.tab = new Tab(e,this.onTabItemClickCallback.bind(this));
		this.tab.bottom = 0;
		this.groupTab.addChild(this.tab);
		this.onTabItemClickCallback(0);
	}

	private onTabItemClickCallback (e) {
		switch (e) {
			case this.TAB_INFO:
				this.comDetail.visible = !0;
				this.comSkill.visible = !1;
				break;
			case this.TAB_SKILL:
				this.comDetail.visible = !1;
				this.comSkill.visible = !0;
				this.comSkill.netGetSkillInfo()
		}
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
		t.target == this.btnIntroLink && HttpClient.instance.openUrl("PET_INFO");
	}

	public onHide () {
		this.comDetail.confirmHide(()=>{
			EventManager.instance.dispatch(EventName.PETLIST_GETINFO);
			super.onHide();
		})
	}

	private TAB_INFO = 0;
	private TAB_SKILL = 1;

}