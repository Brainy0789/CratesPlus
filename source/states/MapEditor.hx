package states;

import backend.MapConfig;
import backend.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import haxe.Json;
import openfl.geom.Rectangle;
import sys.FileSystem;
import sys.io.File;

class MapEditor extends FlxState {
	public static inline var TILE_SIZE:Int = 64;
	public static inline var MAP_WIDTH:Int = 16;
    public static inline var MAP_HEIGHT:Int = 12;

	private var tiles:Array<Array<Int>>;
	private var sprites:FlxGroup;
	private var lastChange:{x:Int, y:Int, old:Int};
	private var showGrid:Bool = true;

	private var palette:Array<Int> = [
		MapConfig.FLOOR,
		MapConfig.GRASS,
		MapConfig.CRATE,
		MapConfig.TARGET,
		MapConfig.WALL,
		MapConfig.PLAYER_START
	];
	private var currentTile:Int = MapConfig.WALL;

	private var infoText:FlxText;
	private var inputMode:String = "";
	private var mapList:Array<String> = [];
	private var mapIndex:Int = 0;

    override public function create():Void {
        super.create();
		tiles = [];
        sprites = new FlxGroup();
        add(sprites);
        for (y in 0...MAP_HEIGHT) {
            tiles[y] = [];
            for (x in 0...MAP_WIDTH) {
				tiles[y][x] = MapConfig.FLOOR;
                var s = new FlxSprite(x * TILE_SIZE, y * TILE_SIZE);
                s.makeGraphic(TILE_SIZE, TILE_SIZE, 0xff888888);
                sprites.add(s);
            }
        }
        infoText = new FlxText(5, FlxG.height - 20, FlxG.width, "");
		add(infoText);
		FlxG.mouse.visible = true;
		redrawAll();
		updateInfo();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

		if (inputMode != "")
		{
			handlePrompt();
			return;
		}

        if (FlxG.mouse.pressed) {
            var gx = Std.int(FlxG.mouse.x / TILE_SIZE);
            var gy = Std.int(FlxG.mouse.y / TILE_SIZE);
            if (gx >= 0 && gx < MAP_WIDTH && gy >= 0 && gy < MAP_HEIGHT) {
				var newTile = FlxG.mouse.pressedRight ? MapConfig.FLOOR : currentTile;
                if (tiles[gy][gx] != newTile) {
					lastChange = {x: gx, y: gy, old: tiles[gy][gx]};
                    tiles[gy][gx] = newTile;
                    redrawCell(gx, gy);
                }
            }
        }

		if (FlxG.keys.justPressed.ONE)
			currentTile = palette[0];
		if (FlxG.keys.justPressed.TWO)
			currentTile = palette[1];
		if (FlxG.keys.justPressed.THREE)
			currentTile = palette[2];
		if (FlxG.keys.justPressed.FOUR)
			currentTile = palette[3];
		if (FlxG.keys.justPressed.FIVE)
			currentTile = palette[4];
		if (FlxG.keys.justPressed.SIX)
			currentTile = palette[5]; 

        if (FlxG.keys.justPressed.G) {
            showGrid = !showGrid;
			redrawAll();
        }

		if (FlxG.keys.justPressed.S)
			enterPrompt("save");
		if (FlxG.keys.justPressed.L)
			enterPrompt("load");

        if (FlxG.keys.justPressed.C) clearMap();
        if (FlxG.keys.justPressed.F) fillMap(currentTile);
        if (FlxG.keys.justPressed.U) undoLast();

        updateInfo();
    }

