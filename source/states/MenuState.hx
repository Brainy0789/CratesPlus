package states;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;
import states.substates.GameSelectSubState;

class MenuState extends FlxState
{
    var sections:Array<String>;
    var selected:Int = 0;
    var selectText:FlxText;
    var selectString:String;
    
    override public function new() {
        super();
        this.sections = ["Game Select", "Options", "Mod Menu"];
        this.selectString = sections[selected];
        this.selectText = new FlxText(0, 10, FlxG.width, this.selectString);
        add(selectText);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        this.selectString = sections[selected];
		this.selectText.text = "Currently Selected: " + selectString + "\n" + Std.string(selected + 1) + "/" + Std.string(sections.length);

        if (FlxG.keys.justPressed.UP) {
            this.selected -= 1;
            if (this.selected < 0)
				selected = 0;
        }
        if (FlxG.keys.justPressed.DOWN) {
            this.selected += 1;
			if (this.selected > (sections.length))
                selected = sections.length;
        }

        if (FlxG.keys.justPressed.ENTER) {
            switch (selectString) {
                case "Game Select":
                    FlxG.switchState(new GameSelectSubState());
                case "Options":
                    trace("Nothing yet.");
                case "Mod Menu":
                    FlxG.switchState(new ModMenu());
                case "Crates":
                    FlxG.switchState(new LevelSelectState());
                default:
                    trace("Unknown menu item: " + selectString + "\nCheck MenuState.hx, maybe?");
            }
        }

        if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(new MapEditor());
    }
}