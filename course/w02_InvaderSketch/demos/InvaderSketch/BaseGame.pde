/* -----------------------------------------------------------------
 * GameSketchLib                                 compiled 2011-10-24
 * -----------------------------------------------------------------
 * 
 * GameSketchLib is an open-source game library for Processing.
 * 
 * It was created by Michal J Wallace and loosely modeled after
 * the flixel game library for actionscript.
 * 
 *       website: http://GameSketchLib.org/
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


// [ GsBasic.java ]:



/**
 * Base class for pretty much anything inside a game.
 *
 */
public class GsBasic extends GsProto
{
    // !! Nullable protocol
    public boolean isNull() { return false; }
  
    // !! Playable protocol
    // these are straight out of flixel
    public boolean visible = true; // if false: GsGroup won't ask it to render()
    public boolean active = true;  // if false: GsGroup won't ask it to update()
    public boolean exists = true;  // if false: GsGroup won't ask for either.
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
    public boolean overlaps(GsBasic that)
    {
        return (this.x < that.x2() && this.x2() > that.x &&
                this.y < that.y2() && this.y2() > that.y);
    }

    /**
     * Returns true if this overlaps all of that's points.
     * 
     * I would have called this contains(), but that is used
     * by the GsContainer protocol to mean something else.
     */
    public boolean covers(GsBasic that)
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
    private GsList<GsBasic> mJustMe = new GsList<GsBasic>(1);
    /**
     * each() is a special method we provide so that we have
     * a single unified interface for dealing with groups, 
     * grids, and single objects in our game.
     *
     * GsContainer uses it to implement several variations
     * of the Visitor design pattern.
     *
     * @return an Iterable containing just the current object.
     */
    public Iterable<GsBasic> each()
    { 
        return mJustMe;
    }
    
    // Constructor
    GsBasic()
    {
        mJustMe.add(this);
    }
}


// [ GsBasicTool.java ]:


/**
 * The GsBasicTool simply calls .click, .drag, or (TODO) .press
 * on anything in Game.mouse.subjects that the user interacts with.
 */
public class GsBasicTool extends GsTool
{
    void click(float x, float y, GsBasic subject)
    {
        if (subject.isNull()) Game.state.click(); else subject.click();
    }

    void drag(float x, float y, GsBasic subject)
    {
        if (subject.isNull()) Game.state.drag(); else subject.drag();
    }
}

// [ GsContainer.java ]:




// !! An interface defines a set of methods that a class can implement.
//    These interfaces require only one method each, and are used for
//    looping through the contents of the various GameContainers 
//    in a uniform way.


// !! Abstract classes are somewhere between classes and interfaces.
//    You can't instantiate it directly, but you can subclass them
//    and you can write both regular methods with bodies and abstract
//    methods that must be overridden.

// !! using "abstract class" prevents the class from being instantiated.
//    It's perfectly okay to declare a variable of this type:
//            GsContainer gc;
//    But if you try to instantiate it (with the "new" keyword), the
//    compiler will complain.
//           GsContainer gc = new GsContainer();
abstract public class GsContainer extends GsBasic
{
    // !! Here, using "abstract" in front of a method forces every subclass
    //    to override the method. If you subclass GsContainer and don't
    //    override these, the compiler will give you an error.
    abstract public void clear();
    abstract public Iterable<GsBasic> each();
    abstract protected Iterable<Object> keys();
    abstract protected void putItem(Object k, GsBasic gab);
    abstract protected GsBasic getItem(Object k);
    abstract protected GsContainer emptyCopy();
    
    // !! GsBasic defines each() for the GsObject side of the class tree.
    //    Each subclass on the GsContainer side of the tree is different,
    //    though, and will need to define its own looping constructs.
    
    // !! The benefit of forcing every class to define each() is  that we can 
    //    use the same collection methods whether we're dealing with GsGrid,
    //    GsGroup, or whatever we make later. (GameQuadTree maybe?)

