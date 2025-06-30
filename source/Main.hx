package;

import backend.*;
import flixel.FlxState;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.*;
import lime.math.Vector2;

class Main extends Sprite
{
	public function new()
	{
		var windowSize:Vector2 = new Vector2(1280, 720);
		var frameRate:Int = 60;
		var drawRate:Int = 60;
		var skipSplash:Bool = true;
		var startInFullScreen = false;
		super();
		addChild(new FlxGame(Std.int(windowSize.x), Std.int(windowSize.y), states.TitleState, frameRate, drawRate, skipSplash, startInFullScreen));
	}
}
