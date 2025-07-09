package backend.objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class ScreenFade extends FlxSprite {
    public function new(color:Int = FlxColor.BLACK, alpha:Float = 0) {
        super();
        makeGraphic(FlxG.width, FlxG.height, color);
        this.alpha = alpha;
    }

    public function fadeIn(time:Float, endAlpha:Float):Void {
        this.alpha = 0;
        FlxTween.tween(this, {alpha: endAlpha}, time);
    }

    public function fadeOut(time:Float, startAlpha:Float):Void {
        this.alpha = startAlpha;
        FlxTween.tween(this, {alpha: 0}, time, {
            onComplete: function(_) {
                this.kill();
            }
        });
    }
}
