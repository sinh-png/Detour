package detour.skin.origin;

import detour.ui.skinable.SettingsDialogBase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxCollision;
import flixel.util.FlxDestroyUtil;

class SettingDialog extends SettingsDialogBase {

	public var background:FlxSprite;
	public var line:FlxSprite;
	public var btnSave:FlxButton;
	public var btnLoad:FlxButton;
	public var musicIcon:FlxSprite;
	public var soundIcon:FlxSprite;
	public var musicSlider:Slider;
	public var soundSlider:Slider;
	public var textMute:FlxText;
	public var checkBoxMute:FlxButton;
	public var btnClose:FlxSprite;
	
	var _mouseMask:FlxSprite;
	
	public function new() {
		super();
	
		background = new FlxSprite();
		background.makeGraphic(FlxG.width, FlxG.height, 0xaa000000);
		add(background);
		
		line = new FlxSprite((FlxG.width - 660) / 2, FlxG.height / 2 - 60);
		line.makeGraphic(660, 2);
		add(line);
		
		btnSave = new FlxButton(0, 0);
		btnSave.loadGraphic(Detour.theme.getAssetPath("button_save.png"));
		btnSave.x = FlxG.width / 2 - btnSave.width - 40;
		btnSave.y = line.y - btnSave.height - 40;
		btnSave.antialiasing = true;
		btnSave.onOver.callback = function() {
			btnSave.scale.x = btnSave.scale.y = 1.2;
		}
		btnSave.onOut.callback = function() {
			btnSave.scale.x = btnSave.scale.y = 1;
		}
		btnSave.onDown.callback = btnSave.onOver.callback;
		btnSave.onUp.callback = function() {
			btnSave.onOut.callback();
			btnSave.loadGraphic(Detour.theme.getAssetPath("button_saved.png"));
			btnSave.color = 0x999999;
			btnSave.active = false;
			Detour.save.quickSave();
		}
		add(btnSave);
		
		btnLoad = new FlxButton(0, 0);
		btnLoad.loadGraphic(Detour.theme.getAssetPath("button_load.png"));
		btnLoad.x = FlxG.width / 2 + 40;
		btnLoad.y = btnSave.y;
		btnLoad.antialiasing = true;
		btnLoad.onOver.callback = function() {
			btnLoad.scale.x = btnLoad.scale.y = 1.2;
		}
		btnLoad.onOut.callback = function() {
			btnLoad.scale.x = btnLoad.scale.y = 1;
		}
		btnLoad.onDown.callback = btnLoad.onOver.callback;
		btnLoad.onUp.callback = function() {
			btnLoad.onOut.callback();
			Detour.save.quickLoad();
		}
		add(btnLoad);
		
		musicIcon = new FlxSprite(Detour.theme.getAssetPath("icon_music.png"));
		musicIcon.y = line.y + 30;
		add(musicIcon);
		
		musicSlider = new Slider(musicIcon.x + musicIcon.width + 20, musicIcon.y + 20);
		add(musicSlider);
		
		musicIcon.x = (FlxG.width - (musicSlider.x + musicSlider.width - musicIcon.x)) / 2 - 10;
		musicSlider.x = musicIcon.x + musicIcon.width + 30;
		
		soundIcon = new FlxSprite(Detour.theme.getAssetPath("icon_sound.png"));
		soundIcon.x = musicIcon.x - 6;
		soundIcon.y = musicIcon.y + 80;
		add(soundIcon);
		
		soundSlider = new Slider(musicSlider.x, soundIcon.y + 15);
		add(soundSlider);
		
		textMute = new FlxText();
		textMute.setFormat(Detour.fontBold, 30, 0xffffff, "left", SHADOW, 0xaa00fcff);
		textMute.shadowOffset.x = textMute.shadowOffset.y = 2;
		textMute.text = Origin.lang.mute;
		textMute.x = soundIcon.x + 15;
		textMute.y = soundIcon.y + soundIcon.height + 5;
		add(textMute);
		
		checkBoxMute = new FlxButton(textMute.x + textMute.textField.textWidth + 20, textMute.y);
		checkBoxMute.loadGraphic(Detour.theme.getAssetPath("check_box_unchecked.png"));
		if (checkBoxMute.x < soundSlider.x) checkBoxMute.x = soundSlider.x;
		checkBoxMute.ID = 0;
		checkBoxMute.antialiasing = true;
		checkBoxMute.onOver.callback = function() {
			checkBoxMute.scale.x = checkBoxMute.scale.y = 1.2;
		}
		checkBoxMute.onOut.callback = function() {
			checkBoxMute.scale.x = checkBoxMute.scale.y = 1;
		}
		checkBoxMute.onDown.callback = checkBoxMute.onOver.callback;
		checkBoxMute.onUp.callback = function() {
			checkBoxMute.onOut.callback();
			
			if (checkBoxMute.ID == 0) {
				checkBoxMute.ID = 1;
				checkBoxMute.loadGraphic(Detour.theme.getAssetPath("check_box_checked.png"));
			} else {
				checkBoxMute.ID = 0;
				checkBoxMute.loadGraphic(Detour.theme.getAssetPath("check_box_unchecked.png"));
			}
		}
		add(checkBoxMute);
		
		btnClose = new FlxSprite(FlxG.width - 180, 45);
		btnClose.antialiasing = true;
		btnClose.angle = 45;
		btnClose.loadGraphic(Detour.theme.getAssetPath("button_close_settings.png"));
		add(btnClose);
		
		_mouseMask = new FlxSprite();
		_mouseMask.makeGraphic(5, 5, 0xffffffff);
		_mouseMask.visible = false;
		add(_mouseMask);
	}
	
