package backend;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

@:bitmap("assets/images/tiles/basetiles.png")
class CustomTilemap extends FlxGroup {
  public var tileWidth:Int;
  public var tileHeight:Int;
  public var tiles:Array<Array<Int>>; // 2D array of tile IDs
  public var tileset:FlxGraphicAsset;

  public function new(tiles:Array<Array<Int>>, tileset:FlxGraphicAsset, tileWidth:Int, tileHeight:Int) {
    super();
    this.tiles = tiles;
    this.tileset = tileset;
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;

    buildTiles();
  }

  private function buildTiles():Void {
  for (y in 0...tiles.length) {
    for (x in 0...tiles[y].length) {
      var tileID = tiles[y][x];
      if (tileID <= 0) continue;

      var tileSprite = new FlxSprite(x * tileWidth, y * tileHeight);
      tileSprite.loadGraphic(tileset, true, 16, tileWidth, false);
      tileSprite.frame = cast(tileID - 1);
      add(tileSprite);
      }
    }
  }
}
