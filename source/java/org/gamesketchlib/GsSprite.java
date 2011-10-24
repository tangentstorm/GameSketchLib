package org.gamesketchlib;

import processing.core.PImage;
import static org.gamesketchlib._GameSketchLib.*;

public class GsSprite extends GsObject
{
    // animation stuff:
    int frame = 0;
    private PImage[] mFrames;
    boolean animated = false;
    GsTimer timer = new GsTimer(SECONDS/8);

    // rotation stuff:
    int degrees = 0;    
    float xOffset = 0;
    float yOffset = 0;

    GsSprite(float x, float y)
    {
        super(x, y, 0, 0);
        animated = true;
    }
    
    void setFrames(PImage[] frames)
    {
        mFrames = frames;
        sizeToFrame();
    }
    
    void sheetFrames(int[] frameNums)
    {
        this.setFrames(SHEET.getFrames(frameNums));
    }
    
    
    void sizeToFrame()
    {
        this.w = mFrames[this.frame].width;
        this.h = mFrames[this.frame].height;
        this.xOffset = this.w / 2;
        this.yOffset = this.h / 2;
    }
    
    @Override
    public void update()
    {
        if (this.animated)
        {
            this.timer.update();
            if (this.timer.ready)
            {
                this.frame++;
                this.frame %= mFrames.length;
            }
        }
    }
    
    void randomize()
    {
        this.frame = (int) random(mFrames.length);
        this.timer.randomize();
    }
    
    @Override
    public void render()
    {
        if (! visible) return;
        
        if (this.degrees == 0)
        {
            image(mFrames[this.frame], this.x, this.y);
        }
        else
        {
            pushMatrix();
            translate(this.x + this.xOffset, this.y + this.yOffset);
            rotate(this.degrees * PI / 180);
            image(mFrames[this.frame], -this.xOffset, -this.yOffset);
            popMatrix();
        }
        
        if (DEBUG)
        {
          stroke(255);
          noFill();
          rect(x, y, w, h);
        }
    }
}

