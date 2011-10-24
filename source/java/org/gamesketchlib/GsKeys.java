package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

public class GsKeys
{
    GsDict mPressedKeys = new GsDict();
    GsDict mJustPressed = new GsDict();
    
    void update()
    {
        // Important: clear out the justPressed after every frame
        // (else it won't unset until they key repeats)
        mJustPressed.clear();
    }

    // keyCode is an int, but key is a char, so we need a version for each:
    boolean isKeyDown(char code) { return mPressedKeys.get(code) != null; }
    boolean isKeyDown(int  code) { return mPressedKeys.get(code) != null; }
    boolean justPressed(char code) { return mJustPressed.get(code) != null; }
    boolean justPressed(int  code) { return mJustPressed.get(code) != null; }

    void setKeyDown(Object value, boolean isCoded, char key, int keyCode)
    { 
        if (isCoded)
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
    
    boolean goN() { return isKeyDown(UP)    || isAnyDown(WASD_N); }
    boolean goW() { return isKeyDown(LEFT)  || isAnyDown(WASD_W); }
    boolean goS() { return isKeyDown(DOWN)  || isAnyDown(WASD_S); }
    boolean goE() { return isKeyDown(RIGHT) || isAnyDown(WASD_E); }
}



