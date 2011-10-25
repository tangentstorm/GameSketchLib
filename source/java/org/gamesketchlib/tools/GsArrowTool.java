package org.gamesketchlib.tools;

import org.gamesketchlib.*;
import org.gamesketchlib.draw.*;
import static org.gamesketchlib._GameSketchLib.*;

/**
 * A tool that connects two GsSketch objects with an arrow.
 */
public class GsArrowTool extends GsTool
{
    GsSketch empty = new GsSketch();
    GsArrowSketch arrow;

    public GsArrowTool()
    {
        this.exists = true;
        this.visible = false;
        this.active = false;
        this.w = 1;
        this.h = 1;
    }

    @Override
    public void drag(float mouseX, float mouseY, GsBasic subject)
    {
        this.x = mouseX;
        this.y = mouseY;
    }

    @Override
    public void dragStart(float x, float y, GsBasic subject)
    {
        this.visible = this.active = ! subject.isNull();
        this.arrow = new GsArrowSketch(subject, this);
    }

    @Override
    public void dragEnd(float x, float y, GsBasic subject)
    {
        if (! this.active) return;
        
        this.active = this.visible = false;
        GsBasic gsb = Game.mouse.topSubject();
        if (gsb.isNull())
        {
            Game.state.message(this, TOOL_ARROW_TO_NOTHING, arrow);
        }
        else
        {
            this.arrow.setPointB(gsb);
            Game.state.message(this, TOOL_ARROW_TO_SUBJECT, arrow);
        }
    }

    @Override
    public void render()
    {
        this.arrow.render();
    }
}
