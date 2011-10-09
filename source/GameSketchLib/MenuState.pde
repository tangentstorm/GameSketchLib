class MenuState extends GameState
{
   void create()
   {
       add(new GameText("A New GameSketchLib Game!",
                        Game.bounds.w /2, 100, #FFFFFF, 18));
                        
       add(new GameText("Click to Play",
                        Game.bounds.w / 2, 150, #CCCCCC, 12));
   }
   
   void mousePressed()
   {
       Game.switchState(new PlayState());
   }
}
