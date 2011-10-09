/*
 * GameSketchLib
 * http://github.com/sabren/GameSketchLib
 *
 * A small game engine for processing and processing-js,
 * inspired by flixel.
 *
 * USAGE:
 * ====================================================
 *
 *  1. In processing, use "File... Save As" to make a
 *     new copy of this directory
 *
 *  2. Change the size() call below to the window size
 *     you want to use.
 * 
 *  3. Edit PlayState and MenuState to get started!
 *
 */
 
void setup()
{
    size(300, 300);
    Game.init(new MenuState());
}

