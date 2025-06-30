package backend;

import sys.FileSystem;
import sys.io.File;

class ModList extends Mod {
    public var mods:Array<String> = [];

    public function new() {
        super();
        loadMods();
    }

    function loadMods():Void {
        if (!FileSystem.exists("mods")) return;

        for (file in FileSystem.readDirectory("mods")) {
            if (file.endsWith(".json")) {
                var content = File.getContent("mods/" + file);
                trace("Loaded mod config: " + file);
                mods.push(content);
            }
        }
    }
}
