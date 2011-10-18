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
    
    @Override
    GameBasic getItem(Object o)
    {
        return this.get((Integer) o);
    }

    @Override    
    void putItem(Object o, GameBasic gab)
    {
        this.put((Integer) o, gab);
    }
    
    @Override
    Iterable<GameBasic> each()
    {
        return this.members;
    }
    
    @Override
    Iterable<Object> keys()
    {
        ArrayList res = new ArrayList();
        for (int i = 0; i < this.size(); ++i)
        {
            res.add(i);
        }
        return res;
    }
    
    @Override
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
    
    @Override
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

