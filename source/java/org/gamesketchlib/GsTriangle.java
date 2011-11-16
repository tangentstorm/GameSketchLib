package org.gamesketchlib;

import static org.gamesketchlib._GameSketchLib.*;

/**
 * A simple triangle that draws itself on screen.
 * Will toggle fill colors based on this.alive.
 */

public class GsTriangle extends GsBasic {
	
	// Define the vertices of the triangle
	int x1, y1;
	int x2,	y2;
	int x3, y3;
	
	//The usual colors for the object
	public int liveColor = 0xffFFFFFF;
    public int deadColor = 0xffCCCCCC;
    public int lineColor = 0xff666666;
    public int lineWeight = 1;
	
	public GsTriangle(int x1, int y1, int x2, int y2, int x3, int y3){
				this.x1 = x1;
				this.x2 = x2;
				this.x3 = x3;
				this.y1 = y1;
				this.y2 = y2;
				this.y3 = y3;
	}
	
	@Override
    public void render()
    {
        strokeWeight(this.lineWeight);
        fill(this.alive ? this.liveColor : this.deadColor );
        triangle(x1, y1, x2, y2, x3, y3);
    }
	
	public boolean containsPoint(float x, float y)
    {
		double v0[]= new double[2];
		double v1[]= new double[2];
		double v2[]= new double[2];
		
		v0[0] = x3-x1;
		v0[1] =	y3-y1;
		
		v1[0] = x2-x1;
		v1[1] =	y2-y1;
		
		v2[0] = (int)x-x1;
		v2[1] =	(int)y-y1;
		
		double dot00 = dotProduct(v0, v0);
		double dot01 = dotProduct(v0, v1);
		double dot02 = dotProduct(v0, v2);
		double dot11 = dotProduct(v1, v1);
		double dot12 = dotProduct(v1, v2);
		
		// Compute barycentric coordinates
		double invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
		double u = (dot11 * dot02 - dot01 * dot12) * invDenom;
		double v = (dot00 * dot12 - dot01 * dot02) * invDenom;

		// Check if point is in triangle
		return (u >= 0) && (v >= 0) && (u + v < 1);
    }
	
	public double dotProduct(double v0[], double v1[]){
		return (v0[0]*v1[0])+(v0[1]*v1[1]);
	}
}
