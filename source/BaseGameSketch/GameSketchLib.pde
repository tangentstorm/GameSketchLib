/* -----------------------------------------------------------------
 * GameSketchLib                                 compiled 2011-10-18
 * -----------------------------------------------------------------
 * 
 * GameSketchLib is an open-source game library for Processing.
 * 
 * It was created by Michal J Wallace and loosely modeled after
 * the flixel game library for actionscript.
 * 
 *       website: http://gamesketchlib.org/
 *          code: https://github.com/sabren/GameSketchLib
 *       twitter: @tangentstorm
 * 
 * If you want to modify the library, consider forking the git
 * repository at github, rather than editing this combined file.
 * 
 * -----------------------------------------------------------------
 * 
 * GameSketchLib
 * Copyright (c) 2011 Michal J. Wallace
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 * 
 */// [Begin GameSketchLib] ---------------------------------------


void draw()
{
    Game.update();
    Game.render();
}



// global debug flag.
// so far, this just shows Bounds for sprites
boolean DEBUG = false;

// a predefined GameSheet, since everyone wants a GameSheet!
GameSheet SHEET;

// Timer Constants
float SECONDS = 1000;

// Keyboard Constants:
char SPACE = ' ';
char[] WASD_N  = new char[] { 'W', ',', '<' };
char[] WASD_W  = new char[] { 'A', 'a' };
char[] WASD_S  = new char[] { 'S', 's', 'O', 'o' };
char[] WASD_E  = new char[] { 'D', 'd', 'E', 'e' };


// global event handlers:
// global event handlers:
void mousePressed()  { Game.mouse.pressed();  }
void mouseReleased() { Game.mouse.released(); }
void mouseMoved()    { Game.mouse.moved();    }
void mouseDragged()  { Game.mouse.dragged();  }
void keyPressed()    { Game.keys.setKeyDown(true); }
void keyReleased()   { Game.keys.setKeyDown(null); }



// [ Game.pde ]:


void _size(int w, int h) { size(w, h); }

// Game is a Singleton - i.e., the only instance of GameClass.
class GameClass
{
    GameState state;
    GameObject bounds;
    PFont defaultFont;
    GameKeys keys = new GameKeys();
    
    
    /**
     * The mouse/touchscreen system.
     */
    public final GameMouse mouse = new GameMouse();
    
    /**
     * The current GameTool. Defaults to BasicTool;
     */
    public GameTool tool = new BasicTool();
    
    
    /**
     *  time ellapsed since last frame;
     */
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

