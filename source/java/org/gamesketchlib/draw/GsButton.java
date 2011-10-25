package org.gamesketchlib.draw;

import org.gamesketchlib.GsRect;
import org.gamesketchlib.GsText;

import static org.gamesketchlib._GameSketchLib.*;

public class GsButton extends GsSketch
{
    private GsText mText;

    public GsButton(String label)
    {
        super();
        mText = new GsText(label, 0, 0, 0xffcccc99, 18);
        this.reset(0, 0, mText.bounds.w, mText.bounds.h);
        this.children.add(mText);
    }

    @Override
    public void reset(float x, float y, float w, float h)
    {
        super.reset(x, y, w, h);
        if (mText != null)
        {
            mText.x = cx();
            mText.y = cy();
        }
    }

}
