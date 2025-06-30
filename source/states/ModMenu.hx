package states;

import flixel.FlxState;
import flixel.FlxG;

class ModMenu extends FlxState
{
    override public function new() {
        super();
        trace("ModMenu state is not currently in the game, returning to MenuState.");
        FlxG.switchState(new MenuState());
    }
}
