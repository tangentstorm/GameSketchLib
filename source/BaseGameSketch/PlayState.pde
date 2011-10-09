class PlayState extends GameState
{
 
   void create()
   {
       add(new GameText("Put your game logic in PlayState.",
                        Game.bounds.w/2, 50, #CCCCCC, 12));
   }
  
}

