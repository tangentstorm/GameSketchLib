package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

public class GsState extends GsGroup
{
    int bgColor = 0x00000000;
    
    public GsState()
    {
        super();
        this.w = Game.bounds.w;
        this.h = Game.bounds.h;
    }
    
    public void create()
    {
    }
    
    @Override
    public void render()
    {
        background(bgColor);
        super.render();
    }
}

