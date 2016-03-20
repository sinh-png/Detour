package detour.ui;

import detour.animation.BackgroundTransition;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.util.FlxDestroyUtil;

class Background extends FlxTypedGroup<FlxSprite> {
	
	public var back:FlxSprite;
	public var front:FlxSprite;
	
	public function new() {
		super();
		
		back = new FlxSprite();
		add(back);
		
		front = new FlxSprite();
		front.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		add(front);
	}
	
	override public function kill():Void {
		super.kill();
		back.kill();
		front.kill();
	}
	
	override public function revive():Void {
		super.revive();
		back.revive();
		front.revive();
	}
	
	override public function destroy():Void {
		super.destroy();
		FlxDestroyUtil.destroy(back);
		FlxDestroyUtil.destroy(front);
	}
	
	public function setBG(
		g:FlxGraphicAsset, 
		?transitionFunction:BackgroundTransitionFunction, 
		?duration:Float = 1, ?ease:EaseFunction,
		?onComplete:Void->Void
	):FlxSprite {
		
		if (transitionFunction == null) {
			if (BackgroundTransition.defaultTransition == null) 
				transitionFunction = BackgroundTransition.None;
			else
				transitionFunction = BackgroundTransition.defaultTransition;
		}
		
		ContextState.current.inProcessActionCount++;
		
		back.visible = true;
		if (ease == null) ease = FlxEase.sineInOut;
		
		transitionFunction(this, g, duration, ease, onComplete);
		
		return front;
	}
	
	public function finishTransition():Void {
		front.loadGraphicFromSprite(back);
		
		front.x = front.y = back.x = back.y = 0;
		
		front.visible = true;
		back.visible = false;
		
		front.alpha = 1;
		back.alpha = 1;
		
		ContextState.current.inProcessActionCount--;
	}
	
}