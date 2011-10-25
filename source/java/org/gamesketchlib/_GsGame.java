package org.gamesketchlib;

import processing.core.PFont;

import static org.gamesketchlib._GameSketchLib.*;

// Game is a Singleton - i.e., the only instance of _GsGame.
public class _GsGame
{
    public GsState state;
    public GsObject bounds;
    PFont defaultFont;
    GsKeys keys = new GsKeys();
    GsGroup tools = new GsGroup();
    
    
    /**
     * The mouse/touchscreen system.
     */
    public final GsMouse mouse = new GsMouse();
    
    private GsTool tool = new GsBasicTool();
    private GsTool toolR = new GsBasicTool();
    private GsTool toolM = new GsBasicTool();

    public GsTool buttonTool(int mouseButton)
    {
        switch (mouseButton)
        {
            case (RIGHT): return this.toolR;
            case (CENTER): return this.toolM;
            default:
                return this.tool;
        }
    }
    
    
    /**
     *  time ellapsed since last frame;
     */
    public  float frameMillis = 0;
    private float mLastMillis = 0;
        
    // !! no state in init, so that we can be sure .bounds is ready for GsState constructor
    public void init()
    {
        Game.defaultFont = 
            CONFIG_JVM ? loadFont("DejaVuSans-48.vlw")
                       : loadFont("Arial");
        Game.bounds = new GsObject(0, 0, width, height);
    }


    /**
     * This generates a new code for message(). (It just counts up from 0).
     */    
    public int newMessageCode()
    {
        return mCodeCounter++;
    }
    private int mCodeCounter = 0;

    
    /**
     * Switches the game to a new GsState. Pretty self-explanitory. :)
     */
    public void switchState(GsState newState)
    {
        Game.state = newState;
        Game.setTool(new GsBasicTool());
        Game.setToolM(new GsBasicTool());
        Game.setToolR(new GsBasicTool());
        Game.mouse.subjects.clear();
        Game.mouse.observers.clear();
        newState.create();
    }
    
    void update(float ms)
    {
        // update the clock:
        this.frameMillis = ms - mLastMillis;
        mLastMillis = ms;
        
        // now update everything else:
        this.state.update();
        
        // update the keyboard last (it clears justPressed, and we need it!)
        this.keys.update();

        this.tools.update();
    }
    
    void render()
    {
        this.state.render();
        this.tools.render();
    }
    
    void portrait()  { setOrientation(true); }
    void landscape() { setOrientation(false); }    
    
    private void setOrientation(boolean usePortrait)
    {
        if (! CONFIG_ANDROID) return;
        
        // use reflection so the standard compiler doesn't gripe
        // about PORTRAIT and LANDSCAPE
        try
        {
            Class thisClass = this.getClass();
            thisClass.getMethod("orientation").invoke(
                thisClass.getField(usePortrait ? "PORTRAIT" : "LANDSCAPE")
            );
            
        } 
        // Overly broad, but failing here is the general case.
        catch (Exception e)
        {
            println("Error in setOrientation:" + e);
        }
    }

    boolean _isAndroid()
    {
        Class _androidClass = null;
        try { 
            _androidClass = Class.forName("android.os.Build"); 
        }
        catch (ClassNotFoundException e)
        {
        }
        return (_androidClass != null);
    }

    /**
     * The current GsTool. Defaults to GsBasicTool;
     */
    public void setTool(GsTool tool)
    {
        this.tool = tool;
        this.updateTools();
    }

    /**
     * Tool to use for the right mouse button.
     */
    public void setToolR(GsTool toolR)
    {
        this.toolR = toolR;
        this.updateTools();
    }

    /**
     * Tool to use for the middle mouse button.
     */
    public void setToolM(GsTool toolM)
    {
        this.toolM = toolM;
        this.updateTools();
    }


    private void updateTools()
    {
        this.tools.clear();
        this.tools.add(this.tool);
        this.tools.add(this.toolR);
        this.tools.add(this.toolR);
    }
}
