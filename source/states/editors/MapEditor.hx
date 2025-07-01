package states.editors;

import Std;
import backend.MapConfig;
import backend.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import haxe.Json;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import sys.FileSystem;
import sys.io.File;

class MapEditor extends FlxState {
	public static inline var TILE_SIZE:Int = 64;
	public static inline var MAP_WIDTH:Int = 16;
	public static inline var MAP_HEIGHT:Int = 12;
	public static inline var PANEL_WIDTH:Int = 200;

	private var tiles:Array<Array<Int>>;
	private var sprites:FlxGroup;
	private var iconOverlayGroup:FlxGroup;
	private var uiGroup:FlxGroup;
	private var paletteSprites:FlxGroup;
	private var panel:FlxSprite;

	private var palette = [
		MapConfig.FLOOR,
		MapConfig.GRASS,
		MapConfig.CRATE,
		MapConfig.TARGET,
		MapConfig.WALL,
		MapConfig.PLAYER_START
	];
	private var currentTile:Int = MapConfig.WALL;
	private var showGrid:Bool = true;
	private var lastChange:{x:Int, y:Int, old:Int};

	private var infoText:FlxText;
	private var fileRef:FileReference;

	override public function create():Void {
		super.create();
		FlxG.mouse.visible = true;

		tiles = [];
		sprites = new FlxGroup();
		add(sprites);

		iconOverlayGroup = new FlxGroup();
		add(iconOverlayGroup);

		for (y in 0...MAP_HEIGHT) {
			tiles[y] = [];
			for (x in 0...MAP_WIDTH) {
				tiles[y][x] = MapConfig.FLOOR;
				var s = new FlxSprite(x * TILE_SIZE, y * TILE_SIZE);
				s.makeGraphic(TILE_SIZE, TILE_SIZE, 0xff888888);
				sprites.add(s);
			}
		}

		uiGroup = new FlxGroup();
		add(uiGroup);

		panel = new FlxSprite(FlxG.width - PANEL_WIDTH, 0).makeGraphic(PANEL_WIDTH, FlxG.height, 0xcc222222);
		uiGroup.add(panel);

		paletteSprites = new FlxGroup();
		uiGroup.add(paletteSprites);

		for (i in 0...palette.length)
{
	var tx = FlxG.width - PANEL_WIDTH + 20;
	var ty = 20 + i * (TILE_SIZE + 10);
	var ps = new FlxSprite(tx, ty);
	var path = Paths.TILES + palette[i] + ".png";

	if (FileSystem.exists(path)) {
		ps.loadGraphic(path, false); 
		if (palette[i] == MapConfig.PLAYER_START) {
			ps.setGraphicSize(48, 48);
			ps.updateHitbox();
		} else {
			ps.setGraphicSize(TILE_SIZE, TILE_SIZE); 
			ps.updateHitbox();
		}
	} else {
		ps.makeGraphic(TILE_SIZE, TILE_SIZE, 0xff444444);
	}

	ps.ID = palette[i];
	paletteSprites.add(ps);
}


		infoText = new FlxText(FlxG.width - PANEL_WIDTH + 10, FlxG.height - 60, PANEL_WIDTH - 20, "");
		infoText.setFormat(null, 12, 0xffffffff, "left");
		uiGroup.add(infoText);

		redrawAll();
		drawPaletteHighlight();
		updateInfo();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.mouse.justReleased) {
			var mp:FlxPoint = FlxG.mouse.getScreenPosition();
			for (member in paletteSprites.members) {
				var ps:FlxSprite = cast member;
				if (ps.overlapsPoint(mp)) {
					currentTile = ps.ID;
					drawPaletteHighlight();
					updateInfo();
					return;
				}
			}
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

		if (FlxG.keys.justPressed.ONE) currentTile = palette[0];
		if (FlxG.keys.justPressed.TWO) currentTile = palette[1];
		if (FlxG.keys.justPressed.THREE) currentTile = palette[2];
		if (FlxG.keys.justPressed.FOUR) currentTile = palette[3];
		if (FlxG.keys.justPressed.FIVE) currentTile = palette[4];
		if (FlxG.keys.justPressed.SIX) currentTile = palette[5];
		if (FlxG.keys.justPressed.G) {
			showGrid = !showGrid;
			redrawAll();
		}

		if (FlxG.keys.justPressed.S) openSaveDialog();
		if (FlxG.keys.justPressed.L) openLoadDialog();
		if (FlxG.keys.justPressed.C) clearMap();
		if (FlxG.keys.justPressed.F) fillMap(currentTile);
		if (FlxG.keys.justPressed.U) undoLast();

		drawPaletteHighlight();
		updateInfo();
	}

