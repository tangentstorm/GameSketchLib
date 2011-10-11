class GameText extends GameObject
{
    String label;
    color textColor;
    int fontSize = 20;
    int align = CENTER;
    
    GameText(String label, float x, float y, color textColor, int fontSize)
    {
        super(x, y, 0, 0);
        this.label = label;
        this.fontSize = fontSize;
        this.textColor = textColor;
    }
    
    void render()
    {
        fill(this.textColor);
        textFont(Game.defaultFont, this.fontSize);
        textAlign(this.align);
        text(this.label, this.x, this.y);
    }
    
}

