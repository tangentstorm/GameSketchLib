/*
 * GameSketchLib
 * http://github.com/sabren/GameSketchLib
 *
 * A small game engine for processing and processing-js,
 * inspired by flixel.
 *
 * ------------------------------------------------------
 * 
 * DON'T USE GameSketchLib DIRECTLY! Use  ../source.pde
 * to generate ../BaseGameSketch/BaseGameSketch.pde and 
 * then do a "File -> Save as..." on that.
 *
 * -------------------------------------------------------
 */

void draw()
{
    Game.state.update();
    Game.state.render();
}

void mousePressed()  { Game.state.mousePressed();  }
void mouseReleased() { Game.state.mouseReleased(); }
void mouseMoved()    { Game.state.mouseMoved();    }
void keyPressed()    { Game.state.keyPressed();    }
void keyReleased()   { Game.state.keyReleased();   }

// This figures out which runtime we're using dynamically,
// so we can do conditional compilation.
 
final boolean CONFIG_PJS = (new Object()).toString() == "[object Object]";
final boolean CONFIG_JVM = !CONFIG_PJS;
final String RUNTIME_JVM = "JVM";
final String RUNTIME_PJS = "PJS";
final String RUNTIME = CONFIG_PJS ? RUNTIME_PJS : RUNTIME_JVM;