	private function openSaveDialog():Void {
		fileRef = new FileReference();
		fileRef.save(Json.stringify({tiles: tiles}, "\t"), "map.json");
	}

	private function openLoadDialog():Void {
		fileRef = new FileReference();
		var jsonFilter = new FileFilter("JSON files", "*.json");
		fileRef.browse([jsonFilter]);
		fileRef.addEventListener(Event.SELECT, function(_:Event):Void {
			fileRef.load();
		});
		fileRef.addEventListener(Event.COMPLETE, function(_:Event):Void {
			var data:String = cast fileRef.data;
			var d = Json.parse(data);
			tiles = d.tiles;
			redrawAll();
		});
	}

	private function redrawAll():Void {
		iconOverlayGroup.clear();
		for (y in 0...MAP_HEIGHT)
			for (x in 0...MAP_WIDTH)
				redrawCell(x, y);
	}

	private function redrawCell(x:Int, y:Int):Void {
    var idx = y * MAP_WIDTH + x;
    var s:FlxSprite = cast sprites.members[idx];
    var path = Paths.TILES + tiles[y][x] + ".png";

    if (FileSystem.exists(path)) {
        s.loadGraphic(path);
        s.setGraphicSize(TILE_SIZE, TILE_SIZE);
        s.updateHitbox();
    } else {
        s.makeGraphic(TILE_SIZE, TILE_SIZE, 0xff444444);
    }

    if (showGrid) {
        var b = s.pixels;
        b.lock();
        b.fillRect(new Rectangle(0,0,TILE_SIZE,1),0xffffffff);
        b.fillRect(new Rectangle(0,TILE_SIZE-1,TILE_SIZE,1),0xffffffff);
        b.fillRect(new Rectangle(0,0,1,TILE_SIZE),0xffffffff);
        b.fillRect(new Rectangle(TILE_SIZE-1,0,1,TILE_SIZE),0xffffffff);
        b.unlock();
    }
}


	private function drawPaletteHighlight():Void {
		for (member in paletteSprites.members) {
			var ps:FlxSprite = cast member;
			var bmp = ps.pixels;
			bmp.lock();
			var col = (ps.ID == currentTile) ? 0xffffffff : 0xff888888;
			bmp.fillRect(new Rectangle(0, 0, TILE_SIZE, 2), col);
			bmp.fillRect(new Rectangle(0, TILE_SIZE - 2, TILE_SIZE, 2), col);
			bmp.fillRect(new Rectangle(0, 0, 2, TILE_SIZE), col);
			bmp.fillRect(new Rectangle(TILE_SIZE - 2, 0, 2, TILE_SIZE), col);
			bmp.unlock();
		}
	}

	private function updateInfo():Void {
		infoText.text = [
			"Brush: " + currentTile + "  (click palette)",
			"G=Grid  C=Clear  F=Fill  U=Undo",
			"S=Save  L=Load"
		].join("\n");
	}

	private function clearMap():Void {
		for (y in 0...MAP_HEIGHT)
			for (x in 0...MAP_WIDTH) {
				tiles[y][x] = MapConfig.FLOOR;
				redrawCell(x, y);
			}
	}

	private function fillMap(tileType:Int):Void {
		for (y in 0...MAP_HEIGHT)
			for (x in 0...MAP_WIDTH) {
				tiles[y][x] = tileType;
				redrawCell(x, y);
			}
	}

	private function undoLast():Void {
		if (lastChange != null) {
			tiles[lastChange.y][lastChange.x] = lastChange.old;
			redrawCell(lastChange.x, lastChange.y);
			lastChange = null;
		}
	}
}
