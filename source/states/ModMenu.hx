package states;

import backend.Mod;
import flixel.FlxG;
import flixel.FlxState;

class ModMenu extends FlxState
{
	var mod:Mod;
    override public function new() {
        super();
		mod = new Mod("modtemplate");
        trace("ModMenu state is not currently in the game, returning to MenuState.");
        FlxG.switchState(new MenuState());
    }
}
