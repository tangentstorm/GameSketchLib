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
    abstract public ArrayList<GameBasic> each();
    abstract protected ArrayList<Object> keys();
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
    
    
    @Override
    public void render()
    {
        for (GameBasic gab : this.each())
        {
            gab.render();
        }
    }
    
}

