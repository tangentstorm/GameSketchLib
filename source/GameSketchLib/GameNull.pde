class _GameNull extends GameBasic
{
    public final boolean alive = false;
    public final boolean exists = false;
    public final boolean visible = false;
    public final boolean active = false;
    _GameNull()
    {
    }
    
    private final  ArrayList<GameBasic> mEmptyList = new ArrayList<GameBasic>(0);
    
    @Override
    ArrayList<GameBasic> each()
    {
        return mEmptyList;
    }
}
_GameNull GameNull = new _GameNull();

