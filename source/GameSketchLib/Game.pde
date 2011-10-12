

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
    
    // global
    
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

}

// !! Normally, I'd use a static class for this, but all
//    our code has to end up in one file for studio sketchpad,
//    and static classes have to be top level in processing.
GameClass Game = new GameClass();



