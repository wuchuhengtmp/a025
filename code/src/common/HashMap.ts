class HashMap {
	private data;
	public  constructor() {
		this.data = {}
	}

	public set (e, t) {
		this.data[e] = t;
	}

	public put (e, t) {
		this.set(e, t)
	}

	public add (e, t) {
		this.set(e, t)
	}

	public get (e, t?) {
		return 1 == arguments.length ? this.data[e] : this.has(e) ? this.data[e] : t
	}

	public addNum (e, t) {
		if (Util.isNumber(t)) {
			var n = this.get(e, 0) + t;
			this.put(e, n)
		}
	}

	public has (e) {
		return this.data.hasOwnProperty(e)
	}

	public remove (e) {
		this.data[e] = void 0, delete this.data[e]
	}

	public clear () {
		this.data = {}
	}

	public keys () {
		var e = [];
		for (var t in this.data)
			e.push(t);
		return e
	}

	public intKeys () {
		var e = [];
		for (var t in this.data)
			e.push(Util.int(t));
		return e
	}

	public values () {
		var e = [];
		for (var t in this.data)
			e.push(this.data[t]);
		return e
	}
	public eachValue (e, t) {
		for (var n in this.data)
			e.call(t, this.data[n])
	}
	public forEach (e, t) {
		for (var n in this.data)
			e.call(t, n, this.data[n])
	}
	public isEmpty () {
		for (var e in this.data)
			return !1;
		return !0
	}
	public reset (e) {
		e && (this.data = e.data || e)
	}
	public parse (e) {
		if (e) {
			var t = JSON.parse(e);
			this.data = t.data
		}
	}
	public toString () {
		return JSON.stringify(this.data)
	}
}