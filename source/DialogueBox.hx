package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitMid:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		bgFade = new FlxSprite().makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFF000000);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);
		bgFade.screenCenter();

		this.dialogueList = dialogueList;
		
		portraitLeft = new FlxSprite(0, -20);
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'feet' | 'toes' | 'sole':
				portraitLeft.frames = Paths.getSparrowAtlas('dialogue/dogePortrait');
				portraitLeft.animation.addByPrefix('enter', 'doge icon enter', 24, false);
				portraitLeft.animation.addByPrefix('exit', 'doge icon exit', 24, false);
			case 'fire truck' | 'moster truck' | 'all bark no bite' | 'scrapped':
				portraitLeft.frames = Paths.getSparrowAtlas('dialogue/walterPortrait');
				portraitLeft.animation.addByPrefix('enter', 'walter icon enter', 24, false);
				portraitLeft.animation.addByPrefix('exit', 'walter icon exit', 24, false);
		}
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, -20);
		portraitRight.frames = Paths.getSparrowAtlas('dialogue/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'bf icon enter', 24, false);
		portraitRight.animation.addByPrefix('exit', 'bf icon exit', 24, false);
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		portraitMid = new FlxSprite(0, -20);
		portraitMid.frames = Paths.getSparrowAtlas('dialogue/gfPortrait');
		portraitMid.animation.addByPrefix('enter', 'gf icon enter', 24, false);
		portraitMid.animation.addByPrefix('exit', 'gf icon exit', 24, false);
		portraitMid.scrollFactor.set();
		add(portraitMid);
		portraitMid.visible = false;
		
		box = new FlxSprite().loadGraphic(Paths.image('dialogue/dialogueBox'));
		box.alpha = 0;
		add(box);

		FlxTween.tween(bgFade, {alpha: 0.75}, 2, {ease: FlxEase.expoInOut});
		FlxTween.tween(box, {alpha: 1}, 0.5, {ease: FlxEase.expoInOut});

		swagDialogue = new FlxTypeText(0, 490, Std.int(FlxG.width * 0.7), "", 24);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFFEDEEEE;
		add(swagDialogue);
		swagDialogue.screenCenter(X);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (!dialogueStarted)
		{
			startDialogue();
			FlxG.sound.playMusic(Paths.music('breakfast'), 0);
			FlxG.sound.music.fadeIn(1, 0, 0.1);
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (FlxG.sound.music != null)
						FlxG.sound.music.fadeOut(2, 0);

					if (portraitRight.animation.name != "exit")
						portraitRight.animation.play('exit');

					if (portraitLeft.animation.name != "exit")
						portraitLeft.animation.play('exit');

					if (portraitMid.animation.name != "exit")
						portraitMid.animation.play('exit');

					FlxTween.tween(bgFade, {alpha: 0}, 2, {ease: FlxEase.expoInOut});
					FlxTween.tween(box, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut});
					FlxTween.tween(swagDialogue, {alpha: 0}, 0.5, {ease: FlxEase.expoInOut});

					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);

		if (curCharacter == 'dad') {

			portraitLeft.visible = true;

			if (portraitLeft.animation.name != "enter")
				portraitLeft.animation.play('enter');
			
			if (portraitRight.animation.name != "exit")
				portraitRight.animation.play('exit');

			if (portraitMid.animation.name != "exit")
				portraitMid.animation.play('exit');

			switch (PlayState.SONG.song.toLowerCase()) {
				case "feet" | "toes" | "sole":
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dogeText'), 0.6), FlxG.sound.load(Paths.sound('dogeText'), 0.8)];
				case "fire truck" | "moster truck" | "all bark no bite" | "scrapped":
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('walterText'), 0.6), FlxG.sound.load(Paths.sound('walterText'), 0.8)];
			}
		}
		if (curCharacter == 'bf') {

			portraitRight.visible = true;

			if (portraitRight.animation.name != "enter")
				portraitRight.animation.play('enter');
			
			if (portraitLeft.animation.name != "exit")
				portraitLeft.animation.play('exit');

			if (portraitMid.animation.name != "exit")
				portraitMid.animation.play('exit');

			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6), FlxG.sound.load(Paths.sound('bfText'), 0.8)];
		}
		if (curCharacter == 'gf') {

			portraitMid.visible = true;

			if (portraitMid.animation.name != "enter")
				portraitMid.animation.play('enter');
			
			if (portraitLeft.animation.name != "exit")
				portraitLeft.animation.play('exit');

			if (portraitRight.animation.name != "exit")
				portraitRight.animation.play('exit');

			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 0.7), FlxG.sound.load(Paths.sound('gfText'), 0.9)];
		}

		swagDialogue.start(0.04, true);
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
