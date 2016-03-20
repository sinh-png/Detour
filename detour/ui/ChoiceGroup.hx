package detour.ui;

import detour.animation.ChoiceAnimation;
import detour.ui.skinable.ChoiceButtonBase;
import flixel.group.FlxGroup.FlxTypedGroup;

class ChoiceGroup extends FlxTypedGroup<ChoiceButtonBase> {
	
	public function new() {
		super();
	}
	
	override public function destroy():Void {
		super.destroy();
	}
	
	public function setChoices(choices:ChoiceList):Void {
		clean();
		
		var i = 0;
		for (choice in choices) {
			var btn = getNewButton();
			btn.contextText.text = choice.text;
			btn.node = choice.node;
			btn.index = i;
			i++;
		}
		
		ContextState.current.inProcessActionCount++;

		ChoiceAnimation.defaultAnimation(this);
	}
	
	public function clean():Void {
		for (btn in this) {
			btn.kill();
		}
	}
	
	public inline function countChoices():Int {
		return countLiving();
	}
	
	public function finishTransition():Void {
		ContextState.current.inProcessActionCount--;
	}

	function getNewButton():ChoiceButtonBase {
		var btn:ChoiceButtonBase;
		
		if (countDead() > 0) {
			btn = getFirstDead();
			@:privateAccess btn.onOut();
			btn.revive();
		} else {
			btn = Type.createInstance(Detour.theme.choiceButtonClass, []);
			add(btn);
		}
		
		return btn;
	}
	
}

class Choice {
	
	public var text:String;
	public var node:ContextNode;
	
	public inline function new(text:String, node:ContextNode) {
		this.text = text;
		this.node = node;
	}
	
}

class ChoiceList {
	
	var _array:Array<Choice>;
	var _i:Int;
	
	public function new() {
		_array = new Array<Choice>();
		_i = 0;
	}
	
	public function add(text:String, node:ContextNode):Void {
		_array.push(new Choice(text, node));
	}
	
	public function get(index:Int):Choice {
		return _array[index];
	}
	
	public function hasNext():Bool {
		return _i < _array.length;
	}

	public function next():Choice {
		return _array[_i++];
	}
	
}