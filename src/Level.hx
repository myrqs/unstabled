import h2d.Tile;
import h2d.Anim;
import Item.Fruit;
import Item.Rake;
import Item.Haystack;
import Item.Freshgrass;
import hxd.Res;

class Level {
	var bmp:h2d.Bitmap;
	var tiles:Array<Tile> = [];
	var levelW:Int = 24;
	var index:Int = 0;
	var items:Array<String> = [];
	var litems:Array<Item> = [];
	var type:String = "";

	public function new(type:String, s2d:h2d.Scene, i) {
		if (type == "stable") {
			tiles.push(hxd.Res.ground.stableground.toTile());
			items.push("haystack");
			items.push("rake");
			items.push("fruit");
		} else if (type == "outside") {
			items.push("freshgrass");
		}
		this.type = type;
		this.index = i;
	}

	public function initWorld(s2d:h2d.Scene) {
		for (x in levelW * index...levelW * (index + 1)) {
			for (y in 0...15) {
				bmp = null;
				if (tiles.length >= 2) {
					if (Math.random() < 0.4) {
						bmp = new h2d.Bitmap(tiles[0], s2d);
					} else {
						bmp = new h2d.Bitmap(tiles[1], s2d);
					}
				} else {
					if (type == "outside") {
						var g:Anim = null;
						if (Math.random() * 100 <= 10)
							g = new Anim([
								Res.ground.puddle1.toTile(),
								Res.ground.puddle2.toTile(),
								Res.ground.puddle3.toTile(),
								Res.ground.puddle4.toTile(),
								Res.ground.puddle5.toTile(),
								Res.ground.puddle6.toTile()
							], 5.0, s2d);
						else
							g = new Anim([Res.ground.grass1.toTile(), Res.ground.grass2.toTile()], 2.0, s2d);
						g.x = x * 32;
						g.y = y * 32;
					} else
						bmp = new h2d.Bitmap(tiles[0], s2d);
				}
				if (bmp != null) {
					bmp.x = x * 32;
					bmp.y = y * 32;
				}
				if ((Math.random() < 0.015) && (items.length >= 1)) {
					var itemindex:Int = 0;
					var i:Item = null;
					if (items.length > 1)
						itemindex = Math.round(Math.random() * (items.length - 1));
					switch items[itemindex] {
						case "haystack":
							i = new Haystack(s2d);
						case "rake":
							i = new Rake(s2d);
						case "fruit":
							i = new Fruit(s2d);
						case "freshgrass":
							i = new Freshgrass(s2d);
					}

					i.x = x * 32;
					i.y = y * 32;
					litems.push(i);
				}
			}
		}
	}

	public function getLItems() {
		return litems;
	}
}
