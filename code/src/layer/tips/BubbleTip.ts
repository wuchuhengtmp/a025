class BubbleTip extends eui.Component implements  eui.UIComponent {
	private isBusy:boolean;
	private groupBubble:eui.Group;
	private labelContent:eui.Label;
	private content;
	public constructor() {
		super();
		this.isBusy = !1;
		this.skinName = "BubbleTipSkin";
		this.groupBubble.scaleX = this.groupBubble.scaleY = 0;
		this.touchChildren = this.touchEnabled = false;
	}

	protected partAdded(partName:string,instance:any):void {
		super.partAdded(partName,instance);
	}


	protected createChildren():void {
		super.createChildren();
	}

	public showLoop (content) {
		var t = this;
		this.content = content;
		if(!this.isBusy){
			this.labelContent.text = content;
			this.isBusy = true;
			egret.Tween.get(this.groupBubble).set({
				scaleX: 0,
				scaleY: 0
			}).wait(1e3).to({
				scaleX: 1,
				scaleY: 1
			}, 800, egret.Ease.elasticOut).wait(6e3).to({
				scaleX: 0,
				scaleY: 0
			}, 300, egret.Ease.quadOut).wait(1e4).call(()=>{
				t.isBusy = false;
				t.showLoop(t.content)
			})
		}
	}
	
	public show (e, t, n) {
		void 0 === n && (n = 6e3);
		this.labelContent.text = e,
		egret.Tween.get(this.groupBubble).set({
			scaleX: 0,
			scaleY: 0
		}).to({
			scaleX: 1,
			scaleY: 1
		}, 800, egret.Ease.elasticOut).wait(n).to({
			scaleX: 0,
			scaleY: 0
		}, 300, egret.Ease.quadOut).call(()=>{
			t && t()
		})
	}
}