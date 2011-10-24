package org.gamesketchlib;

/**
 * GameTools allow the GsMouse to interact with the
 * game in different ways.
 *
 * They work very much like tools in any drawing or paint
 * program, but may also come in handy for things like:
 *
 *   - weapons with mouse based aiming
 *   - level editors
 *   - games where you assign tasks to characters
 *   - etc.
 */
public abstract class GsTool extends GsProto
{
    void click(float x, float y, GsBasic subject)
    {
    }

    void press(float x, float y, GsBasic subject)
    {
    }

    void dragStart(float x, float y, GsBasic subject)
    {
    }
    
    void drag(float x, float y, GsBasic subject)
    {
    }

    void dragEnd(float x, float y, GsBasic subject)
    {
    }
    
    
    /* Same as GsBasic.send
     *
     * A generic (untyped) message-passing protocol for
     * communicating between objects.
     *
     * Messages should be defined with Game.newMessageId();
     */
    Object send(int message, Object arg)
    {
        return null;
    }
}


