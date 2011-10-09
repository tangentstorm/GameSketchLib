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
 */

PrintWriter out = createWriter("BaseGameSketch-Combined.txt");

final String kSpliceMainFile = "-A-";
final String kSpliceLibStart = "-B-";
final String kSpliceLibEnd   = "-C-";
final String kDirName = "BaseGameSketch";
final String chunks[] =
{
  kSpliceMainFile  , // BaseGameSketch
  "MenuState.pde"  ,
  "PlayState.pde"  ,
  kSpliceLibStart  ,
  "Game.pde"       ,
  "GameBounds.pde" ,
  "GameGroup.pde"  ,
  "GameLoop.pde"   ,
  "GameObject.pde" ,
  "GameRect.pde"   ,
  "GameSquare.pde" ,
  "GameState.pde"  ,
  "GameText.pde"   ,
  kSpliceLibEnd    
};

boolean inTheLib = false;

for (int i = 0; i < chunks.length; ++i)
{
    String s = chunks[i];
    
    if (s == kSpliceMainFile)
    {
        String lines[] = loadStrings(kDirName + "/" + kDirName + ".pde");
        
        out.println("/* ");
        out.println(" * " + kDirName);
        out.println(" * ");
        out.println(" * http://github.com/sabren/GameSketchLib");
        out.println(" * ");
        out.println(" * A small game engine for processing and processing-js,");
        out.println(" * inspired by flixel.");
        out.println(" * ");
        out.println(" * USAGE:");
        out.println(" * ====================================================");
        out.println(" * ");
        out.println(" *  1. Change the size() call below to the window size");
        out.println(" *     you want to use.");
        out.println(" * ");
        out.println(" *  2. Edit PlayState and MenuState to get started!");
        out.println(" * ");

        out.println(" */");
        
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
            out.println(lines[j]);
        }
    }
}

out.flush();
out.close();

