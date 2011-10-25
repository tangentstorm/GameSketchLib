package org.gamesketchlib;

import org.gamesketchlib.delegate.*;

import java.util.Arrays;

import static org.gamesketchlib._GameSketchLib.*;

/**
 * A 2D container, handy for tile maps, puzzle games, etc.
 */
public class GsGrid extends GsContainer
{
    public final int rows;
    public final int cols;
    public final int area;
    
    private final GsBasic[] mData;
    private float cellW;
    private float cellH;

    public GsGrid(int cols, int rows)
    {
        this.cols = cols;
        this.rows = rows;
        this.area = cols * rows;
        mData = new GsBasic[this.area];
        this.clear(); // fill with GameNull
        setCellSize(32, 32);
    }
    
    public void setCellSize(float cellW, float cellH)
    {
        this.cellW = cellW;
        this.cellH = cellH;
        this.w = cellW * this.cols;
        this.h = cellH * this.rows;
    }
    
    /**
     * Warning: this assumes that the objects are actually
     * in the grid cells. That is only true if you called layout()
     * and haven't moved them since.
     */
    public GsBasic memberAtPoint(float x, float y)
    {
        int gx = (int) ((x - this.x) / this.cellW);
        int gy = (int) ((y - this.y) / this.cellH);
        
        if (gx >= this.cols || gy >= this.rows)
        {
            return GameNull;
        }
        else
        {
            return this.get(gx, gy);
        }
    }

    
    // !! We have to override the abstract methods,
    //    each() and changed() or it won't compile.
    
    public GsList<GsBasic> each()
    {
        GsList<GsBasic> these = new GsList<GsBasic>();
        these.addAll(Arrays.asList(mData).subList(0, this.area));
        return these;
    }
    
    public GsGrid changed(GsChanger chg)
    {
        GsGrid res = new GsGrid(this.cols, this.rows);
        for (int i = 0; i < this.area; ++i)
        {
            res.mData[i] = chg.change(mData[i]);
        }
        return res;
    }
    
    protected Iterable<Object> keys()
    {
        GsList<Object> res = new GsList<Object>();
        for (int i = 0; i < this.area; i++)
        {
            res.add(i);
        }
        return res;
    }
    
    protected void putItem(Object k, GsBasic gab)
    {
        mData[(Integer) k] = gab;
    }
    
    protected GsBasic getItem(Object k)
    {
        return mData[(Integer) k];
    }
    
    protected GsContainer emptyCopy()
    {
        return new GsGrid(this.cols, this.rows);
    }
    
     
     
    /**
     * This is the 2d analog of GsGroup.get(i).
     */  
    public GsBasic get(int gx, int gy)
    {
        return mData[this.toIndex(gx, gy)];
    }
    
    /**
     * This is the 2d analog of GsGroup.put(i).
     */
    public GsBasic put(int gx, int gy, GsBasic gab)
    {
        gab.gx = gx;
        gab.gy = gy;
        mData[this.toIndex(gx, gy)] = gab;
        return gab;
    }


    // Fill the grid with NullObjects    
    public void clear()
    {
        for (int i = 0; i < mData.length; ++i)
        {
            mData[i] = GameNull;
        }
    }
    
    
    public void visitCells(GsVisitorG vis)
    {
        for (int gx = 0; gx < this.cols; ++gx)
        {
            for (int gy = 0; gy < this.rows; ++gy)
            {
                vis.visit(gx, gy, this.get(gx, gy));
            }
        }
    }
    
    public void populateCells(GsPopulatorG pop)
    {
        for (int gx = 0; gx < this.cols; ++gx)
        {
            for (int gy = 0; gy < this.rows; ++gy)
            {
                this.put(gx, gy, pop.populate(gx, gy));
            }
        }
    }
    
    
    public void layout()
    {
        this.visitCells(new GsVisitorG()
        { 
             public void visit(int gx, int gy, GsBasic gab)
             {
                  // only GsObject and its children have coordinates
                  if (gab instanceof GsObject)
                  {
                      ((GsObject) gab).reset(x + cellW * gx, y + cellH * gy, cellW, cellH);
                  }
             }
        });
    }
    
    public void fitToScreen()
    {  
        this.x = 0;
        this.y = 0;
        this.setCellSize(Game.bounds.w/this.cols, Game.bounds.h/this.rows);
        this.layout();
    }
    
    
    private int toIndex(int gx, int gy)
    {
        return this.cols * gy + gx;
    }
}

