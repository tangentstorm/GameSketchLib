/**
 * A 2D container, handy for tile maps, puzzle games, etc.
 */
class GameGrid extends GameContainer
{
    public final int rows;
    public final int cols;
    public final int area;
    
    private final GameBasic[] mData;
    private float cellW;
    private float cellH;

    GameGrid(int cols, int rows)
    {
        this.cols = cols;
        this.rows = rows;
        this.area = cols * rows;
        mData = new GameBasic[this.area];
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
    GameBasic memberAtPoint(float x, float y)
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
    
    public ArrayList<GameBasic> each()
    {
        ArrayList<GameBasic> these = new ArrayList<GameBasic>();
        for (int i = 0; i < this.area; ++i)
        {
            these.add(mData[i]);
        }
        return these;
    }
    
    public GameGrid changed(GameChanger chg)
    {
        GameGrid res = new GameGrid(this.cols, this.rows);
        for (int i = 0; i < this.area; ++i)
        {
            res.mData[i] = chg.change(mData[i]);
        }
        return res;
    }
    
    protected ArrayList keys()
    {
        ArrayList res = new ArrayList();
        for (int i = 0; i < this.area; i++)
        {
            res.add(i);
        }
        return res;
    }
    
    protected void putItem(Object k, GameBasic gab)
    {
        mData[(Integer) k] = gab;
    }
    
    protected GameBasic getItem(Object k)
    {
        return mData[(Integer) k];
    }
    
    protected GameContainer emptyCopy()
    {
        return new GameGrid(this.cols, this.rows);
    }
    
     
     
    /**
     * This is the 2d analog of GameGroup.get(i).
     */  
    public GameBasic get(int gx, int gy)
    {
        return mData[this.toIndex(gx, gy)];
    }
    
    /**
     * This is the 2d analog of GameGroup.put(i).
     */
    public GameBasic put(int gx, int gy, GameBasic gab)
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
    
    
    public void visitCells(GameGridVisitor vis)
    {
        for (int gx = 0; gx < this.cols; ++gx)
        {
            for (int gy = 0; gy < this.rows; ++gy)
            {
                vis.visitCell(gx, gy, this.get(gx, gy));
            }
        }
    }
    
    public void populateCells(GameGridPopulator pop)
    {
        for (int gx = 0; gx < this.cols; ++gx)
        {
            for (int gy = 0; gy < this.rows; ++gy)
            {
                this.put(gx, gy, pop.populateCell(gx, gy));
            }
        }
    }
    
    
    public void layout()
    {
        this.visitCells(new GameGridVisitor()
        { 
             public void visitCell(int gx, int gy, GameBasic gab)
             {
                  // only GameObject and its children have coordinates
                  if (gab instanceof GameObject)
                  {
                      ((GameObject) gab).reset(x + cellW * gx, y + cellH * gy, cellW, cellH);
                  }
             }
        });
    }
    
    public void fitToScreen()
    {  
        this.x = 0;
        this.y = 0;
        this.setCellSize(width/this.cols, height/this.rows);
        this.layout();
    }
    
    
    private int toIndex(int gx, int gy)
    {
        return this.cols * gy + gx;
    }
}

