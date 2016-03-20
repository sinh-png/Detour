package detour.skin.origin;

import detour.ui.skinable.LogViewerBase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;

class LogViewer extends LogViewerBase {

	public var background:FlxSprite;
	public var tipText:FlxText;
	public var closeButton:FlxButton;
	public var lines:Array<FlxSprite>;
	public var cards:Array<ContextLogCard>;
	public var indexText:FlxText;
	
	public var ready(get, null):Bool;
	
	var _index:Int;
	public var index(get, set):Int;
	
	var _jumpIndex:Float;
	public var jumpIndex(get, set):Float;
	
	var _holdFrames:Int = 0;
	var _jumpSize:Float = 0;
	
	public function new() {
		super();
		
		background = new FlxSprite();
		background.makeGraphic(900, 506, 0xaa000000);
		add(background);
		
		tipText = new FlxText(15, 3);
		tipText.setFormat(Detour.fontRegular, 18);
		tipText.text = Origin.lang.logTip;
		add(tipText);
		
		closeButton = new FlxButton();
		closeButton.loadGraphic(Detour.theme.getAssetPath("button_close_log.png"));
		closeButton.x = FlxG.width - closeButton.width - 15;
		closeButton.antialiasing = true;
		closeButton.origin.y = 0;
		closeButton.onOut.callback = function() {
			closeButton.scale.x = closeButton.scale.y = 1;
		}
		closeButton.onOver.callback = function() {
			closeButton.scale.x = closeButton.scale.y = 1.2;
		}
		closeButton.onDown.callback = closeButton.onOver.callback;
		closeButton.onUp.callback = function() {
			closeButton.onOut.callback();
			ContextState.current.closeLog();
		}
		add(closeButton);
		
		var topLineY = 35;
		var contextHeight = (FlxG.height - topLineY) / 4;
		
		lines = new Array<FlxSprite>();
		cards = new Array<ContextLogCard>();
		for (i in 0...4) {
			var line  = new FlxSprite();
			line.makeGraphic(860, 2);
			
			line.x = (FlxG.width - line.width) / 2;
			if (i == 0) line.y = topLineY;
			else line.y = topLineY + i * contextHeight;

			add(line );
			lines.push(line);
			
			//
			
			var card = new ContextLogCard(lines[i].y, i);
			add(card);
			cards.push(card);
		}
		
		indexText = new FlxText(0, 0, FlxG.width - 15, "0");
		indexText.setFormat(Detour.fontRegular, 18, 0xffffff, "right");
		indexText.y = FlxG.height - indexText.height - 3;
		add(indexText);
	}
	
	override public function destroy():Void {
		super.destroy();
		
		FlxDestroyUtil.destroy(background);
		FlxDestroyUtil.destroy(tipText);
		FlxDestroyUtil.destroy(closeButton);
		
		if (lines != null) {
			while (lines.length > 0) {
				FlxDestroyUtil.destroy(lines.pop());
				FlxDestroyUtil.destroy(cards.pop());
			}
		}

		lines = null;
		cards = null;
		
		FlxDestroyUtil.destroy(indexText);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (!ready) return;
		
		if (FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight) {
			if (Math.floor(jumpIndex) != index) index = Math.floor(jumpIndex);
			_holdFrames = 0;
			_jumpSize = 0;
			return;
		}
		
		var pressed = 0;

		#if mobile
		if (FlxG.mouse.pressed) 
			pressed = FlxG.mouse.x < FlxG.width / 2 ? -1 : 1;
		#else
		if (FlxG.mouse.pressed) pressed = -1;
		else if (FlxG.mouse.pressedRight) pressed = 1;
		#end
		
		if (pressed != 0) {
			if (_holdFrames < 15) {
				jumpIndex = index + 4 * pressed;
			} else {
				if (pressed * _jumpSize < 0) _jumpSize = 0;
				_jumpSize += 0.005 * pressed;
				jumpIndex += _jumpSize;
			}
			
			_holdFrames++;
		}
	}
	
	override public function open():Void {
		index = Detour.log.lenght - 1;
		_holdFrames = 0;
		_jumpSize = 0;
		super.open();
	}
	
