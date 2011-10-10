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

final String kSpliceMainFile = "-A-";
final String kSpliceLibStart = "-B-";
final String kSpliceLibEnd   = "-C-";
final String kDirName = "GameSketchLib";
PrintWriter out = createWriter("BaseGameSketch/BaseGameSketch.pde");

// a sneaky trick so we can replace lines like loadFont(...)
final String kReplaceMarker = "//:PJS-REPLACE://";

final String chunks[] =
{
  "BaseGameSketch.pde",
  "MenuState.pde"  ,
  "PlayState.pde"  ,
  kSpliceLibStart  ,
  kSpliceMainFile  , // "GameSketchLib.pde"
  "Game.pde"       ,
  "GameBounds.pde" ,
  "GameGroup.pde"  ,
  "GameKeys.pde"   ,
  "GameMath.pde"   ,
  "GameObject.pde" ,
  "GameRect.pde"   ,
  "GameSheet.pde"  ,
  "GameSprite.pde" ,
  "GameSquare.pde" ,
  "GameState.pde"  ,
  "GameText.pde"   ,
  "GameTimer.pde"  ,
  kSpliceLibEnd    
};

boolean inTheLib = false;

for (int i = 0; i < chunks.length; ++i)
{
    String s = chunks[i];
    
    if (s == kSpliceMainFile)
    {
        String lines[] = loadStrings(kDirName + "/" + kDirName + ".pde");
        
        // strip out he initial comment
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
    else if (s == kSpliceLibStart)
    {
        out.println();
        out.println("// -- [Begin GameSketchLib] --------------------------------------");
        out.println();
    }
    else if (s == kSpliceLibEnd)
    {
        out.println();
        out.println("// -- [End GameSketchLib] ----------------------------------------");
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
        for (int j = 0; j < lines.length; ++j)
        {
            if (lines[j].indexOf(kReplaceMarker) != -1)
            {
                int cutPoint = lines[j].indexOf(kReplaceMarker) + kReplaceMarker.length();
                out.println(lines[j].substring(cutPoint));
            }
            else
            {
                out.println(lines[j]);
            }
        }
    }
}

out.flush();
out.close();

