package detour.ui;

import detour.animation.PortraitAnimation;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets;
import flixel.tweens.FlxEase;
import haxe.ds.StringMap;

class PortraitGroup extends FlxTypedGroup<FlxSprite> {

	public var map:StringMap<FlxSprite>;
	
	public function new() {
		super();
		map = new StringMap<FlxSprite>();
	}
	
	override public function destroy():Void {
		for (key in map.keys()) {
			map.remove(key);
		}
		
		super.destroy();
	}
	
	public function addPortrait(
		name:String, g:FlxGraphicAsset, ?x:Float, ?y:Float, ?dx:Float, ?dy:Float,
		?transitionFunction:PortraitAddAnimationFunction,
		?duration:Float = 1, ?ease:EaseFunction,
		?onComplete:Void->Void
	):FlxSprite {
		name = name.toLowerCase();
		
		if (map.exists(name)) {
			FlxG.log.error('Portrait named $name already exists.');
			return null;
		}
		
		var spr = getNewSprite();
		spr.loadGraphic(g);
		spr.offset.x = spr.origin.x;
		spr.offset.y = spr.height;
		spr.x = x != null ? x : FlxG.width / 2;
		spr.y = y != null ? y : FlxG.height;
		
		map.set(name, spr);
		
		if (transitionFunction == null) {
			if (PortraitAnimation.defaultAddAnimation == null) 
				transitionFunction = PortraitAnimation.AddNone;
			else 
				transitionFunction = PortraitAnimation.defaultAddAnimation;
		}

		ContextState.current.inProcessActionCount++;
		
		if (ease == null) ease = FlxEase.sineInOut;
		
		if (dx == null) dx = FlxG.width / 2;
		if (dy == null) dy = FlxG.height;
		
		transitionFunction(this, spr, dx, dy, duration, ease, onComplete);
		
		return spr;
	}
	
	public function changePortrait(
		name:String, g:FlxGraphicAsset, 
		?transitionFunction:PortraitChangeTransitionFunction, 
		?duration:Float = 1, ?ease:EaseFunction,
		?onComplete:Void->Void
	):FlxSprite {
		name = name.toLowerCase();
		
		if (!map.exists(name)) {
			FlxG.log.error('Unable to find portrait named $name.');
			return null;
		}
		
		var portrait = getPortrait(name);
		
		if (transitionFunction == null) {
			if (PortraitAnimation.defaultChangeTransition == null) 
				transitionFunction = PortraitAnimation.ChangeNone;
			else 
				transitionFunction = PortraitAnimation.defaultChangeTransition;
		}
		
		ContextState.current.inProcessActionCount++;
		
		var transited = getNewSprite();
		
		members.remove(transited);
		members.insert(portrait.ID + 2, transited);
	
		transited.loadGraphicFromSprite(portrait);
		transited.offset.x = portrait.origin.x;
		transited.offset.y = portrait.height;
		transited.color = portrait.color;
		transited.alpha = portrait.alpha;
		transited.angle = portrait.angle;
		transited.scale.x = portrait.scale.x;
		transited.scale.y = portrait.scale.y;
		transited.flipX = portrait.flipX;
		transited.flipY = portrait.flipY;
		transited.antialiasing = portrait.antialiasing;
		transited.x = portrait.x;
		transited.y = portrait.y;
		
		portrait.loadGraphic(g);
		portrait.offset.x = portrait.origin.x;
		portrait.offset.y = portrait.height;
		
		if (ease == null) ease = FlxEase.sineInOut;
		
		transitionFunction(this, portrait, transited, duration, ease, onComplete);
		
		return portrait;
	}
	
	public function getPortrait(name:String):FlxSprite {
		name = name.toLowerCase();
		return map.get(name);
	}
	
	public function removePortrait(name:String):Void {
		name = name.toLowerCase();
		var ptr = map.get(name);
		map.remove(name);
		ptr.kill();
	}
	
	public function getNewSprite():FlxSprite {
		var spr:FlxSprite;
		
		if (countDead() > 0) {
			spr = getFirstDead();
			spr.alpha = 1;
			spr.angle = 0;
			spr.color = 0xffffff;
			spr.scale.x = spr.scale.y = 1;
			spr.flipX = spr.flipY = false;
			spr.antialiasing = false;
			spr.revive();
			
			var i = 0;
			for (s in this) {
				if (s == spr) spr.ID = i;
				i++;
			}
		} else {
			spr = new FlxSprite();
			spr.ID = length - 1;
			add(spr);
		}
		
		return spr;
	}
	
	public function finishTransition():Void {
		ContextState.current.inProcessActionCount--;
	}
	
}
