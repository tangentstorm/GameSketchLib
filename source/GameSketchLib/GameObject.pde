/*
 * Base class for pretty much anything inside a game.
 *
 */
class GameObject extends GameBounds
{
    boolean alive = true;
    boolean visible = true;
    boolean exists = true;
    float dx = 0;
    float dy = 0;
    float health = 1;
    
    GameObject (float x, float y, float w, float h)
    {
        super(x, y, w, h);
    }
    
    public void render()
    {
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
    
    public void onOverlap(GameObject other)
    {
    }
    
    public void onDeath()
    {
        this.visible = false;
    }
}

