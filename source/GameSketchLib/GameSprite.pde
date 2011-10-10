class GameSprite extends GameObject
{
    // animation stuff:
    int frame = 0;
    private PImage[] mFrames;
    boolean animated = false;
    GameTimer timer = new GameTimer(SECONDS/8);

    // rotation stuff:
    int degrees = 0;    
    float xOffset = 0;
    float yOffset = 0;
    
    GameSprite(float x, float y, PImage[] frames)
    {
        super(x, y, 0, 0);
        setFrames(frames);
        animated = true;
    }

    GameSprite(float x, float y, PImage still)
    {
        super(x, y, 0, 0);
        setFrames(new PImage[] { still });
    }
    
    void setFrames(PImage[] frames)
    {
        mFrames = frames;
        sizeToFrame();
    }
    
    void sizeToFrame()
    {
        this.w = mFrames[this.frame].width;
        this.h = mFrames[this.frame].height;
        this.xOffset = this.w / 2;
        this.yOffset = this.h / 2;
    }
    
    void update()
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
    
    void render()
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
