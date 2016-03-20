package detour.skin.origin;

import detour.ui.skinable.ContextBoxBase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

class ContextBox extends ContextBoxBase {

	public function new() {
		super();
		
		contextBG = new FlxSprite();
		contextBG.makeGraphic(FlxG.width, Math.round(FlxG.height / 2.8), 0xaa000000);
		contextBG.y = FlxG.height - contextBG.height;
		add(contextBG);
		
		nameText = new FlxText(10, contextBG.y + 3);
		nameText.setFormat(Detour.fontBold, 24);
		add(nameText);
		
		contextText = new FlxText(10, nameText.y + nameText.textField.textHeight + 3, contextBG.width - 20);
		contextText.setFormat(Detour.fontRegular, 22);
		add(contextText);
	}
	
	override function set_nameVisible(value:Bool):Bool {
		contextText.y = value ? nameText.y + nameText.textField.textHeight + 3 : nameText.y;
		return super.set_nameVisible(value);
	}
	
}