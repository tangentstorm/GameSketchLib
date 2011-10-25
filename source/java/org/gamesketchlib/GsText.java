package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

/**
 * A GsObject that displays text.
 *
 */
public class GsText extends GsObject
{
    public String label;
    public int textColor;
    public int fontSize = 20;
    public int align = CENTER;
    public int vAlign = BASELINE;
    
    /**
     * A GsRect in case you want to draw a background or border.
     * It's hidden by default.
     * If you change .x, .y, or .label, you should call calcBounds();
     */
    public GsRect bounds;
    
    public GsText(String label, float x, float y, int textColor, int fontSize)
    {
        super(x, y, 0, 0);
        
        this.fontSize = fontSize;
        this.textColor = textColor;
        
        this.setLabel(label);
    }
    
    @Override
    public void render()
    {
        this.setupFont();
        text(this.label, this.x, this.y);
    }

    public void setLabel(String label)
    {
       this.label = label;   
       this.calcBounds();
    }
    
    
    public void calcBounds()
    {
        this.setupFont();
        
        this.w = textWidth(this.label);
        this.h = textAscent() + textDescent();
        
        this.bounds = new GsRect(this.x, this.y, this.w, this.h);
        this.bounds.liveColor = 0xff000000;
        this.bounds.lineColor = 0xff999999;
        this.bounds.visible = false;
        
        if (this.align == CENTER)
            this.bounds.x -= this.w / 2;
        if (this.vAlign == BASELINE)
            this.bounds.y -= textAscent();
    }

    public void moveByBoundsTo(float x, float y)
    {
        float offX = this.x - bounds.x;
        float offY = this.y - bounds.y;
        this.x = x + offX;
        this.y = y + offY;
        calcBounds();
    }

    protected void setupFont()
    {
        fill(this.textColor);
        textFont(Game.defaultFont, this.fontSize);
        textAlign(this.align);
    }

}

