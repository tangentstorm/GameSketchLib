/**
 * A GameObject that displays text.
 *
 */
class GameText extends GameObject
{
    public String label;
    public color textColor;
    public int fontSize = 20;
    public int align = CENTER;
    public int vAlign = BASELINE;
    
    /**
     * A GameRect in case you want to draw a background or border.
     * It's hidden by default.
     * If you change .x, .y, or .label, you should call calcBounds();
     */
    public GameRect bounds;
    
    GameText(String label, float x, float y, color textColor, int fontSize)
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
        
        this.bounds = new GameRect(this.x, this.y, this.w, this.h);
        this.bounds.liveColor = #000000;
        this.bounds.lineColor = #999999;
        this.bounds.visible = false;
        
        if (this.align == CENTER)
            this.bounds.x -= this.w / 2;
        if (this.vAlign == BASELINE)
            this.bounds.y -= textAscent();
    }

    
    protected void setupFont()
    {
        fill(this.textColor);
        textFont(Game.defaultFont, this.fontSize);
        textAlign(this.align);
    }
    
}

