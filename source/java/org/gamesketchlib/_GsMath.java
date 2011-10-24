package org.gamesketchlib;

public class _GsMath
{
    public static float clamp(float value, float minValue, float maxValue)
    {
        if (value > maxValue) return maxValue;
        if (value < minValue) return minValue;
        return value;
    }
}