    /**
     * This generates a new code for message(). (It just counts up from 0).
     */    
    public int newMessageCode()
    {
        return mCodeCounter++;
    }
    private int mCodeCounter = 0;
    
    
    /**
     * Switches the game to a new GameState. Pretty self-explanitory. :)
     */
    void switchState(GameState newState)
    {
        Game.state = newState;
        Game.mouse.subjects.clear();
        Game.mouse.observers.clear();
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


// [ GameBasic.pde ]:

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


// [ GameContainer.pde ]:

// !! An interface defines a set of methods that a class can implement.
//    These interfaces require only one method each, and are used for
//    looping through the contents of the various GameContainers 
//    in a uniform way.

// These work with all subclasses of GameContainer (GameGroup, GameState, GameGrid... GameQuadtree? )
interface GameVisitor   { public  void        visit   (GameBasic gab); }
interface GameChecker   { public  boolean     check   (GameBasic gab); }
interface GameChanger   { public  GameBasic   change  (GameBasic gab); }
interface GameExtractor { public  Object      extract (GameBasic gab); }
interface GamePopulator { public  GameBasic   populate(Object k); }
  
// The ones below add the gx and gxy parameters, which often come in handy when dealing with grids.
interface GameGridVisitor   { public void        visitCell   (int gx, int gy, GameBasic gab); }
interface GameGridChecker   { public boolean     checkCell   (int gx, int gy, GameBasic gab); }
interface GameGridChanger   { public GameBasic   changeCell  (int gx, int gy, GameBasic old); }
interface GameGridExtractor { public GameBasic   extractCell (int gx, int gy, GameBasic old); }
interface GameGridPopulator { public GameBasic   populateCell(int gx, int gy); }


// !! Abstract classes are somewhere between classes and interfaces.
//    You can't instantiate it directly, but you can subclass them
//    and you can write both regular methods with bodies and abstract
//    methods that must be overridden.

// !! using "abstract class" prevents the class from being instantiated.
//    It's perfectly okay to declare a variable of this type:
//            GameContainer gc;
//    But if you try to instantiate it (with the "new" keyword), the
//    compiler will complain.
//           GameContainer gc = new GameContainer();
abstract class GameContainer extends GameBasic
{
    // !! Here, using "abstract" in front of a method forces every subclass
    //    to override the method. If you subclass GameContainer and don't
    //    override these, the compiler will give you an error.
    abstract public void clear();
    abstract public Iterable<GameBasic> each();
    abstract protected Iterable<Object> keys();
    abstract protected void putItem(Object k, GameBasic gab);
    abstract protected GameBasic getItem(Object k);
    abstract protected GameContainer emptyCopy();
    
    // !! GameBasic defines each() for the GameObject side of the class tree.
    //    Each subclass on the GameContainer side of the tree is different,
    //    though, and will need to define its own looping constructs.
    
    // !! The benefit of forcing every class to define each() is  that we can 
    //    use the same collection methods whether we're dealing with GameGrid,
    //    GameGroup, or whatever we make later. (GameQuadTree maybe?)

    /**
     * Walk the flattened tree of FlxBasic instances provided by each();
     * 
     *  Example usage:
     *
           void census()
           {
                GameGrid grid = new GameGrid(10, 10);
                
                // grid.visit is the method defined here.
                grid.visit(new GameVisitor ()
                {
                     int count = 0;
                     
                     // !! the visit here implements the GameVisitor interface
                     public void visit(GameBasic gab)
                     {
                         count += 1;
                         println("GameBasic instance number " + count + " is "
                             + (gab.active  ? "alive" : "dead") + " and "
                             + (gab.visible ? "visible" : "invisible") + "!");
                     }
                }); // !! note the end paren and semicolon, capping off our call to grid.visit();
           }
    */
    public void visit(GameVisitor vis)
    {
        for (GameBasic gab : this.each())
        {
            vis.visit(gab);
        }
    }
    
    public GameBasic firstWhere(GameChecker chk) 
    {
        for (GameBasic gab : this.each())
        {
            if (chk.check(gab)) return gab;
        }
        return GameNull;
    }
    
    public int countWhere(GameChecker chk)
    {
        int count = 0;
        for (GameBasic gab : this.each())
        {
            if (chk.check(gab)) count++;
        }
        return count;
    }
    
    /**
     * This returns a new ArrayList, hopefully leaving
     * the current container intact.
     */
    public ArrayList<GameBasic> eachChanged(GameChanger chg)
    {
        ArrayList<GameBasic> res = new ArrayList<GameBasic>();
        for (GameBasic gab : this.each())
        {
            res.add(chg.change(gab));
        }
        return res;
    }
    
    
    /**
     * This is like eachChanged, but it returns an instance of its own class.
     * That is, GameGrid.changed() returns a GameGrid, and GameGroup.changed()
     * returns a GameGroup()
     *
     * Since we've already got abstract methods called getItem, putItem and keys,
     * we can write a generic implementation:
     */
    public GameContainer changed(GameChanger chg)
    {
        GameContainer res = this.emptyCopy();
        for (Object k : this.keys())
        {
            res.putItem(k, chg.change(this.getItem(k)));
        }
        return res;
    }
    

    /**
     * This one is almost the same as .eachChanged, but returns an ArrayList<Object>
     * instead of an ArrayList<GameBasic>. GameExtractor.extract() can
     * return any Object whatsoever.
     */
     public ArrayList extract(GameExtractor ext)
     {
        ArrayList res = new ArrayList();
        for (GameBasic gab : this.each())
        {
            res.add(ext.extract(gab));
        }
        return res;
     }
    
    
    public void populate(GamePopulator pop)
    {
        for (Object k : this.keys())
        {
            this.putItem(k, pop.populate(k));
        }
    }
    
    
    public void render()
    {
        for (GameBasic gab : this.each())
        {
            gab.render();
        }
    }
    
}


// [ GameDroid.pde ]:



// [ GameGroup.pde ]:

/*
 * A generic list-like container for GameBasic objects.
 */
class GameGroup extends GameContainer
{
    ArrayList<GameBasic> members = new ArrayList();

    GameGroup()
    {
        super();
    }
    
    // realize abstract GameContainer:
    
    GameBasic getItem(Object o)
    {
        return this.get((Integer) o);
    }

    void putItem(Object o, GameBasic gab)
    {
        this.put((Integer) o, gab);
    }
    
    Iterable<GameBasic> each()
    {
        return this.members;
    }
    
    Iterable<Object> keys()
    {
        ArrayList res = new ArrayList();
        for (int i = 0; i < this.size(); ++i)
        {
            res.add(i);
        }
        return res;
    }
    
    GameContainer emptyCopy()
    {
        GameGroup res = new GameGroup();
        for (int i = 0; i < this.size(); ++i)
        {
            res.add(GameNull);
        }
        return res;
    }
    
    
    // friendlier ArrayList - like interface:
    
    GameBasic get(int i)
    {
        return (GameBasic) this.members.get(i);
    }
    
    GameBasic put(int i, GameBasic gab)
    {
        this.members.set(i, gab);
        return gab;
    }
    
    int size()
    {
        return this.members.size();
    }

    GameBasic add(GameBasic gab)
    {
        this.members.add(gab);
        return gab;
    }
    
    void remove(GameBasic gab)
    {
        this.members.remove(gab);
    }
    
    boolean contains(GameBasic gab)
    {
        return this.members.contains(gab);
    }
    
    void clear()
    {
        this.members.clear();
    }
    
    
    boolean isEmpty()
    {
        return this.size() == 0;
    }
    
    GameBasic atRandom()
    {
        if (this.isEmpty()) return null;
        return this.get((int) random(this.size()));
    }
    
    void update()
    {
        GameBasic gab;
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            gab = this.get(i);
            if (gab.exists && gab.active) gab.update();
        }
    }
    
    void render()
    {
        GameBasic gab;
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            gab = this.get(i);
            if (gab.exists && gab.visible) gab.render();
        }
    }
    
