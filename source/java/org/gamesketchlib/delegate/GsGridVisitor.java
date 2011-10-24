package org.gamesketchlib.delegate;

import org.gamesketchlib.GsBasic;

public interface GsGridVisitor
{
    public void visitCell(int gx, int gy, GsBasic gab);
}
