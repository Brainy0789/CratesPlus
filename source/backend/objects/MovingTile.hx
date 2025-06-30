package backend.objects;

import lime.math.Vector2;

class MovingTile extends Tile {
    public var elapsedTime:Float = 0;

    public function new(gx:Int, gy:Int, type:Int = 0, tile:Int = 5) {
        super(gx, gy, type, tile);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        elapsedTime += elapsed;
    }

    public function moveTiles(dx:Int, dy:Int = 0):Vector2 {
        this.gx += dx;
        this.gy += dy;
        moveTo(this.gx, this.gy);
        return new Vector2(dx * Tile.TILE_SIZE, dy * Tile.TILE_SIZE);
    }
}
