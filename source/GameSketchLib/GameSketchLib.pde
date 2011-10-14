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
    Game.update();
    Game.render();
}



// global debug flag.
// so far, this just shows Bounds for sprites
boolean DEBUG = false;

// a predefined GameSheet, since everyone wants a GameSheet!
GameSheet SHEET;

// Timer Constants
float SECONDS = 1000;

// Keyboard Constants:
char SPACE = ' ';
char[] WASD_N  = new char[] { 'W', ',', '<' };
char[] WASD_W  = new char[] { 'A', 'a' };
char[] WASD_S  = new char[] { 'S', 's', 'O', 'o' };
char[] WASD_E  = new char[] { 'D', 'd', 'E', 'e' };


// global event handlers:
void mousePressed()  { Game.state.mousePressed();  }
void mouseReleased() { Game.state.mouseReleased(); }
void mouseMoved()    { Game.state.mouseMoved();    }
void mouseDragged()  { Game.state.mouseDragged();  }
void keyPressed()    { Game.keys.setKeyDown(true); }
void keyReleased()   { Game.keys.setKeyDown(null); }


