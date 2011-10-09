/*
 * Base class for pretty much anything inside a game.
 *
 */
class GameObject extends GameBounds
{
    boolean alive = true;
    float dx = 0;
    float dy = 0;
    
    GameObject (float x, float y, float w, float h)
    {
        super(x, y, w, h);
    }
    
    public void render()
    {
    }
    
    public void update()
    {
    }
    
    public void onOverlap(GameObject other)
    {
    }
}

