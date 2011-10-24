package org.gamesketchlib;

import org.gamesketchlib.delegate.*;

import static org.gamesketchlib._GameSketchLib.*;

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
    
    
    @Override
    public void render()
    {
        for (GsBasic gab : this.each())
        {
            gab.render();
        }
    }
    
}

