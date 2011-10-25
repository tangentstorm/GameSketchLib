package org.gamesketchlib.draw;

import org.gamesketchlib.GsBasic;

import static org.gamesketchlib._GameSketchLib.*;

/**
 * An arrow between two sketches.
 */
public class GsArrowSketch extends GsSketch
{
    private GsBasic pointA;
    private GsBasic pointB;

    public GsArrowSketch(GsBasic pointA, GsBasic pointB)
    {
        this.pointA = pointA;
        this.pointB = pointB;
    }

    @Override
    public void render()
    {
        stroke(128);
        strokeWeight(2);
        line(pointA.cx(), pointA.cy(), pointB.cx(), pointB.cy());
    }

    public GsBasic getPointA()
    {
        return pointA;
    }

    public void setPointA(GsBasic pointA)
    {
        this.pointA = pointA;
    }

    public GsBasic getPointB()
    {
        return pointB;
    }

    public void setPointB(GsBasic pointB)
    {
        this.pointB = pointB;
    }

}
