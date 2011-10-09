/**
* KeyboardTest
* Shows state of the arrow and WASD keys on each tick.
*
* This fixes the issue with CODED keys by replacing
* "switch(key) case CODED" with "if (key==CODED)..."
*
* live: http://studio.sketchpad.cc/sp/pad/view/ro.9NdN1h6prKB9u/latest
*/
final int N = 1;
final int S = 2;
final int E = 4;
final int W = 8;
 
int mArrows = 0;
int mWASD = 0;
 
final int kKeySize = 25;
 
void setup()
{
  size(300, 300);
}
 
void draw()
{
  background(0);
  
  // wasd on the left:
  drawKey( 50, 100, mWASD&N);
  drawKey( 25, 125, mWASD&W);
  drawKey( 50, 125, mWASD&S);
  drawKey( 75, 125, mWASD&E);
 
  // arrows on the right:
  drawKey(225, 100, mArrows&N);
  drawKey(200, 125, mArrows&W);
  drawKey(225, 125, mArrows&S);
  drawKey(250, 125, mArrows&E);
}
 
void keyPressed() { toggleBits(); }
void keyReleased() { toggleBits(); }
 
void toggleBits()
{
  if (key == CODED)
  {
    switch(keyCode)
    {
      case(UP):    mArrows ^= N; break;
      case(LEFT):  mArrows ^= W; break;
      case(DOWN):  mArrows ^= S; break;
      case(RIGHT): mArrows ^= E; break;
    }
  }
  else
  {
    switch(key)
    {
      // wasd + dvorak equivalents:
      case('w'):case('W'):case(','):case('<'): mWASD ^= N; break;
      case('a'):case('A'):                     mWASD ^= W; break;
      case('s'):case('S'):case('o'):case('O'): mWASD ^= S; break;
      case('d'):case('D'):case('e'):case('E'): mWASD ^= E; break;
    }
  }
}
 
void drawKey(int x, int y, int bitMask)
{
  boolean isDown = bitMask != 0;
  fill(isDown ? 255 : 128); 
  rect(x+2, y+2, kKeySize-2, kKeySize-2);
}