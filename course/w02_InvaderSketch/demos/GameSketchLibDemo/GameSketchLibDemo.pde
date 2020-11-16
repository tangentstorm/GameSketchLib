 /*
  * BulletDemo for InvaderSketch Tutorial
  *
  * video: http://www.youtube.com/playlist?list=PL9164D8831A48D0DE&feature=viewall
  *
  */
  
class GameBasic
{
    // these are straight out of flixel
    boolean visible = true; // if false: GameGroup won't ask it to render()
    boolean active = true;  // if false: GameGroup won't ask it to update()
    boolean exists = true;  // if false: GameGroup won't ask for either.
    boolean alive = true;   // this one is just handy in games
     
    public void update()
    {
    }
    
    public void render()
    {
    }
}


  
 class GameObject extends GameBasic
 {
     public float x = 0;
     public float y = 0;
     public float w = 0;
     public float h = 0;

     float dx = 0;
     float dy = 0;

     GameObject() { this(0,0,0,0); }

     GameObject(float x, float y, float w, float h)
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




     public void onOverlap(GameObject other)
     {
     }
 }

 class GameGroup extends GameObject
 {
     ArrayList members = new ArrayList();

     GameGroup() { }

     GameBasic get(int i)
     {
         return (GameBasic) this.members.get(i);
     }
     
     GameBasic put(int i, GameBasic obj)
     {
         this.members.set(i, obj);
         return obj;
     }
     
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

 }


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
     void mouseMoved() { }
 }

 class GameClass
 {
     GameState state;
     GameObject bounds;

     void init(GameState newState)
     {
         Game.bounds = new GameObject(0, 0, width, height);
         switchState(newState);
     }

     void switchState(GameState newState)
     {
         Game.state = newState;
         newState.create();
     }
 }
 // simulating a static class:
 GameClass Game = new GameClass();




 class Rectangle extends GameObject
 {
     color liveColor = #FFFFFF;
     color deadColor = #CCCCCC;

     Rectangle (float x, float y, float w, float h)
     {
         super(x, y, w, h);
     }

     public void render()
     {
         fill(this.alive ? this.liveColor : this.deadColor );
         rect(this.x, this.y, this.w, this.h);
     }
 }


 class Square extends Rectangle
 {
     Square (float x, float y, float side)
     {
         super(x, y, side, side);
     }
 }


 final int kBulletW = 10;
 final int kBulletH = 20;

 class Bullet extends Rectangle
 {
     Bullet(float x, float y)
     {
         super(x, y, kBulletW, kBulletH);
         alive = false;
         liveColor = deadColor = #FFCC33;
     }

     void update()
     {
         if (this.alive)
         {
             y += dy;
             x += dx;
         }
     }

     void fire(float x, float y)
     {
         this.x = x;
         this.y = y;
         this.alive = true;
     }

     void onOverlap(GameObject other)
     {
         this.alive = false;
         other.alive = false;
     }

 }

 //========================================================================

 class PlayState extends GameState
 {
     final int kBulletCount = 3;
     final float kBulletSpeed = -3.75;
     int mBulletsLeft = kBulletCount;
     GameGroup mBullets = new GameGroup();

     final int kPerRow = 3;
     final int kNumRows = 3;
     final int kSquareCount = kPerRow * kNumRows;
     GameGroup mSquares = new GameGroup();

     void create()
     {
         for (int i = 0; i < 3; ++i)
         {
             for (int j = 0; j < 3; ++j)
             {
                 mSquares.add(new Square(75 * i + 50, 75 * j + 50, 25));
             }
         }

         for (int i = 0; i < kBulletCount; ++i)
         {
             Bullet b = (Bullet) mBullets.add(new Bullet(0,0));
             b.dy = kBulletSpeed;
         }

         bgColor = #3366FF;
         add(mSquares);
         add(mBullets);
     }

     void update()
     {
         mBullets.overlap(mSquares);
         
         int bulletsLeft = 0;
         for (int i = 0; i < kBulletCount; ++i)
         {
             Bullet b = (Bullet) mBullets.get(i);
             b.update();
             if (! b.overlaps(Game.bounds)) b.alive = false;
             if (! b.alive)
             {
                 b.x = kBulletW * bulletsLeft++;
                 b.y = height - kBulletH;
             }
         }
         //mBulletsLeft = bulletsLeft;
         
         if (mSquares.firstAlive() == null) { Game.switchState(new MenuState()); }
     }

     void mousePressed()
     {
         //if (mBulletsLeft > 0)
         //{
         //    mBulletsLeft--;
             Bullet b = (Bullet) mBullets.firstDead();
             if (b != null)
             {
             	b.fire(mouseX, height - kBulletH * 2);
             }
         //}
     }
 }
 
 class GameText extends GameObject
{
    String label;
    color textColor;
    int fontSize = 20;
    int align = LEFT;
    
    GameText(String label, float x, float y, color textColor, int fontSize)
    {
        super(x, y, 0, 0);
        this.label = label;
        this.fontSize = fontSize;
        this.textColor = textColor;
    }
    
    void render()
    {
        fill(this.textColor);
        textSize(this.fontSize); // textFont(Game.defaultFont, this.fontSize);
        textAlign(this.align);
        text(this.label, this.x, this.y);
    }
    
}
 


 class MenuState extends GameState
 {
 	 void create()
 	 {
 	 	this.add(new GameText(
 	 		"BulletDemo! Click to start.",
 	 		 10, 50, #FFFFFF, 16));
 	 }

     void mousePressed()
     {
         Game.switchState(new PlayState());
     }
 }


 void setup()
 {
     size(300, 300);
     Game.init(new MenuState());
 }

 void draw()
 {
     Game.state.update();
     Game.state.render();
 }

 void mousePressed()  { Game.state.mousePressed(); }
 void mouseReleased() { Game.state.mouseReleased(); }
 void mouseMoved()    { Game.state.mouseMoved(); }
