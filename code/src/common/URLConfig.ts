 class URLConfig{
	public static getPlant(e, t) {
		return t == PlantPhase.seed || 1 == e ? "resource/assets/icon/plant/plant_p0.png" : t == PlantPhase.die ? "resource/assets/icon/plant/plant_p4.png" : "resource/assets/icon/plant/" + e + "_" + t + ".png"
	}
	public static getIcon(e) {
		return "" + e + "_png"
	}
	public static getHead(e) {
		return "resource/assets/icon/head/head" + e + ".png"
	}
	public static getLand(e) {
		return "resource/assets/icon/land/" + e + ".png"
	}
	public static getSkin(e) {
		return "resource/assets/icon/skin/skin" + e + ".png"
	}
	public static getGround(e) {
		return "resource/assets/icon/skin/ground" + e + ".jpg"
	}
	public static getGroundFenceFront(e) {
		return "resource/assets/icon/skin/fence" + e + "_1.png"
	}
	public static getGroundFenceBack(e) {
		return "resource/assets/icon/skin/fence" + e + "_0.png"
	}
	public static getHouse(e) {
		return "resource/assets/icon/house/" + e + ".png"
	}
	public static getGod(e, t) {
		return "resource/assets/icon/god/god_" + e + "_" + t + ".png"
	}
}