package detour.skin;

import detour.ui.skinable.ChoiceButtonBase;
import detour.ui.skinable.ContextBoxBase;
import detour.ui.skinable.LogViewerBase;
import detour.ui.skinable.SettingsDialogBase;
import detour.ui.skinable.StateLoaderBase;

class Skin {
	
	public var name:String;
	
	public var contextBoxClass:Class<ContextBoxBase>;
	public var choiceButtonClass:Class<ChoiceButtonBase>;
	public var logViewerClass:Class<LogViewerBase>;
	public var settingDialogClass:Class<SettingsDialogBase>;
	public var stateLoaderClass:Class<StateLoaderBase>;
	
	public function new() {
	
	}
	
	public function getAssetPath(key:String):String {
		return "detour/skins/" + name + "/" + key;
	}
	
}