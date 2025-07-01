package backend;

import backend.Paths;
import haxe.Json;
import sys.io.File;

class Mod {
	var modPath:String;
	var games:Array<String> = new Array();
	var data:Dynamic;
	var modName:String;
	var name:String;
	var description:String;
	var authors:Array<String> = new Array();
	var homepage:String;
	var loaderVersion:String;
	var version:String;

	public function new(modName:String)
	{
		this.modPath = Paths.MODS + modName + "/";
		trace("Loaded mod: " + modName);
		trace("Mod path: + " + modPath);
		this.data = loadJsonData(modPath + "pack.json");
		this.name = this.data.name;
		this.description = this.data.description;
		this.authors = this.data.authors;
		this.homepage = this.data.homepage;
		this.loaderVersion = this.data.modloaderversion;
		this.version = this.data.version;

		trace("MOD DATA:");
		trace("Name: " + this.name);
		trace("Description: " + this.description);

		var j:Int = 1;
		for (i in this.authors)
		{
			trace("Author " + j + ": " + i);
			j += 1;
		}

		trace("Homepage: " + this.homepage);
		trace("Modloader Version: " + this.loaderVersion);
		trace("Mod Version: " + this.version);
	}

	function loadJsonData(path:String):Dynamic
	{
		var jsonText:String = File.getContent(path);
		var jsonData:Dynamic = Json.parse(jsonText);
		return jsonData;
    }
}
