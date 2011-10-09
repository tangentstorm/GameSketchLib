class GameText extends GameObject
{
    String text;
    color textColor;
    int textSize = 20;
    int textAlign = CENTER;
    
    GameText(String text, float x, float y, color textColor, int textSize)
    {
        super(x, y, 0, 0);
        this.text = text;
        this.textSize = textSize;
        this.textColor = textColor;
    }
    
    void render()
    {
        fill(this.textColor);
        textSize(this.textSize);
        textAlign(this.textAlign);
        text(this.text, this.x, this.y);
    }
}
