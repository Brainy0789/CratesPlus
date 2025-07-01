package;

import backend.*;
import flixel.FlxGame;
import flixel.FlxState;
import lime.math.Vector2;
import openfl.Lib;
import openfl.display.Sprite;
import states.*;
#if (linux || mac)
import lime.graphics.Image;
#end

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
		#if (linux || mac)
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end
	}
}
