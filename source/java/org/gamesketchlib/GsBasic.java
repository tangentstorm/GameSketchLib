package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

/**
 * Base class for pretty much anything inside a game.
 *
 */
public class GsBasic extends GsProto
{
    // !! Nullable protocol
    public boolean isNull() { return false; }
  
    // !! Playable protocol
    // these are straight out of flixel
    public boolean visible = true; // if false: GsGroup won't ask it to render()
    public boolean active = true;  // if false: GsGroup won't ask it to update()
    public boolean exists = true;  // if false: GsGroup won't ask for either.
    public boolean alive = true;   // this one is just handy in games
    public void update()
    {
    }

    public void render()
    {
    }


    // !! GridMember protocol
    // these are handy for storing any of our objects in a grid:
    public int gx;
    public int gy;


    // !! Spatial protocol
    // basic bounds checking
    public float x = 0;
    public float y = 0;
    public float w = 0;
    public float h = 0;

    /**
     * @return the second x coordinate (far right side if .w is positive)
     */
    public float x2()
    {
        return this.x + this.w;
    }

    /**
     * @return the second y coordinate (bottom if h is positive)
     */
    public float y2()
    {
        return this.y + this.h;
    }

    /**
     * @return the horizontal center.
     */
    public float cx()
    {
        return this.x + this.w / 2;
    }

    /**
     * @return the vertical center.
     */
    public float cy()
    {
        return this.y + this.h / 2;
    }

    public boolean containsPoint(float x, float y)
    {
        return this.x <= x && x <= this.x2()
        && this.y <= y && y <= this.y2();
    }

    // http://stackoverflow.com/questions/306316/determine-if-two-Squares-overlap-each-other
    public boolean overlaps(GsBasic that)
    {
        return (this.x < that.x2() && this.x2() > that.x &&
        this.y < that.y2() && this.y2() > that.y);
    }

    /**
     * Returns true if this overlaps all of that's points.
     *
     * I would have called this contains(), but that is used
     * by the GsContainer protocol to mean something else.
     */
    public boolean covers(GsBasic that)
    {
        return this.x <= that.x
        && this.y <= that.y
        && this.x2() >= that.x2()
        && this.y2() >= that.y2();
    }


    // !! Interactive protocol (mouse/touch support)
    // Register with Game.mouse.subjects to get click/press/drag
    public void click() {  }
    public void press() {  }
    public boolean draggable = false;
    public void  drag()
    {
        if (this.draggable)
        {
            this.x = Game.mouse.adjustedX;
            this.y = Game.mouse.adjustedY;
        }
    }

    // Register with Game.mouse.observers to get mouseAt updates.
    public void mouseAt(float x, float y)
    {
    }


    // !! Iteration protocol
    private GsList<GsBasic> mJustMe = new GsList<GsBasic>(1);
    /**
     * each() is a special method we provide so that we have
     * a single unified interface for dealing with groups, 
     * grids, and single objects in our game.
     *
     * GsContainer uses it to implement several variations
     * of the Visitor design pattern.
     *
     * @return an Iterable containing just the current object.
     */
    public Iterable<GsBasic> each()
    { 
        return mJustMe;
    }
    
    // Constructor
    public GsBasic()
    {
        mJustMe.add(this);
    }
}

