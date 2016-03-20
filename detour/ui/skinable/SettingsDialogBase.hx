package detour.ui.skinable;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxCollision;
import flixel.util.FlxDestroyUtil;

class SettingsDialogBase extends FlxSpriteGroup {

	public function open():Void {
		revive();
	}
	
	public function close():Void {
		kill();
	}
	
}