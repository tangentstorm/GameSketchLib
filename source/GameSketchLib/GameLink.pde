/**
 * A GameText that looks and acts like a hyperlink.
 *
 * For the time being, hook up the mouse handling yourself
 * in your GameState, using something like this:
 * 
 *  void mouseMoved()
 *  {
 *      mLink.hover = mLink.bounds.containsPoint(mouseX, mouseY);
 *      cursor( mLink.hover ? HAND : ARROW );
 *  }
 *  
 *  void mousePressed()
 *  {
 *      if (mLink.hover) mLink.click();
 *  }
 * 
 */
public class GameLink extends GameText
{
    String url;
    
    // !! this is meant to be changed from outside
    public boolean hover = false;
  
    GameLink(String label, String url, float x, float y, color textColor, int fontSize)
    {
        super(label, x, y, textColor, fontSize);
        this.url = url;
        this.calcBounds();
    }
    
    @Override
    public void render()
    {
        if (this.bounds.visible) this.bounds.render();
        super.render();
        
        if (hover)
        {
            stroke(this.textColor);
            float txtW = textWidth(this.label);
            // TODO: get underline working when align != CENTER, BASELINE
            float lineY = this.y +2;
            line(this.x - txtW/2, lineY, this.x + txtW/2 , lineY);
        }
        
    }
    
    public void click()
    {
        link(this.url, "_new");
    }
    
}

