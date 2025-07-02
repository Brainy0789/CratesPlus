package states.settings;

import backend.Paths;
import haxe.Json;
import states.settings.objects.Setting;
import sys.FileSystem;
import sys.io.File;

class Settings
{
    
    var defaultSettings:String;
    public var settings:Array<Setting>;
    public var config:Dynamic;

    public function new()
    {
        this.defaultSettings = 
        '{
            "controls": [["LEFT", "A"], ["DOWN", "S"], ["UP", "W"], ["RIGHT", "D"], ["Z", "ENTER", "SPACE"], ["X", "ESCAPE", "BACKSPACE"]],
            "soundvolume": 0.5,
            "musicvolume": 0.3,
            "developer": true
        }';

        var configPath = Paths.DATA + "config.json";

        if (!FileSystem.exists(config))
            saveJson(this.defaultSettings, configPath);

        this.config = loadJsonData(configPath);

    }
    
    function loadJsonData(path:String):Dynamic
	{
        var jsonText:String = File.getContent(path);
        var jsonData:Dynamic = Json.parse(jsonText);
        return jsonData;
    }

    function saveJson(content:String, path:String=""):Void {
        File.saveContent(path, content);
    }
}