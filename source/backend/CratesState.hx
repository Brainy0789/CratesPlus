package backend;

import backend.objects.ScreenFade;
import flixel.FlxState;

class CratesState extends FlxState {
    private var fade:ScreenFade;

    public function new() {
        super();
        fade = new ScreenFade();
        add(fade);
        fade.fadeIn(.1, 0);
        fade.fadeOut(.1, 1);
    }
}