	private function enterPrompt(mode:String):Void
	{
		inputMode = mode;
		mapList = FileSystem.readDirectory(Paths.MAPS).filter(f -> f.length > 5 && f.toLowerCase().substr(f.length - 5) == ".json");
		if (mode == "save")
			mapList.push("<New>");
		mapIndex = 0;
	}
	private function handlePrompt():Void
	{
		if (FlxG.keys.justPressed.LEFT)
			mapIndex = (mapIndex - 1 + mapList.length) % mapList.length;
		if (FlxG.keys.justPressed.RIGHT)
			mapIndex = (mapIndex + 1) % mapList.length;

		if (FlxG.keys.justPressed.ESCAPE)
		{
			inputMode = "";
			updateInfo();
			return;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			var fn = mapList[mapIndex];
			if (inputMode == "save")
			{
				if (fn == "<New>")
				{
					var idx:Int = 1;
					do
					{
						fn = "map" + idx + ".json";
						idx++;
					}
					while (FileSystem.exists(Paths.MAPS + fn));
				}
				exportToFile(fn);
			}
			else
			{
				importFromFile(fn);
			}
			inputMode = "";
		}

		var label = if (inputMode == "save") "Save to:" else "Load from:";
		infoText.text = label + " <" + mapList[mapIndex] + ">  ←/→ ENTER ESC";
	}

	private function redrawAll():Void
	{
		for (y in 0...MAP_HEIGHT)
			for (x in 0...MAP_WIDTH)
				redrawCell(x, y);
	}
	private function redrawCell(x:Int, y:Int):Void
	{
		var idx = y * MAP_WIDTH + x;
		var s:FlxSprite = cast sprites.members[idx];
		var code = tiles[y][x];
		var path = Paths.TILES + code + ".png";

		if (FileSystem.exists(path))
		{
			s.loadGraphic(path);
		}
		else
		{
			s.makeGraphic(TILE_SIZE, TILE_SIZE, 0xff444444);
		}

		if (showGrid)
		{
			try
			{
				var bmp = s.framePixels;
				if (bmp != null)
				{
					bmp.lock();
					bmp.fillRect(new Rectangle(0, 0, TILE_SIZE, 1), 0xffffffff);
					bmp.fillRect(new Rectangle(0, TILE_SIZE - 1, TILE_SIZE, 1), 0xffffffff);
					bmp.fillRect(new Rectangle(0, 0, 1, TILE_SIZE), 0xffffffff);
					bmp.fillRect(new Rectangle(TILE_SIZE - 1, 0, 1, TILE_SIZE), 0xffffffff);
					bmp.unlock();
				}
			}
			catch (_) {}
		}
    }

	private function updateInfo():Void
	{
		if (inputMode == "")
		{
			infoText.text = "Brush="
				+ currentTile
				+ " 1=Floor 2=Grass 3=Crate 4=Target 5=Wall 6=Player  "
				+ "G=Grid S=Save L=Load C=Clear F=Fill U=Undo";
        }
    }

	private function clearMap():Void
	{
        for (y in 0...MAP_HEIGHT)
            for (x in 0...MAP_WIDTH) {
				tiles[y][x] = MapConfig.FLOOR;
                redrawCell(x, y);
            }
    }

	private function fillMap(tileType:Int):Void
	{
        for (y in 0...MAP_HEIGHT)
            for (x in 0...MAP_WIDTH) {
                tiles[y][x] = tileType;
                redrawCell(x, y);
            }
    }

	private function undoLast():Void
	{
        if (lastChange != null) {
            tiles[lastChange.y][lastChange.x] = lastChange.old;
            redrawCell(lastChange.x, lastChange.y);
            lastChange = null;
        }
    }
	private function exportToFile(filename:String):Void
	{
		var json = Json.stringify({tiles: tiles}, "\t");
		File.saveContent(Paths.MAPS + filename, json);
		trace("[MapEditor] saved → " + filename);
	}

	private function importFromFile(filename:String):Void
	{
		var path = Paths.MAPS + filename;
		if (FileSystem.exists(path))
		{
			var txt = File.getContent(path);
			var d = Json.parse(txt);
			tiles = d.tiles;
			redrawAll();
			trace("[MapEditor] loaded ← " + filename);
		}
		else
		{
			trace("[MapEditor] load failed: " + filename);
		}
	}
}
