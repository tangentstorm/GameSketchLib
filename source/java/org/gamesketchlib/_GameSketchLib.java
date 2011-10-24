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
    void mousePressed()  { Game.mouse.pressed(mouseX, mouseY);  }
    void mouseReleased() { Game.mouse.released(mouseX, mouseY); }
    void mouseMoved()    { Game.mouse.moved(mouseX, mouseY);    }
    void mouseDragged()  { Game.mouse.dragged(mouseX, mouseY);  }
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
    public static class GsDict extends HashMap{ }
    // TODO : public static class GsFont  {}
    // TODO : public static class GsImage {}




// [suppress]
    
    // processing API. marked as "native" here so we can compile without Processing
    public static final int ARGB = 0;
    public static final double PI = 3.14159265;
    native static void size(float w, float h);
    native static void print(String s);
    native static void println(String s);
    native static float millis();
    native static float random(float x);
    native static void background(int color);
    native static void stroke(int textColor);
    native static void link(String url, String aNew);
    native static void line(float v, float lineY, float v1, float lineY1);
    native static void noFill();
    native static void rect(float x, float y, float w, float h);
    native static void strokeWeight(int lineWeight);
    native static void popMatrix();
    native static void translate(float v, float v1);
    native static void pushMatrix();
    native static void rotate(double v);
    native static void textAlign(int align);
    native static void fill(int color);
    native static float textDescent();
    native static float textAscent();
    native static float textWidth(String label);
    native static void text(String label, float x, float y);


    // !! TODO for anything that uses PFont or PImage, force ourselves to
    //    use "Game.xxxx" instead, so all our processing dependencies
    //    are in one place.
    native static void image(PImage img, float x, float y);
    native static void textFont(PFont font, int fontSize);
    native static PImage loadImage(String path);
    native static PImage createImage(int w, int hH, int mode);
    native static PFont  loadFont(String path);

    // can't mark primitives as native, but the processing builder will strip them out anyway
    static float width;
    static float height;
    static char CODED;
    static char key;
    static int keyCode;
    static int UP;
    static int DOWN;
    static int LEFT;
    static int RIGHT;
    static int BASELINE;
    static int CENTER;
    static float mouseY;
    static float mouseX;
}
// [/suppress]