	override public function close():Void {
		for (card in cards) card.contextText.text = "";
		super.close();
	}
	
	function get_index():Int {
		return _index;
	}
	
	function set_index(value:Int):Int {
		if (value > Detour.log.lenght - 1) value = Detour.log.lenght - 1;
		
		var start = 0;
		if (value < 3) {
			if (Detour.log.lenght > 3) value = 3;
			else value = Detour.log.lenght - 1;
		} else {
			start = value - 3;
		}

		indexText.text = (start + 1) + " - " + (value + 1) + " / " + Detour.log.lenght;

		for (i in 0...(value + 1 - start)) {
			var card = cards[i];
			var node = Detour.log.nodes[start + i];
			card.setText(node.context, node.name, value < index);
		}
		
		return _index = value;
	}
	
	function get_jumpIndex():Float {
		return _jumpIndex;
	}
	
	function set_jumpIndex(value:Float):Float {
		refreshIndexText();
		
		if (value > Detour.log.lenght - 1) value = Detour.log.lenght - 1;
		
		var start = 0;
		var end = Math.floor(value);
		if (value  < 3) {
			if (Detour.log.lenght > 3) end = cast value = 3;
			else end = cast value = Detour.log.lenght - 1;
		} else {
			start = end - 3;
		}
		
		if (value != index)
			indexText.text = "(" + (start + 1) + " - " + (end + 1) + ") " + indexText.text;
		
		return _jumpIndex = value;
	}
	
	function refreshIndexText():Void {
		var start = 0;
		if (index > 3) start = index - 3;
		indexText.text = (start + 1) + " - " + (index + 1) + " / " + Detour.log.lenght;
	}
	
	function get_ready():Bool {
		if (closeButton.scale.x != 1) return false;
		for (card in cards) if (!card.ready) return false;
		return true;
	}
	
}

class ContextLogCard extends FlxTypedGroup<FlxText> {
	
	public var nameText:FlxText;
	public var contextText:FlxText;
	
	public var ready(default, null):Bool = true;
	
	var _originX:Float = 20;
	var _cardIndex:Int;
	
	public function new(y:Float, index:Int) {
		super();
		
		_cardIndex = index;
		
		nameText = new FlxText(_originX, y + 3);
		nameText.setFormat(Detour.fontBold, 20);
		//nameText.bold = true;
		nameText.text = "";
		add(nameText);
		
		contextText = new FlxText(_originX, nameText.y + nameText.textField.textHeight + 3, FlxG.width - nameText.x * 2);
		contextText.setFormat(Detour.fontRegular, 18);
		contextText.text = "";
		add(contextText);
	}
	
	override public function destroy():Void {
		super.destroy();
		FlxDestroyUtil.destroy(nameText);
		FlxDestroyUtil.destroy(contextText);
	}
	
	override public function update(elapsed:Float):Void {
		contextText.x = nameText.x;
		super.update(elapsed);
	}
	
	public function setText(context:String, ?name:String = "", backing:Bool = true):Void {
		ready = false;
		
		if (contextText.text == "") {
			if (name == "") contextText.y = nameText.y;
			else contextText.y = nameText.y + nameText.textField.textHeight + 3;
			
			nameText.text = name;
			contextText.text = context;

			if (backing) nameText.x = FlxG.width;
			else nameText.x = -FlxG.width;
			tweenToPosition();
		} else {
			var dx = FlxG.width;
			if (backing) dx = -FlxG.width;
			
			FlxTween.tween(nameText, { x: dx }, 0.8 - _cardIndex / 8, { ease: FlxEase.sineIn, 
				onComplete: function(_) {
					nameText.text = name;
					contextText.text = context;
					
					if (name == "") contextText.y = nameText.y;
					else contextText.y = nameText.y + nameText.textField.textHeight + 3;
					
					nameText.x = dx * -1;
					tweenToPosition();
				}
			});
		}
	}
	
	function tweenToPosition():Void {
		FlxTween.tween(nameText, { x: _originX }, 0.8 - _cardIndex / 8, { ease: FlxEase.sineOut, 
			onComplete: function(_) {
				ready = true;
			}
		});
	}
	
}