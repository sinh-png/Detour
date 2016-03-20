package detour.animation;

import detour.ui.Background;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;

class BackgroundTransition {

	public static var defaultTransition:BackgroundTransitionFunction = Fade;
	
	public static function None(bg:Background, g:FlxGraphicAsset, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		var back = bg.back;
		var front = bg.front;
		back.loadGraphic(g);
		bg.finishTransition();
		if (onComplete != null) onComplete();
	}
	
	public static function Fade(bg:Background, g:FlxGraphicAsset, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		var back = bg.back;
		var front = bg.front;
		
		back.loadGraphic(g);
		FlxTween.tween(front, { alpha: 0 }, d, { ease: e,
			onComplete: function(_) {
				bg.finishTransition();
				if (onComplete != null) onComplete();
			}
		});
	}
	
	public static function SlideUp(bg:Background, g:FlxGraphicAsset, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		var back = bg.back;
		var front = bg.front;
		
		back.loadGraphic(g);
		back.y = front.height;
		FlxTween.tween(back, { y: 0 }, d, { ease: e });
		FlxTween.tween(front, { y: -front.height }, d, { ease: e,
			onComplete: function(_) {
				bg.finishTransition();
				if (onComplete != null) onComplete();
			}
		});
	}
	
	public static function SlideDown(bg:Background, g:FlxGraphicAsset, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		var back = bg.back;
		var front = bg.front;
		
		back.loadGraphic(g);
		back.y = -front.height;
		FlxTween.tween(back, { y: 0 }, d, { ease: e });
		FlxTween.tween(front, { y: front.height }, d, { ease: e,
			onComplete: function(_) {
				bg.finishTransition();
				if (onComplete != null) onComplete();
			}
		});
	}
	
	public static function SlideLeft(bg:Background, g:FlxGraphicAsset, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		var back = bg.back;
		var front = bg.front;
		
		back.loadGraphic(g);
		back.x = front.width;
		FlxTween.tween(back, { x: 0 }, d, { ease: e });
		FlxTween.tween(front, { x: -front.width }, d, { ease: e,
			onComplete: function(_) {
				bg.finishTransition();
				if (onComplete != null) onComplete();
			}
		});
	}
	
	public static function SlideRight(bg:Background, g:FlxGraphicAsset, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		var back = bg.back;
		var front = bg.front;
		
		back.loadGraphic(g);
		back.x = -front.width;
		FlxTween.tween(back, { x: 0 }, d, { ease: e });
		FlxTween.tween(front, { x: front.width }, d, { ease: e,
			onComplete: function(_) {
				bg.finishTransition();
				if (onComplete != null) onComplete();
			}
		});	
	}
	
	public static function Wave(bg:Background, g:FlxGraphicAsset, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		var back = bg.back;
		back.loadGraphic(g);
		
		var front = bg.front;
		front.visible = false;
		
		var wave = new FlxWaveEffect(null, 10, -1, 3, 5, HORIZONTAL);
		var effect = new FlxEffectSprite(front, [wave]);
		bg.add(effect);
		
		FlxTween.tween(wave, { strength: 50 },  2, { ease: e });
		FlxTween.tween(effect, { alpha: 0 }, 2, {
			ease: e,
			onComplete: function(_) {
				bg.remove(effect, true);
				
				FlxDestroyUtil.destroy(effect);
				FlxDestroyUtil.destroy(wave);
				
				front.visible = true;

				bg.finishTransition();
				if (onComplete != null) onComplete();
			}
		});
	}
	
	public static function SpinIn(bg:Background, g:FlxGraphicAsset, d:Float, e:EaseFunction, onComplete:Void->Void):Void {
		var back = bg.back;
		var front = bg.front;
		
		back.loadGraphic(g);
		FlxTween.tween(front, { angle: 1080 }, d, { ease: e });
		FlxTween.tween(front.scale, { x: 0, y: 0 }, d, { ease: e,
			onComplete: function(_) {
				front.scale.x = front.scale.y = 1;
				front.angle = 0;
				
				bg.finishTransition();
				
				if (onComplete != null) onComplete();
			}
		});	
	}
	
}

typedef BackgroundTransitionFunction = Background->FlxGraphicAsset->Float->EaseFunction->(Void->Void)->Void;