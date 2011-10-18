

/*
 * GameSketchLib file packager.
 *
 * The source code for games is under BaseGameSketch.
 * Open that in processing and "Save As" something else.
 *
 * This script combines the various files into a single
 * script for studio.sketchpad.cc, which doesn't offer
 * multiple tabs yet.
 *
 * You can also clone the latest version via sketchpad:
 *
 * http://studio.sketchpad.cc/sp/pad/view/ro.9QgCGSB51i-nJ/latest
 *
 */

final String kSpliceLibStart = "-A-";
final String kSpliceLibEnd   = "-B-";

final String kDirName = "GameSketchLib";
PrintWriter outLib = createWriter("BaseGameSketch/GameSketchLib.pde");
PrintWriter outBase = createWriter("BaseGameSketch/BaseGameSketch.pde");

PrintWriter out = outBase;

// !! A sneaky trick so we can replace lines like loadFont(...)
//    This was before we hand RUNTIME and CONFIG_XXX.
//    We don't need this at the moment, but I'm leaving it 
//    here for future work, since android and pjs both have 
//    some incompatabilities.
final String kReplaceMarker = "//:PJS-REPLACE://";

final String chunks[] =
{
  "BaseGameSketch.pde",
  "MenuState.pde"  ,
  "PlayState.pde"  ,
  kSpliceLibStart  ,
  "Game.pde"       ,
  "GameBasic.pde"  ,
  "GameContainer.pde",
  "GameDroid.pde"  ,
  "GameGroup.pde"  ,
  "GameGrid.pde"   ,
  "GameKeys.pde"   ,
  "GameMath.pde"   ,
  "GameMouse.pde"  ,
  "GameNull.pde"   ,
  "GameLink.pde"   ,
  "GameObject.pde" ,
  "GameRect.pde"   ,
  "GameSheet.pde"  ,
  "GameSprite.pde" ,
  "GameSquare.pde" ,
  "GameState.pde"  ,
  "GameText.pde"   ,
  "GameTimer.pde"  ,
  "GameTool.pde"   ,
  kSpliceLibEnd    
};

boolean inTheLib = false;

for (int i = 0; i < chunks.length; ++i)
{
    String s = chunks[i];
    
    if (s == kSpliceLibStart)
    {
        out = outLib;
        inTheLib = true;

        out.println("/* -----------------------------------------------------------------");
                                                                            // YYYY-MM-DD
        out.println(" * GameSketchLib                                 compiled " +
                         String.valueOf(year())
                         + "-" +
                         (month() < 10 ? "0" : "") + String.valueOf(month())
                         + "-" +
                         (day()   < 10 ? "0" : "") + String.valueOf(day())
        );
        out.println(" * -----------------------------------------------------------------");
        out.println(" * ");
        out.println(" * GameSketchLib is an open-source game library for Processing.");
        out.println(" * ");
        out.println(" * It was created by Michal J Wallace and loosely modeled after");
        out.println(" * the flixel game library for actionscript.");
        out.println(" * ");
        out.println(" *       website: http://gamesketchlib.org/");
        out.println(" *          code: https://github.com/sabren/GameSketchLib");
        out.println(" *       twitter: @tangentstorm");
        out.println(" * ");
        out.println(" * If you want to modify the library, consider forking the git");
        out.println(" * repository at github, rather than editing this combined file.");
        out.println(" * ");
        out.println(" * -----------------------------------------------------------------");

        // !! license contains stuff about the course. skip that part.
        String[] license = loadStrings("../LICENSE.txt");
        int licenseHrCount = 0;
        for (int licenseLine = 0; licenseLine < license.length; ++licenseLine)
        {
            if (licenseHrCount >= 2)
            {
                out.println(" * " + license[licenseLine]);
            }
            if (license[licenseLine].startsWith("-")) licenseHrCount++;
        }
        
        out.println(" */// [Begin GameSketchLib] ---------------------------------------");
        out.println();

        // strip out the initial comment in GameSketchLib.pde
        String lines[] = loadStrings(kDirName + "/" + kDirName + ".pde");
        boolean inTheCode = false;
        for (int j = 0; j < lines.length; ++j)
        {
            if (inTheCode)
            {
                out.println(lines[j]);
            }
            else if (lines[j].indexOf("*/") != -1)
            {
                inTheCode = true;
            }
        }

    }
    else if (s == kSpliceLibEnd)
    {
        out.println();
        out.println("/* -- [End GameSketchLib] --------------------------------------*/");
        out.println();
    }
    else
    {
        if (inTheLib)
        {
            out.println();
            out.println("// [ " + s + " ]:");
        }
        out.println();
        
        // dump file contents:
        String lines[] = loadStrings(kDirName + "/" + s);
        if (lines.length == 0) throw new RuntimeException(s + " was empty!");
        
        for (int j = 0; j < lines.length; ++j)
        {
            if (lines[j].indexOf(kReplaceMarker) != -1)
            {
                int cutPoint = lines[j].indexOf(kReplaceMarker) + kReplaceMarker.length();
                out.println(lines[j].substring(cutPoint));
            }
            else if (lines[j].indexOf("@Override") != -1)
            {
                println(s + ":" + j + " - SKIPLINE:" + lines[j]);
            }
            else
            {
                out.println(lines[j]);
            }
        }
    }
}

outBase.flush();
outBase.close();

outLib.flush();
outLib.close();

