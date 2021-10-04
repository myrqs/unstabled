import hxd.snd.Channel;
import Item.Fruit;
import Item.Rake;
import Item.Haystack;
import hxd.snd.Manager;
import hxd.res.Sound;
import h2d.Text;
import Animal.Pig;
import Animal.Chick;
import Animal.Chicken;
import Animal.Cow;
import Animal.Sheep;

class Main extends hxd.App {
	var music:Channel = null;

	var player:Player = null;
	var currentlevelindex:Int = 0;
	var levels:Array<Level> = [];
	var tf:Text = null;
	var worldH:Int = 15;
	var worldW:Int = 0;
	var npcs:Array<Animal> = [];
	var font:h2d.Font = null;
	var wintext:Text = null;
	var items:Array<Item> = [];
	var gameover_s:Sound = null;
	var started:Bool = false;

	function startGame() {
		// init 5 stable levels
		for (x in 0...5) {
			levels.push(new Level("stable", s2d, x));
			levels[x].initWorld(s2d);
			worldW += 24;
			items = items.concat(levels[x].getLItems());
		}
		levels.push(new Level("outside", s2d, 5));
		levels[5].initWorld(s2d);
		worldW += 24;

		items = items.concat(levels[5].getLItems());

		wintext = new Text(font, s2d);
		wintext.x = worldW * 32 - 24 * 32;
		wintext.y = 0;
		wintext.textAlign = Center;
		wintext.textColor = 0xFF00FF;

		for (i in 0...10) {
			var c:Chicken = new Chicken(worldW, worldH, s2d);
			npcs.push(c);
			c.reset();
			for (o in 0...10) {
				var chick:Chick = new Chick(worldW, worldH, s2d);
				npcs.push(chick);
				chick.reset();
			}
		}
		for (i in 0...10) {
			var p:Pig = new Pig(worldW, worldH, s2d);
			npcs.push(p);
			p.reset();
		}
		for (i in 0...10) {
			var p:Cow = new Cow(worldW, worldH, s2d);
			npcs.push(p);
			p.reset();
		}
		for (i in 0...10) {
			var p:Sheep = new Sheep(worldW, worldH, s2d);
			npcs.push(p);
			p.reset();
		}
		player = new Player(s2d, worldW, worldH);

		s2d.camera.follow = player;
	}

	override function init() {
		super.init();

		s2d.scaleMode = Zoom(2.5);

		font = hxd.res.DefaultFont.get();
		// init music
		var musicResource:Sound = null;
		if (hxd.res.Sound.supportedFormat(Wav)) {
			musicResource = hxd.Res.sound.track1;
		}
		if (musicResource != null) {
			// Play the music and loop it
			music = musicResource.play(true);
		}
		s2d.camera.anchorY = 0.5;
		s2d.camera.anchorX = 0.5;
	}

	function spawnRandomItem() {
		var n:Item = null;
		switch (Math.round(Math.random() * 10)) {
			case 3:
				n = new Haystack(s2d);
			case 2:
				n = new Rake(s2d);
			case 1:
				n = new Fruit(s2d);
		}
		n.x = Math.random() * worldW * 32;
		n.y = Math.random() * worldH * 32;
		n.scale(0.1);
		Item.addItemToList(n);
	}

	function spawnRandomNpc() {
		var n:Animal = null;
		switch (Math.round(Math.random() * 10)) {
			case 4:
				n = new Cow(worldW, worldH, s2d);
			case 3:
				n = new Chicken(worldW, worldH, s2d);
			case 2:
				n = new Sheep(worldW, worldH, s2d);
			case 1:
				n = new Pig(worldW, worldH, s2d);
			default:
				n = new Chick(worldW, worldH, s2d);
		}
		n.x = 0;
		n.y = 0;
		n.reset();
		n.scale(0.1);
		npcs.push(n);
	}

	override function update(dt:Float) {
		if (started) {
			if (Math.random() * 100 <= 1)
				spawnRandomNpc();
			if (Math.random() * 100 <= 2)
				spawnRandomItem();
			if (player.isGameOver()) {
				if (tf == null) {
					tf = new Text(font);
					s2d.addChild(tf);
				}
				tf.setPosition(-1000.0, -1000.0);
				s2d.renderer.clear(0xadd8e6);
				s2d.camera.follow = tf;
				tf.text = "Game Over!\n\nSPACE - to restart";
				tf.textColor = 0xFF0000;
				tf.textAlign = Center;
				music.mute = true;
				if (hxd.Key.isPressed(hxd.Key.SPACE)) {
					s2d.removeChildren();
					tf = null;
					started = false;
				}
				// TODO: game over sound?
				return;
			}
			if (player.won) {
				if (tf == null) {
					tf = new Text(font);
					s2d.addChild(tf);
				}
				tf.setPosition(-1000.0, -1000.0);
				s2d.renderer.clear(0xadd8e6);
				s2d.camera.follow = tf;
				tf.text = "congrats you made it out and unstabled yourself.\n you got: " + player.getPoints() + " points\n\nSPACE - to try again";
				tf.textColor = 0xFFFF00;
				tf.textAlign = Center;
				music.mute = true;
				if (hxd.Key.isPressed(hxd.Key.SPACE)) {
					s2d.removeChildren();
					tf = null;
					started = false;
				}
				return;
			}

			s2d.renderer.clear(0xadd8e6);
			player.update();
			if (player.attack != null) {
				for (npc in npcs) {
					if (npc.getDead())
						npcs.remove(npc);
					if (player.attack.getBounds().intersects(npc.getBounds())) {
						npc.hit(player);
					}
				}
			}
			for (npc in npcs) {
				if (player.getBounds().intersects(npc.getBounds())) {
					player.hit();
				}
				if (npc.getDropItem() != null)
					items.push(npc.getDropItem());
			}
			for (item in Item.getItemList()) {
				if (player.getBounds().intersects(item.getBounds())) {
					item.onPickup(player);
					items.remove(item);
				}
			}
		} else {
			if (tf == null) {
				tf = new Text(font);
				s2d.addChild(tf);
			}

			tf.text = "Welcome!\n\nSPACE - to Start\nM - to mute music and sounds";
			tf.textColor = 0xFFFF00;
			tf.textAlign = Center;
			s2d.camera.follow = tf;
			if (hxd.Key.isPressed(hxd.Key.SPACE)) {
				startGame();
				started = true;
				s2d.removeChild(tf);
				tf = null;
			}
		}

		// mute music if M is pressed
		if (hxd.Key.isPressed(hxd.Key.M)) {
			if (Manager.get().masterVolume >= 1.0)
				Manager.get().masterVolume = 0.0;
			else
				Manager.get().masterVolume = 1.0;
		}
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}
