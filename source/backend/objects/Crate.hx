package backend.objects;

class Crate extends MovingTile {
    public function new(gx:Int, gy:Int, tile:Int = 2) {
        super(gx, gy, 0, tile);
    }
}
