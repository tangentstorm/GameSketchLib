
/*
 * GameTimer timer = new GameTimer(1.25 * SECONDS);
 *
 * Then in your .update() method:
 *
 *     timer.update();
 *     if (timer.ready) { }
 *
 * Alternatively, you can override onTick();
 *
 */
class GameTimer extends GameObject
{
    float millisPerTick = 0;
    float mMillisSoFar = 0;
    boolean ready;
    int tickCount = 0;
    
    GameTimer(float millisPerTick)
    {
        super(0, 0, 0, 0);
        this.millisPerTick = millisPerTick;
    }
    
    GameTimer(float millisPerTick, boolean immediate)
    {
        super(0, 0, 0, 0);
        this.millisPerTick = millisPerTick;
        if (immediate) mMillisSoFar = millisPerTick;
    }

    void setTicksPerSecond(float ps)
    {
        this.millisPerTick = SECONDS / ps;
    }
    
    void update()
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
