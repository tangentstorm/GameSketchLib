class GameRect extends GameObject
{
    color liveColor = #FFFFFF;
    color deadColor = #CCCCCC;
  
    GameRect (float x, float y, float w, float h)
    {
        super(x, y, w, h);
    }
    
    public void render()
    {
        fill(this.alive ? this.liveColor : this.deadColor );
        rect(this.x, this.y, this.w, this.h);
    }  
}

