/*
 * GameSketchLib : http://github.com/sabren/GameSketchLib
 *
 * A small game engine for processing and processing-js,
 * inspired by flixel.
 *
 *
 * >>   Edit PlayState and MenuState to get started!   <<
 *
 *
 */
 
void setup()
{
    size(300, 300);
    Game.init(new MenuState());
}

//========================================================

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

