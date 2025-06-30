package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Lib;
import states.MapEditor;

class TitleState extends FlxState {
    var title:FlxSprite;

    override public function create() {
        super.create();
        title = new FlxSprite(0, 0, "assets/images/title.png");
        add(title);
        FlxG.sound.playMusic("assets/music/main.ogg");
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) {
            Lib.application.window.close();
        }

        if (FlxG.keys.justPressed.ENTER) {
            FlxG.switchState(PlayState.new);
        }

        if (FlxG.keys.justPressed.SEVEN) {
            FlxG.switchState(new MapEditor());
        }
    }
}
