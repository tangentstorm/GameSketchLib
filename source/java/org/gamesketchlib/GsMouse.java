package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

/**
 * Global Mouse handler.
 */
public class GsMouse
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
     * The GsBasic we're currently dragging, or GameNull.
     */
    public GsBasic subject = GameNull;
    
    /**
     * Adding any GsBasic to Game.mouse.subjects lets it
     * interact with the mouse / touchscreen.
     *
     * If Game.tool is set to GsBasicTool (the default) then
     * the subject's click(), drag() and press() will be
     * called.
     *
     * Other behaviors are defined by the individual Tools.
     */
    public GsGroup subjects  = new GsGroup();
    
    /**
     * Adding a GsBasic to Game.mouse.observers lets it
     * receive position updates.
     *
     * This might come in handy for targeting systems,
     * mouseover effects, etc.
     */
    public GsGroup observers = new GsGroup();
  
    // mousePressed
    public void pressed(float mouseX, float mouseY)
    {
        this.x = this.startX = mouseX;
        this.y = this.startY = mouseY;
        
        for (GsBasic gab : this.subjects.each())
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
    public void released(float mouseX, float mouseY)
    {
        this.updateCoordinates(mouseX, mouseY);
        
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
    public void moved(float mouseX, float mouseY)
    {
        this.updateCoordinates(mouseX, mouseY);
        this.notifyObservers();
    }
    
    // mouseDragged
    public void dragged(float mouseX, float mouseY)
    {
        this.moved(mouseX, mouseY);
        if (! this.dragging)
        {
            Game.tool.dragStart(this.startX, this.startY, this.subject);
            this.dragging = true;
        }
        this.updateCoordinates(mouseX, mouseY);
        Game.tool.drag(this.x, this.y, this.subject);
    }
    
    protected void updateCoordinates(float mouseX, float mouseY)
    {
        this.x = mouseX;
        this.y = mouseY;
        this.adjustedX = this.x + this.offsetX;
        this.adjustedY = this.y + this.adjustedY;
    }
    
    protected void notifyObservers()
    {
         for (GsBasic gab : this.observers.each())
         {
             // gab.mouseAt(mouseX, mouseY);
         }
    }
}

