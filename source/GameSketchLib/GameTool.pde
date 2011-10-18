/**
 * GameTools allow the GameMouse to interact with the
 * game in different ways.
 *
 * They work very much like tools in any drawing or paint
 * program, but may also come in handy for things like:
 *
 *   - weapons with mouse based aiming
 *   - level editors
 *   - games where you assign tasks to characters
 *   - etc.
 */
abstract class GameTool extends GameProto
{
    void click(float x, float y, GameBasic subject)
    {
    }

    void press(float x, float y, GameBasic subject)
    {
    }

    void dragStart(float x, float y, GameBasic subject)
    {
    }
    
    void drag(float x, float y, GameBasic subject)
    {
    }

    void dragEnd(float x, float y, GameBasic subject)
    {
    }
    
    
    /* Same as GameBasic.send
     *
     * A generic (untyped) message-passing protocol for
     * communicating between objects.
     *
     * Messages should be defined with Game.newMessageId();
     */
    Object send(int message, Object arg)
    {
        return null;
    }
}

/**
 * The BasicTool simply calls .click, .drag, or (TODO) .press
 * on anything in Game.mouse.subjects that the user interacts with.
 */
class BasicTool extends GameTool
{
    @Override
    void click(float x, float y, GameBasic subject)
    {
        subject.click();
    }

    @Override
    void drag(float x, float y, GameBasic subject)
    {
        subject.drag();
    }
}


