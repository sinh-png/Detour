package detour.animation;

import detour.ui.PortraitGroup;
import flixel.FlxSprite;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;

class PortraitAnimation {
	
	public static var defaultAddAnimation:PortraitAddAnimationFunction = AddFade;
	public static var defaultChangeTransition:PortraitChangeTransitionFunction = ChangeFade;
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static function AddNone(group:PortraitGroup, portrait:FlxSprite, x:Float, y:Float, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		group.finishTransition();
		if (onComplete != null) onComplete();
	}
	
	public static function AddFade(group:PortraitGroup, portrait:FlxSprite, x:Float, y:Float, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		portrait.alpha = 0;
		FlxTween.tween(portrait, { alpha: 1 }, d, { ease: e,
			onComplete: function(_) {
				group.finishTransition();
				if (onComplete != null) onComplete();
			}
		});
	}
	
	public static function AddMove(group:PortraitGroup, portrait:FlxSprite, x:Float, y:Float, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		FlxTween.tween(portrait, { x: x, y: y }, d, { ease: e,
			onComplete: function(_) {
				group.finishTransition();
				if (onComplete != null) onComplete();
			}
		});
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static function ChangeNone(group:PortraitGroup, portrait:FlxSprite, transited:FlxSprite, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		transited.kill();
		group.finishTransition();
		if (onComplete != null) onComplete();
	}
	
	public static function ChangeFade(group:PortraitGroup, portrait:FlxSprite, transited:FlxSprite, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		FlxTween.tween(transited, { alpha: 0 }, d, { ease: e,
			onComplete: function(_) {
				transited.kill();
				group.finishTransition();
				if (onComplete != null) onComplete();
			}
		});
	}
	
}

typedef PortraitAddAnimationFunction = PortraitGroup->FlxSprite-> Float->Float->Float->EaseFunction->(Void->Void)->Void;
typedef PortraitChangeTransitionFunction = PortraitGroup->FlxSprite->FlxSprite->Float->EaseFunction->(Void->Void)->Void;