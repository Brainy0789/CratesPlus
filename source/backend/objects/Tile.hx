package backend.objects;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class Tile extends FlxSprite {
    public static inline var TILE_SIZE:Int = 64;

    public var gx:Int;
    public var gy:Int;
    public var type:Int;
    public var tile:Int;

    public function new(gx:Int, gy:Int, type:Int = 0, tile:Int = 5) {
        super();
		this.gx = gx;
		this.gy = gy;
        this.type = type;
        this.tile = tile;
		loadGraphic("assets/images/tiles/" + tile + ".png");
		setGraphicSize(TILE_SIZE);
		updateHitbox();
		moveTo(gx, gy, 0);
    }

    public function setTile(index:Int):Void {
        this.tile = index;
		loadGraphic("assets/images/tiles/" + tile + ".png");
		setGraphicSize(TILE_SIZE);
		updateHitbox();
    }

	public function moveTo(gx:Int, gy:Int, duration:Float = 0.25):Void
	{
		this.gx = gx;
		this.gy = gy;
		var targetX = gx * TILE_SIZE + (TILE_SIZE - this.width) / 2;
		var targetY = gy * TILE_SIZE + (TILE_SIZE - this.height) / 2;
		if (duration <= 0)
		{
			this.x = targetX;
			this.y = targetY;
		}
		else
		{
			FlxTween.tween(this, {x: targetX, y: targetY}, duration);
		}
	}
}
