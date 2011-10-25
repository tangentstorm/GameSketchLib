package org.gamesketchlib.draw;

import org.gamesketchlib.*;

import java.util.ArrayList;

import static org.gamesketchlib._GameSketchLib.*;

/**
 * A Sketch is a composite GsObject.
 */
public class GsSketch extends GsObject
{
    public GsGroup children = new GsGroup();
    protected int mBgColor = -1;

    public GsSketch()
    {   super(0, 0, 50, 50);
        this.draggable = true;
    }

    public GsSketch at(float x, float y)
    {
        this.x = x;
        this.y = y;
        return this;
    }

    public void add(GsBasic gsb)
    {
        this.children.add(gsb);
    }

    @Override
    public void render()
    {
        if (mBgColor != -1)
        {
            fill(mBgColor);
            rect(x, y, w, h);
        }
        pushMatrix();
        translate(this.x, this.y);
        this.children.render();
        popMatrix();
    }

    @Override
    public void update()
    {
        this.children.update();
    }


    @Override
    public Iterable<GsBasic> each()
    {
        ArrayList<GsBasic> us = new ArrayList<GsBasic>();
        us.add(this);
        for (GsBasic gsb : this.children.each())
        {
            us.add(gsb);
        }
        return us;
    }

    public void printStructure(int level)
    {
        for (int i = 0; i < level; ++i) { print("  "); }
        println(this.getClass().getName());
        for (GsBasic gsb : this.children.each())
        {
            if (gsb instanceof GsSketch)
            {
                ((GsSketch) gsb).printStructure(level + 1);
            }
            else
            {
                for (int i = 0; i <= level; ++i) { print("  "); }
                println(gsb.getClass().getName());

            }
        }

    }

    public GsSketch resize(int w, int h)
    {
        this.reset(x, y, w, h);
        return this;
    }

    public GsSketch setBgColor(int bgColor)
    {
        mBgColor = bgColor;
        return this;
    }
}
