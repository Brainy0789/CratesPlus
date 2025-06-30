package states;

import backend.LevelGroupConfig;
import backend.objects.Player;
import backend.objects.TileMap;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import states.LevelSelectState;

class PlayState extends FlxState {
	private var cfg:LevelGroupConfig;
	private var gi:Int;
	private var li:Int;
	private var tileMap:TileMap;
	private var player:Player;
	private var status:FlxText;

	public function new(cfg:LevelGroupConfig, gi:Int, li:Int)
	{
		super();
		this.cfg = cfg;
		this.gi = gi;
		this.li = li;
	}

	override public function create():Void
	{
		super.create();
		var path = cfg.getLevelPath(gi, li);
		tileMap = new TileMap(path);
		add(tileMap);

		player = new Player(tileMap, tileMap.startX, tileMap.startY);
		add(player);
		status = new FlxText(5, 5, FlxG.width, "");
		add(status);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(new MapEditor());
		if (tileMap.isWin())
		{
			li++;
			if (li >= cfg.groups[gi].levels.length)
				FlxG.switchState(new LevelSelectState());
			else
				FlxG.switchState(new PlayState(cfg, gi, li));
		}
	}
}
