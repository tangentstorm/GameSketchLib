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
public abstract class GsTool extends GsBasic
{
    public void click(float mouseX, float mouseY, GsBasic subject)
    {
    }

    public void press(float mouseX, float mouseY, GsBasic subject)
    {
    }

    public void dragStart(float mouseX, float mouseY, GsBasic subject)
    {
    }

    public void drag(float mouseX, float mouseY, GsBasic subject)
    {
    }

    public void dragEnd(float mouseX, float mouseY, GsBasic subject)
    {
    }
}