    /**
     * Walk the flattened tree of FlxBasic instances provided by each();
     * 
     *  Example usage:
     *
           void census()
           {
                GsGrid grid = new GsGrid(10, 10);
                
                // grid.visit is the method defined here.
                grid.visit(new GameVisitor ()
                {
                     int count = 0;
                     
                     // !! the visit here implements the GameVisitor interface
                     public void visit(GsBasic gab)
                     {
                         count += 1;
                         println("GsBasic instance number " + count + " is "
                             + (gab.active  ? "alive" : "dead") + " and "
                             + (gab.visible ? "visible" : "invisible") + "!");
                     }
                }); // !! note the end paren and semicolon, capping off our call to grid.visit();
           }
    */
    public void visit(GsVisitor vis)
    {
        for (GsBasic gab : this.each())
        {
            vis.visit(gab);
        }
    }
    
    public GsBasic firstWhere(GsChecker chk)
    {
        for (GsBasic gab : this.each())
        {
            if (chk.check(gab)) return gab;
        }
        return GameNull;
    }
    
    public int countWhere(GsChecker chk)
    {
        int count = 0;
        for (GsBasic gab : this.each())
        {
            if (chk.check(gab)) count++;
        }
        return count;
    }
    
    /**
     * This returns a new ArrayList, hopefully leaving
     * the current container intact.
     */
    public GsList<GsBasic> eachChanged(GsChanger chg)
    {
        GsList<GsBasic> res = new GsList<GsBasic>();
        for (GsBasic gab : this.each())
        {
            res.add(chg.change(gab));
        }
        return res;
    }
    
    
    /**
     * This is like eachChanged, but it returns an instance of its own class.
     * That is, GsGrid.changed() returns a GsGrid, and GsGroup.changed()
     * returns a GsGroup()
     *
     * Since we've already got abstract methods called getItem, putItem and keys,
     * we can write a generic implementation:
     */
    public GsContainer changed(GsChanger chg)
    {
        GsContainer res = this.emptyCopy();
        for (Object k : this.keys())
        {
            res.putItem(k, chg.change(this.getItem(k)));
        }
        return res;
    }
    

    /**
     * This one is almost the same as .eachChanged, but returns an ArrayList<Object>
     * instead of an ArrayList<GsBasic>. GsReporter.report() can
     * return any Object whatsoever.
     */
     public GsList extract(GsReporter ext)
     {
        GsList res = new GsList();
        for (GsBasic gab : this.each())
        {
            res.add(ext.report(gab));
        }
        return res;
     }
    
    
    public void populate(GsPopulator pop)
    {
        for (Object k : this.keys())
        {
            this.putItem(k, pop.populate(k));
        }
    }
    
    
    public void render()
    {
        for (GsBasic gab : this.each())
        {
            gab.render();
        }
    }
    
}


// [ GsGrid.java ]:





/**
 * A 2D container, handy for tile maps, puzzle games, etc.
 */
public class GsGrid extends GsContainer
{
    public final int rows;
    public final int cols;
    public final int area;
    
    private final GsBasic[] mData;
    private float cellW;
    private float cellH;

