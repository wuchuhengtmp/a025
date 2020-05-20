class FruitUseBoxPannel extends PanelBase {
	public constructor(data) {
		super(null);
		this.isFullScreen = !0;
		this.isVisibleAnimate = !0;
		this.customData = data;
		this.skinName = new FruitUseBoxSkin;
	}
	private customData;
	private bonusDesc;
	private groupCost;
	private groupBonus;
	private btnStart;
	private btnEnd;
	private price: number;
	protected createChildren() {
		super.createChildren();
		this.commonPanel.setPanelWidth(640),
			this.commonPanel.setPanelHeight(740),
		this.commonPanel.setIconOffsetX(65),
			//this.commonPanel.setTitleIcon(URLConfig.getIcon("4_" + 6 + "b")),
			this.commonPanel.setTitle("fruit_title_png"),
			this.initCost()
		this.getBonusInfo()
	}

	private getBonusInfo() {
		HttpClient.instance.post("API_URL", { c: "user", a: "fruitCheck", tId: this.customData.id }).then((response: any) => {
			this.price = response.data.startprice;
			this.showAllBonus(response.data.desc);
		});
	}

	private showAllBonus(e) {
		e && (this.bonusDesc.text = e)
	}

	private initCost() {
		var e = [[this.customData.id, "1"]];
		this.groupCost.removeChildren();
		for (let n = 0; n < e.length; n++) {
			var i = e[n][0];
			var a = e[n][1];
			var s = WareHouseDataManager.instance.getFruitData(i);
			var o = "", r = 0, h = "未知";
			s && (o = s.name, r = s.num, h = s.desc);
			var c = new CostVo({
				cId: i,
				type: 1,
				tName: o,
				num: r,
				info: h
			});
			var l = new CostItem(c.gvo, a);
			l.itemWidth(100);
			l.visibleAdd(!1),
				l.x = 125 * n + 10;
			l.y = -10;
			this.groupCost.addChild(l);
		}
	}

	private updateCost() {
		var e = [[this.customData.id, "1"]];
		var t = e.length;
		for (let n = 0; t > n; n++) {
			var i = e[n][0];
			var a = (e[n][1], WareHouseDataManager.instance.getFruitData(i));
			var s = a.num;
			var o = new CostVo({
				cId: i,
				type: 1,
				tName: a.name,
				num: s,
				info: a.desc
			});
			var r = this.groupCost.getChildAt(n);
			r.vo = o.gvo;
			r.updateShow();
		}
	}

	private showBonus(e, n, i) {
		this.bonusDesc.visible = false;
		this.groupBonus.removeChildren();
		var a = 400, s = 85, o = 0;
		//果实和种子
		if (e) {
			var r = e;
			var h = r.length;
			for (let c = 0; h > c; c++) {
				var l = r[c][0];
				var d = r[c][1] * 1;
				var u = WareHouseDataManager.instance.getFruitData(l);
				var g = (u.num,
					new CostVo({
						cId: l,
						type: 1,
						tName: u.name,
						num: d,
						info: u.desc
					})
				);
				var p = new WareHouseItem;
				p.data = g.gvo,
					p.x = 0,
					egret.Tween.get(p).to({
						x: o * s
					}, a),
					this.groupBonus.addChild(p),
					o++
			}
		}
		//道具
		if (n) {
			var m = n[0]
			var f = n[1]
			var v = WareHouseDataManager.instance.getPropData(m);
			m >= 6 && 9 >= m && (v = WareHouseDataManager.instance.getGemData(m));
			var g = new CostVo({
				cId: m,
				type: v.type,
				tName: v.name,
				num: f,
				info: v.desc
			})
			var p = new WareHouseItem;
			p.data = g.gvo,
				p.x = 0,
				egret.Tween.get(p).to({
					x: o * s
				}, a),
				this.groupBonus.addChild(p),
				o++
		}
		//原有钻石、现在的金币
		if (i) {
			var g = new CostVo({
				cId: 999,
				type: 999,
				tName: "金币",
				num: i,
				info: "你懂的"
			})
			var p = new WareHouseItem;
			p.data = g.gvo,
				p.x = 0,
				egret.Tween.get(p).to({
					x: o * s
				}, a),
				this.groupBonus.addChild(p),
				o++
		}
	}

	public onTouchTap(t) {
		super.onTouchTap(t);
		switch (t.target) {
			case this.btnStart:
				this.openBox();
				break;
			case this.btnEnd:
				var fruit = WareHouseDataManager.instance.getFruitData(this.customData.id);

				CountAlert.instance.show(1, fruit.num, (n) => {
					var i = fruit.name;
					var a = n;
					//this.vo.stock && (a = n * this.vo.stock);
					return "出售" + a + "个" + i + "获得" + n * this.price + "金币";
				}, (t) => {
					this.sellTool(t);
				});
				break;
		}
	}
	private sellTool(t) {
		if (t > 0) {
			var fruit = WareHouseDataManager.instance.getFruitData(this.customData.id);
			if (t > fruit.num) {
				Util.message.show(fruit.name + "数量不足！");
			}
			else {
				HttpClient.instance.post("API_URL", { c: "user", a: "fruitSell", tId: this.customData.id, num: t }).then((response: any) => {
					AudioManager.instance.playEffect(AudioTag.SUCCESS)
					Util.message.show(response.msg);
					Player.instance.diamond = Math.floor(response.data.diamonds);
					WareHouseNet.instance.list((responseA: any) => {
						if (responseA.code == 0) {
							EventManager.instance.dispatch(EventName.WAREHOUSE_LIST_CHANGE);
							this.updateCost();
							var t = WareHouseDataManager.instance.getFruitData(this.customData.id);
							if (t.num > 0) { this.btnEnd.label = "继续出售"; } else { this.btnEnd.visible = false; this.btnStart.visible = false; }
						}
					})

				}, (response: any) => {
					AudioManager.instance.playEffect(AudioTag.FAIL)
					Util.message.show(response.msg);
				});
			}

		}
	}
	private openBox() {
		HttpClient.instance.post("API_URL", { c: "user", a: "fruitUse", tId: this.customData.id, num: 1 }).then((response: any) => {
			Util.message.show(response.msg);
			this.showAllBonus(response.msg);
			WareHouseNet.instance.list((responseA: any) => {
				if (responseA.code == 0) {
					EventManager.instance.dispatch(EventName.WAREHOUSE_LIST_CHANGE);
					this.updateCost();
					var t = WareHouseDataManager.instance.getFruitData(this.customData.id);
					if (t.num > 0) { this.btnStart.label = "继续使用"; } else { this.btnEnd.visible = false; this.btnStart.visible = false; }
				}
			})
			this.showBonus(response.data.fruit, response.data.tool, response.data.gotdiamond);
			Player.instance.diamond = Math.floor(response.data.diamonds);
			AudioManager.instance.playEffect(AudioTag.SUCCESS)
		}, (response: any) => {
			AudioManager.instance.playEffect(AudioTag.FAIL)
			Util.message.show(response.msg);
		});
	}
}