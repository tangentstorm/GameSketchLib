abstract class GameProto
{
    /* A generic (untyped) message-passing protocol for
     * communicating between objects.
     *
     * Message codes are unique ints and should be created
     * with Game.newMessageCode();
     */
    void message(GameProto sender, int code, Object arg)
    {
    }
}


/*
 * Base class for pretty much anything inside a game.
 *
 */
class GameBasic extends GameProto
{
    // !! Nullable protocol
    public final boolean isNull = false;
  
    // !! Playable protocol
    // these are straight out of flixel
    public boolean visible = true; // if false: GameGroup won't ask it to render()
    public boolean active = true;  // if false: GameGroup won't ask it to update()
    public boolean exists = true;  // if false: GameGroup won't ask for either.
    public boolean alive = true;   // this one is just handy in games
    
    void update()
    {
    }
    
    void render()
    {
    }


    // !! GridMember protocol
    // these are handy for storing any of our objects in a grid:
    public int gx;
    public int gy;
    

    // !! Spatial protocol
    // basic bounds checking
    public float x;
    public float y;
    public float w;
    public float h;
    
    public float x2()
    {
        return this.x + this.w;
    }
    
    public float y2()
    {
        return this.y + this.h;
    }
    
    public boolean containsPoint(float x, float y)
    {
        return this.x <= x && x <= this.x2()
            && this.y <= y && y <= this.y2();
    }
    
    // http://stackoverflow.com/questions/306316/determine-if-two-Squares-overlap-each-other
    public boolean overlaps(GameBasic that)
    {
        return (this.x < that.x2() && this.x2() > that.x &&
                this.y < that.y2() && this.y2() > that.y);
    }

    /**
     * Returns true if this overlaps all of that's points.
     * 
     * I would have called this contains(), but that is used
     * by the GameContainer protocol to mean something else.
     */
    public boolean covers(GameBasic that)
    {
        return this.x <= that.x
            && this.y <= that.y
            && this.x2() >= that.x2()
            && this.y2() >= that.y2();
    }

    
    // !! Interactive protocol (mouse/touch support)
    // Register with Game.mouse.subjects to get click/press/drag
    public void click() {  }
    public void press() {  }
    public void  drag()
    { 
        this.x = Game.mouse.adjustedX;
        this.y = Game.mouse.adjustedY;
    }
    
    // Register with Game.mouse.observers to get mouseAt updates.
    public void mouseAt(float x, float y)
    {
    }

    
    // !! Iteration protocol
    private ArrayList<GameBasic> mJustMe = new ArrayList<GameBasic>(1);
    /**
     * each() is a special method we provide so that we have
     * a single unified interface for dealing with groups, 
     * grids, and single objects in our game.
     *
     * GameContainer uses it to implement several variations
     * of the Visitor design pattern.
     */
    public Iterable<GameBasic> each()
    { 
        return mJustMe;
    }
    
    // Constructor
    GameBasic()
    {
        mJustMe.add(this);
    }
}

