package detour.ui.skinable;

import detour.ui.ChoiceGroup;
import detour.ContextState;
import detour.Detour;
import detour.ContextNode;
import detour.Save;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxDestroyUtil;

class StateLoaderBase extends FlxGroup {

	public var save:SaveNode;
	
	var _state:ContextState;
	var _choices:Array<Int>;
	var _route:Dynamic;
	var _i:Int = 0;
	
	public function new() {
		super();
	}
	
	override public function destroy():Void {
		save = null;
		_state = null;
		_choices = null;
		_route = null;
		super.destroy();
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (_i == save.lenght) {
			if (Std.is(_route, ChoiceList)) {
				_state.choices.setChoices(_route);
			} else {
				_state.nextNode = _route;
			}
			
			onLoadFinished();
			return;
		}
		
		if (_i > 0 && _state.ready) {
			if (Std.is(_route, ChoiceList)) {
				var choices:ChoiceList = _route;
				var choiceIndex = _choices[0];
				_choices.remove(choiceIndex);
				_route = choices.get(choiceIndex).node(_state);
			} else {
				var node:ContextNode = _route;
				_route = node(_state);
			}
			
			_i++;
		}
	}
	
	public function load(save:SaveNode):Void {
		revive();
		
		_choices = save.choices.copy();
		Detour.save.saveNode = save;
		
		this.save = save;
		
		_state = ContextState.current;
		_state.loading = true;
		
		var c = Type.resolveClass(save.rootClassName);
		var f = Reflect.field(c, save.rootNodeName);
		_route = Reflect.callMethod(c, f, [_state]);
		
		_i = 1;
	}
	
	function onLoadFinished():Void {
		kill();
		_state.loading = false;
	}
	
}