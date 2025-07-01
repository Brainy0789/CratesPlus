package backend;

import backend.Global;
import backend.Mod;
import backend.Paths;
import sys.FileSystem;
import sys.io.File;

class ModList
{
	public var mods:Array<Mod>;

	public function new()
	{
		this.mods = new Array();
        loadMods();
    }

    function loadMods():Void {
        if (!FileSystem.exists("mods")) return;

		for (directory in FileSystem.readDirectory("mods"))
		{
			mods.push(new Mod(directory));
		}

		Global.games = new Array();

		for (mod in mods)
		{
			for (game in mod.games)
			{
				Global.games.push(game);
			}
		}
    }
}
