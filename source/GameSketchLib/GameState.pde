class GameState extends GameGroup
{
    color bgColor = #000000;
    
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
    void mouseMoved() { }
    void keyPressed() { } 
    void keyReleased() { }
}

