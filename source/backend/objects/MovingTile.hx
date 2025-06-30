package backend.objects;

import backend.objects.Tile;
import lime.math.Vector2;

class MovingTile extends Tile {
    public var elapsed:Float = 0.0;

    public function new(gx:Int, gy:Int, type:Int = 0, tile:Int = 5) {
        super(gx, gy, type, tile);
    }

    override public function setTile(index) {
        super.setTile(index);
    }

    public function moveTiles(gx:Int, gy:Int=0):Vector2 {
        this.x += gx*64;
        this.y += gy*64;
        var moved:Vector2 = new Vector2(gx*64, gy*64);
        return moved;
    }

    override public function update(elapsed:Float) {
        elapsed = this.elapsed + 1;
    }
}