package org.gamesketchlib;
import static org.gamesketchlib._GameSketchLib.*;

/**
 * The GsBasicTool simply calls .click, .drag, or (TODO) .press
 * on anything in Game.mouse.subjects that the user interacts with.
 */
public class GsBasicTool extends GsTool
{
    @Override
    public void click(float x, float y, GsBasic subject)
    {
        if (subject.isNull()) Game.state.click(); else subject.click();
    }

    @Override
    public void drag(float x, float y, GsBasic subject)
    {
        if (subject.isNull()) Game.state.drag(); else subject.drag();
    }
}
