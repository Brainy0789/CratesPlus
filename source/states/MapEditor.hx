package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxSave;
import haxe.Json;
import openfl.geom.Rectangle;
import sys.FileSystem;
import sys.io.File;

class MapEditor extends FlxState {
    public static inline var TILE_SIZE:Int = 64;
    public static inline var MAP_WIDTH:Int = 16;
    public static inline var MAP_HEIGHT:Int = 12;

    var tiles:Array<Array<Int>>;
    var sprites:FlxGroup;
    var palette:Array<Int> = [0,1,2,3,4,5];
    var currentTile:Int = 1;
    var infoText:FlxText;
    var lastChange:{ x:Int, y:Int, old:Int };
    var showGrid:Bool = true;

    override public function create():Void {
        super.create();
        tiles = [];
        sprites = new FlxGroup();
        add(sprites);
        for (y in 0...MAP_HEIGHT) {
            tiles[y] = [];
            for (x in 0...MAP_WIDTH) {
                tiles[y][x] = 0;
                var s = new FlxSprite(x * TILE_SIZE, y * TILE_SIZE);
                s.makeGraphic(TILE_SIZE, TILE_SIZE, 0xff888888);
                sprites.add(s);
            }
        }
        infoText = new FlxText(5, FlxG.height - 20, FlxG.width, "");
        add(infoText);
        updateInfo();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.mouse.pressed) {
            var gx = Std.int(FlxG.mouse.x / TILE_SIZE);
            var gy = Std.int(FlxG.mouse.y / TILE_SIZE);
            if (gx >= 0 && gx < MAP_WIDTH && gy >= 0 && gy < MAP_HEIGHT) {
                var newTile = FlxG.mouse.pressedRight ? 0 : currentTile;
                if (tiles[gy][gx] != newTile) {
                    lastChange = { x:gx, y:gy, old:tiles[gy][gx] };
                    tiles[gy][gx] = newTile;
                    redrawCell(gx, gy);
                }
            }
        }

        if (FlxG.keys.justPressed.ONE) currentTile = palette[0];
        if (FlxG.keys.justPressed.TWO) currentTile = palette[1];
        if (FlxG.keys.justPressed.THREE) currentTile = palette[2];
        if (FlxG.keys.justPressed.FOUR) currentTile = palette[3];
        if (FlxG.keys.justPressed.FIVE) currentTile = palette[4];
        if (FlxG.keys.justPressed.SIX) currentTile = palette[5];

        if (FlxG.keys.justPressed.G) {
            showGrid = !showGrid;
            for (y in 0...MAP_HEIGHT)
                for (x in 0...MAP_WIDTH)
                    redrawCell(x, y);
        }

        if (FlxG.keys.justPressed.S) saveMap();
        if (FlxG.keys.justPressed.L) loadMap();
        if (FlxG.keys.justPressed.E) exportToFile();
        if (FlxG.keys.justPressed.I) importFromFile();
        if (FlxG.keys.justPressed.C) clearMap();
        if (FlxG.keys.justPressed.F) fillMap(currentTile);
        if (FlxG.keys.justPressed.U) undoLast();

        updateInfo();
    }

    function redrawCell(x:Int, y:Int):Void {
        var idx = y * MAP_WIDTH + x;
        var s:FlxSprite = cast sprites.members[idx];
        var t = tiles[y][x];
        var path = "assets/images/tiles/" + t + ".png";
        if (FileSystem.exists(path)) s.loadGraphic(path); else s.makeGraphic(TILE_SIZE, TILE_SIZE, 0xff444444);
        if (showGrid) {
            s.framePixels.lock();
            s.framePixels.fillRect(new Rectangle(0, 0, TILE_SIZE, 1), 0xffffffff);
            s.framePixels.fillRect(new Rectangle(0, TILE_SIZE - 1, TILE_SIZE, 1), 0xffffffff);
            s.framePixels.fillRect(new Rectangle(0, 0, 1, TILE_SIZE), 0xffffffff);
            s.framePixels.fillRect(new Rectangle(TILE_SIZE - 1, 0, 1, TILE_SIZE), 0xffffffff);
            s.framePixels.unlock();
        }
    }

    function updateInfo():Void {
        infoText.text = "Tile:" + currentTile + " 1-6 G S L E I C F U";
    }

    function saveMap():Void {
        var save = new FlxSave();
        if (save.bind("mapdata")) {
            save.data.map = Json.stringify({ width:MAP_WIDTH, height:MAP_HEIGHT, tiles:tiles });
            save.flush();
        }
    }

    function loadMap():Void {
        var save = new FlxSave();
        if (save.bind("mapdata") && save.data.map != null) {
            var d = Json.parse(save.data.map);
            tiles = d.tiles;
            for (y in 0...MAP_HEIGHT)
                for (x in 0...MAP_WIDTH)
                    redrawCell(x, y);
        }
    }

    function exportToFile():Void {
        var json = Json.stringify({ width:MAP_WIDTH, height:MAP_HEIGHT, tiles:tiles }, "\t");
        File.saveContent("maps/map.json", json);
    }

    function importFromFile():Void {
        if (FileSystem.exists("maps/map.json")) {
            var txt = File.getContent("maps/map.json");
            var d = Json.parse(txt);
            tiles = d.tiles;
            for (y in 0...MAP_HEIGHT)
                for (x in 0...MAP_WIDTH)
                    redrawCell(x, y);
        }
    }

    function clearMap():Void {
        for (y in 0...MAP_HEIGHT)
            for (x in 0...MAP_WIDTH) {
                tiles[y][x] = 0;
                redrawCell(x, y);
            }
    }

    function fillMap(tileType:Int):Void {
        for (y in 0...MAP_HEIGHT)
            for (x in 0...MAP_WIDTH) {
                tiles[y][x] = tileType;
                redrawCell(x, y);
            }
    }

    function undoLast():Void {
        if (lastChange != null) {
            tiles[lastChange.y][lastChange.x] = lastChange.old;
            redrawCell(lastChange.x, lastChange.y);
            lastChange = null;
        }
    }
}
