package detour;
import flixel.FlxG;
import flixel.util.FlxSave;

class Save {
	
	public var saveNode:SaveNode = new SaveNode();
	
	var _save:FlxSave = new FlxSave();
	
	public function new() {
		
	}
	
	public function save(key:String):Void {
		if (Detour.projectID == null || Detour.projectID == "") {
			FlxG.log.error("Detour.projectID has to be set before saving / loading.");
			return;
		}
		
		key = "DETOUR$" + Detour.projectID + "-" + key;
		
		_save.bind(key);
		_save.data.nodeData = saveNode.serialize();
		_save.data.log = Detour.log.serialize();
		_save.data.data = Detour.data;
		_save.flush();
	}
	
	public function load(key:String):Bool {
		if (Detour.projectID == null || Detour.projectID == "") {
			FlxG.log.error("Detour.projectID has to be set before saving / loading.");
			return false;
		}
		
		key = "DETOUR$" + Detour.projectID + "-" + key;
		
		if (!_save.bind(key)) return false;
		
		saveNode.fromString(_save.data.nodeData);
		Detour.log.fromString(_save.data.log);
		Detour.data = _save.data.data;
		FlxG.switchState(new ContextState(saveNode));
		
		return true;
	}
	
	public inline function quickSave():Void {
		save("quick");
	}
	
	public inline function quickLoad():Void {
		load("quick");
	}
	
}

class SaveNode {

	public var rootClassName:String;
	public var rootNodeName:String;
	public var choices:Array<Int> = new Array<Int>();
	public var lenght:Int = 0;
	
	public function new() {
	
	}
	
	public function setRoot(functionName:String, ?className:String):Void {
		if (ContextState.current.loading) return;
		
		if (className != null) this.rootClassName = className;
		rootNodeName = functionName;
		
		while (choices.length > 0) choices.pop();
		lenght = 0;
	}
	
	public inline function pushChoice(index:Int):Void {
		choices.push(index);
	}
	
	public function serialize():String {
		var s = rootClassName + ";" + rootNodeName + ";" + lenght + ";";
		
		for (i in 0...choices.length) {
			s += choices[i];
			if (i < choices.length - 1) s += ",";
		}
		
		return s;
	}
	
	public function fromString(s:String):Void {
		var parts = s.split(";");
		
		setRoot(parts[1], parts[0]);
		
		lenght = Std.parseInt(parts[2]);
		
		var choiceParts = parts[3].split(",");
		for (index in choiceParts) {
			choices.push(Std.parseInt(index));
		}
	}
	
}