package states.editors;

import flixel.FlxState;
import states.MenuState;
import states.editors.MapEditor;

class MasterEditor extends MenuState {
    override public function new() {
        super();
        this.sections = ["Map Editor"];
    }
}