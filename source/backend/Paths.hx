package backend;

import sys.FileSystem;

class Paths {
  public static inline var TILES:String       = "assets/images/tiles/";
  
	public static inline var MAPS:String = "assets/data/levels/";
  
  public static inline var DATA:String        = "assets/data/";
  
  public static inline var MUSIC:String       = "assets/music/";
  
  public static inline var SOUNDS:String      = "assets/sounds/";

	public static inline var MODS:String = "mods/";

	public static function getMapFile(name:String, checkMods:Bool = false):String
	{
		var p:String;

		if (checkMods)
			p = MODS + "data/levels/";
		else
			p = MAPS;

		p = p + name;
    return FileSystem.exists(p) ? p : null;
  }

	public static function getDataFile(name:String, checkMods:Bool = false):String
	{
		var p:String;

		if (checkMods)
			p = MODS + "data/";
		else
			p = DATA;

		p = p + name;
    return FileSystem.exists(p) ? p : null;
  }
}
