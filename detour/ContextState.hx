package detour;

import detour.animation.BackgroundTransition;
import detour.animation.ContextTextAnimation;
import detour.animation.PortraitAnimation;
import detour.ui.ChoiceGroup;
import detour.ui.*;
import detour.ui.skinable.*;
import detour.Save;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import haxe.ds.StringMap;
import openfl.display.BitmapData;
import openfl.geom.Matrix;

@:allow(detour.ui.skinable.StateLoaderBase)
class ContextState extends FlxState {
	
	public static var current:ContextState;
	
	public var ready(get, null):Bool;
	@:isVar public var inProcessActionCount(default, set):Int;
	
	public var background:Background;
	public var backLayer:FlxGroup;
	public var backEmitter:FlxEmitter;
	public var portraits:PortraitGroup;
	public var frontLayer:FlxGroup;
	public var frontEmitter:FlxEmitter;
	public var contextBox:ContextBoxBase;
	public var choices:ChoiceGroup;
	
	public var clickToContinueIcon:FlxSprite;
	public var clickToContinueIconTween:VarTween;
	
	public var settingsButton:FlxButton;
	public var logButton:FlxButton;
	
	public var settingsDialog:SettingsDialogBase;
	public var logViewer:LogViewerBase;

	public var node:ContextNode;
	public var nextNode:ContextNode;
	
	public var loading(default, null):Bool;
	public var loader:StateLoaderBase;
	public var saveNode:SaveNode;
	
	var _tweens:StringMap<VarTween> = new StringMap<VarTween>();
	
	public function new(startObj:Dynamic) {
		super();
		
		if (Std.is(startObj, SaveNode)) {
			saveNode = startObj;
		} else {
			node = startObj;
		}
	
		ContextState.current = this;
	}

	override public function create():Void {
		super.create();

		inProcessActionCount = 0;
		
		background = new Background();
		add(background);
		
		backLayer = new FlxGroup();
		add(backLayer);
		
		backEmitter = new FlxEmitter();
		backEmitter.setSize(FlxG.width, FlxG.height);
		backEmitter.x = FlxG.width / 2;
		backEmitter.y = FlxG.height / 2;
		backEmitter.kill();
		backLayer.add(backEmitter);
		
		portraits = new PortraitGroup();
		add(portraits);
		
		frontLayer = new FlxGroup();
		add(frontLayer);
		
		frontEmitter = new FlxEmitter();
		frontEmitter.setSize(FlxG.width, FlxG.height);
		frontEmitter.x = FlxG.width / 2;
		frontEmitter.y = FlxG.height / 2;
		frontEmitter.kill();
		frontLayer.add(frontEmitter);
		
		contextBox = Type.createInstance(Detour.theme.contextBoxClass, []);
		add(contextBox);
		
		choices = new ChoiceGroup();
		add(choices);
		
		clickToContinueIcon = new FlxSprite(FlxG.width, FlxG.height, Detour.theme.getAssetPath("icon_click_to_continue.png"));
		clickToContinueIcon.x -= clickToContinueIcon.width + 8;
		clickToContinueIcon.y -= clickToContinueIcon.height + 5;
		clickToContinueIcon.antialiasing = true;
		clickToContinueIcon.angle = -30;
		clickToContinueIconTween = FlxTween.tween(clickToContinueIcon, { angle: 30 }, 2, {
			type: FlxTween.PINGPONG,
			ease: FlxEase.sineInOut
		});
		clickToContinueIcon.alpha = 0;
		add(clickToContinueIcon);
		
		settingsButton = new FlxButton();
		settingsButton.loadGraphic(Detour.theme.getAssetPath("button_open_settings.png"));
		settingsButton.x = 8;
		settingsButton.y = FlxG.height - settingsButton.height - 5;
		settingsButton.antialiasing = true;
		settingsButton.onOut.callback = function() {
			settingsButton.scale.x = settingsButton.scale.y = 1;
			settingsButton.angle = 0;
		}
		settingsButton.onOver.callback = function() {
			settingsButton.scale.x = settingsButton.scale.y = 1.2;
			settingsButton.angle = 20;
		}
		settingsButton.onDown.callback = settingsButton.onOver.callback;
		settingsButton.onUp.callback = function() {
			settingsButton.onOut.callback();
			openSettings();
		};
		add(settingsButton);
		
		logButton = new FlxButton();
		logButton.loadGraphic(Detour.theme.getAssetPath("button_open_log.png"));
		logButton.x = settingsButton.x + settingsButton.width + 10;
		logButton.y = settingsButton.y;
		logButton.antialiasing = true;
		logButton.onOut.callback = function() {
			logButton.scale.x = logButton.scale.y = 1;
			logButton.angle = 0;
		}
		logButton.onOver.callback = function() {
			logButton.scale.x = logButton.scale.y = 1.2;
			logButton.angle = 20;
		}
		logButton.onDown.callback = logButton.onOver.callback;
		logButton.onUp.callback = function() {
			logButton.onOut.callback();
			openLog();
		};
		add(logButton);
		
		settingsDialog = Type.createInstance(Detour.theme.settingDialogClass, []);
		settingsDialog.kill();
		add(settingsDialog);
		
		logViewer = Type.createInstance(Detour.theme.logViewerClass, []);
		logViewer.kill();
		add(logViewer);
		
		if (node != null) execNode();
		else if (saveNode != null) {
			loader = Type.createInstance(Detour.theme.stateLoaderClass, []);
			loader.load(saveNode);
			add(loader);
		}
	}

