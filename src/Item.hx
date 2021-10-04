import h2d.Text;
import h2d.Font;
import h2d.RenderContext;
import hxd.Res;
import h2d.Object;
import hxd.res.Sound;
import h2d.Bitmap;
import h2d.Tile;

class Item extends Bitmap {
	var pickup_s:Sound = null;
	var font:Font = null;
	var picktext:Text = null;

	static var items:Array<Item> = [];

	var picked:Bool = false;

	public function new(t:Tile, p:Object) {
		super(t, p);

		items.push(this);

		font = hxd.res.DefaultFont.get();

		picktext = new Text(font);
		picktext.text = "";
		this.addChild(picktext);
		picktext.textColor = 0xFF0000;
	}

	public function playSound() {
		if (pickup_s != null)
			pickup_s.play(false, 0.5);
	}

	public function onPickup(from:Player) {
		playSound();
		items.remove(this);
		picked = true;
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		if (!picked) {
			if (color.a >= 0.5)
				color.a -= 0.01;
			else
				color.a = 1.0;
			if (scaleX < 1.0)
				scaleX += 0.1;
			if (scaleY < 1.0)
				scaleY += 0.1;
		}
		if (picked) {
			scaleX -= 0.1;
			scaleY -= 0.1;
			if (scaleX <= 0.1)
				remove();
		}
	}

	public static function getItemList():Array<Item> {
		return items;
	}

	public static function addItemToList(i:Item) {
		items.push(i);
	}
}

class Haystack extends Item {
	public function new(p:Object) {
		super(Res.items.hay.toTile(), p);
		if (hxd.res.Sound.supportedFormat(Wav)) {
			pickup_s = Res.sound.powerup2;
		}
	}

	public override function onPickup(from:Player) {
		from.setHP(from.getHP() + 0.2);
		from.setStatustext("HP + 0.2");
		super.onPickup(from);
	}
}

class Rake extends Item {
	public function new(p:Object) {
		super(Res.items.rake.toTile(), p);
		if (hxd.res.Sound.supportedFormat(Wav)) {
			pickup_s = Res.sound.powerup5;
		}
	}

	public override function onPickup(from:Player) {
		from.setHP(from.getHP() - 0.1);
		from.setRunspeed(from.getRunspeed() + 0.1);
		from.setStatustext("HP - 0.1\nspeed + 0.1");
		super.onPickup(from);
	}
}

class Fruit extends Item {
	public function new(p:Object) {
		super(Res.items.fruit.toTile(), p);
		if (hxd.res.Sound.supportedFormat(Wav)) {
			pickup_s = Res.sound.powerup1;
		}
	}

	public override function onPickup(from:Player) {
		from.setStamina(from.getMaxStamina());
		from.setStatustext("full stamina");
		super.onPickup(from);
	}
}

class Egg extends Item {
	public function new(p:Object) {
		super(Res.items.egg.toTile(), p);
		if (hxd.res.Sound.supportedFormat(Wav)) {
			pickup_s = Res.sound.blip2;
		}
	}

	public override function onPickup(from:Player) {
		from.setMaxStamina(from.getMaxStamina() + 10);
		from.setStamina(from.getMaxStamina());
		from.setStatustext("max. stamina + 10\nfull stamina");
		super.onPickup(from);
	}
}

class Milk extends Item {
	public function new(p:Object) {
		super(Res.items.milk.toTile(), p);
		if (hxd.res.Sound.supportedFormat(Wav)) {
			pickup_s = Res.sound.powerup7;
		}
	}

	public override function onPickup(from:Player) {
		from.setHP(1.0);
		from.setStatustext("full HP");
		super.onPickup(from);
	}
}

class Wool extends Item {
	public function new(p:Object) {
		super(Res.items.wool.toTile(), p);
		if (hxd.res.Sound.supportedFormat(Wav)) {
			pickup_s = Res.sound.powerup5;
		}
	}

	public override function onPickup(from:Player) {
		from.setHP(2.0);
		from.setStatustext("full armor");
		super.onPickup(from);
	}
}

class Freshgrass extends Item {
	public function new(p:Object) {
		super(Res.items.freshgrass.toTile(), p);
		if (hxd.res.Sound.supportedFormat(Wav)) {
			pickup_s = Res.sound.powerup6;
		}
	}

	public override function onPickup(from:Player) {
		from.addPoints(10);
		from.setStatustext("points +10");
		super.onPickup(from);
	}
}
