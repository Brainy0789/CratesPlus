package states.substates;

import backend.Global;
import flixel.FlxState;
class GameSelectSubState extends MenuState
{
	override public function new()
	{
		super();
		this.sections = ["Crates"];

		// This may be a bit confusing but the switch check to check for things in this class is in MenuState.hx, not this script.
		for (game in Global.games)
		{
			this.sections.push(game);
		}
	}
}