    void overlap(GameGroup other)
    {
        // !! this will certainly crash if the group contains other groups
        // TODO: see how flixel handles GameObject in .overlap()
        // !! meanwhile, just don't use overlap() on nested groups.
        
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GameObject a = (GameObject) this.get(i);
            if (a.active && a.exists)
            {
                for (int j = 0; j < other.size(); ++j)
                {
                    GameObject b = (GameObject) other.get(j);
                    if (b.active && b.exists && a != b && a.overlaps(b))
                    {
                        a.onOverlap(b);
                    }
                }
            }
        }
    }
    
    
    GameBasic firstDead()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GameBasic gab = this.get(i);
            if (! gab.alive) return gab;
        }
        return null;
    }
    
    GameBasic firstAlive()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GameBasic gab = this.get(i);
            if (gab.alive) return gab;
        }
        return null;
    }

    GameBasic firstInactive()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GameBasic gab = this.get(i);
            if (! gab.active) return gab;
        }
        return null;
    }


    void removeDead()
    {
        while (true)
        {
            GameBasic body = firstDead();
            if (body == null) { break; } else { remove(body); }
        }
    }

}


// [ GameGrid.pde ]:

/**
 * A 2D container, handy for tile maps, puzzle games, etc.
 */
class GameGrid extends GameContainer
{
    public final int rows;
    public final int cols;
    public final int area;
    
    private final GameBasic[] mData;
    private float cellW;
    private float cellH;

    GameGrid(int cols, int rows)
    {
        this.cols = cols;
        this.rows = rows;
        this.area = cols * rows;
        mData = new GameBasic[this.area];
        this.clear(); // fill with GameNull
        setCellSize(32, 32);
    }
    
    public void setCellSize(float cellW, float cellH)
    {
        this.cellW = cellW;
        this.cellH = cellH;
        this.w = cellW * this.cols;
        this.h = cellH * this.rows;
    }
    
    /**
     * Warning: this assumes that the objects are actually
     * in the grid cells. That is only true if you called layout()
     * and haven't moved them since.
     */
    GameBasic memberAtPoint(float x, float y)
    {
        int gx = (int) ((x - this.x) / this.cellW);
        int gy = (int) ((y - this.y) / this.cellH);
        
        if (gx >= this.cols || gy >= this.rows)
        {
            return GameNull;
        }
        else
        {
            return this.get(gx, gy);
        }
    }

    
    // !! We have to override the abstract methods,
    //    each() and changed() or it won't compile.
    
