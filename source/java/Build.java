import processing.core.PApplet;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.lang.reflect.Array;
import java.util.Arrays;

/*
* GameSketchLib file packager.
*
* The source code for games is under BaseGameSketch.
* Open that in processing and "Save As" something else.
*
* This script combines the various files into a single
* script for studio.sketchpad.cc, which doesn't offer
* multiple tabs yet.
*
* You can also clone the latest version via sketchpad:
*
* http://studio.sketchpad.cc/sp/pad/view/ro.9QgCGSB51i-nJ/latest
*
*/
public class Build
{
    // I wanted a real IDE, but I still prefer processing's API :)
    static PApplet pApplet = new PApplet();

    private static void printClass(File file, PrintWriter out) throws FileNotFoundException
    {
        boolean suppressed = false;

        if (! file.getName().endsWith(".java"))
        {
            System.out.println("WARNING: non-java file bundled with GameSketchLib!:");
            System.out.println(file.getAbsolutePath());
        }

        out.println();
        out.println("// [ " + file.getName() + " ]:");
        out.println();

        // dump file contents:
        String lines[] = pApplet.loadStrings(file.getAbsolutePath());
        if (lines == null || lines.length == 0)
        {
            throw new RuntimeException(file.getAbsolutePath() + " was empty!");
        }

        for (int j = 0; j < lines.length; ++j)
        {
            String line = lines[j];

            // general purpose code suppressor:
            if (line.contains("// [suppress]")) suppressed = true;
            if (line.contains("// [/suppress]"))
            {
                suppressed = false;
                continue;
            }

            // special cases: no packages or imports!!
            if (line.startsWith("package")) continue;
            if (line.startsWith("import")) continue;

            // no @Override because processing-js chokes
            if (line.contains("@Override")) continue;

            // don't use static stuff in processing
            if (line.contains(" static "))
            {
                if (! file.getName().startsWith("_"))
                {
                    System.out.println("warning: odd static import in " + file.getName() + ":");
                    System.out.println(line);
                }
                line = line.replace(" static ", " ");
            }

            if (line.contains("_GameSketchLib."))
            {
                System.out.println("EVIL STATIC IMPORT at " + file.getAbsolutePath());
                System.out.println(line);
            }

            if (! suppressed)
            {
                out.println(line);
            }
        }
    }

    

    private static void printHeader(PrintWriter out) throws FileNotFoundException
    {
        out.println("/* -----------------------------------------------------------------");
        // YYYY-MM-DD
        out.println(" * GameSketchLib                                 compiled " +
                String.valueOf(pApplet.year())
                + "-" +
                (pApplet.month() < 10 ? "0" : "") + String.valueOf(pApplet.month())
                + "-" +
                (pApplet.day()   < 10 ? "0" : "") + String.valueOf(pApplet.day())
        );
        out.println(" * -----------------------------------------------------------------");
        out.println(" * ");
        out.println(" * GameSketchLib is an open-source game library for Processing.");
        out.println(" * ");
        out.println(" * It was created by Michal J Wallace and loosely modeled after");
        out.println(" * the flixel game library for actionscript.");
        out.println(" * ");
        out.println(" *       website: http://GameSketchLib.org/");
        out.println(" *          code: https://github.com/sabren/GameSketchLib");
        out.println(" *       twitter: @tangentstorm");
        out.println(" * ");
        out.println(" * If you want to modify the library, consider forking the git");
        out.println(" * repository at github, rather than editing this combined file.");
        out.println(" * ");
        out.println(" * -----------------------------------------------------------------");

        // !! license contains stuff about the course. skip that part.
        String[] license = pApplet.loadStrings("../../LICENSE.txt");
        int licenseHrCount = 0;
        for (int licenseLine = 0; licenseLine < license.length; ++licenseLine)
        {
            if (licenseHrCount >= 2)
            {
                out.println(" * " + license[licenseLine]);
            }
            if (license[licenseLine].startsWith("-")) licenseHrCount++;
        }

        out.println(" */// [Begin GameSketchLib] ---------------------------------------");
        out.println();
    }

    private static void printFooter(PrintWriter out)
    {
        out.println();
        out.println("/* -- [End GameSketchLib] --------------------------------------*/");
        out.println();
    }

    public static void walkAndPrint(File dir, PrintWriter out) throws FileNotFoundException
    {
        if (dir.isDirectory())
        {
            String childNames[] = dir.list();
            File[] children = new File[childNames.length];
            Arrays.sort(childNames);

            for (int i = 0; i < childNames.length; ++i)
            {
                children[i] = new File(dir, childNames[i]);
            }

            // do all the files in alphabetical order:
            for (File child : children)
            {
                if (child.isFile()) walkAndPrint(child, out);
            }

            // then do the sub-packages:
            for (File child : children)
            {
                if (child.isDirectory()) walkAndPrint(child, out);
            }
        }
        else
        {
            printClass(dir, out);
        }
    }


    public static void main(String[] args) throws FileNotFoundException
    {

        PrintWriter out = new PrintWriter("../BaseGameSketch/GameSketchLib.pde");

        printHeader(out);
        walkAndPrint(new File("org"), out);
        printFooter(out);

        out.flush();
        out.close();
    }

}