/*
 * GameSketchLib
 * http://gamesketchlib.org/
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
 *  2. Change the Game.size() call below to the window size
 *     you want to use.
 * 
 *  3. Edit PlayState and MenuState to get started!
 *
 */
 
void setup()
{
    Game.size(300, 300);
    Game.init(new MenuState());
}

