package org.gamesketchlib;

import processing.core.PImage;

import static org.gamesketchlib._GameSketchLib.*;

public class GsSpriteSheet
{
    String assetPath; // empty means the "data" directory
    PImage sheet;
    GsList frames = new GsList();

    GsSpriteSheet(String imageName, int cellW, int cellH, String jsPath)
    {
        this.assetPath = CONFIG_PJS ? jsPath : "";
        this.sheet = loadImage(this.assetPath + "/" + imageName);
        
        for (int y = 0; y < this.sheet.height; y += cellH)
        {
            for (int x = 0; x < this.sheet.width; x += cellW)
            {
                PImage cell = createImage(cellW, cellH, ARGB);
                cell.copy(sheet, x, y, cellW, cellH, 0, 0, cellW, cellH);
                this.frames.add(cell);
            }
        }
    }

    PImage getFrame(int i)
    {
        return (PImage) this.frames.get(i);
    }
    
    PImage[] getFrames(int[] wantedFrames)
    {
      
        PImage[] res = new PImage[wantedFrames.length];
        for (int i = 0; i < wantedFrames.length; ++i)
        {
            res[i] = this.getFrame(wantedFrames[i]);
        }
        return res;
    }
    
    // for debugging:
    void renderAll(int x, int y, int perRow)
    {
        int gx, gy;
        for (int i = 0; i < this.frames.size(); ++i)
        {
            PImage img = this.getFrame(i);
            gy = (int) i / perRow;
            gx = i % perRow;
            image(img, x + gx * img.width, y + gy * img.height);
            stroke(255);
            noFill();
            rect(x + gx * img.width, y + gy * img.height, img.width, img.width);
        }
    }

}
