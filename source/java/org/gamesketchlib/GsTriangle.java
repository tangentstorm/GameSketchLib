package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

/**
 * A simple triangle that draws itself on screen. Will toggle fill colors based
 * on this.alive.
 */

public class GsTriangle extends GsBasic
{

    // Define the vertices of the triangle
    public float x1, y1;
    public float x2, y2;
    public float x3, y3;

    // The usual colors for the object
    public int liveColor = 0xffFFFFFF;
    public int deadColor = 0xffCCCCCC;
    public int lineColor = 0xff666666;
    public int lineWeight = 1;

    public GsTriangle(float x1, float y1, float x2, float y2, float x3, float y3)
    {
        this.x1 = x1;
        this.x2 = x2;
        this.x3 = x3;
        this.y1 = y1;
        this.y2 = y2;
        this.y3 = y3;
    }

    @Override
    public void render()
    {
        strokeWeight(this.lineWeight);
        fill(this.alive ? this.liveColor : this.deadColor);

        // Triangle interface requires integer coordinates, hence convert from
        // float to int
        triangle((int) x1, (int) y1, (int) x2, (int) y2, (int) x3, (int) y3);
    }

    /**
     * Barycentric technique, based on code found at:
     * http://www.blackpawn.com/texts/pointinpoly/default.html
     */
    public boolean containsPoint(float x, float y)
    {
        float v0[] = new float[2];
        float v1[] = new float[2];
        float v2[] = new float[2];

        v0[0] = x3 - x1;
        v0[1] = y3 - y1;

        v1[0] = x2 - x1;
        v1[1] = y2 - y1;

        v2[0] = x - x1;
        v2[1] = y - y1;

        float dot00 = dotProduct(v0, v0);
        float dot01 = dotProduct(v0, v1);
        float dot02 = dotProduct(v0, v2);
        float dot11 = dotProduct(v1, v1);
        float dot12 = dotProduct(v1, v2);

        // Compute barycentric coordinates
        float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
        float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
        float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

        // Check if point is in triangle
        return (u >= 0) && (v >= 0) && (u + v < 1);
    }

    /**
     * Method to calculate "Dot Product" between two
     * vectors.
     */
    private float dotProduct(float a[], float b[])
    {
        return (a[0] * b[0]) + (a[1] * b[1]);
    }
}
