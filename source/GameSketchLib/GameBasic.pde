/*
 * Base class for pretty much anything inside a game.
 *
 */
class GameBasic
{
    // these are straight out of flixel
    public boolean visible = true; // if false: GameGroup won't ask it to render()
    public boolean active = true;  // if false: GameGroup won't ask it to update()
    public boolean exists = true;  // if false: GameGroup won't ask for either.
    public boolean alive = true;   // this one is just handy in games
    
    // !! these are handy for storing any of our objects in a grid:
    public int gx;
    public int gy;

    // !! this is each() for all the "single object" subclasses under GameObject
    private ArrayList<GameBasic> mJustMe = new ArrayList<GameBasic>(1);
    GameBasic()
    {
        mJustMe.add(this);
    }
     
    // these two are the core interface for all our objects:
    void update() { }
    void render() { }

    
    /**
     * each() is a special method we provide so that we have
     * a single unified interface for dealing with groups, 
     * and grids, and single objects in our game.
     *
     * GameContainer uses it to implement several variations
     * of the Visitor design pattern.
     */
    public GameBasic[] each()
    { 
        return mJustMe;
    }
    private final GameBasic[] mJustMe = new GameBasic[] { this };
}