    GsGrid(int cols, int rows)
    {
        this.cols = cols;
        this.rows = rows;
        this.area = cols * rows;
        mData = new GsBasic[this.area];
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
    GsBasic memberAtPoint(float x, float y)
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
    
    public GsList<GsBasic> each()
    {
        GsList<GsBasic> these = new GsList<GsBasic>();
      //TODO:  these.addAll(Arrays.asList(mData).subList(0, this.area));
        return these;
    }
    
    public GsGrid changed(GsChanger chg)
    {
        GsGrid res = new GsGrid(this.cols, this.rows);
        for (int i = 0; i < this.area; ++i)
        {
            res.mData[i] = chg.change(mData[i]);
        }
        return res;
    }
    
    protected Iterable<Object> keys()
    {
        GsList<Object> res = new GsList<Object>();
        for (int i = 0; i < this.area; i++)
        {
            res.add(i);
        }
        return res;
    }
    
    protected void putItem(Object k, GsBasic gab)
    {
        mData[(Integer) k] = gab;
    }
    
    protected GsBasic getItem(Object k)
    {
        return mData[(Integer) k];
    }
    
    protected GsContainer emptyCopy()
    {
        return new GsGrid(this.cols, this.rows);
    }
    
     
     
    /**
     * This is the 2d analog of GsGroup.get(i).
     */  
    public GsBasic get(int gx, int gy)
    {
        return mData[this.toIndex(gx, gy)];
    }
    
    /**
     * This is the 2d analog of GsGroup.put(i).
     */
    public GsBasic put(int gx, int gy, GsBasic gab)
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
    
    
    public void visitCells(GsVisitorG vis)
    {
        for (int gx = 0; gx < this.cols; ++gx)
        {
            for (int gy = 0; gy < this.rows; ++gy)
            {
                vis.visit(gx, gy, this.get(gx, gy));
            }
        }
    }
    
    public void populateCells(GsPopulatorG pop)
    {
        for (int gx = 0; gx < this.cols; ++gx)
        {
            for (int gy = 0; gy < this.rows; ++gy)
            {
                this.put(gx, gy, pop.populate(gx, gy));
            }
        }
    }
    
    
    public void layout()
    {
        this.visitCells(new GsVisitorG()
        { 
             public void visit(int gx, int gy, GsBasic gab)
             {
                  // only GsObject and its children have coordinates
                  if (gab instanceof GsObject)
                  {
                      ((GsObject) gab).reset(x + cellW * gx, y + cellH * gy, cellW, cellH);
                  }
             }
        });
    }
    
    public void fitToScreen()
    {  
        this.x = 0;
        this.y = 0;
        this.setCellSize(Game.bounds.w/this.cols, Game.bounds.h/this.rows);
        this.layout();
    }
    
    
    private int toIndex(int gx, int gy)
    {
        return this.cols * gy + gx;
    }
}


// [ GsGroup.java ]:



/*
 * A generic list-like container for GsBasic objects.
 */
public class GsGroup extends GsContainer
{
    GsList<GsBasic> members = new GsList();

    GsGroup()
    {
        super();
    }
    
    // realize abstract GsContainer:
    
    protected GsBasic getItem(Object o)
    {
        return this.get((Integer) o);
    }

    protected void putItem(Object o, GsBasic gab)
    {
        this.put((Integer) o, gab);
    }
    
    public Iterable<GsBasic> each()
    {
        return this.members;
    }
    
    protected Iterable<Object> keys()
    {
        GsList res = new GsList();
        for (int i = 0; i < this.size(); ++i)
        {
            res.add(i);
        }
        return res;
    }
    
    protected GsContainer emptyCopy()
    {
        GsGroup res = new GsGroup();
        for (int i = 0; i < this.size(); ++i)
        {
            res.add(GameNull);
        }
        return res;
    }
    
    
    // friendlier ArrayList - like interface:
    
    GsBasic get(int i)
    {
        return (GsBasic) this.members.get(i);
    }
    
    GsBasic put(int i, GsBasic gab)
    {
        this.members.set(i, gab);
        return gab;
    }
    
    int size()
    {
        return this.members.size();
    }

    GsBasic add(GsBasic gab)
    {
        this.members.add(gab);
        return gab;
    }
    
    void remove(GsBasic gab)
    {
        this.members.remove(gab);
    }
    
    boolean contains(GsBasic gab)
    {
        return this.members.contains(gab);
    }
    
    public void clear()
    {
        this.members.clear();
    }
    
    
    boolean isEmpty()
    {
        return this.size() == 0;
    }
    
    GsBasic atRandom()
    {
        if (this.isEmpty()) return null;
        return this.get((int) random(this.size()));
    }


    void update()
    {
        GsBasic gab;
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            gab = this.get(i);
            if (gab.exists && gab.active) gab.update();
        }
    }
    
    public void render()
    {
        GsBasic gab;
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            gab = this.get(i);
            if (gab.exists && gab.visible) gab.render();
        }
    }
    
    void overlap(GsGroup other)
    {
        // !! this will certainly crash if the group contains other groups
        // TODO: see how flixel handles GsObject in .overlap()
        // !! meanwhile, just don't use overlap() on nested groups.
        
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GsObject a = (GsObject) this.get(i);
            if (a.active && a.exists)
            {
                for (int j = 0; j < other.size(); ++j)
                {
                    GsObject b = (GsObject) other.get(j);
                    if (b.active && b.exists && a != b && a.overlaps(b))
                    {
                        a.onOverlap(b);
                    }
                }
            }
        }
    }
    
    
    GsBasic firstDead()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GsBasic gab = this.get(i);
            if (! gab.alive) return gab;
        }
        return null;
    }
    
    GsBasic firstAlive()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GsBasic gab = this.get(i);
            if (gab.alive) return gab;
        }
        return null;
    }

    GsBasic firstInactive()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GsBasic gab = this.get(i);
            if (! gab.active) return gab;
        }
        return null;
    }


    void removeDead()
    {
        while (true)
        {
            GsBasic body = firstDead();
            if (body == null) { break; } else { remove(body); }
        }
    }

}


