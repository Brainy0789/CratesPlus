package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Lib;
import states.LevelSelectState;
import states.editors.MapEditor;

class TitleState extends FlxState {
	var music:Bool;

	override public function new(music:Bool = true):Void
	{
		super();
		this.music = music;
	}

	override public function create():Void
	{
		super.create();
		if (music == true) 
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
			FlxG.switchState(new MenuState());
		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(new MapEditor());
	}
}
