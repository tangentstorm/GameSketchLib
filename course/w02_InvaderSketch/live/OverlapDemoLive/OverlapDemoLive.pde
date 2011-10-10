// Drag the boxes around. They turn gray when they overlap.
// This was built in parts 2.1[b-d] of the video lessons here:
// http://www.youtube.com/playlist?list=PL9164D8831A48D0DE&feature=viewall

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
     
     // http://stackoverflow.com/questions/306316/determine-if-two-Squares-overlap-each-other
     public boolean overlaps(Bounds that)
     {
         return (this.x < that.x2() && this.x2() > that.x &&
                 this.y < that.y2() && this.y2() > that.y);
     }

     public boolean containsPoint(float x, float y)
     {
         return this.x <= x && x <= this.x2()
             && this.y <= y && y <= this.y2();
     }
}

class Square extends Bounds
{
    color fillColor = #FFFFFF;
    
    Square(float x, float y, float size)
    {
        super(x, y, size, size);
    }
    
    void render()
    {
       fill(fillColor);
       rect(this.x, this.y, this.w, this.h);
    }
}



 Square[] mSquares = new Square[9];
 Square mInHand = null;
 float mXOff;
 float mYOff;

 void setup()
 {
     size(300, 300);
     
     for (int i = 0; i < 3; ++i)
     {
         for (int j = 0; j < 3; ++j)
         {
             int index = i * 3 + j;
             mSquares[index] = new Square(75 * i + 50, 75 * j + 50, 25);
         }
     }   
 }
 
 /*
 
 

|   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---+---+---+---+---+---+---+---+---+---|
| 0 | . | . | . | . | . | . | . | . | . |
| 1 |   | . | . | . | . | . | . | . | . |
| 2 |   |   | . | . | . | . | . | . | . |
| 3 |   |   |   | . | . | . | . | . | . |
| 4 |   |   |   |   | . | . | . | . | . |
| 5 |   |   |   |   |   | . | . | . | . |
| 6 |   |   |   |   |   |   | . | . | . |
| 7 |   |   |   |   |   |   |   | . | . |
| 8 |   |   |   |   |   |   |   |   | . | 
 
 
 */
 
 
  
 void draw()
 {
     background(#3366FF);
     
     for (int i = 0; i < mSquares.length; ++i)
     {
         mSquares[i].fillColor = #FFFFFF;
     }
     
     for (int i = 0; i < mSquares.length; ++i)
     {
         for (int j = i+1; j < mSquares.length; ++j)
         {
             if (j != i && mSquares[i].overlaps(mSquares[j]))
             {
                 mSquares[i].fillColor = #999999;
                 mSquares[j].fillColor = #999999;
             }
         }
         mSquares[i].render();
     }        
 }
 
 void mousePressed()
 {
      for (int i = 0; i < mSquares.length; ++i)
      {
          if (mSquares[i].containsPoint(mouseX, mouseY))
          {
              // mSquares[i].fillColor = color(random(255), random(255), random(255));
              mInHand = mSquares[i];
              mXOff = mInHand.x - mouseX;
              mYOff = mInHand.y - mouseY;
              break;
          }
      }
 }
 
 void mouseReleased()
 {
     mInHand = null;
 }
 
 
 void mouseDragged()
 {
     if (mInHand != null)
     { 
         mInHand.x = mouseX + mXOff;
         mInHand.y = mouseY + mYOff;
     }
 }
