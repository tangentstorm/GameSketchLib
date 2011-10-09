// Game is a Singleton - i.e., the only instance of GameClass.
class GameClass
{
    GameState state;
    GameBounds bounds = new GameBounds(0,0,0,0);
    
    void init(GameState newState)
    {
        Game.bounds = new GameBounds(0, 0, width, height);
        switchState(newState);
    }
    
    void switchState(GameState newState)
    {
        Game.state = newState;
        newState.create();
    }
}

// !! Normally, I'd use a static class for this, but all
//    our code has to end up in one file for studio sketchpad,
//    and static classes have to be top level in processing.
GameClass Game = new GameClass();