// [ GsKeys.java ]:



public class GsKeys
{
    GsDict mPressedKeys = new GsDict();
    GsDict mJustPressed = new GsDict();
    
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

    void setKeyDown(Object value, boolean isCoded, char key, int keyCode)
    { 
        if (isCoded)
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




// [ GsLink.java ]:



/**
 * A GsText that looks and acts like a hyperlink.
 *
 * For the time being, hook up the mouse handling yourself
 * in your GsState, using something like this:
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
public class GsLink extends GsText
{
    String url;
    
    // !! this is meant to be changed from outside
    public boolean hover = false;
  
    GsLink(String label, String url, float x, float y, int textColor, int fontSize)
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
            line(this.x - txtW / 2, lineY, this.x + txtW / 2, lineY);
        }
        
    }

    public void click()
    {
        //link(this.url, "_new");
    }

}


// [ GsMouse.java ]:



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


// [ GsObject.java ]:


/*
*  This class represents a GsObject, occupying a
*  rectangular area in space.
*/
public class GsObject extends GsBasic
{
    public float x = 0;
    public float y = 0;
    public float w = 0;
    public float h = 0;

    float dx = 0;
    float dy = 0;
    float health = 1;
    
    GsObject()
    {
        reset(0,0,0,0);
    }
    
    GsObject(float x, float y, float w, float h)
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
    public boolean overlaps(GsObject that)
    {
        return (this.x < that.x2() && this.x2() > that.x &&
                this.y < that.y2() && this.y2() > that.y);
    }

    public boolean contains(GsObject that)
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
    
    public void onOverlap(GsObject other)
    {
    }
    
}


// [ GsProto.java ]:


/**
 * Root class for all of our objects.
 * Defines a simple message-passing protocol.
 */
public abstract class GsProto
{
    /* A generic (untyped) message-passing protocol for
     * communicating between objects.
     *
     * Message codes are unique ints and should be created
     * with Game.newMessageCode();
     */
    void message(GsProto sender, int code, Object arg)
    {
    }
}

// [ GsRect.java ]:



/**
 * A simple rectangle that draws itself on screen.
 * Will toggle fill colors based on this.alive.
 */
public class GsRect extends GsObject
{
    public int liveColor = 0xffFFFFFF;
    public int deadColor = 0xffCCCCCC;
    public int lineColor = 0xff666666;
    public int lineWeight = 1;
  
    GsRect()
    {
        super(0, 0, 0, 0);
    }

    GsRect(float x, float y, float w, float h)
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


// [ GsSprite.java ]:



public class GsSprite extends GsObject
{
    // animation stuff:
    int frame = 0;
    private PImage[] mFrames;
    boolean animated = false;
    GsTimer timer = new GsTimer(SECONDS/8);

    // rotation stuff:
    int degrees = 0;    
    float xOffset = 0;
    float yOffset = 0;

    GsSprite(float x, float y)
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
    
    public void update()
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
    
    public void render()
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


// [ GsSpriteSheet.java ]:




public class GsSpriteSheet
{
    String assetPath; // empty means the "data" directory
    PImage sheet;
    GsList frames = new GsList();

    GsSpriteSheet(String imageName, int cellW, int cellH, String jsPath)
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

// [ GsSquare.java ]:


public class GsSquare extends GsRect
{
    GsSquare(float x, float y, float side)
    {
        super(x, y, side, side);
    }
}


// [ GsState.java ]:



public class GsState extends GsGroup
{
    int bgColor = 0x00000000;
    
    public GsState()
    {
        super();
        this.w = Game.bounds.w;
        this.h = Game.bounds.h;
    }
    
    public void create()
    {
    }
    
    public void render()
    {
        background(bgColor);
        super.render();
    }
}


// [ GsText.java ]:



/**
 * A GsObject that displays text.
 *
 */
public class GsText extends GsObject
{
    public String label;
    public int textColor;
    public int fontSize = 20;
    public int align = CENTER;
    public int vAlign = BASELINE;
    
    /**
     * A GsRect in case you want to draw a background or border.
     * It's hidden by default.
     * If you change .x, .y, or .label, you should call calcBounds();
     */
    public GsRect bounds;
    
    GsText(String label, float x, float y, int textColor, int fontSize)
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
        
        this.bounds = new GsRect(this.x, this.y, this.w, this.h);
        this.bounds.liveColor = 0xff000000;
        this.bounds.lineColor = 0xff999999;
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


// [ GsTimer.java ]:



/*
 * GsTimer timer = new GsTimer(1.25 * SECONDS);
 *
 * Then in your .update() method:
 *
 *     timer.update();
 *     if (timer.ready) { }
 *
 * Alternatively, you can override onTick();
 *
 */
public class GsTimer extends GsObject
{
    float millisPerTick = 0;
    float mMillisSoFar = 0;
    boolean ready;
    int tickCount = 0;
    
    GsTimer(float millisPerTick)
    {
        super(0, 0, 0, 0);
        this.millisPerTick = millisPerTick;
    }
    
    GsTimer(float millisPerTick, boolean immediate)
    {
        super(0, 0, 0, 0);
        this.millisPerTick = millisPerTick;
        if (immediate) mMillisSoFar = millisPerTick;
    }

    void setTicksPerSecond(float ps)
    {
        this.millisPerTick = SECONDS / ps;
    }
    
    public void update()
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

// [ GsTool.java ]:


/**
 * GameTools allow the GsMouse to interact with the
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
public abstract class GsTool extends GsProto
{
    void click(float x, float y, GsBasic subject)
    {
    }

    void press(float x, float y, GsBasic subject)
    {
    }

    void dragStart(float x, float y, GsBasic subject)
    {
    }
    
    void drag(float x, float y, GsBasic subject)
    {
    }

    void dragEnd(float x, float y, GsBasic subject)
    {
    }
    
    
    /* Same as GsBasic.send
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



// [ _GameSketchLib.java ]:


    // this is what we provide:
    public final _GsGame Game = new _GsGame();
    public final _GsNull GameNull = new _GsNull();

    public void draw()
    {
        Game.update(millis());
        Game.render();
    }

    // global event handlers:
    void mousePressed()  { Game.mouse.pressed(mouseX, mouseY);  }
    void mouseReleased() { Game.mouse.released(mouseX, mouseY); }
    void mouseMoved()    { Game.mouse.moved(mouseX, mouseY);    }
    void mouseDragged()  { Game.mouse.dragged(mouseX, mouseY);  }
    void keyPressed()    { Game.keys.setKeyDown(true, key==CODED, key, keyCode); }
    void keyReleased()   { Game.keys.setKeyDown(null, key == CODED, key, keyCode); }


    // global debug flag.
    // so far, this just shows Bounds for sprites
    public boolean DEBUG = false;

    // a predefined GsSpriteSheet, since everyone wants a GsSpriteSheet!
    public GsSpriteSheet SHEET;

    // Timer Constants
    public float SECONDS = 1000;

    // Keyboard Constants:
    public char SPACE = ' ';
    public char[] WASD_N  = new char[] { 'W', ',', '<' };
    public char[] WASD_W  = new char[] { 'A', 'a' };
    public char[] WASD_S  = new char[] { 'S', 's', 'O', 'o' };
    public char[] WASD_E  = new char[] { 'D', 'd', 'E', 'e' };


    // This figures out which runtime we're using dynamically,
    // so we can do conditional compilation.
    public final String RUNTIME_ANDROID = "ANDROID";

    public final String RUNTIME_JVM = "JVM";
    public final String RUNTIME_PJS = "PJS";
    public final boolean CONFIG_PJS
        = (new Object()).toString() == "[object Object]";

    public final boolean CONFIG_ANDROID = !CONFIG_PJS && Game._isAndroid();
    public final boolean CONFIG_JVM = ! (CONFIG_PJS || CONFIG_ANDROID);
    public final boolean CONFIG_ANY_JAVA = CONFIG_ANDROID || CONFIG_JVM;
    public final String RUNTIME = CONFIG_PJS ? RUNTIME_PJS
        : CONFIG_ANDROID ? RUNTIME_ANDROID
        : RUNTIME_JVM;


    public class GsList<T> extends ArrayList<T>
    {
        GsList() { super(); }
        GsList(int i) { super(i); }
    }
    public class GsDict extends HashMap{ }
    // TODO : public class GsFont  {}
    // TODO : public class GsImage {}





// [ _GsGame.java ]:




// Game is a Singleton - i.e., the only instance of _GsGame.
public class _GsGame
{
    GsState state;
    GsObject bounds;
    PFont defaultFont;
    GsKeys keys = new GsKeys();
    
    
    /**
     * The mouse/touchscreen system.
     */
    public final GsMouse mouse = new GsMouse();
    
    /**
     * The current GsTool. Defaults to GsBasicTool;
     */
    public GsTool tool = new GsBasicTool();
    
    
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
    void switchState(GsState newState)
    {
        Game.state = newState;
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

// [ _GsMath.java ]:


public static class _GsMath
{
    public static float clamp(float value, float minValue, float maxValue)
    {
        if (value > maxValue) return maxValue;
        if (value < minValue) return minValue;
        return value;
    }
}

// [ _GsNull.java ]:



/**
 * This is a special single-instance class that gives
 * us a null-like value that represents the lack of a
 * normal GsBasic instance.
 *
 * If we used the regular null value, we'd have to 
 * check for (gab != null) everywhere, but with
 * GameNull, we can treat it like any other GsBasic
 * and it just transparently does the right thing.
 *
 * If you do need to test for it, the boolean .isNull
 * is defined on all GsBasic classes. It's false for
 * everything but this class.
 * 
 * http://en.wikipedia.org/wiki/Null_Object_pattern
 */
public final class _GsNull extends GsBasic
{
    // Nullable
    public final boolean isNull() { return true; }

    public boolean containsPoint(float px, float py)
    {
        return false;
    }
    
    public boolean overlaps(GsBasic other)
    {
        return false;
    }

    public boolean covers(GsBasic other)
    {
        return false;
    }
    
    
    // Iterable
    // yields an empty list
    private final GsList<GsBasic> mEmptyList = new GsList<GsBasic>(0);
    public Iterable<GsBasic> each()
    {
        return mEmptyList;
    }

    // Constructor
    private int mInstanceCount = 0;
    public _GsNull()
    {
        // !! You actually can change these things. There's not really any way to
        //    avoid that without resorting to getters and setters. :/

        // Spatial
        // Not A Number coordinates, all overlapping returns false
        x = Float.NaN;
        y = Float.NaN;
        w = Float.NaN;
        h = Float.NaN;

        // Playable
        alive = false;
        active = false;
        exists = false;
        visible = false;

        if (++mInstanceCount > 1)
        {
            throw new RuntimeException("GameNull is a singleton. There can be only one.");
        }
    }
}


// [ GsChanger.java ]:



public interface GsChanger
{
    public GsBasic change(GsBasic gab);
}

// [ GsChangerG.java ]:



public interface GsChangerG
{
    public GsBasic change(int gx, int gy, GsBasic old);
}

// [ GsChecker.java ]:



public interface GsChecker
{
    public  boolean check(GsBasic gab);
}

// [ GsCheckerG.java ]:



public interface GsCheckerG
{
    public boolean check(int gx, int gy, GsBasic gab);
}

// [ GsPopulator.java ]:



public interface GsPopulator
{
    public GsBasic populate(Object k);
}

// [ GsPopulatorG.java ]:



public interface GsPopulatorG
{
    public GsBasic populate(int gx, int gy);
}

// [ GsReporter.java ]:



public interface GsReporter
{
    public Object report(GsBasic gab);
}

// [ GsReporterG.java ]:



public interface GsReporterG
{
    public Object report(int gx, int gy, GsBasic old);
}

// [ GsVisitor.java ]:



public interface GsVisitor
{
    public void visit(GsBasic gab);
}

// [ GsVisitorG.java ]:



public interface GsVisitorG
{
    public void visit(int gx, int gy, GsBasic gab);
}

/* -- [End GameSketchLib] --------------------------------------*/
