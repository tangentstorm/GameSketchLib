package org.gamesketchlib.delegate;

import org.gamesketchlib.GsBasic;

public interface GsGridChanger
{
    public GsBasic changeCell(int gx, int gy, GsBasic old);
}
