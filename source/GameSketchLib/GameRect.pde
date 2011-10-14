class GameRect extends GameObject
{
    color liveColor = #FFFFFF;
    color deadColor = #CCCCCC;
    int lineWeight = 1;
  
    GameRect (float x, float y, float w, float h)
    {
        super(x, y, w, h);
    }
    
    public void render()
    {
        strokeWeight(this.lineWeight);
        fill(this.alive ? this.liveColor : this.deadColor );
        rect(this.x, this.y, this.w, this.h);
    }  
}

