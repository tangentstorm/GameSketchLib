package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

/**
 * A simple rectangle that draws itself on screen.
 * Will toggle fill colors based on this.alive.
 */
public class GsRect extends GsObject
{
    public int liveColor = 0xffFFFFFF;
    public int deadColor = 0xffCCCCCC;
    public int lineColor = 0xff666666;
    public int lineWeight = 1;
  
    GsRect()
    {
        super(0, 0, 0, 0);
    }

    GsRect(float x, float y, float w, float h)
    {
        super(x, y, w, h);
    }
    
    @Override
    public void render()
    {
        strokeWeight(this.lineWeight);
        fill(this.alive ? this.liveColor : this.deadColor );
        rect(this.x, this.y, this.w, this.h);
    }

}