	override public function destroy():Void {
		super.destroy();
		FlxDestroyUtil.destroy(background);
		FlxDestroyUtil.destroy(line);
		FlxDestroyUtil.destroy(btnSave);
		FlxDestroyUtil.destroy(btnLoad);
		FlxDestroyUtil.destroy(musicIcon);
		FlxDestroyUtil.destroy(soundIcon);
		FlxDestroyUtil.destroy(musicSlider);
		FlxDestroyUtil.destroy(soundSlider);
		FlxDestroyUtil.destroy(textMute);
		FlxDestroyUtil.destroy(checkBoxMute);
		FlxDestroyUtil.destroy(btnClose);
		FlxDestroyUtil.destroy(_mouseMask);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		_mouseMask.x = FlxG.mouse.x;
		_mouseMask.y = FlxG.mouse.y;
		
		if (FlxCollision.pixelPerfectCheck(_mouseMask, btnClose)) {
			btnClose.scale.x = btnClose.scale.y = 1.2;
			if (FlxG.mouse.justReleased) ContextState.current.closeSettings();
		} else {
			btnClose.scale.x = btnClose.scale.y = 1;
		}
	}
	
	override public function open():Void {
		btnSave.loadGraphic(Detour.theme.getAssetPath("button_save.png"));
		btnSave.color = 0xffffff;
		btnSave.active = true;
		revive();
	}
	
	override public function close():Void {
		kill();
	}
	
}

class Slider extends FlxTypedSpriteGroup<FlxSprite> {
	
	public var value(default, set):Float;
	
	var _barCount:Int = 20;
	
	public function new(x:Float, y:Float, value:Float = 100) {
		super();
		
		for (i in 0..._barCount + 1) {
			var bar = new FlxSprite(Detour.theme.getAssetPath("slider_bar.png"));
			bar.ID = i;
			bar.antialiasing = true;
			bar.x = (bar.width + 5) * i;
			if (i == 0) bar.visible = false;
			add(bar);
		}
		
		offset.x = members[0].width + 5;
		
		this.value = value;

		this.x = x;
		this.y = y;
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		var mx = FlxG.mouse.x;
		var my = FlxG.mouse.y;
		
		for (bar in this) {
			if (
				mx > bar.x && mx < bar.x + bar.width &&
				my > bar.y && my < bar.y + bar.height
			) {
				if (FlxG.mouse.pressed) onDown(bar);
			}
		}
	}
	
	override function get_width():Float {
		var end = members[length - 1];
		return end.x + end.width - members[0].x;
	}
	
	override function get_height():Float {
		return members[0].height;
	}
	
	function onDown(bar:FlxSprite):Void {
		value = bar.ID * (100 / _barCount);
	}
	
	function set_value(value:Float):Float {
		var i = Math.floor(value / (100 / _barCount));
		
		for (member in this) {
			if (member.ID <= i) member.color = 0x22fcff;
			else member.color = 0xffffff;
			
			member.scale.y = 1.2 - Math.abs(i - member.ID) / (_barCount * 1.1);
		}
		
		return this.value = value;
	}
	
}