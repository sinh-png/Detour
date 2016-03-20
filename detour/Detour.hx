package detour;

import detour.skin.Skin;
import detour.skin.origin.Origin;


class Detour {

	public static var projectID:String;
	
	public static var theme:Skin = new Origin();
	
	public static var fontRegular:String = "detour/fonts/default-regular.ttf";
	public static var fontBold:String = "detour/fonts/default-bold.ttf";
	
	public static var lang:Lang = new Lang("Your choice");
	
	public static var log:Log = new Log();
	
	public static var temp:Dynamic = { };
	public static var data:Dynamic = { };
	
	public static var save:Save = new Save();
	
}

class Lang {
	
	public var yourChoice:String;
	
	public inline function new(yourChoice:String) {
		this.yourChoice = yourChoice;
	}
	
}


