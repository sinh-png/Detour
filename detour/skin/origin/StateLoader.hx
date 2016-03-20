package detour.skin.origin;

import detour.ui.skinable.StateLoaderBase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxDestroyUtil;


class StateLoader extends StateLoaderBase {

	public var image:FlxSprite;
	
	public function new() {
		super();
		
		image = new FlxSprite();
		image.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		add(image);
	}
	
	override public function destroy():Void {
		FlxDestroyUtil.destroy(image);
		super.destroy();
	}
	
}