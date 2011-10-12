class GameGroup extends GameBasic
{
    ArrayList members = new ArrayList();

    GameGroup()
    {
        super();
    }
    
    GameBasic get(int i)
    {
        return (GameBasic) this.members.get(i);
    }
    
    GameBasic put(int i, GameBasic obj)
    {
        this.members.set(i, obj);
        return obj;
    }

    // for javaphiles:
    GameBasic set(int i, GameBasic obj)
    {
        return this.put(i, obj);
    }
    
    int size()
    {
        return this.members.size();
    }

    GameBasic add(GameBasic obj)
    {
        this.members.add(obj);
        return obj;
    }
    
    void remove(GameBasic obj)
    {
        this.members.remove(obj);
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
        GameBasic obj;
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            obj = this.get(i);
            if (obj.exists && obj.active) obj.update();
        }
    }
    
    void render()
    {
        GameBasic obj;
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            obj = this.get(i);
            if (obj.exists && obj.visible) obj.render();
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
            GameBasic obj = this.get(i);
            if (! obj.alive) return obj;
        }
        return null;
    }
    
    GameBasic firstAlive()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GameBasic obj = this.get(i);
            if (obj.alive) return obj;
        }
        return null;
    }

    GameBasic firstInactive()
    {
        int len = this.members.size();
        for (int i = 0; i < len; ++i)
        {
            GameBasic obj = this.get(i);
            if (! obj.active) return obj;
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

