package newp.collision;

import newp.collision.ShapeCollision;
import newp.collision.shapes.*;
import newp.utils.MathUtils;
import openfl.geom.Point;


class SAT {

  static var tmp1:ShapeCollision = new ShapeCollision();
  static var tmp2:ShapeCollision = new ShapeCollision();

  // +-------------------------
  // | Bounds
  // +-------------------------

  public static function testBoundsVsBounds( boundsA:Bounds, boundsB:Bounds, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

    var bounds1 = flip ? boundsB : boundsA;
    var bounds2 = flip ? boundsA : boundsB;

    var dx = bounds2.centerX - bounds1.centerX;
    var px = (bounds1.halfWidth + bounds2.halfWidth) - Math.abs(dx);

    if (px > 0) {

      var dy = bounds2.centerY - bounds1.centerY;
      var py = (bounds1.halfHeight + bounds2.halfHeight) - Math.abs(dy);

      if (py > 0) {

        into = (into == null) ? new ShapeCollision() : into.clear();

        if (px < py) {
          into.unitVectorX = MathUtils.sign(dx);
          into.separationX = px * into.unitVectorX;
          into.overlap = into.separationX;
        } else {
          into.unitVectorY = MathUtils.sign(dy);
          into.separationY = py * into.unitVectorY;
          into.overlap = into.separationY;
        }

        return into;
      }
    }

    return null;
  }

  public static function testCircleVsBounds( circle:Circle, bounds:Bounds, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {
    
    var dx = bounds.centerX - circle.x;
    var px = (bounds.halfWidth + circle.radius) - Math.abs(dx);

    if (px > 0) {

      var dy = bounds.centerY - circle.y;
      var py = (bounds.halfHeight + circle.radius) - Math.abs(dy);

      if (py > 0) {

        into = (into == null) ? new ShapeCollision() : into.clear();

        if (px < py) {
          into.unitVectorX = MathUtils.sign(dx);
          into.separationX = px * into.unitVectorX;
          into.overlap = into.separationX;
        } else {
          into.unitVectorY = MathUtils.sign(dy);
          into.separationY = py * into.unitVectorY;
          into.overlap = into.separationY;
        }

        return into;
      } 
    }

    return null; 
  }

  public static function testPolygonVsBounds( poly:Polygon, bounds:Bounds, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

    // TODO:
    // NOTE: I can't do the simple thing because we made displayObject a required field on Shape X(

    return null;
  }

  // +-------------------------
  // | Shapes
  // +-------------------------

  public static function testCircleVsCircle( circleA:Circle, circleB:Circle, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

    var circle1 = flip ? circleB : circleA;
    var circle2 = flip ? circleA : circleB;

    var distsq = vec_lengthsq(circle1.x - circle2.x, circle1.y - circle2.y);
    var size = circle1.transformedRadius + circle2.transformedRadius;

    if(distsq < size * size) {

      into = (into == null) ? new ShapeCollision() : into.clear();

      into.shape1 = circle1;
      into.shape2 = circle2;
        
      var delta = size - Math.sqrt(distsq);
      var unitVecX = circle1.x - circle2.x;
      var unitVecY = circle1.y - circle2.y;
      var unitVecLen = vec_length(unitVecX, unitVecY);

      unitVecX = vec_normalize(unitVecLen, unitVecX);
      unitVecY = vec_normalize(unitVecLen, unitVecY);

      into.unitVectorX = unitVecX;
      into.unitVectorY = unitVecY;

      into.separationX = into.unitVectorX * delta;
      into.separationY = into.unitVectorY * delta;

      into.overlap = delta;

      return into;
    }

    return null;
  }

  public static function testPolygonVsPolygon( polygon1:Polygon, polygon2:Polygon, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

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

  public static function testCircleVsPolygon( circle:Circle, polygon:Polygon, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

    into = into == null ? new ShapeCollision() : into.clear();

    var verts = polygon.transformedVerts;

    var circleX = circle.x;
    var circleY = circle.y;

    var testDistance :Float = 0x3FFFFFFF;
    var distance = 0.0, closestX = 0.0, closestY = 0.0;
    
    for(i in 0 ... verts.length) {

      distance = vec_lengthsq(circleX - verts[i].x, circleY - verts[i].y);

      if(distance < testDistance) {
        testDistance = distance;
        closestX = verts[i].x;
        closestY = verts[i].y;
      }
    }

    var normalAxisX = closestX - circleX;
    var normalAxisY = closestY - circleY;
    var normAxisLen = vec_length(normalAxisX, normalAxisY);
      normalAxisX = vec_normalize(normAxisLen, normalAxisX);
      normalAxisY = vec_normalize(normAxisLen, normalAxisY);

    var test = 0.0;
    var min1 = vec_dot(normalAxisX, normalAxisY, verts[0].x, verts[0].y);
    var max1 = min1;

    for(j in 1 ... verts.length) {
      test = vec_dot(normalAxisX, normalAxisY, verts[j].x, verts[j].y);
      if(test < min1) min1 = test;
      if(test > max1) max1 = test;
    }

    var max2 = circle.transformedRadius;
    var min2 = -circle.transformedRadius;
    var offset = vec_dot(normalAxisX, normalAxisY, -circleX, -circleY);
      
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
      var aLen = vec_length(normalAxisX, normalAxisY);
      normalAxisX = vec_normalize(aLen, normalAxisX);
      normalAxisY = vec_normalize(aLen, normalAxisY);

      min1 = vec_dot(normalAxisX, normalAxisY, verts[0].x, verts[0].y);
      max1 = min1; //set max and min

      for(j in 1 ... verts.length) {
        test = vec_dot(normalAxisX, normalAxisY, verts[j].x, verts[j].y);
        if(test < min1) min1 = test;
        if(test > max1) max1 = test;
      }

      max2 = circle.transformedRadius; //max is radius
      min2 = -circle.transformedRadius; //min is negative radius

      offset = vec_dot(normalAxisX, normalAxisY, -circleX, -circleY);
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
      var aLen = vec_length(axisX, axisY);
      axisX = vec_normalize(aLen, axisX);
      axisY = vec_normalize(aLen, axisY);

      min1 = vec_dot(axisX, axisY, verts1[0].x, verts1[0].y);
      max1 = min1;

      for(j in 1 ... verts1.length) {
        testNum = vec_dot(axisX, axisY, verts1[j].x, verts1[j].y);
        if(testNum < min1) min1 = testNum;
        if(testNum > max1) max1 = testNum;
      }

      min2 = vec_dot(axisX, axisY, verts2[0].x, verts2[0].y);
      max2 = min2;

      for(j in 1 ... verts2.length) {
        testNum = vec_dot(axisX, axisY, verts2[j].x, verts2[j].y);
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

  static inline function vec_dot(xa:Float, ya:Float, xb:Float, yb:Float) :Float {
    return xa * xb + ya * yb;
  }

  static inline function vec_length(x:Float, y:Float) :Float {
    return Math.sqrt(vec_lengthsq(x, y));
  }

  static inline function vec_lengthsq(x:Float, y:Float) :Float {
    return x * x + y * y;
  }

  static inline function vec_normalize(length:Float, val:Float) :Float {
    if(length == 0) return 0;
    return val /= length;
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
