package newp.collision.sat;

import newp.collision.response.ShapeCollision;
import newp.collision.shapes.*;
import newp.math.Utils as MathUtils;
import openfl.geom.Point;


class PolygonVsPolygon {

  static var tmp1:ShapeCollision = new ShapeCollision();
  static var tmp2:ShapeCollision = new ShapeCollision();

  public static function test( polygon1:Polygon, polygon2:Polygon, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

    into = (into == null) ? new ShapeCollision() : into.clear();
    
    if(checkPolygons(polygon1, polygon2, tmp1, flip) == null) { return null; }

    if(checkPolygons(polygon2, polygon1, tmp2, !flip) == null) { return null; }

    var result = null, other = null;
    if(Math.abs(tmp1.overlap) < Math.abs(tmp2.overlap)) {
      result = tmp1;
      other = tmp2;
    } else {
      result = tmp2;
      other = tmp1;
    }

    result.otherOverlap = other.overlap;
    result.otherSeparationX = other.separationX;
    result.otherSeparationY = other.separationY;
    result.otherUnitVectorX = other.unitVectorX;
    result.otherUnitVectorY = other.unitVectorY;

    into.copy(result);
    result = other = null;

    return into;
  }

  // +-------------------------
  // | Helpers
  // +-------------------------

  static function checkPolygons( polygon1:Polygon, polygon2:Polygon, into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

    into.clear();

    var offset = 0.0, test1 = 0.0, test2 = 0.0, testNum = 0.0;
    var min1 = 0.0, max1 = 0.0, min2 = 0.0, max2 = 0.0;
    var closest :Float = 0x3FFFFFFF;

    var axisX = 0.0;
    var axisY = 0.0;
    var verts1 = polygon1.transformedVerts;
    var verts2 = polygon2.transformedVerts;

    for(i in 0 ... verts1.length) {

      axisX = findNormalAxisX(verts1, i);
      axisY = findNormalAxisY(verts1, i);
      var aLen = MathUtils.vec_length(axisX, axisY);
      axisX = MathUtils.vec_normalize(aLen, axisX);
      axisY = MathUtils.vec_normalize(aLen, axisY);

      min1 = MathUtils.vec_dot(axisX, axisY, verts1[0].x, verts1[0].y);
      max1 = min1;

      for(j in 1 ... verts1.length) {
        testNum = MathUtils.vec_dot(axisX, axisY, verts1[j].x, verts1[j].y);
        if(testNum < min1) min1 = testNum;
        if(testNum > max1) max1 = testNum;
      }

      min2 = MathUtils.vec_dot(axisX, axisY, verts2[0].x, verts2[0].y);
      max2 = min2;

      for(j in 1 ... verts2.length) {
        testNum = MathUtils.vec_dot(axisX, axisY, verts2[j].x, verts2[j].y);
        if(testNum < min2) min2 = testNum;
        if(testNum > max2) max2 = testNum;
      }

      test1 = min1 - max2;
      test2 = min2 - max1;

      if(test1 > 0 || test2 > 0) return null;

      var distMin = -(max2 - min1);

      if (flip) distMin *= -1;

      if (Math.abs(distMin) < closest) {
        into.unitVectorX = axisX;
        into.unitVectorY = axisY;
        into.overlap = distMin;
        closest = Math.abs(distMin);
      }
    }

    into.shape1 = flip ? polygon2 : polygon1;
    into.shape2 = flip ? polygon1 : polygon2;
    into.separationX = -into.unitVectorX * into.overlap;
    into.separationY = -into.unitVectorY * into.overlap;

    if (flip) {
      into.unitVectorX = -into.unitVectorX;
      into.unitVectorY = -into.unitVectorY;
    }

    return into;

  }

  static inline function findNormalAxisX(verts:Array<Point>, index:Int) :Float {
    var v2 = (index >= verts.length - 1) ? verts[0] : verts[index + 1];
    return -(v2.y - verts[index].y);
  }

  static inline function findNormalAxisY(verts:Array<Point>, index:Int) :Float {
    var v2 = (index >= verts.length - 1) ? verts[0] : verts[index + 1];
    return (v2.x - verts[index].x);
  }

}
