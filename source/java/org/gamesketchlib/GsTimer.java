package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

/*
 * GsTimer timer = new GsTimer(1.25 * SECONDS);
 *
 * Then in your .update() method:
 *
 *     timer.update();
 *     if (timer.ready) { }
 *
 * Alternatively, you can override onTick();
 *
 */
public class GsTimer extends GsObject
{
    float millisPerTick = 0;
    float mMillisSoFar = 0;
    boolean ready;
    int tickCount = 0;
    
    GsTimer(float millisPerTick)
    {
        super(0, 0, 0, 0);
        this.millisPerTick = millisPerTick;
    }
    
    GsTimer(float millisPerTick, boolean immediate)
    {
        super(0, 0, 0, 0);
        this.millisPerTick = millisPerTick;
        if (immediate) mMillisSoFar = millisPerTick;
    }

    void setTicksPerSecond(float ps)
    {
        this.millisPerTick = SECONDS / ps;
    }
    
    @Override
    public void update()
    {
        ready = false;
        mMillisSoFar += Game.frameMillis;
        
        if (mMillisSoFar > millisPerTick)
        {
            ready = true;
            mMillisSoFar = 0;
            tickCount++;
            onTick();
        }
    }
    
    // convenience so we don't have to keep calling .update()
    boolean checkReady()
    {
        update();
        return ready;
    }
    
    // this just adds a little variety if you have a
    // bunch of objects doing the same thing.
    void randomize()
    {
        mMillisSoFar = random(millisPerTick);
    }
    
    void onTick()
    {
    }
}
