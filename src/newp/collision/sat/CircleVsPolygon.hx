package newp.collision.sat;

import newp.collision.response.ShapeCollision;
import newp.collision.shapes.*;
import newp.math.Utils as MathUtils;
import openfl.geom.Point;


class CircleVsPolygon {

  public static function test( circle:Circle, polygon:Polygon, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

    into = into == null ? new ShapeCollision() : into.clear();

    var verts = polygon.transformedVerts;

    var circleX = circle.x;
    var circleY = circle.y;

    var testDistance :Float = 0x3FFFFFFF;
    var distance = 0.0, closestX = 0.0, closestY = 0.0;
    
    for(i in 0 ... verts.length) {

      distance = MathUtils.vec_lengthsq(circleX - verts[i].x, circleY - verts[i].y);

      if(distance < testDistance) {
        testDistance = distance;
        closestX = verts[i].x;
        closestY = verts[i].y;
      }
    }

    var normalAxisX = closestX - circleX;
    var normalAxisY = closestY - circleY;
    var normAxisLen = MathUtils.vec_length(normalAxisX, normalAxisY);
      normalAxisX = MathUtils.vec_normalize(normAxisLen, normalAxisX);
      normalAxisY = MathUtils.vec_normalize(normAxisLen, normalAxisY);

    var test = 0.0;
    var min1 = MathUtils.vec_dot(normalAxisX, normalAxisY, verts[0].x, verts[0].y);
    var max1 = min1;

    for(j in 1 ... verts.length) {
      test = MathUtils.vec_dot(normalAxisX, normalAxisY, verts[j].x, verts[j].y);
      if(test < min1) min1 = test;
      if(test > max1) max1 = test;
    }

    var max2 = circle.transformedRadius;
    var min2 = -circle.transformedRadius;
    var offset = MathUtils.vec_dot(normalAxisX, normalAxisY, -circleX, -circleY);
      
    min1 += offset;
    max1 += offset;

    var test1 = min1 - max2;
    var test2 = min2 - max1;

    if(test1 > 0 || test2 > 0) return null;

    var distMin = -(max2 - min1);
    if(flip) distMin *= -1;

    into.overlap = distMin;
    into.unitVectorX = normalAxisX;
    into.unitVectorY = normalAxisY;
    var closest = Math.abs(distMin);

    for(i in 0 ... verts.length) {

      normalAxisX = findNormalAxisX(verts, i);
      normalAxisY = findNormalAxisY(verts, i);
      var aLen = MathUtils.vec_length(normalAxisX, normalAxisY);
      normalAxisX = MathUtils.vec_normalize(aLen, normalAxisX);
      normalAxisY = MathUtils.vec_normalize(aLen, normalAxisY);

      min1 = MathUtils.vec_dot(normalAxisX, normalAxisY, verts[0].x, verts[0].y);
      max1 = min1; //set max and min

      for(j in 1 ... verts.length) {
        test = MathUtils.vec_dot(normalAxisX, normalAxisY, verts[j].x, verts[j].y);
        if(test < min1) min1 = test;
        if(test > max1) max1 = test;
      }

      max2 = circle.transformedRadius; //max is radius
      min2 = -circle.transformedRadius; //min is negative radius

      offset = MathUtils.vec_dot(normalAxisX, normalAxisY, -circleX, -circleY);
      min1 += offset;
      max1 += offset;

      test1 = min1 - max2;
      test2 = min2 - max1;

      if(test1 > 0 || test2 > 0) { return null; }

      distMin = -(max2 - min1);

      if(flip) distMin *= -1;

      if(Math.abs(distMin) < closest) {

        into.unitVectorX = normalAxisX;
        into.unitVectorY = normalAxisY;
        into.overlap = distMin;
        closest = Math.abs(distMin);

      }
    }

    into.shape1 = flip ? polygon : circle;
    into.shape2 = flip ? circle : polygon;
    into.separationX = into.unitVectorX * into.overlap;
    into.separationY = into.unitVectorY * into.overlap;

    if (!flip) {
      into.unitVectorX = -into.unitVectorX;
      into.unitVectorY = -into.unitVectorY;
    }

    return into;
  } 

  // +-------------------------
  // | Helpers
  // +-------------------------

  static inline function findNormalAxisX(verts:Array<Point>, index:Int) :Float {
    var v2 = (index >= verts.length - 1) ? verts[0] : verts[index + 1];
    return -(v2.y - verts[index].y);
  }

  static inline function findNormalAxisY(verts:Array<Point>, index:Int) :Float {
    var v2 = (index >= verts.length - 1) ? verts[0] : verts[index + 1];
    return (v2.x - verts[index].x);
  }

}
