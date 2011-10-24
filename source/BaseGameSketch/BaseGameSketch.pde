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
    size(300, 300);
    Game.init();
    Game.switchState(new MenuState());
}

class MenuState extends GsState
{
   public void create()
   {
       add(new GsText("A New GameSketchLib Game!",
                        Game.bounds.w /2, 100, #FFFFFF, 18));
                        
       add(new GsText("Click to Play",
                        Game.bounds.w / 2, 150, #CCCCCC, 12));
   }
   
   public void click()
   {
       Game.switchState(new PlayState());
   }
}


class PlayState extends GsState
{
   void create()
   {
       add(new GsText("Put your game logic in PlayState!",
                        Game.bounds.w / 2, 150, #CCCCCC, 12));
   }
}



