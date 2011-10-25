// [suppress]
/*
 * GameSketchLib
 * http://github.com/sabren/GameSketchLib
 *
 * A small game engine for processing and processing-js,
 * inspired by flixel.
 *
 * ------------------------------------------------------
 *
 * DON'T USE GameSketchLib DIRECTLY! Use  ../Build.java
 * to generate ../BaseGameSketch/BaseGameSketch.pde and
 * then do a "File -> Save as..." on that.
 *
 * -------------------------------------------------------
 */
package org.gamesketchlib;

import processing.core.PFont;
import processing.core.PImage;

import java.util.ArrayList;
import java.util.HashMap;

public class _GameSketchLib
{
// [/suppress]

    // this is what we provide:
    public static final _GsGame Game = new _GsGame();
    public static final _GsNull GameNull = new _GsNull();

    public static void draw()
    {
        Game.update(millis());
        Game.render();
    }

    // global event handlers:
    void mouseMoved()    { Game.mouse.moved(mouseX, mouseY);    }
    void mousePressed()  { Game.mouse.pressed(mouseX, mouseY, mouseButton);  }
    void mouseReleased() { Game.mouse.released(mouseX, mouseY, mouseButton); }
    void mouseDragged()  { Game.mouse.dragged(mouseX, mouseY, mouseButton);  }
    void keyPressed()    { Game.keys.setKeyDown(true, key==CODED, key, keyCode); }
    void keyReleased()   { Game.keys.setKeyDown(null, key == CODED, key, keyCode); }


    // global debug flag.
    // so far, this just shows Bounds for sprites
    public static boolean DEBUG = false;

    // a predefined GsSpriteSheet, since everyone wants a GsSpriteSheet!
    public static GsSpriteSheet SHEET;

    // Timer Constants
    public static float SECONDS = 1000;

    // Keyboard Constants:
    public static char SPACE = ' ';
    public static char[] WASD_N  = new char[] { 'W', ',', '<' };
    public static char[] WASD_W  = new char[] { 'A', 'a' };
    public static char[] WASD_S  = new char[] { 'S', 's', 'O', 'o' };
    public static char[] WASD_E  = new char[] { 'D', 'd', 'E', 'e' };


    // This figures out which runtime we're using dynamically,
    // so we can do conditional compilation.
    public static final String RUNTIME_ANDROID = "ANDROID";

    public static final String RUNTIME_JVM = "JVM";
    public static final String RUNTIME_PJS = "PJS";
    public static final boolean CONFIG_PJS
        = (new Object()).toString() == "[object Object]";

    public static final boolean CONFIG_ANDROID = !CONFIG_PJS && Game._isAndroid();
    public static final boolean CONFIG_JVM = ! (CONFIG_PJS || CONFIG_ANDROID);
    public static final boolean CONFIG_ANY_JAVA = CONFIG_ANDROID || CONFIG_JVM;
    public static final String RUNTIME = CONFIG_PJS ? RUNTIME_PJS
        : CONFIG_ANDROID ? RUNTIME_ANDROID
        : RUNTIME_JVM;


    public static class GsList<T> extends ArrayList<T>
    {
        GsList() { super(); }
        GsList(int i) { super(i); }
    }
    public static class GsDict<K,V> extends HashMap<K,V>
    {
    }

    // TODO : public static class GsFont  {}
    // TODO : public static class GsImage {}


    public static final int TOOL_ARROW_TO_NOTHING = Game.newMessageCode();
    public static final int TOOL_ARROW_TO_SUBJECT = Game.newMessageCode();



// [suppress]
    
    // processing API. marked as "native" here so we can compile without Processing

    public native static void size(float w, float h);
    public native static void print(String s);
    public native static void println(String s);
    public native static float millis();
    public native static void smooth();
    public native static float random(float x);
    public native static void background(int color);
    public native static void stroke(int textColor);
    public native static void link(String url, String aNew);
    public native static void line(float x1, float y1, float x2, float y2);
    public native static void noFill();
    public native static void rect(float x, float y, float w, float h);
    public native static void strokeWeight(int lineWeight);
    public native static void popMatrix();
    public native static void translate(float v, float v1);
    public native static void pushMatrix();
    public native static void rotate(double v);
    public native static void textAlign(int align);
    public native static void fill(int color);
    public native static float textDescent();
    public native static float textAscent();
    public native static float textWidth(String label);
    public native static void text(String label, float x, float y);
    public native static void arc(float x, float y, float diamx, float diamy, float radStart, float radEnd);

    // !! TODO for anything that uses PFont or PImage, force ourselves to
    //    use "Game.xxxx" instead, so all our processing dependencies
    //    are in one place.
    public native static void image(PImage img, float x, float y);
    public native static void textFont(PFont font, int fontSize);
    public native static PImage loadImage(String path);
    public native static PImage createImage(int w, int hH, int mode);
    public native static PFont  loadFont(String path);

    // can't mark primitives as native, but the processing builder will strip them out anyway
    static char key;
    static int keyCode;
    static float width;
    static float height;
    static float mouseY;
    static float mouseX;
    static int mouseButton;
    static final char CODED = 0;
    static final int UP = 1;
    static final int DOWN = 2;
    static final int LEFT = 3;
    static final int RIGHT = 5;
    static final int BASELINE = 6;
    static final int CENTER = 7;
    public static final int ARGB = 0;
    public static final float PI = 3.14159265f;

}
// [/suppress]
