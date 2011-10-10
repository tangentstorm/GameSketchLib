
// again, virtual "static" class for studio.sketchpad
GameMathClass GameMath = new GameMathClass();
class GameMathClass
{
    float clamp(float value, float minValue, float maxValue)
    {
        if (value > maxValue) return maxValue;
        if (value < minValue) return minValue;
        return value;
    }
}