    public ArrayList<GameBasic> each()
    {
        ArrayList<GameBasic> these = new ArrayList<GameBasic>();
        for (int i = 0; i < this.area; ++i)
        {
            these.add(mData[i]);
        }
        return these;
    }
    
    public GameGrid changed(GameChanger chg)
    {
        GameGrid res = new GameGrid(this.cols, this.rows);
        for (int i = 0; i < this.area; ++i)
        {
            res.mData[i] = chg.change(mData[i]);
        }
        return res;
    }
    
    protected ArrayList keys()
    {
        ArrayList res = new ArrayList();
        for (int i = 0; i < this.area; i++)
        {
            res.add(i);
        }
        return res;
    }
    
    protected void putItem(Object k, GameBasic gab)
    {
        mData[(Integer) k] = gab;
    }
    
    protected GameBasic getItem(Object k)
    {
        return mData[(Integer) k];
    }
    
    protected GameContainer emptyCopy()
    {
        return new GameGrid(this.cols, this.rows);
    }
    
     
     
    /**
     * This is the 2d analog of GameGroup.get(i).
     */  
    public GameBasic get(int gx, int gy)
    {
        return mData[this.toIndex(gx, gy)];
    }
    
    /**
     * This is the 2d analog of GameGroup.put(i).
     */
    public GameBasic put(int gx, int gy, GameBasic gab)
    {
        gab.gx = gx;
        gab.gy = gy;
        mData[this.toIndex(gx, gy)] = gab;
        return gab;
    }


    // Fill the grid with NullObjects    
    public void clear()
    {
        for (int i = 0; i < mData.length; ++i)
        {
            mData[i] = GameNull;
        }
    }
    
    
    public void visitCells(GameGridVisitor vis)
    {
        for (int gx = 0; gx < this.cols; ++gx)
        {
            for (int gy = 0; gy < this.rows; ++gy)
            {
                vis.visitCell(gx, gy, this.get(gx, gy));
            }
        }
    }
    
    public void populateCells(GameGridPopulator pop)
    {
        for (int gx = 0; gx < this.cols; ++gx)
        {
            for (int gy = 0; gy < this.rows; ++gy)
            {
                this.put(gx, gy, pop.populateCell(gx, gy));
            }
        }
    }
    
    
    public void layout()
    {
        this.visitCells(new GameGridVisitor()
        { 
             public void visitCell(int gx, int gy, GameBasic gab)
             {
                  // only GameObject and its children have coordinates
                  if (gab instanceof GameObject)
                  {
                      ((GameObject) gab).reset(x + cellW * gx, y + cellH * gy, cellW, cellH);
                  }
             }
        });
    }
    
    public void fitToScreen()
    {  
        this.x = 0;
        this.y = 0;
        this.setCellSize(width/this.cols, height/this.rows);
        this.layout();
    }
    
    
    private int toIndex(int gx, int gy)
    {
        return this.cols * gy + gx;
    }
}


// [ GameKeys.pde ]:


class GameKeys
{
    HashMap mPressedKeys = new HashMap();
    HashMap mJustPressed = new HashMap();
    
    void update()
    {
        // Important: clear out the justPressed after every frame
        // (else it won't unset until they key repeats)
        mJustPressed.clear();
    }

    // keyCode is an int, but key is a char, so we need a version for each:
    boolean isKeyDown(char code) { return mPressedKeys.get(code) != null; }
    boolean isKeyDown(int  code) { return mPressedKeys.get(code) != null; }
    boolean justPressed(char code) { return mJustPressed.get(code) != null; }
    boolean justPressed(int  code) { return mJustPressed.get(code) != null; }

    void setKeyDown(Object value)
    { 
        if (key == CODED)
        {
            mJustPressed.put(keyCode, isKeyDown(keyCode) ? null : true);
            mPressedKeys.put(keyCode, value);
        }
        else
        {
            mJustPressed.put(key, isKeyDown(key) ? null : true);
            mPressedKeys.put(key, value);
        }
    }
    
    // unfortunately, we can't mix them in the array in processing
    boolean isAnyDown(char[] keys)
    {
        for (int i = 0; i < keys.length; ++i)
        {
            if (isKeyDown(keys[i])) return true;
        }
        return false;
    }
    
