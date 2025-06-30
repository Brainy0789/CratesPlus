package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Lib;
import states.LevelSelectState;

class TitleState extends FlxState {
	override public function create():Void
	{
		super.create();
		add(new FlxSprite(0, 0, "assets/images/title.png"));
		FlxG.sound.playMusic("assets/music/main.ogg");
		FlxG.mouse.visible = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE)
			Lib.application.window.close();
		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(new LevelSelectState());
		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(new MapEditor());
	}
}
