package states;

import backend.LevelGroupConfig;
import backend.Mod;
import backend.ModList;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import openfl.Lib;
import states.PlayState;

class LevelSelectState extends FlxState {
	private var cfgArray:Array<LevelGroupConfig> = new Array();
    private var gi:Int = 0;
    private var li:Int = 0;
    private var header:FlxText;
    private var info:FlxText;
	private var modList:ModList;
	private var mods:Array<Mod>;

    override public function create():Void {
        super.create();
		modList = new ModList();

		for (mod in modList.mods)
		{
			for (game in mod.games)
			{
				cfgArray.push(new LevelGroupConfig(mod.path + "data/" + game + "/levelgroups.json", true));
			}
		}

		cfgArray.push(new LevelGroupConfig("levelgroups.json"));

        header = new FlxText(0,10,FlxG.width,"Select Pack");
        header.setFormat(null,24,0xffffff,"center");
        add(header);

        info = new FlxText(0,60,FlxG.width,"",true);
        info.setFormat(null,16,0xffffff,"center");
        add(info);

        refresh();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

		for (cfg in cfgArray)
		{
			if (FlxG.keys.justPressed.LEFT)
			{
				gi = (gi - 1 + cfg.groups.length) % cfg.groups.length;
				li = 0;
				refresh();
			}
			if (FlxG.keys.justPressed.RIGHT)
			{
				gi = (gi + 1) % cfg.groups.length;
				li = 0;
				refresh();
			}
			if (FlxG.keys.justPressed.UP)
			{
				li = (li - 1 + cfg.groups[gi].levels.length) % cfg.groups[gi].levels.length;
				refresh();
			}
			if (FlxG.keys.justPressed.DOWN)
			{
				li = (li + 1) % cfg.groups[gi].levels.length;
				refresh();
			}

			if (FlxG.keys.justPressed.ENTER)
			{
				FlxG.switchState(new PlayState(cfg, gi, li));
			}
		}
        
        if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new MenuState());
        }
    }

    private function refresh():Void {
		var g = cfgArray[0].groups[gi];
        info.text = "Pack: " + g.name +
                    "\n\nLevel " + (li+1) + "/" + g.levels.length +
                    "\n\n" + g.levels[li] +
                    "\n\n←/→ pack   ↑/↓ level   ENTER play";
    }
}