    boolean goN() { return isKeyDown(UP)    || isAnyDown(WASD_N); }
    boolean goW() { return isKeyDown(LEFT)  || isAnyDown(WASD_W); }
    boolean goS() { return isKeyDown(DOWN)  || isAnyDown(WASD_S); }
    boolean goE() { return isKeyDown(RIGHT) || isAnyDown(WASD_E); }
}




// [ GameMath.pde ]:


// again, virtual "static" class for studio.sketchpad
GameMathClass GameMath = new GameMathClass();
class GameMathClass
{
    float clamp(float value, float minValue, float maxValue)
    {
        if (value > maxValue) return maxValue;
        if (value < minValue) return minValue;
        return value;
    }
}

// [ GameMouse.pde ]:

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


// [ GameNull.pde ]:

/**
 * This is a special single-instance class that gives
 * us a null-like value that represents the lack of a
 * normal GameBasic instance.
 *
 * If we used the regular null value, we'd have to 
 * check for (gab != null) everywhere, but with
 * GameNull, we can treat it like any other GameBasic
 * and it just transparently does the right thing.
 *
 * If you do need to test for it, the boolean .isNull
 * is defined on all GameBasic classes. It's false for
 * everything but this class.
 * 
 * http://en.wikipedia.org/wiki/Null_Object_pattern
 */
final class _GameNull extends GameBasic
{
    // Nullable
    public final boolean isNull = true;
  
    // Playable
    // all booleans are false, so no render/update
    public final boolean alive = false;
    public final boolean exists = false;
    public final boolean visible = false;
    public final boolean active = false;

    // GridMember
    public final int gx = 0;
    public final int gy = 0;
    
    // Spatial
    // Not A Number coordinates, all overlapping returns false
    public final float x = Float.NaN;
    public final float y = Float.NaN;
    public final float w = Float.NaN;
    public final float h = Float.NaN;
    
    boolean containsPoint(float px, float py)
    {
        return false;
    }
    
    boolean overlaps(GameBasic other)
    {
        return false;
    }
    
    boolean contains(GameBasic other)
    {
        return false;
    }
    
    
    // Iterable
    // yields an empty list
    private final  ArrayList<GameBasic> mEmptyList = new ArrayList<GameBasic>(0);
    ArrayList<GameBasic> each()
    {
        return mEmptyList;
    }

    // Constructor
    private int mInstanceCount = 0;
    _GameNull()
    {
        if (++mInstanceCount > 1)
        {
            throw new RuntimeException("GameNull is a singleton. There can be only one.");
        }
    }
}
final _GameNull GameNull = new _GameNull();


// [ GameLink.pde ]:

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


// [ GameObject.pde ]:

/*
 *  This class represents a GameObject, occupying a
 *  rectangular area in space.
 */
class GameObject extends GameBasic
{
    public float x = 0;
    public float y = 0;
    public float w = 0;
    public float h = 0;

    float dx = 0;
    float dy = 0;
    float health = 1;
    
    GameObject()
    {
        reset(0,0,0,0);
    }
    
    GameObject(float x, float y, float w, float h)
    {
        reset(x, y, w, h);
    }
    
    public void reset(float x, float y, float w, float h)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }
    
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
    public boolean overlaps(GameObject that)
    {
        return (this.x < that.x2() && this.x2() > that.x &&
                this.y < that.y2() && this.y2() > that.y);
    }

    public boolean contains(GameObject that)
    {
        return this.x <= that.x
            && this.y <= that.y
            && this.x2() >= that.x2()
            && this.y2() >= that.y2();
    }
    
    public void update()
    {
        x += dx;
        y += dy;
    }
    
    public void hurt()
    {
        this.health--;
        if (this.health <= 0)
        {
            this.health = 0;
            this.alive = false;
            this.onDeath();
        }
    }
    
    public void onDeath()
    {
        this.visible = false;
    }
    
    public void onOverlap(GameObject other)
    {
    }
    
}


// [ GameRect.pde ]:

/**
 * A simple rectangle that draws itself on screen.
 * Will toggle fill colors based on this.alive.
 */
class GameRect extends GameObject
{
    public color liveColor = #FFFFFF;
    public color deadColor = #CCCCCC;
    public color lineColor = #666666;
    public int lineWeight = 1;
  
