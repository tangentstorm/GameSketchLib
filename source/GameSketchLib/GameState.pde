class GameState extends GameGroup
{
    color bgColor = #000000;
    
    public GameState()
    {
        super();
        this.w = Game.bounds.w;
        this.h = Game.bounds.h;
    }
    
    void create()
    {
    }
    
    void render()
    {
        background(bgColor);
        super.render();
    }
    
    // empty event handlers:
    void mousePressed() { }
    void mouseReleased() { }
    void mouseDragged()  { }
    void mouseMoved() { }
    void keyPressed() { } 
    void keyReleased() { }
}

