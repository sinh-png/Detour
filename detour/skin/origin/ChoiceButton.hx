package detour.skin.origin;

import detour.ui.skinable.ChoiceButtonBase;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class ChoiceButton extends ChoiceButtonBase {

	public function new() {
		super();
				
		background = new FlxButton();
		background.makeGraphic(FlxG.width - 100, 32, 0xaa000000);
		background.onOver.callback = onOver;
		background.onOut.callback = onOut;
		background.onDown.callback = onDown;
		background.onUp.callback = onUp;
		add(background);
	
		contextText = new FlxText(5, -2, background.width - 10);
		contextText.setFormat(Detour.fontRegular, 22, 0xffffff, "center");
		add(contextText);
		
		background.antialiasing = contextText.antialiasing = true;
	}
	
	override function onOver():Void {
		if (!ContextState.current.ready) return;
		
		background.scale.x = background.scale.y =
		contextText.scale.x = contextText.scale.y = 1.2;
	}
	
	override function onOut():Void {
		if (!ContextState.current.ready) return;
		
		background.scale.x = background.scale.y =
		contextText.scale.x = contextText.scale.y = 1;	
	}
	
}