	override public function destroy():Void {
		super.destroy();
		
		FlxDestroyUtil.destroy(background);
		FlxDestroyUtil.destroy(backLayer);
		FlxDestroyUtil.destroy(backEmitter);
		FlxDestroyUtil.destroy(portraits);
		FlxDestroyUtil.destroy(frontLayer);
		FlxDestroyUtil.destroy(frontEmitter);
		FlxDestroyUtil.destroy(contextBox);
		FlxDestroyUtil.destroy(choices);
		
		if (clickToContinueIconTween != null) {
			clickToContinueIconTween.cancel();
			clickToContinueIconTween.destroy();
		}
		FlxDestroyUtil.destroy(clickToContinueIcon);
		
		FlxDestroyUtil.destroy(settingsButton);
		FlxDestroyUtil.destroy(logButton);
		
		FlxDestroyUtil.destroy(logViewer);

		node = nextNode = null;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (!loading) {
			if (!ready) {
				clickToContinueIcon.alpha = 0;
			} else {
				if ((choices != null && choices.countChoices() > 0) || nextNode != null) {
					clickToContinueIcon.alpha = 1;
				}
				
				if (
					FlxG.mouse.justReleased &&
					clickToContinueIcon.alpha == 1 && clickToContinueIcon.alive &&
					nextNode != null && choices.countChoices() < 1
				) {
					if (checkButtonZoneBounding(settingsButton) || checkButtonZoneBounding(logButton)) {
						execNextNode();
					}
				}
			}
		}
	}
	
	public function execNode():Void {
		inProcessActionCount = 0;
		
		var route:Dynamic = node(this);
		if (Std.is(route, ChoiceList)) {
			choices.setChoices(route);
		} else {
			nextNode = route;
		}
		
		Detour.save.saveNode.lenght++;
	}
	
	public  function execNextNode():Void {
		node = nextNode;
		nextNode = null;
		execNode();
	}
	
	public function setBG(
		g:FlxGraphicAsset, 
		?transitionFunction:BackgroundTransitionFunction, 
		?duration:Float = 1, ?ease:EaseFunction,
		?onComplete:Void->Void
	):FlxSprite {
		if (loading) transitionFunction = BackgroundTransition.None;
		return background.setBG(g, transitionFunction, duration, ease, onComplete);
	}
	
	public function setText(context:String, ?name:String, ?transitionFunction:ContextTextTransitionFunction):Void {
		if (loading) transitionFunction = ContextTextAnimation.None;
		contextBox.setText(context, name, transitionFunction);
	}
	
	public function addPortrait(
		name:String, g:FlxGraphicAsset, ?x:Float, ?y:Float, ?dx:Float, ?dy:Float,
		?transitionFunction:PortraitAddAnimationFunction,
		?duration:Float = 1, ?ease:EaseFunction,
		?onComplete:Void->Void
	):FlxSprite {
		if (loading) transitionFunction = PortraitAnimation.AddNone;
		return portraits.addPortrait(name, g, x, y, dx, dy, transitionFunction, duration, ease, onComplete);
	}
	
	public function changePortrait(
		name:String, g:FlxGraphicAsset, 
		?transitionFunction:PortraitChangeTransitionFunction, 
		?duration:Float = 1, ?ease:EaseFunction,
		?onComplete:Void->Void
	):FlxSprite {
		if (loading) transitionFunction = PortraitAnimation.ChangeNone;
		return portraits.changePortrait(name, g, transitionFunction, duration, ease, onComplete);
	}
	
	public inline function getPortrait(name:String):FlxSprite {
		return portraits.getPortrait(name);
	}
	
	public inline function removePortrait(name:String):Void {
		portraits.removePortrait(name);
	}
	
	public function tween(object:Dynamic, values:Dynamic, duration:Float = 1, ?options:TweenOptions, ?key:String):VarTween {
		inProcessActionCount++;
		
		var func = options.onComplete;
		options.onComplete = function(t) {
			inProcessActionCount--;
			if (func != null) func(t);
		}

		if (loading && options.type != FlxTween.LOOPING && options.type != FlxTween.PINGPONG) {
			return FlxTween.tween(object, values, 0.01, options);
		} 
		
		return FlxTween.tween(object, values, duration, options);
	}
	
	public function hideUI():Void {
		choices.visible = choices.active = false;
		contextBox.kill();
		clickToContinueIcon.kill();
		settingsButton.kill();
		logButton.kill();
	}
	
	public function showUI():Void {
		choices.visible = choices.active = true;
		contextBox.revive();
		clickToContinueIcon.revive();
		settingsButton.revive();
		logButton.revive();
	}
	
	public function openSettings():Void {
		FlxG.mouse.update();
		settingsDialog.open();
		hideUI();
	}
	
	public function closeSettings():Void {
		FlxG.mouse.update();
		settingsDialog.close();
		showUI();
	}
	
	public function openLog():Void {
		FlxG.mouse.update();
		logViewer.open();
		hideUI();
	}
	
	public function closeLog():Void {
		FlxG.mouse.update();
		logViewer.close();
		showUI();
	}
	
	function checkButtonZoneBounding(button:FlxButton):Bool {
		var zoneSize = 40;
		return !(
			FlxG.mouse.x > button.x - zoneSize &&
			FlxG.mouse.x < button.x + button.width + zoneSize &&
			FlxG.mouse.y > button.y - zoneSize &&
			FlxG.mouse.y < button.y + button.height + zoneSize
		);
	}
	
	function get_ready():Bool {
		return inProcessActionCount < 1;
	}
	
	function set_inProcessActionCount(value:Int):Int {
		if (value < 1) value = 0;
		return inProcessActionCount = value;
	}

}
