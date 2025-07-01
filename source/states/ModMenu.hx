package states;

import backend.Mod;
import backend.ModList;
import flixel.FlxG;
import flixel.FlxState;

class ModMenu extends FlxState
{
	var modlist:ModList;
    override public function new() {
        super();
		modlist = new ModList();
        trace("ModMenu state is not currently in the game, returning to MenuState.");
        FlxG.switchState(new MenuState());
		return;
    }
}
