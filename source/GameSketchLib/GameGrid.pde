/**
 * A 2D container, handy for tile maps, puzzle games, etc.
 */
class GameGrid extends GameContainer
{
    public final int rows;
    public final int cols;
    public final int area;
    
    private final GameBasic[] mData;
    
    GameGrid(int cols, int rows)
    {
        this.cols = cols;
        this.rows = rows;
        this.area = cols * rows;
        mData = new GameBasic[this.area];
        this.clear();
    }
    
    
    // !! We have to override the abstract methods,
    //    each() and changed() or it won't compile.
    
    @Override
    public ArrayList<GameBasic> each()
    {
        ArrayList<GameBasic> these = new ArrayList<GameBasic>();
        for (int i = 0; i < this.area; ++i)
        {
            these.add(mData[i]);
        }
        return these;
    }
    
    @Override
    public GameGrid changed(GameChanger chg)
    {
        GameGrid res = new GameGrid(this.cols, this.rows);
        for (int i = 0; i < this.area; ++i)
        {
            res.mData[i] = chg.change(mData[i]);
        }
        return res;
    }
    
    @Override
    protected ArrayList keys()
    {
        ArrayList res = new ArrayList();
        for (int i = 0; i < this.area; i++)
        {
            res.add(i);
        }
        return res;
    }
    
    @Override
    protected void putItem(Object k, GameBasic gab)
    {
        mData[(Integer) k] = gab;
    }
    
    @Override
    protected GameBasic getItem(Object k)
    {
        return mData[(Integer) k];
    }
    
    @Override
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
    
    
    public void layout(final float x, final float y, final float cellW, final float cellH)
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
        this.layout(0, 0, width/this.cols, height/this.rows);
    }
    
    
    private int toIndex(int x, int y)
    {
        return this.cols * y + x;
    }
}

