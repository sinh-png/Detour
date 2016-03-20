package detour.animation;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import detour.ui.skinable.ContextBoxBase;

class ContextTextAnimation {

	public static var typeDelay:Float = 0.1;
	
	public static var defaultTransition:ContextTextTransitionFunction = Fade;
	
	public static function None(box:ContextBoxBase):Void {
		box.contextText.text = box.contextStringText;
		box.finishTransition();
	}
	
	public static function Typing(box:ContextBoxBase):Void {
		var context = box.contextText;
		var text = box.contextStringText;
		new FlxTimer().start(typeDelay, function(timer:FlxTimer) {
			context.text = text.substr(0, text.length - timer.loopsLeft);
			if (timer.loopsLeft == 0) {
				timer.destroy();
				box.finishTransition();
			}
		}, text.length);
	}
	
	public static function Fade(box:ContextBoxBase):Void {
		var context = box.contextText;
		context.text = box.contextStringText;
		context.alpha = 0;
		FlxTween.tween(context, { alpha:1 }, 1, { ease: FlxEase.sineInOut,
			onComplete:function(_) {
				box.finishTransition();
			}
		});
	}
	
}

typedef ContextTextTransitionFunction = ContextBoxBase->Void;