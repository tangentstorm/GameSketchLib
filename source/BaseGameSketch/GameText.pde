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
        GameText_render(this);
    }
}

// !! Another processing-js workaround.
//    Calling txt.render() fails silently.
//    Maybe it screws up javascript's "this" context?
void GameText_render(GameText txt)
{
    fill(txt.textColor);
    textSize(txt.textSize);
    textAlign(txt.textAlign);
    text(txt.text, txt.x, txt.y);
}
