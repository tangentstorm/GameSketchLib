package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

/**
 * This is a special single-instance class that gives
 * us a null-like value that represents the lack of a
 * normal GsBasic instance.
 *
 * If we used the regular null value, we'd have to 
 * check for (gab != null) everywhere, but with
 * GameNull, we can treat it like any other GsBasic
 * and it just transparently does the right thing.
 *
 * If you do need to test for it, the boolean .isNull
 * is defined on all GsBasic classes. It's false for
 * everything but this class.
 * 
 * http://en.wikipedia.org/wiki/Null_Object_pattern
 */
public final class _GsNull extends GsBasic
{
    // Nullable
    @Override
    public final boolean isNull() { return true; }

    @Override
    public boolean containsPoint(float px, float py)
    {
        return false;
    }
    
    @Override
    public boolean overlaps(GsBasic other)
    {
        return false;
    }

    @Override
    public boolean covers(GsBasic other)
    {
        return false;
    }
    
    
    // Iterable
    // yields an empty list
    private final GsList<GsBasic> mEmptyList = new GsList<GsBasic>(0);
    @Override
    public Iterable<GsBasic> each()
    {
        return mEmptyList;
    }

    // Constructor
    private int mInstanceCount = 0;
    public _GsNull()
    {
        // !! You actually can change these things. There's not really any way to
        //    avoid that without resorting to getters and setters. :/

        // Spatial
        // TODO : GsNull coordinates should all be NaN, but not sure how to make it work for pjs
//        x = Float.NaN;
//        y = Float.NaN;
//        w = Float.NaN;
//        h = Float.NaN;

        // Playable
        alive = false;
        active = false;
        exists = false;
        visible = false;

        if (++mInstanceCount > 1)
        {
            throw new RuntimeException("GameNull is a singleton. There can be only one.");
        }
    }
}

