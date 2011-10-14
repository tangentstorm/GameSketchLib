
void _size(int w, int h) { size(w, h); }

// Game is a Singleton - i.e., the only instance of GameClass.
class GameClass
{
    GameState state;
    GameObject bounds;
    PFont defaultFont;
    GameKeys keys = new GameKeys();
    
    // global timer
    public  float frameMillis = 0;
    private float mLastMillis = 0;
    
    void size(int w, int h)
    {
        if (CONFIG_ANDROID)
        {
            _size(screenWidth, screenHeight);
        }
        else
        {
            _size(w, h);
        }
    }
    
    void init(GameState newState)
    {
        Game.defaultFont = 
            CONFIG_JVM ? loadFont("DejaVuSans-48.vlw")
                       : loadFont("Arial");
        Game.bounds = new GameObject(0, 0, width, height);
        switchState(newState);
    }
    
    void switchState(GameState newState)
    {
        Game.state = newState;
        newState.create();
    }
    
    void update()
    {
        // update the clock:
        float ms = millis();
        this.frameMillis = ms - mLastMillis;
        mLastMillis = ms;
        
        // now update everything else:
        this.state.update();
        
        // update the keyboard last (it clears justPressed, and we need it!)
        this.keys.update();        
    }
    
    void render()
    {
        this.state.render();
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
    

}

// !! Normally, I'd use a static class for this, but all
//    our code has to end up in one file for studio sketchpad,
//    and static classes have to be top level in processing.
GameClass Game = new GameClass();





// This figures out which runtime we're using dynamically,
// so we can do conditional compilation.
final String RUNTIME_ANDROID = "ANDROID";
final String RUNTIME_JVM = "JVM";
final String RUNTIME_PJS = "PJS";
 
final boolean CONFIG_PJS = (new Object()).toString() == "[object Object]";
final boolean CONFIG_ANDROID = !CONFIG_PJS && Game._isAndroid();
final boolean CONFIG_JVM = ! (CONFIG_PJS || CONFIG_ANDROID);
final boolean CONFIG_ANY_JAVA = CONFIG_ANDROID || CONFIG_JVM;
final String RUNTIME = 
    CONFIG_PJS ? RUNTIME_PJS
               : CONFIG_ANDROID ? RUNTIME_ANDROID
                                : RUNTIME_JVM;

