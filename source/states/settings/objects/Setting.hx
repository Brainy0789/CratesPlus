package states.settings.objects;

import flixel.FlxSprite;
import haxe.Json;
import sys.io.File;

class Setting
{
    public var name:String;
    public var value:Dynamic; // Can be any type, such as Bool, Int, Float, String, etc.
    public var type:String; // "bool", "int", "float", "string", etc.

    public function new() {
        this.name = "";
        this.value = null;
        this.type = "string";
    }
}