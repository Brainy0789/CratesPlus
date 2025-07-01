package backend;

import backend.Paths;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

class Mod {
	public var path:String;
	public var games:Array<String> = new Array();
	public var data:Dynamic;
	public var modName:String;
	public var name:String;
	public var description:String;
	public var authors:Array<String> = new Array();
	public var homepage:String;
	public var loaderVersion:String;
	public var version:String;
	public var enabled:Bool;

	public function new(modName:String, enabled:Bool = true)
	{
		this.enabled = enabled;
		this.path = Paths.MODS + modName + "/";
		trace("Loaded mod: " + modName);
		trace("Mod path: + " + path);
		this.data = loadJsonData(path + "pack.json");
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
		games = readFolders(this.path + "data/games/");
	}

	function readFolders(path:String):Array<String>
	{
		if (!FileSystem.exists(path))
			return null;

		var array:Array<String> = new Array();
		for (directory in FileSystem.readDirectory(path))
		{
			array.push(directory);
		}

		return array;
	}

	function loadJsonData(path:String):Dynamic
	{
		var jsonText:String = File.getContent(path);
		var jsonData:Dynamic = Json.parse(jsonText);
		return jsonData;
	}
}
