import h2d.Tile;
import h2d.Object;
import h2d.RenderContext;
import hxd.Res;
import h2d.Anim;

class Attack extends Anim {

	public function new(parent:Object, x, y) {
		var t:Array<Tile> = [];
		t.push(Res.attack1.toTile());
		t.push(Res.attack2.toTile());
		t.push(Res.attack3.toTile());
		t.push(Res.attack4.toTile());
		t.push(Res.attack5.toTile());
		t.push(Res.attack6.toTile());
		super(t, parent);
		speed = 10;
		
        this.x = x;
		this.y = y;
	}

	override function sync(ctx:RenderContext) {
		var plusOrMinus:Int = Math.random() < 0.5 ? -1 : 1;
		if (curFrame > 4) {
			getScene().camera.anchorX += Math.random() * 0.007 * plusOrMinus;
			getScene().camera.anchorY += Math.random() * 0.007 * plusOrMinus;
		}
		super.sync(ctx);
	}
}
