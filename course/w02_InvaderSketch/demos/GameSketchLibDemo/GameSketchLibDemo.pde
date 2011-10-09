 /*
  * GameSketchLibDemo for InvaderSketch Tutorial
  *
  * video: http://www.youtube.com/playlist?list=PL9164D8831A48D0DE&feature=viewall
  *
  */
  
 class Bounds
 {
     public float x = 0;
     public float y = 0;
     public float w = 0;
     public float h = 0;

     Bounds(float x, float y, float w, float h)
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
     public boolean overlaps(Bounds that)
     {
         return (this.x < that.x2() && this.x2() > that.x &&
                 this.y < that.y2() && this.y2() > that.y);
     }

     /* exercise:
     public boolean contains(Bounds that)
     {
         return this.x <= that.x
             && this.y <= that.y
             && this.x2() >= that.x2()
             && this.y2() >= that.y2();
     }
     */
 }


 class GameObject extends Bounds
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
     void keyPressed() { }
     void keyReleased() { }
 }

 class GameSketchLib
 {
     GameState state;
     Bounds bounds = new Bounds(0,0,0,0);

     void init(GameState newState)
     {
         Game.bounds = new Bounds(0, 0, width, height);
         switchState(newState);
     }

     void switchState(GameState newState)
     {
         Game.state = newState;
         newState.create();
     }
 }
 // simulating a static class:
 GameSketchLib Game = new GameSketchLib();




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
         mBulletsLeft = bulletsLeft;
         if (mSquares.firstAlive() == null) { Game.switchState(new TitleState()); }
     }

     void mousePressed()
     {
         if (mBulletsLeft > 0)
         {
             mBulletsLeft--;
             Bullet b = (Bullet) mBullets.firstDead();
             b.fire(mouseX, height - kBulletH * 2);
         }
     }
 }


 class TitleState extends GameState
 {
     void render()
     {
         background(0);
         textSize(16);
         fill(255);
         text("GameGroups Demo. Click to start.", 10, 50);
     }

     void mousePressed()
     {
         Game.switchState(new PlayState());
     }
 }


 void setup()
 {
     size(300, 300);
     Game.init(new TitleState());
 }

 void draw()
 {
     Game.state.update();
     Game.state.render();
 }

 void mousePressed()  { Game.state.mousePressed(); }
 void mouseReleased() { Game.state.mouseReleased(); }
 void mouseMoved()    { Game.state.mouseMoved(); }
 void keyPressed()    { Game.state.keyPressed(); }
 void keyReleased()   { Game.state.keyReleased(); }
