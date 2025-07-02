package states.substates;

import backend.Mod;
import backend.ModList;
import flixel.FlxState;

class GameSelectSubState extends MenuState {
	var modList:ModList;
	var mods:Array<Mod>;

     override public function new() {
        super();
		modList = new ModList();
		mods = modList.mods;
		this.sections = ["Crates", "Crates Original", "Crates 2 Original"];
		if (mods.length > 0)
			this.sections.push("Mods");

		// This may be a bit confusing but the switch check to check for things in this class is in MenuState.hx, not this script.
    }
}