/**
 * A simple rectangle that draws itself on screen.
 * Will toggle fill colors based on this.alive.
 */
class GameRect extends GameObject
{
    public color liveColor = #FFFFFF;
    public color deadColor = #CCCCCC;
    public color lineColor = #666666;
    public int lineWeight = 1;
  
    GameRect()
    {
        super(0, 0, 0, 0);
    }
  
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

