package backend.objects;

import flixel.FlxSprite;

class Tile extends FlxSprite {
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

        this.x = gx * 64;
        this.y = gy * 64;

        this.loadGraphic("assets/images/tiles/" + tile + ".png");
        this.setGraphicSize(64);
        this.updateHitbox();
        
    }

    public function setTile(index:Int):Void {
        this.tile = index;
        this.loadGraphic("assets/images/tiles/" + tile + ".png");
        this.setGraphicSize(64);
        this.updateHitbox();
    }
}