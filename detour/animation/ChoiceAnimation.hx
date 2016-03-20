package detour.animation;

import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import detour.ui.ChoiceGroup;

class ChoiceAnimation {

	public static var defaultAnimation:ChoiceAnimationFunction = Drop;
	public static var duration:Float = 1;
	public static var ease:EaseFunction = FlxEase.backOut;
	
	public static function Drop(group:ChoiceGroup):Void {
		ChoicePlacement.defaultPlacement(group);
		
		var i = 0;
		for (choice in group) {
			var  y = choice.y;
			choice.y = -choice.height;
			FlxTween.tween(choice, { y: y }, duration, { 
				ease: ease,
				onComplete: function(_) {
					group.finishTransition();
				}
			});
			
			i++;
		}
	}
	
}

typedef ChoiceAnimationFunction = ChoiceGroup->Void;

class ChoicePlacement {
	
	public static var defaultPlacement:ChoicePlacementFunction;

}

typedef ChoicePlacementFunction = ChoiceGroup->Void;