    GameRect()
    {
        super(0, 0, 0, 0);
    }
  
    GameRect (float x, float y, float w, float h)
    {
        super(x, y, w, h);
    }
    
    public void render()
    {
        strokeWeight(this.lineWeight);
        fill(this.alive ? this.liveColor : this.deadColor );
        rect(this.x, this.y, this.w, this.h);
    }  
}


// [ GameSheet.pde ]:

class GameSheet
{
    String assetPath; // empty means the "data" directory
    PImage sheet;
    ArrayList frames = new ArrayList();
    
    GameSheet(String imageName, int cellW, int cellH, String jsPath)
    {
        this.assetPath = CONFIG_PJS ? jsPath : "";
        this.sheet = loadImage(this.assetPath + "/" + imageName);
        
        for (int y = 0; y < this.sheet.height; y += cellH)
        {
            for (int x = 0; x < this.sheet.width; x += cellW)
            {
                PImage cell = createImage(cellW, cellH, ARGB);
                cell.copy(sheet, x, y, cellW, cellH, 0, 0, cellW, cellH);
                this.frames.add(cell);
            }
        }
    }
    
    PImage getFrame(int i)
    {
        return (PImage) this.frames.get(i);
    }
    
    PImage[] getFrames(int[] wantedFrames)
    {
      
        PImage[] res = new PImage[wantedFrames.length];
        for (int i = 0; i < wantedFrames.length; ++i)
        {
            res[i] = this.getFrame(wantedFrames[i]);
        }
        return res;
    }
    
    // for debugging:
    void renderAll(int x, int y, int perRow)
    {
        int gx, gy;
        for (int i = 0; i < this.frames.size(); ++i)
        {
            PImage img = this.getFrame(i);
            gy = (int) i / perRow;
            gx = i % perRow;
            image(img, x + gx * img.width, y + gy * img.height);
            stroke(255);
            noFill();
            rect(x + gx * img.width, y + gy * img.height, img.width, img.width);
        }
    }
}

// [ GameSprite.pde ]:

class GameSprite extends GameObject
{
    // animation stuff:
    int frame = 0;
    private PImage[] mFrames;
    boolean animated = false;
    GameTimer timer = new GameTimer(SECONDS/8);

    // rotation stuff:
    int degrees = 0;    
    float xOffset = 0;
    float yOffset = 0;
    GameSprite(float x, float y)
    {
        super(x, y, 0, 0);
        animated = true;
    }
    
    void setFrames(PImage[] frames)
    {
        mFrames = frames;
        sizeToFrame();
    }
    
    void sheetFrames(int[] frameNums)
    {
        this.setFrames(SHEET.getFrames(frameNums));
    }
    
    
    void sizeToFrame()
    {
        this.w = mFrames[this.frame].width;
        this.h = mFrames[this.frame].height;
        this.xOffset = this.w / 2;
        this.yOffset = this.h / 2;
    }
    
    void update()
    {
        if (this.animated)
        {
            this.timer.update();
            if (this.timer.ready)
            {
                this.frame++;
                this.frame %= mFrames.length;
            }
        }
    }
    
    void randomize()
    {
        this.frame = (int) random(mFrames.length);
        this.timer.randomize();
    }
    
    void render()
    {
        if (! visible) return;
        
        if (this.degrees == 0)
        {
            image(mFrames[this.frame], this.x, this.y);
        }
        else
        {
            pushMatrix();
            translate(this.x + this.xOffset, this.y + this.yOffset);
            rotate(this.degrees * PI / 180);
            image(mFrames[this.frame], -this.xOffset, -this.yOffset);
            popMatrix();
        }
        
        if (DEBUG)
        {
          stroke(255);
          noFill();
          rect(x, y, w, h);
        }
    }
}


// [ GameSquare.pde ]:


class GameSquare extends GameRect
{
    GameSquare (float x, float y, float side)
    {
        super(x, y, side, side);
    }
}


// [ GameState.pde ]:

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
    void mouseDragged()  { }
    void mouseMoved() { }
    void keyPressed() { } 
    void keyReleased() { }
}


// [ GameText.pde ]:

/**
 * A GameObject that displays text.
 *
 */
