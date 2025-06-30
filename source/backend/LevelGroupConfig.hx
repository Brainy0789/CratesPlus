package backend;

import Std;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

typedef LevelGroup = {
  public var name:String;
  public var levels:Array<String>;
}

class LevelGroupConfig {
  public var groups:Array<LevelGroup>;

  public function new(configName:String) {
    var path = Paths.getDataFile(configName);
    if (path == null) {
      trace("Missing levelgroups.json");
      groups = [];
      return;
    }
    try {
      var raw = File.getContent(path);
      var d:Dynamic = Json.parse(raw);
      groups = (d.groups:Array<Dynamic>).map(e -> {
        { name: e.name, levels: (e.levels:Array<String>) }
      });
    } catch (e:Dynamic) {
      trace("Parse error: " + Std.string(e));
      groups = [];
    }
  }

  public function getLevelPath(gi:Int, li:Int):String {
    if (gi < 0 || gi >= groups.length) return null;
    var lvl = groups[gi].levels;
    if (li < 0 || li >= lvl.length) return null;
    return Paths.getMapFile(lvl[li]);
  }
}
