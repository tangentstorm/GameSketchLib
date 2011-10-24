package org.gamesketchlib.delegate;

import org.gamesketchlib.GsBasic;

public interface GsGridExtractor
{
    public GsBasic extractCell(int gx, int gy, GsBasic old);
}
