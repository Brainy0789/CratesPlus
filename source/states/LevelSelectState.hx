package states;

import backend.LevelGroupConfig;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import openfl.Lib;
import states.PlayState;

class LevelSelectState extends FlxState {
    private var cfg:LevelGroupConfig;
    private var gi:Int = 0;
    private var li:Int = 0;
    private var header:FlxText;
    private var info:FlxText;

    override public function create():Void {
        super.create();
        cfg = new LevelGroupConfig("levelgroups.json");

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

        if (FlxG.keys.justPressed.LEFT)  { gi = (gi-1+cfg.groups.length)%cfg.groups.length; li=0; refresh(); }
        if (FlxG.keys.justPressed.RIGHT) { gi = (gi+1)%cfg.groups.length;      li=0; refresh(); }
        if (FlxG.keys.justPressed.UP)    { li = (li-1+cfg.groups[gi].levels.length)%cfg.groups[gi].levels.length; refresh(); }
        if (FlxG.keys.justPressed.DOWN)  { li = (li+1)%cfg.groups[gi].levels.length; refresh(); }

        if (FlxG.keys.justPressed.ENTER) {
            FlxG.switchState(new PlayState(cfg, gi, li));
        }
        if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new MenuState());
        }
    }

    private function refresh():Void {
        var g = cfg.groups[gi];
        info.text = "Pack: " + g.name +
                    "\n\nLevel " + (li+1) + "/" + g.levels.length +
                    "\n\n" + g.levels[li] +
                    "\n\n←/→ pack   ↑/↓ level   ENTER play";
    }
}
