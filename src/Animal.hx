import Item.Wool;
import Item.Milk;
import h2d.Tile;
import h2d.col.Point;
import h2d.Text;
import h2d.Font;
import hxd.res.Sound;
import h2d.Scene;
import h2d.RenderContext;
import hxd.Res;
import h2d.Anim;
import h2d.col.Bounds;
import Item.Egg;

class Animal extends Anim {
	var walkanim:Array<Tile> = [];
	var w_anim:Anim = null;
	var armor:Float = 0.0;
	var worldW:Int = 0;
	var worldH:Int = 0;
	var vx:Float = 0.0;
	var vy:Float = 0.0;
	var vhx:Float = 0.0;
	var vhr:Float = 0.0;
	var weight:Float = 0.0;

	var points = 1;

	var font:h2d.Font = null;
	var pointtext:Text = null;
	var hitfrom:Player = null;
	var dead:Bool = false;
	var dropitem:Item = null;

	public function new(ww:Int, wh:Int, s2d:Scene) {
		worldH = wh * 32;
		worldW = ww * 32;

		vy = Math.random() * 10;
		vx = Math.random() * 10;

		loop = true;
		super(walkanim, 10, s2d);
		x = 0;
		y = 0;
		font = hxd.res.DefaultFont.get();
		pointtext = new Text(font);
	}

	public function hit(from:Player) {
		color.g -= 0.1 - armor;
		color.b -= 0.1 - armor;
		vhx = 50.0 - weight;
		vhr = 0.2;
		hitfrom = from;
	}

	public function reset() {
		if (x == 0 && y == 0) {
			x = Math.random() * (worldW - 32);
			y = Math.random() * (worldH - 32);
		}

		vy = Math.random() * 10;
		vx = Math.random() * 10;
		if (Math.random() <= 0.5)
			vy = -vy;
		if (Math.random() <= 0.5)
			vx = -vx;
	}

	public function followBounds(b:Bounds) {
		var dx:Float = b.getCenter().x - this.getBounds().getCenter().x;
		var dy:Float = b.getCenter().y - this.getBounds().getCenter().y;
		dx /= Math.abs(dx);
		dy /= Math.abs(dy);
		vx = dx * 10.0;
		vy = dy * 10.0;
	}

	function drop() {
		return;
	}

	override function sync(ctx:RenderContext) {
		if (scaleX < 1.0)
			scaleX += 0.1;
		if (scaleY < 1.0)
			scaleY += 0.1;
		if (Math.random() == 0.2)
			reset();
		if (y + walkanim[0].width >= worldH || y <= 1 || x + walkanim[0].height >= worldW || x <= 1) {
			vx = -vx;
			vy = -vy;
			reset();
		}
		if (hitfrom != null && vhx <= 0.1) {
			followBounds(hitfrom.getBounds());
		}
		if (vhx <= 0.1)
			rotation = 0;
		else
			rotation = 0.7;
		x += 0.1 * (vx + (vhx >= 0.1 ? vhx -= 1.0 : 0));
		y += 0.1 * vy;
		if (color.g <= 0.1 && color.b <= 0.1) {
			dead = true;
			var blip:Sound = null;
			if (Sound.supportedFormat(Wav)) {
				blip = Res.sound.blip1;
			}
			if (blip != null)
				blip.play();
			var deathanim:Array<Tile> = [];
			deathanim.push(Res.deathanim.death1.toTile());
			deathanim.push(Res.deathanim.death2.toTile());
			deathanim.push(Res.deathanim.death3.toTile());
			deathanim.push(Res.deathanim.death4.toTile());
			deathanim.push(Res.deathanim.death5.toTile());
			deathanim.push(Res.deathanim.death6.toTile());
			deathanim.push(Res.deathanim.death7.toTile());
			deathanim.push(Res.deathanim.death8.toTile());
			deathanim.push(Res.deathanim.death9.toTile());
			deathanim.push(Res.deathanim.death10.toTile());
			var anim:Anim = new Anim(deathanim, 10, getScene());

			anim.addChild(pointtext);
			pointtext.text = "+" + points;
			pointtext.textColor = 0x0000FF;

			if (hitfrom != null) {
				hitfrom.addPoints(points);
			}
			anim.x = x;
			anim.y = y;
			drop();
			if (dropitem != null) {
				dropitem.x = x + 32.0;
				dropitem.y = y + 32.0;
			}
			anim.onAnimEnd = function() {
				anim.remove();
			}
			remove();
		}
		super.sync(ctx);
	}

	public function getPoints() {
		return this.points;
	}

	public function getHP() {
		return color.b + color.g;
	}

	public function getDead() {
		return dead;
	}

	public function getDropItem() {
		return dropitem;
	}
}

class Chicken extends Animal {
	public function new(ww:Int, wh:Int, s2d:Scene) {
		super(ww, wh, s2d);
		walkanim.push(Res.chicken.chicken_w1.toTile());
		walkanim.push(Res.chicken.chicken_w2.toTile());
		walkanim.push(Res.chicken.chicken_w3.toTile());
		walkanim.push(Res.chicken.chicken_w4.toTile());
		walkanim.push(Res.chicken.chicken_w5.toTile());
		walkanim.push(Res.chicken.chicken_w6.toTile());
		armor = 0.01;
		weight = 5.0;
		points = 2;
	}

	override function drop() {
		dropitem = new Egg(getScene());
	}
}

class Chick extends Animal {
	public function new(ww:Int, wh:Int, s2d:Scene) {
		super(ww, wh, s2d);
		walkanim.push(Res.chick.chick_w1.toTile());
		walkanim.push(Res.chick.chick_w2.toTile());
		walkanim.push(Res.chick.chick_w3.toTile());
		walkanim.push(Res.chick.chick_w4.toTile());
		walkanim.push(Res.chick.chick_w5.toTile());
	}
}

class Pig extends Animal {
	public function new(ww:Int, wh:Int, s2d:Scene) {
		super(ww, wh, s2d);
		walkanim.push(Res.pig.pig_w1.toTile());
		walkanim.push(Res.pig.pig_w2.toTile());
		walkanim.push(Res.pig.pig_w3.toTile());
		walkanim.push(Res.pig.pig_w4.toTile());
		weight = 20.0;
		armor = 0.05;
		points = 5;
	}
}

class Cow extends Animal {
	public function new(ww:Int, wh:Int, s2d:Scene) {
		super(ww, wh, s2d);
		walkanim.push(Res.cow.cow_w1.toTile());
		walkanim.push(Res.cow.cow_w2.toTile());
		walkanim.push(Res.cow.cow_w3.toTile());
		walkanim.push(Res.cow.cow_w4.toTile());
		weight = 40.0;
		armor = 0.07;
		points = 15;
	}

	override function drop() {
		dropitem = new Milk(getScene());
	}
}

class Sheep extends Animal {
	public function new(ww:Int, wh:Int, s2d:Scene) {
		super(ww, wh, s2d);
		walkanim.push(Res.sheep.sheep_w1.toTile());
		walkanim.push(Res.sheep.sheep_w2.toTile());
		walkanim.push(Res.sheep.sheep_w3.toTile());
		walkanim.push(Res.sheep.sheep_w4.toTile());
		weight = 10.0;
		armor = 0.09;
		points = 10;
	}

	override function drop() {
		dropitem = new Wool(getScene());
	}
}
