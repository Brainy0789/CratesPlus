package states.settings;

import flixel.FlxState;
import states.settings.Settings;

class SettingsState extends FlxState
{
    var settings:Settings;

    public function new() {
        super();
        
        settings = new Settings();
    }
}