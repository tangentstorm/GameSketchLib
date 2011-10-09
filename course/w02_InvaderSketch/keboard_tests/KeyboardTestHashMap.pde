/*
 * KeyboardTest : HashMap version
 *
 * This extends the previous demos to handle all keys.
 * 
 * Shows state of the arrow keys and [WASD]/[>AOE] keys,
 * demonstrating isKeyDown(code) and isAnyDown(char[])
 *
 * Changes the background color randomly when you press the spacebar,
 * demonstrating the justPressed(code).
 *
 * live: http://studio.sketchpad.cc/sp/pad/view/ro.9Kb7By87p10yZ/latest
 *
 */
 
//== keyboard handling ================================================
 
HashMap mPressedKeys = new HashMap();
HashMap mJustPressed = new HashMap();
 
void keyPressed()  { setKeyDown(true); }
void keyReleased() { setKeyDown(null); }
 
// keyCode is an int, but key is a char, so we need a version for each:
boolean isKeyDown(char code) { return mPressedKeys.get(code) != null; }
boolean isKeyDown(int  code) { return mPressedKeys.get(code) != null; }
boolean justPressed(char code) { return mJustPressed.get(code) != null; }
boolean justPressed(int  code) { return mJustPressed.get(code) != null; }
 
void setKeyDown(Object value)
{ 
    if (key == CODED)
    {
        mJustPressed.put(keyCode, isKeyDown(keyCode) ? null : true);
        mPressedKeys.put(keyCode, value);
    }
    else
    {
        mJustPressed.put(key, isKeyDown(key) ? null : true);
        mPressedKeys.put(key, value);
    }
}
 
// unfortunately, we can't mix them in the array in processing
boolean isAnyDown(char[] keys)
{
    for (int i = 0; i < keys.length; ++i)
    {
        if (isKeyDown(keys[i])) return true;
    }
    return false;
}
 
 
char[] WASD_N  = new char[] { 'W', ',', '<' };
char[] WASD_W  = new char[] { 'A', 'a' };
char[] WASD_S  = new char[] { 'S', 's', 'O', 'o' };
char[] WASD_E  = new char[] { 'D', 'd', 'E', 'e' };
 
 
//== display logic ================================================
 
final int kKeySize = 25;
color mBgColor = color(0,0,0);
 
void setup()
{
    size(300, 300);
}
 
void draw()
{
    boolean INPUT_N = isKeyDown(UP)    || isAnyDown(WASD_N);
    boolean INPUT_W = isKeyDown(LEFT)  || isAnyDown(WASD_W);
    boolean INPUT_S = isKeyDown(DOWN)  || isAnyDown(WASD_S);
    boolean INPUT_E = isKeyDown(RIGHT) || isAnyDown(WASD_E);
    
    background(mBgColor);
    
    if (justPressed(' '))
    {
        mBgColor = color(random(255),random(255),random(255));
    }
    
    // wasd on the left:
    drawKey( 50,  75, isAnyDown(WASD_N));
    drawKey( 25, 100, isAnyDown(WASD_W));
    drawKey( 50, 100, isAnyDown(WASD_S));
    drawKey( 75, 100, isAnyDown(WASD_E));
 
    // "either" in the middle
    drawKey( 135, 175, INPUT_N);
    drawKey( 110, 200, INPUT_W);
    drawKey( 135, 200, INPUT_S);
    drawKey( 160, 200, INPUT_E);
  
    // arrows on the right:
    drawKey(225,  75, isKeyDown(UP));
    drawKey(200, 100, isKeyDown(LEFT));
    drawKey(225, 100, isKeyDown(DOWN));
    drawKey(250, 100, isKeyDown(RIGHT));
    
    // Important: clear out the justPressed after every frame
    // (else it won't unset until they key repeats)
    mJustPressed.clear();
    
}
 
void drawKey(int x, int y, boolean isDown)
{
    fill(isDown ? 255 : 128); 
    rect(x+2, y+2, kKeySize-2, kKeySize-2);
}