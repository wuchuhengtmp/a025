class SettingPanel extends PanelBase {
	public constructor() {
		super(null);
		this.isFullScreen = !0;
		this.isVisibleAnimate = !0;
		this.skinName = new SettingPanelSkin;
	}
	private btnLogout;
	private btnMusic;
	private labelMusic;
	public createChildren () {
		super.createChildren();
		this.changeAudioIcon();
	}

	public onTouchTap (t) {
		super.onTouchTap(t);
		if(t.target == this.btnLogout){
			// this.hide();
			// LocalStorage.remove("userInfo");
			// SceneManager.instance.runScene(LoginScene);
			if(!Util.isEmpty(Const.ReferUrl)){
				window.location.href=Const.ReferUrl;
			}
			else{
				window.location.href="https://bcnrc.com";
			}
		}else if(t.target == this.btnMusic){
			AudioManager.instance.setIsOpen(!AudioManager.instance.isOpen);
			this.changeAudioIcon()
		}
	}

	private changeAudioIcon () {
		this.btnMusic.source = AudioManager.instance.isOpen ? "setting_music_on_png" : "setting_music_off_png";
		this.labelMusic.text = AudioManager.instance.isOpen ? "音效已开启" : "音效已关闭";
	}
}