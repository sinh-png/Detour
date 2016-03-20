package detour;

class Log {
	
	public var nodes(default, null):Array<LogNode> = new Array<LogNode>();
	
	public var nameBreakSymbol:String = "@>";
	public var nodeBreakSymbol:String = "!|";
	
	public var lenght(get, null):Int;
	
	public function new() {
		
	}
	
	public function add(context:String, ?name:String):Void {
		if (ContextState.current == null || ContextState.current.loading) return;
		nodes.push(new LogNode(context, name));
	}
	
	public function serialize():String {
		var s = "";
		
		var i = 0;
		for (node in nodes) {
			if (node.name != null) {
				s += node.name + nameBreakSymbol;
			}
			
			s += node.context;
			if (i < nodes.length - 1)  s += nodeBreakSymbol;
			
			i++;
		}
		
		return s;
	}
	
	public function fromString(string:String):Void {
		while (nodes.length > 0) nodes.pop();

		var nodeStrings = string.split(nodeBreakSymbol);
		for (s in nodeStrings) {
			var data = s.split(nameBreakSymbol);
			nodes.push(new LogNode(
				data[data.length - 1], 
				data.length > 1 ? data[0] : ""
			));
		}
		
		
	}
	
	function get_lenght():Int {
		return nodes.length;
	}
	
}

class LogNode {
	
	public var context(default, null):String;
	public var name(default, null):String;
	
	public inline function new(context:String, ?name:String) {
		this.context = context;
		this.name = name;
	}
	
}