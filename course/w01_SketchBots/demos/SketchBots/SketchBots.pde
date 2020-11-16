/* @pjs preload="/static/uploaded_resources/p.1181/orangeguy-D.png"; */

/*
Course URL: http://ureddit.com/class/268
Instructor: SquashMonster
me: tangentstorm (michal.wallace@gmail.com)
*/

final static int NORTH = 1;
final static int EAST = 2;
final static int SOUTH = 4;
final static int WEST = 8;

int mOrangeGuyHeading = 0;
int mOrangeGuySpeed = 10;

// for the adventurous, make orange and blue guys into sprites:
/*
class Sprite
{
  int x;
  int y;
  // more variables should go here
  // (image, speed, etc.)
  
  Sprite(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
}
// then you would say:
Sprite mOrangeGuy = new Sprite(0,0);
*/

// these are the ones we draw:
PImage mOrangeGuyImage;
PImage mBlueGuyImage;
PImage mBackgroundImage;

// this is where we draw them
int mOrangeGuyX = 0;
int mOrangeGuyY = 0;

// low tech sprite sheet (since we're not using Arrays yet)
PImage mOrangeGuyU;
PImage mOrangeGuyD;
PImage mOrangeGuyL;
PImage mOrangeGuyR;


int kCanvasWidth = 300;
int kCanvasHeight = 300;

// this is run once
void setup()
{
    // set the background color
    background(255);
    
    // canvas size remember to update kCanvasXX 
    size(300, 300); 
      
    // smooth edges
    smooth();
    
    // limit the number of frames per second
    frameRate(30);
    
    mOrangeGuyD= loadImage("data/orangeguy-D.png");
    mOrangeGuyU= loadImage("data/orangeguy-U.png");
    mOrangeGuyR= loadImage("data/orangeguy-R.png");
    mOrangeGuyL= loadImage("data/orangeguy-L.png");
    
    mBackgroundImage= loadImage("data/background.png");
    
    mBlueGuyImage= loadImage("data/blueguy-D.png");

    // initialize our "current frame" images
    mOrangeGuyImage = mOrangeGuyL; 
    mOrangeGuyX = kCanvasWidth/2 - mOrangeGuyImage.width/2;
    mOrangeGuyY = kCanvasHeight/2 - mOrangeGuyImage.height/2;
} 

// this is run repeatedly.
void draw()
{
   // draw the background
   image(mBackgroundImage, 0, 0);

   switch(mOrangeGuyHeading)
   {
      case NORTH: mOrangeGuyY-=mOrangeGuySpeed; break;
      case EAST: mOrangeGuyX+=mOrangeGuySpeed; break;
      case SOUTH: mOrangeGuyY+=mOrangeGuySpeed; break;
      case WEST: mOrangeGuyX-=mOrangeGuySpeed; break;
      case NORTH|EAST: mOrangeGuyY-=mOrangeGuySpeed; mOrangeGuyX+=mOrangeGuySpeed; break;
      case NORTH|WEST: mOrangeGuyY-=mOrangeGuySpeed; mOrangeGuyX-=mOrangeGuySpeed; break;
      case SOUTH|EAST: mOrangeGuyY+=mOrangeGuySpeed; mOrangeGuyX+=mOrangeGuySpeed; break;
      case SOUTH|WEST: mOrangeGuyY+=mOrangeGuySpeed; mOrangeGuyX-=mOrangeGuySpeed; break;
    }
    
    // bounds checking
    if (mOrangeGuyY + mOrangeGuyImage.height > kCanvasHeight)
    {
      mOrangeGuyY = kCanvasHeight - mOrangeGuyImage.height;
    }
    
  
    image(mOrangeGuyImage, mOrangeGuyX, mOrangeGuyY);
    image(mBlueGuyImage, kCanvasWidth/2 - mBlueGuyImage.width/2,
         kCanvasHeight - mBlueGuyImage.height );
}


void keyPressed()
{
  switch(key)
  {
    case(','):case('<'):case('w'):case('W'):
      mOrangeGuyHeading |=NORTH;
      mOrangeGuyImage = mOrangeGuyU;
     break;
    case('e'):case('E'):case('d'):case('D'):
      mOrangeGuyHeading |=EAST;
      mOrangeGuyImage = mOrangeGuyR;
    break;
    case('o'):case('O'):case('s'):case('S'):
      mOrangeGuyHeading |=SOUTH;
      mOrangeGuyImage = mOrangeGuyD;
    break;
    case('a'):case('A'):
      mOrangeGuyHeading |=WEST;
      mOrangeGuyImage = mOrangeGuyL;
    break;
    case(CODED):
      switch(keyCode)
      {
        case(UP): mOrangeGuyHeading |=NORTH;  break;
      }
    break;
  }
}
 
void keyReleased()
{  
  switch(key)
  {
    case(','):case('<'):case('w'):case('W'):mOrangeGuyHeading ^=NORTH;break;
    case('e'):case('E'):case('d'):case('D'):mOrangeGuyHeading ^=EAST;break;
    case('o'):case('O'):case('s'):case('S'):mOrangeGuyHeading ^=SOUTH;break;
    case('a'):case('A'):mOrangeGuyHeading ^=WEST;break;
    case(CODED):
      switch(keyCode)
      {
        case(UP): mOrangeGuyHeading ^=NORTH;  break;
      }
    break;
  }
}
