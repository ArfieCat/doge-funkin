package;

import sys.FileSystem;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

using StringTools;

class Caching extends MusicBeatState
{
    var toBeDone = 0;
    var done = 0;

    var text:FlxText;
    var kadeLogo:FlxSprite;

	override function create()
	{
        FlxG.mouse.visible = false;

        FlxG.worldBounds.set(0,0);

        text = new FlxText(0, FlxG.height / 2 + 300,0,"Loading...");
        text.size = 34;
        text.alignment = FlxTextAlign.CENTER;
        text.alpha = 0;

        kadeLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('KadeEngineLogo'));
        kadeLogo.x -= kadeLogo.width / 2;
        kadeLogo.y -= kadeLogo.height / 2 + 100;
        text.y -= kadeLogo.height / 2 - 125;
        kadeLogo.setGraphicSize(Std.int(kadeLogo.width * 0.6));
        kadeLogo.antialiasing = true;
        kadeLogo.alpha = 0;

        add(kadeLogo);
        add(text);
        text.screenCenter(X);

        trace('starting caching..');
        
        sys.thread.Thread.create(() -> {
            cache();
        });


        super.create();
    }

    var calledDone = false;

    override function update(elapsed) 
    {

        if (toBeDone != 0 && done != toBeDone)
        {
            var alpha = HelperFunctions.truncateFloat(done / toBeDone * 100,2) / 100;
            kadeLogo.alpha = alpha;
            text.alpha = alpha;
            text.text = "Loading...";
        }

        super.update(elapsed);
    }


    function cache()
    {

        var images = [];
        var music = [];

        trace("caching images...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
        {
            if (!i.endsWith(".png"))
                continue;
            images.push(i);
        }

        trace("caching music...");

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
        {
            music.push(i);
        }

        toBeDone = Lambda.count(images) + Lambda.count(music);

        trace("LOADING: " + toBeDone + " OBJECTS.");

        for (i in images)
        {
            var replaced = i.replace(".png","");
            FlxG.bitmap.add(Paths.image("characters/" + replaced,"shared"));
            trace("cached " + replaced);
            done++;
        }

        for (i in music)
        {
            FlxG.sound.cache(Paths.inst(i));
            FlxG.sound.cache(Paths.voices(i));
            trace("cached " + i);
            done++;
        }

        trace("Finished caching...");

        FlxG.switchState(new TitleState());
    }

}