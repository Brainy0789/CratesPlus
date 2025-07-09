package backend.objects;

import Std;
import flixel.group.FlxGroup;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

class TileMap extends FlxGroup {
    public var mapData:Array<Array<Int>> = [];
    public var crates:Array<Crate>        = [];
    public var width:Int                  = 0;
    public var height:Int                 = 0;
    public var startX:Int                 = 0;
    public var startY:Int                 = 0;
    public var targetX:Int                = 0;
    public var targetY:Int                = 0;
	public var solidTiles:Array<Int> = [4];

    public function new(path:String) {
        super();
        loadMap(path);
    }

    public function loadMap(path:String):Void {
        if (path == null || !FileSystem.exists(path)) {
            trace("TileMap: '" + path + "' not found, using empty map");
            initEmptyMap();
        } else {
            try {
                var raw = File.getContent(path);
                var d:Dynamic = Json.parse(raw);
                if (d.tiles == null) throw "no tiles field";
                mapData = d.tiles;
            } catch (e:Dynamic) {
                trace("TileMap parse error: " + Std.string(e));
                initEmptyMap();
            }
        }
        height = mapData.length;
        width  = if (height > 0) mapData[0].length else 0;
        populateTiles();
    }

    private function initEmptyMap():Void {
        width = 5;
        height = 5;
        mapData = [];
        for (y in 0...height) {
            var row = new Array<Int>();
            for (x in 0...width) row.push(0);
            mapData.push(row);
        }
    }

    private function populateTiles():Void {
        crates = [];
        for (child in members.copy()) remove(child, true);

        for (y in 0...height) {
            for (x in 0...width) {
                var t = mapData[y][x];
                switch (t) {
                    case 8: 
                        startX = x; startY = y;
                        mapData[y][x] = 0;
                        add(new Tile(x, y, 0, 0));

                    case 3: 
                        targetX = x; targetY = y;
                        mapData[y][x] = 0;
                        add(new Tile(x, y, 0, 3));

                    case 2: 
                        var c = new Crate(x, y);
                        crates.push(c);
                        add(c);

                    default: 
                        add(new Tile(x, y, mapData[y][x], mapData[y][x]));
                }
            }
        }
    }

    public function isBlocked(x:Int, y:Int):Bool {
		var blocked = false;
		for (i in solidTiles)
		{
			if (i == mapData[y][x])
			{
				blocked = true;
				break;
			}
		}
		return x < 0 || y < 0 || x >= width || y >= height || blocked;
    }

    public function crateAt(x:Int, y:Int):Bool {
        for (c in crates) if (c.gx == x && c.gy == y) return true;
        return false;
    }

    public function isOccupied(x:Int, y:Int):Bool {
        return isBlocked(x, y) || crateAt(x, y);
    }

    public function isWin():Bool {
        return crateAt(targetX, targetY);
    }
}
