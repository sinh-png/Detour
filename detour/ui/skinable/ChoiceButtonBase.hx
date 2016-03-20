package detour.ui.skinable;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;

class ChoiceButtonBase extends FlxSpriteGroup {
	
	public var background:FlxButton;
	public var contextText:FlxText;
	public var node:ContextNode;
	public var index:Int;
	
	public function new() {
		super();
	}
	
	override public function destroy():Void {
		super.destroy();
		FlxDestroyUtil.destroy(background);
		FlxDestroyUtil.destroy(contextText);
		node = null;
	}
	
	override function get_height():Float {
		return background.height;
	}
	
	function onOver():Void {

	}
	
	function onOut():Void {

	}
	
	function onDown():Void {
		onOver();
	}
	
	function onUp():Void {
		if (!ContextState.current.ready) return;
		
		Detour.log.add('"${contextText.text}"', Detour.lang.yourChoice);
		
		Detour.save.saveNode.pushChoice(index);
	
		FlxG.mouse.update();
		var state = ContextState.current;
		state.nextNode = node;
		state.execNextNode();
		ContextState.current.choices.clean();
	}
	
}