class GameText extends GameObject
{
    public String label;
    public color textColor;
    public int fontSize = 20;
    public int align = CENTER;
    public int vAlign = BASELINE;
    
    /**
     * A GameRect in case you want to draw a background or border.
     * It's hidden by default.
     * If you change .x, .y, or .label, you should call calcBounds();
     */
    public GameRect bounds;
    
    GameText(String label, float x, float y, color textColor, int fontSize)
    {
        super(x, y, 0, 0);
        
        this.fontSize = fontSize;
        this.textColor = textColor;
        
        this.setLabel(label);
    }
    
    public void render()
    {
        this.setupFont();
        text(this.label, this.x, this.y);
    }

    public void setLabel(String label)
    {
       this.label = label;   
       this.calcBounds();
    }
    
    
    public void calcBounds()
    {
        this.setupFont();
        
        this.w = textWidth(this.label);
        this.h = textAscent() + textDescent();
        
        this.bounds = new GameRect(this.x, this.y, this.w, this.h);
        this.bounds.liveColor = #000000;
        this.bounds.lineColor = #999999;
        this.bounds.visible = false;
        
        if (this.align == CENTER)
            this.bounds.x -= this.w / 2;
        if (this.vAlign == BASELINE)
            this.bounds.y -= textAscent();
    }

    
    protected void setupFont()
    {
        fill(this.textColor);
        textFont(Game.defaultFont, this.fontSize);
        textAlign(this.align);
    }
    
}


// [ GameTimer.pde ]:


/*
 * GameTimer timer = new GameTimer(1.25 * SECONDS);
 *
 * Then in your .update() method:
 *
 *     timer.update();
 *     if (timer.ready) { }
 *
 * Alternatively, you can override onTick();
 *
 */
class GameTimer extends GameObject
{
    float millisPerTick = 0;
    float mMillisSoFar = 0;
    boolean ready;
    int tickCount = 0;
    
    GameTimer(float millisPerTick)
    {
        super(0, 0, 0, 0);
        this.millisPerTick = millisPerTick;
    }
    
    GameTimer(float millisPerTick, boolean immediate)
    {
        super(0, 0, 0, 0);
        this.millisPerTick = millisPerTick;
        if (immediate) mMillisSoFar = millisPerTick;
    }

    void setTicksPerSecond(float ps)
    {
        this.millisPerTick = SECONDS / ps;
    }
    
    void update()
    {
        ready = false;
        mMillisSoFar += Game.frameMillis;
        
        if (mMillisSoFar > millisPerTick)
        {
            ready = true;
            mMillisSoFar = 0;
            tickCount++;
            onTick();
        }
    }
    
    // convenience so we don't have to keep calling .update()
    boolean checkReady()
    {
        update();
        return ready;
    }
    
    // this just adds a little variety if you have a
    // bunch of objects doing the same thing.
    void randomize()
    {
        mMillisSoFar = random(millisPerTick);
    }
    
    void onTick()
    {
    }
}

// [ GameTool.pde ]:

/**
 * GameTools allow the GameMouse to interact with the
 * game in different ways.
 *
 * They work very much like tools in any drawing or paint
 * program, but may also come in handy for things like:
 *
 *   - weapons with mouse based aiming
 *   - level editors
 *   - games where you assign tasks to characters
 *   - etc.
 */
abstract class GameTool extends GameProto
{
    void click(float x, float y, GameBasic subject)
    {
    }

    void press(float x, float y, GameBasic subject)
    {
    }

    void dragStart(float x, float y, GameBasic subject)
    {
    }
    
    void drag(float x, float y, GameBasic subject)
    {
    }

    void dragEnd(float x, float y, GameBasic subject)
    {
    }
    
    
    /* Same as GameBasic.send
     *
     * A generic (untyped) message-passing protocol for
     * communicating between objects.
     *
     * Messages should be defined with Game.newMessageId();
     */
    Object send(int message, Object arg)
    {
        return null;
    }
}

/**
 * The BasicTool simply calls .click, .drag, or (TODO) .press
 * on anything in Game.mouse.subjects that the user interacts with.
 */
class BasicTool extends GameTool
{
    void click(float x, float y, GameBasic subject)
    {
        subject.click();
    }

    void drag(float x, float y, GameBasic subject)
    {
        subject.drag();
    }
}



/* -- [End GameSketchLib] --------------------------------------*/

