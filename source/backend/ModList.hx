package backend;

import backend.Mod;
import backend.Paths;
import sys.FileSystem;
import sys.io.File;

class ModList
{
	public var mods:Array<Mod> = [];

	public function new()
	{
        loadMods();
    }

    function loadMods():Void {
        if (!FileSystem.exists("mods")) return;

		for (directory in FileSystem.readDirectory("mods"))
		{
			mods.push(new Mod(directory));
		}

    }
}
