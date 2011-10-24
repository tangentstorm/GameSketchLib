class MenuState extends GameState
{
   public void create()
   {
       add(new GameText("A New GameSketchLib Game!",
                        this.w /2, 100, #FFFFFF, 18));
                        
       add(new GameText("Click to Play",
                        this.w / 2, 150, #CCCCCC, 12));
                        
       Game.mouse.subjects.add(this);
   }
   
   public void click()
   {
       Game.switchState(new PlayState());
   }
}
