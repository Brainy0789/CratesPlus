package states;

import backend.objects.*;
import flixel.FlxState;
import flixel.FlxG;

class PlayState extends FlxState {
	var player:Player;

	override public function create():Void {
		super.create();
		player = new Player(0, 0);
		add(player);
		player.setTile(5);
		FlxG.mouse.visible = false;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
