package detour.skin.origin;

import detour.skin.Skin;

class Origin extends Skin {

	public static var lang:Lang = new Lang("Left Click: Back / Right Click: Next / Hold: Jump", "MUTE");
	
	public function new() {
		super();
		
		name = "origin";
		
		contextBoxClass = ContextBox;
		choiceButtonClass = ChoiceButton;
		logViewerClass = LogViewer;
		settingDialogClass = SettingDialog;
		stateLoaderClass = StateLoader;
	}
	
}

class Lang {
	
	public var logTip:String;
	public var mute:String;
	
	public inline function new(logTip:String, mute:String) {
		this.logTip = logTip;
		this.mute = mute;
	}
	
}
