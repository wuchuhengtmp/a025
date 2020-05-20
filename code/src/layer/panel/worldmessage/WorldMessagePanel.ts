class WorldMessagePanel extends PanelBase {
	private pageIndex;
	private pageMax;
	private scroller:eui.Scroller;
	private list:eui.List;
	private scrollerTouchStart;
	private btnPrev:eui.Button;
	private btnNext:eui.Button;
	private btnAdd:eui.Button;
	private labelPage:eui.Label;
	private msgprice:number;
	public constructor() {
		super(null);
		this.pageIndex = 1,
		this.pageMax = 1,
		this.isFullScreen = !0,
		this.isVisibleAnimate = !0,
		this.skinName = new WorldMessagePanelSkin
		this.msgprice=100;
	}
	protected createChildren():void {
		super.createChildren();
		this.getMsgPrice();
		this.commonPanel.setPanelWidth(590),
		this.commonPanel.setPanelHeight(830),
		// this.commonPanel.setIconOffsetX(65),
		this.commonPanel.setTitleIcon("panel_icon_log_png"),
		this.commonPanel.setTitle("msg_title_png"),
		this.initList(),
		this.changePage(1, !0)
	}
	public getMsgPrice(){
			HttpClient.instance.post("API_URL",{c:'message',a:'getMsgPrice'}).then((response:any)=>{
					this.msgprice=response.data.price;
				},(response:any)=>{
					this.msgprice=100;
				});
	}
	public onRemoved () {
		super.onRemoved();
		this.scroller.removeEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onScrollerTouchBegan, this)
	}

	private initList () {
		this.list.dataProvider = null,
		this.list.itemRenderer = WorldMessageItem,
		this.scroller.addEventListener(egret.TouchEvent.TOUCH_BEGIN, this.onScrollerTouchBegan, this)
	}

	private onScrollerTouchBegan (e) {
		this.scrollerTouchStart = e.stageX,
		this.stage.once(egret.TouchEvent.TOUCH_END, this.onScrollerTouchEnded, this, !0, Number.MAX_VALUE)
	}

	private onScrollerTouchEnded (e) {
		var t = e.stageX - this.scrollerTouchStart;
		t > 150 ? this.changePage(-1) : -150 > t && this.changePage(1)
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
		var n = t.target;
		switch (n) {
			case this.btnPrev:
				this.changePage(-1);
				break;
			case this.btnNext:
				this.changePage(1);
				break;
			case this.btnAdd:
				//this.clearLog()
				AddMessageAlert.instance.show("每发布一条世界消息消耗"+this.msgprice+"金币","请输入消息内容",(m)=>{
					this.sendMessage(m);
				});
				break;
		}
	}

	private sendMessage(msg){
		if(!msg){
			Util.message.show("请输入消息内容");
			return ;
		}
		HttpClient.instance.post("API_URL",{c:'message',a:'saveWorldMessage',msg:msg}).then((response:any)=>{
					AudioManager.instance.playEffect(AudioTag.SUCCESS)
					Util.message.show(response.msg);
					Player.instance.diamond = Math.floor(response.data.diamonds);
				},(response:any)=>{
					AudioManager.instance.playEffect(AudioTag.FAIL)
					Util.message.show(response.msg);
				});
	}

	private changePage (e, t?) {
		0 === t && (t = !1);
		this.pageMax = WorldMessageDataManager.instance.msgPageMax;
		if (t){
			this.pageIndex = e;
		} else {
			if (this.pageIndex <= 1 && 0 > e)
				return;
			if (this.pageIndex >= this.pageMax && e > 0)
				return;
			this.pageIndex += e
		}
		this.labelPage.text = this.pageIndex + "/" + this.pageMax;
		HttpClient.instance.post("API_URL", {c: 'message', a: 'list', page: this.pageIndex}).then((response:any)=>{
			WorldMessageDataManager.instance.msgPageMax = response.data.totalPage;
			WorldMessageDataManager.instance.serverInit(response.data.list);
			this.pageMax = WorldMessageDataManager.instance.msgPageMax,
			this.labelPage.text = this.pageIndex + "/" + this.pageMax;
			var t = WorldMessageDataManager.instance.msgData;
			this.list.dataProvider = new eui.ArrayCollection(t);
		}, (response:any)=>{
			Util.message.show(response.msg, null, 300);
		});
	}
}