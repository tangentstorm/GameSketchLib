/**
 * Global Mouse handler.
 */
class GameMouse
{
    /** 
     * stores current mouseX
     */
    public float x;
    
    /** 
     * stores current mouseX
     */
    public float y;
    
    /** 
     * mouseX recorded on mousePressed
     */
    public float startX;
    
    /** 
     * mouseY recorded on mousePressed
     */
    public float startY;
    
    /** 
     * offset of subject.x from mouseX
     */
    public float offsetX;
    
    /** 
     * offset of subject.y from mouseY
     */
    public float offsetY;
    
    /** 
     * mouseX adjusted by offsetX
     */
    public float adjustedX;
    
    /** 
     * mouseY adjusted by offsetY
     */
    public float adjustedY;
    
    /** 
     * are we currently dragging/swiping?
     * true if mouse is down, even if subject is GameNull
     */
    public boolean dragging = false;
    
    /**
     * The GameBasic we're currently dragging, or GameNull.
     */
    public GameBasic subject = GameNull;
    
    /**
     * Adding any GameBasic to Game.mouse.subjects lets it 
     * interact with the mouse / touchscreen.
     *
     * If Game.tool is set to BasicTool (the default) then
     * the subject's click(), drag() and press() will be
     * called.
     *
     * Other behaviors are defined by the individual Tools.
     */
    public GameGroup subjects  = new GameGroup();
    
    /**
     * Adding a GameBasic to Game.mouse.observers lets it
     * receive position updates.
     *
     * This might come in handy for targeting systems,
     * mouseover effects, etc.
     */
    public GameGroup observers = new GameGroup();
  
    // mousePressed
    public void pressed()
    {
        this.x = this.startX = mouseX;
        this.y = this.startY = mouseY;
        
        for (GameBasic gab : this.subjects.each())
        {
            if (gab.containsPoint(this.x, this.y))
            {
                this.subject = gab;
                this.offsetX = gab.x - this.x;
                this.offsetY = gab.y - this.y;
                return;
            }
        }
        // whatever they clicked on wasn't clickable :)
        this.subject = GameNull;
    }
    
    // mouseReleased
    public void released()
    {
        this.updateCoordinates();
        
        if (this.dragging)
        {
            Game.tool.dragEnd(this.x, this.y, this.subject);
        }
        else
        {
            // TODO add a timer and allow for long presses
            Game.tool.click(this.x, this.y, this.subject);
        }
      
        this.dragging = false;
        this.offsetX = 0;
        this.offsetY = 0;
        this.subject = GameNull;
    }
    
    // mouseMoved
    public void moved()
    {
        this.updateCoordinates();
        this.notifyObservers();
    }
    
    // mouseDragged
    public void dragged()
    {
        this.moved();
        if (! this.dragging)
        {
            Game.tool.dragStart(this.startX, this.startY, this.subject);
            this.dragging = true;
        }
        this.updateCoordinates();
        Game.tool.drag(this.x, this.y, this.subject);
    }
    
    protected void updateCoordinates()
    {
        this.x = mouseX;
        this.y = mouseY;
        this.adjustedX = this.x + this.offsetX;
        this.adjustedY = this.y + this.adjustedY;
    }
    
    protected void notifyObservers()
    {
         for (GameBasic gab : this.observers.each())
         {
             // gab.mouseAt(mouseX, mouseY);
         }
    }
}

