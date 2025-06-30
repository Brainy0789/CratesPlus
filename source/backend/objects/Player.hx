package backend.objects;

import backend.objects.MovingTile;
import lime.math.Vector2;
import flixel.FlxG;
import flixel.FlxBasic;

class Player extends MovingTile
{
    public function new(gx:Int, gy:Int, type:Int = 0, tile:Int = 5) {
        super(gx, gy, type, tile);
    }

    override public function setTile(index) {
        super.setTile(index);
    }

    override public function moveTiles(gx:Int, gy:Int=0):Vector2 {
        super.moveTiles(gx, gy);
        var moved:Vector2 = new Vector2(gx*64, gy*64);
        return moved;
    }

    override public function update(elapsed:Float) {
        super.update(this.elapsed);
        if (FlxG.keys.justPressed.LEFT) {
            this.moveTiles(-1);
        }
        if (FlxG.keys.justPressed.RIGHT) {
            this.moveTiles(1);
        }
        if (FlxG.keys.justPressed.DOWN) {
            this.moveTiles(0, 1);
        }
        if (FlxG.keys.justPressed.UP) {
            this.moveTiles(0, -1);
        }
    }
}