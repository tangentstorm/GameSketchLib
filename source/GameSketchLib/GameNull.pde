/**
 * This is a special single-instance class that gives
 * us a null-like value that represents the lack of a
 * normal GameBasic instance.
 *
 * If we used the regular null value, we'd have to 
 * check for (gab != null) everywhere, but with
 * GameNull, we can treat it like any other GameBasic
 * and it just transparently does the right thing.
 *
 * If you do need to test for it, the boolean .isNull
 * is defined on all GameBasic classes. It's false for
 * everything but this class.
 * 
 * http://en.wikipedia.org/wiki/Null_Object_pattern
 */
final class _GameNull extends GameBasic
{
    // Nullable
    public final boolean isNull = true;
  
    // Playable
    // all booleans are false, so no render/update
    public final boolean alive = false;
    public final boolean exists = false;
    public final boolean visible = false;
    public final boolean active = false;

    // GridMember
    public final int gx = 0;
    public final int gy = 0;
    
    // Spatial
    // Not A Number coordinates, all overlapping returns false
    public final float x = Float.NaN;
    public final float y = Float.NaN;
    public final float w = Float.NaN;
    public final float h = Float.NaN;
    
    boolean containsPoint(float px, float py)
    {
        return false;
    }
    
    boolean overlaps(GameBasic other)
    {
        return false;
    }
    
    boolean contains(GameBasic other)
    {
        return false;
    }
    
    
    // Iterable
    // yields an empty list
    private final  ArrayList<GameBasic> mEmptyList = new ArrayList<GameBasic>(0);
    ArrayList<GameBasic> each()
    {
        return mEmptyList;
    }

    // Constructor
    private int mInstanceCount = 0;
    _GameNull()
    {
        if (++mInstanceCount > 1)
        {
            throw new RuntimeException("GameNull is a singleton. There can be only one.");
        }
    }
}
final _GameNull GameNull = new _GameNull();

