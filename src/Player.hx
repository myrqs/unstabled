import h2d.Tile;
import h2d.Text;
import hxd.Res;
import hxd.res.Sound;
import h2d.filter.Glow;

class Player extends h2d.Anim {
	var runspeed:Float = 1.5;
	var speedmult:Int = 1;

	var walkA:Array<Tile> = [];
	var attackA:Array<Tile> = [];
	var worldH:Int = 0;
	var worldW:Int = 0;

	var hittile = null;

	var stamina:Float = 0.0;
	var maxstamina:Float = 10.0;

	var statustext:Text = null;
	var font:h2d.Font = null;
	var hit_s:Sound = null;
	var failure_s:Sound = null;
	var points:Int = 0;
	var texttimer:Int = 0;

	var hp:Float = 1.0;

	public var attack:Attack = null;
	public var won:Bool = false;

	public function new(parent:h2d.Object, ww:Int, wh:Int) {
		walkA.push(hxd.Res.horse_w1.toTile());
		walkA.push(hxd.Res.horse_w2.toTile());
		walkA.push(hxd.Res.horse_w3.toTile());
		walkA.push(hxd.Res.horse_w4.toTile());

		attackA.push(hxd.Res.horse_a1.toTile());
		attackA.push(hxd.Res.horse_a2.toTile());
		attackA.push(hxd.Res.horse_a3.toTile());
		attackA.push(hxd.Res.horse_a4.toTile());
		attackA.push(hxd.Res.horse_a1.toTile());
		super(walkA, parent);

		font = hxd.res.DefaultFont.get();
		statustext = new Text(font);
		statustext.text = "";
		this.addChild(statustext);
		statustext.textColor = 0xFF0000;
		statustext.textAlign = Center;

		if (Sound.supportedFormat(Wav)) {
			hit_s = Res.sound.hit1;
			failure_s = Res.sound.hit2;
		}
		worldW = ww;
		worldH = wh;

		loop = true;
		speed = 5;
		pause = true;

		x = 160;
		y = 160;
		stamina = maxstamina;
	}

	public function hit() {
		hp -= 0.001;
	}

	public function foundItem(item:Item) {}

	public function getHP() {
		return hp;
	}

	public function getRunspeed() {
		return runspeed;
	}

	public function getMaxStamina() {
		return maxstamina;
	}

	public function setHP(hp:Float) {
		this.hp = hp;
	}

	public function setRunspeed(s:Float) {
		this.runspeed = s;
	}

	public function setMaxStamina(s:Float) {
		maxstamina = s;
	}

	public function setStamina(s:Float) {
		stamina = s;
	}

	public function setStatustext(t:String) {
		statustext.text = t;
		texttimer = 75;
	}

	public function update() {
		if (texttimer > 0)
			texttimer--;
		if (stamina <= 10) {
			stamina += 0.05;
		}
		if (texttimer == 0)
			statustext.text = "";

		if (hp >= 2.0) {
			if (filter == null) {
				filter = new Glow(0x0000FF);
			}
			if (!filter.enable)
				filter.enable = true;

			hp = 2.0;
		} else if (hp <= 1.5) {
			if (filter != null && filter.enable)
				filter.enable = false;
		}
		color.b = color.g = hp;
		if (hxd.Key.isDown(hxd.Key.D)) {
			pause = false;
			if (x + 32 + 1.0 < worldW * 32)
				x += runspeed * speedmult;
			else
				won = true;
		}
		if (hxd.Key.isDown(hxd.Key.A)) {
			if (x - 1.0 > 0)
				x -= runspeed * speedmult;
			pause = false;
		}
		if (hxd.Key.isDown(hxd.Key.S)) {
			if (y + 32 + 1.0 < worldH * 32)
				y += runspeed * speedmult;
			pause = false;
		}
		if (hxd.Key.isDown(hxd.Key.W)) {
			if (y - 1.0 > 0)
				y -= runspeed * speedmult;
			pause = false;
		}
		if (hxd.Key.isReleased(hxd.Key.W) || hxd.Key.isReleased(hxd.Key.S) || hxd.Key.isReleased(hxd.Key.A) || hxd.Key.isReleased(hxd.Key.D)) {
			pause = true;
			currentFrame = 0;
		}
		if (hxd.Key.isPressed(hxd.Key.SPACE)) {
			if (stamina >= 5.5) {
				loop = false;
				play(attackA, 0);
				if (attack == null) {
					attack = new Attack(this, 32, -32);

					stamina -= 5.5;
					attack.onAnimEnd = function() {
						attack.remove();

						var hit:Sound = null;
						if (Sound.supportedFormat(Wav)) {
							hit = Res.sound.hit1;
						}
						if (hit != null)
							hit.play();

						getScene().camera.anchorX = 0.5;
						getScene().camera.anchorY = 0.5;
						getScene().camera.rotation = 0;

						play(walkA, 0);
						pause = true;
						loop = true;
						attack = null;
					}
				}
			} else {
				if (failure_s != null)
					failure_s.play();
				setStatustext("not enough stamina");
			}
		}
		if (hxd.Key.isDown(hxd.Key.SHIFT)) {
			if (stamina >= 0.2) {
				speed = 10;
				speedmult = 2;
				stamina -= 0.2;
			} else {
				speed = 5;
				speedmult = 1;
			}
		}
		if (hxd.Key.isReleased(hxd.Key.SHIFT)) {
			speed = 5;
			speedmult = 1;
		}
	}

	public function addPoints(points:Int) {
		this.points += points;
	}

	public function getPoints() {
		return this.points;
	}

	public function isGameOver() {
		if (color.g <= 0.1 && color.b <= 0.1) {
			return true;
		}
		return false;
	}
}
