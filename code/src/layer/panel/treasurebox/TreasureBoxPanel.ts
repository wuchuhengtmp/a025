class TreasureBoxPanel extends PanelBase {
	public constructor(data) {
		super(null);
		this.isFullScreen = !0;
		this.isVisibleAnimate = !0;
		this.customData = data;
		this.skinName = new TreasureBoxSkin;
	}
	private customData;
	private bonusDesc;
	private groupCost;
	private groupBonus;
	private btnStart;
	private boxType = {
		4: "cchest", //铜宝箱
		5: "schest", //银宝箱
		6: "gchest", //金宝箱
		7: "dchest"	//金币宝箱
	};
	protected createChildren() {
		super.createChildren();
		this.commonPanel.setPanelWidth(640),
			this.commonPanel.setPanelHeight(740),
			this.commonPanel.setTitleIcon(URLConfig.getIcon("4_" + this.customData.id + "b")),
			this.commonPanel.setTitle("boxtitle_" + this.customData.id + "_png"),
			this.initCost(),
			this.getBonusInfo()
	}

	private getBonusInfo() {
		HttpClient.instance.post("API_URL", { c: "user", a: "chestCheck", tId: this.customData.id, mark: this.boxType[this.customData.id] }).then((response: any) => {
			this.showAllBonus(response.data.desc);
		});
	}

	private showAllBonus(e) {
		e && (this.bonusDesc.text = e)
	}

	private initCost() {
		if (this.customData.id == 7) {
			this.bonusDesc.y += 10;
			this.bonusDesc.text = "可能获得的奖励： 50~10000金币";
		}
		var e = this.customData.data.costs;
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
			l.x = 125 * n + 10;
			l.y = -10;
			this.groupCost.addChild(l);
		}

		var r = WareHouseDataManager.instance.getPropNum(this.customData.id);

		var c = new CostVo({
			cId: this.customData.id,
			type: 4,
			tName: this.customData.name,
			num: r,
			info: this.customData.data.depict
		})

		var l = new CostItem(c.gvo, 1);
		l.itemWidth(100),
			l.visibleAdd(!1),
			l.x = 125 * e.length + 20,
			l.y = -10,
			this.groupCost.addChild(l)
	}

	private updateCost() {
		var e = this.customData.data.costs;
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
		var num: number = WareHouseDataManager.instance.getPropNum(this.customData.id)
		var o = new CostVo({
			cId: this.customData.id,
			type: 4,
			tName: this.customData.name,
			num: num,
			info: this.customData.data.depict
		})
		var r = this.groupCost.getChildAt(t);
		r.vo = o.gvo;
		r.updateShow();
	}

	private showBonus(e, t, n, i) {
		this.bonusDesc.visible = false;
		this.groupBonus.removeChildren();
		var a = 400, s = 85, o = 0;
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

		if (t) {
			var g = new CostVo({
				cId: 1,
				type: "coin",
				tName: "金币",
				num: t,
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
		}
	}

	private openBox() {
		HttpClient.instance.post("API_URL", { c: "user", a: "chestOpen", tId: this.customData.id, mark: this.boxType[this.customData.id] }).then((response: any) => {
			Util.message.show(response.msg);
			WareHouseNet.instance.list((responseA: any) => {
				if (responseA.code == 0) {
					EventManager.instance.dispatch(EventName.WAREHOUSE_LIST_CHANGE);
					this.updateCost();
					var t = WareHouseDataManager.instance.getPropNum(this.customData.id);
					t > 0 ? this.btnStart.label = "再开一次" : this.btnStart.visible = false;
				}
			})
			this.showBonus(response.data.fruit, response.data.coin, response.data.tool, response.data.diamond);
			response.data.diamond && (Player.instance.diamond += response.data.diamond);
			AudioManager.instance.playEffect(AudioTag.OPEN_BOX);
		}, (response: any) => {
			Util.message.show(response.msg);
		});
	}
}