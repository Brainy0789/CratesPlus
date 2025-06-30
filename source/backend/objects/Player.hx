package backend.objects;

import backend.objects.MovingTile;
import flixel.FlxG;
import lime.math.Vector2;

class Player extends MovingTile {
    public function new(gx:Int, gy:Int, type:Int = 0, tile:Int = 5) {
        super(gx, gy, type, tile);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.LEFT) {
            moveTiles(-1, 0);
        }
        if (FlxG.keys.justPressed.RIGHT) {
            moveTiles(1, 0);
        }
        if (FlxG.keys.justPressed.DOWN) {
            moveTiles(0, 1);
        }
        if (FlxG.keys.justPressed.UP) {
            moveTiles(0, -1);
        }
    }
}
