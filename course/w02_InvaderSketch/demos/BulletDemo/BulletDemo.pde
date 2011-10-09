 /*
  * BulletDemo for InvaderSketch Tutorial
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
 }

 class Rectangle extends GameObject
 {
     Rectangle (float x, float y, float w, float h)
     {
         super(x, y, w, h);
     }

     public void render()
     {
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
         dy = kBulletSpeed;
         alive = false;
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

 }



 //========================================================================

 final int kSquareCount = 9;
 Square[] mSquares = new Square[kSquareCount];

 final int kBulletCount = 3;
 final float kBulletSpeed = -3.75;
 int mBulletsLeft = kBulletCount;
 Bullet[] mBullets = new Bullet[kBulletCount];

 final int kPerRow = 3;
 final int kNumRows = 3;
 // final int kSquareCount = kPerRow * kNumRows;
 Bounds SCREEN_BOUNDS;

 void setup()
 {
     size(300, 300);
     SCREEN_BOUNDS = new Bounds(0, 0, width, height);

     for (int i = 0; i < 3; ++i)
     {
         for (int j = 0; j < 3; ++j)
         {
             mSquares[i * 3 + j] = new Square(75 * i + 50, 75 * j + 50, 25);
         }
     }

     for (int i = 0; i < kBulletCount; ++i)
     {
         mBullets[i] = new Bullet(0,0);
     }

 }

 void draw()
 {
     update();
     render();
 }


 void update()
 {
     int bulletsLeft = 0;
     for (int i = 0; i < kBulletCount; ++i)
     {
         Bullet b = mBullets[i];
         if (b.overlaps(SCREEN_BOUNDS))
         {
             b.update();
         }
         else
         {
             b.alive = false;
         }

         if (b.alive)
         {
             for (int j = 0; j < kSquareCount; ++j)
             {
                 Square sq = mSquares[j];
                 if (sq.alive && b.overlaps(sq))
                 {
                     sq.alive = false;
                     b.alive = false;
                 }
             }
         }
         else
         {
             b.x = kBulletW * bulletsLeft++;
             b.y = height - kBulletH;
         }
     }
     mBulletsLeft = bulletsLeft;



 }

 void render()
 {
     background(#3366FF);
     for (int i = 0; i < kSquareCount; ++i)
     {
         fill(mSquares[i].alive ? #FFFFFF : #CCCCCC);
         mSquares[i].render();
     }

     fill(#FFCC33);
     for (int i = 0; i < kBulletCount; ++i)
     {
         mBullets[i].render();
     }

 }


 Bullet nextBullet()
 {
     for (int i = 0; i < kBulletCount; ++i)
     {
         if (! mBullets[i].alive)
         {
             return mBullets[i];
         }
     }
     return mBullets[0];
 }

 void mousePressed()
 {
     if (mBulletsLeft > 0)
     {
         mBulletsLeft--;
         Bullet b = nextBullet();
         b.fire(mouseX, height - kBulletH * 2);
     }
 }
