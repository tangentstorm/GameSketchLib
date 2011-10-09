class GameGroup extends GameObject
{
    ArrayList children = new ArrayList();

    GameGroup()
    {
        super(0,0,0,0);
    }
    
    GameObject add(GameObject obj)
    {
        this.children.add(obj);
        return obj;
    }
    
    GameObject get(int i)
    {
        return (GameObject) this.children.get(i);
    }
    
    void remove(GameObject obj)
    {
        this.children.remove(obj);
    }
    
    int size()
    {
        return this.children.size();
    }
    
    void update()
    {
        int len = this.children.size();
        for (int i = 0; i < len; ++i)
        {
            this.get(i).update();
        }
    }
    
    void render()
    {
        int len = this.children.size();
        for (int i = 0; i < len; ++i)
        {
            this.get(i).render();
        }
    }
    
    void overlap(GameGroup other)
    {
        int len = this.children.size();
        for (int i = 0; i < len; ++i)
        {
            GameObject a = this.get(i);
            if (a.alive)
            {
                for (int j = 0; j < other.size(); ++j)
                {
                    GameObject b = other.get(j);
                    if (b.alive && a.overlaps(b))
                    {
                        a.onOverlap(b);
                    }
                }
            }
        }
    }
    
    
    GameObject firstDead()
    {
        int len = this.children.size();
        for (int i = 0; i < len; ++i)
        {
            GameObject obj = this.get(i);
            if (! obj.alive) return obj;
        }
        return null;
    }
    
    GameObject firstAlive()
    {
        int len = this.children.size();
        for (int i = 0; i < len; ++i)
        {
            GameObject obj = this.get(i);
            if (obj.alive) return obj;
        }
        return null;
    }

    
}

