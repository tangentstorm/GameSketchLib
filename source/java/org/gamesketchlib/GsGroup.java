package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

/*
 * A generic list-like container for GsBasic objects.
 */
public class GsGroup extends GsContainer
{
    GsList<GsBasic> members = new GsList();

    public GsGroup()
    {
        super();
    }
    
    // realize abstract GsContainer:
    
    @Override
    protected GsBasic getItem(Object o)
    {
        return this.get((Integer) o);
    }

    @Override
    protected void putItem(Object o, GsBasic gab)
    {
        this.put((Integer) o, gab);
    }
    
    @Override
    public Iterable<GsBasic> each()
    {
        return this.members;
    }
    
    @Override
    protected Iterable<Object> keys()
    {
        GsList res = new GsList();
        for (int i = 0; i < this.size(); ++i)
        {
            res.add(i);
        }
        return res;
    }
    
    @Override
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
    
    public GsBasic get(int i)
    {
        return (GsBasic) this.members.get(i);
    }
    
    public GsBasic put(int i, GsBasic gab)
    {
        this.members.set(i, gab);
        return gab;
    }
    
    public int size()
    {
        return this.members.size();
    }

    public GsBasic add(GsBasic gab)
    {
        this.members.add(gab);
        return gab;
    }
    
    public void remove(GsBasic gab)
    {
        this.members.remove(gab);
    }
    
    public boolean contains(GsBasic gab)
    {
        return this.members.contains(gab);
    }
    
    @Override
    public void clear()
    {
        this.members.clear();
    }
    
    
    public boolean isEmpty()
    {
        return this.size() == 0;
    }
    
    public GsBasic atRandom()
    {
        if (this.isEmpty()) return null;
        return this.get((int) random(this.size()));
    }


    @Override
    public void update()
    {
        GsBasic gab;
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            gab = this.get(i);
            if (gab.exists && gab.active) gab.update();
        }
    }
    
    @Override
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
    
    public void overlap(GsGroup other)
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
    
    
    public GsBasic firstDead()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GsBasic gab = this.get(i);
            if (! gab.alive) return gab;
        }
        return null;
    }
    
    public GsBasic firstAlive()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GsBasic gab = this.get(i);
            if (gab.alive) return gab;
        }
        return null;
    }

    public GsBasic firstInactive()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GsBasic gab = this.get(i);
            if (! gab.active) return gab;
        }
        return null;
    }


    public void removeDead()
    {
        while (true)
        {
            GsBasic body = firstDead();
            if (body == null) { break; } else { remove(body); }
        }
    }

    public GsBasic[] reversed()
    {
        GsBasic res[] = new GsBasic[this.members.size()];
        for (int i = 0; i < res.length; ++i)
        {
            res[i] = this.get(res.length - 1 - i);
        }
        return res;
    }
}

