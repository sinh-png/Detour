package detour.ui.skinable;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;

class LogViewerBase extends FlxGroup {

	public function open():Void {
		revive();
	}
	
	public function close():Void {
		kill();
	}

}