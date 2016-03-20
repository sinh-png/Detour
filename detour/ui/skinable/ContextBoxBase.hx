package detour.ui.skinable;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxDestroyUtil;
import detour.animation.ContextTextAnimation;

class ContextBoxBase extends FlxGroup {
	
	public var nameBG:FlxSprite;
	public var contextBG:FlxSprite;
	public var nameText:FlxText;
	public var contextText:FlxText;
	public var contextStringText(default, null):String;
	
	public var nameVisible(get, set):Bool;
	
	public function new() {
		super();
	}
	
	override public function destroy():Void {
		super.destroy();
		FlxDestroyUtil.destroy(nameBG);
		FlxDestroyUtil.destroy(contextBG);
		FlxDestroyUtil.destroy(nameText);
		FlxDestroyUtil.destroy(contextText);
		contextStringText = null;
	}
	
	public function setText(context:String, ?name:String, ?transitionFunction:ContextTextTransitionFunction):Void {
		Detour.log.add(context, name);
		
		if (name == null) nameVisible = false;
		else {
			nameVisible = true;
			nameText.text = name;
		}
		
		contextStringText = context;
		
		if (transitionFunction == null) {
			if (ContextTextAnimation.defaultTransition == null) 
				transitionFunction = ContextTextAnimation.None;
			else 
				transitionFunction = ContextTextAnimation.defaultTransition;
		}
		
		ContextState.current.inProcessActionCount++;
		
		contextText.text = "";
		transitionFunction(this);
	}
	
	public function finishTransition():Void {
		ContextState.current.inProcessActionCount--;
	}
	
	function get_nameVisible():Bool {
		return nameText.visible;
	}
	
	function set_nameVisible(value:Bool):Bool {
		if (nameBG != null) nameBG.visible = value;
		return nameText.visible = value;
	}
	
}