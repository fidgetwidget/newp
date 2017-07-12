package newp.collision.sat;

import newp.collision.response.ShapeCollision;
import newp.collision.shapes.*;
import newp.math.Utils as MathUtils;


class CircleVsCircle {

  public static function test( circleA:Circle, circleB:Circle, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

    var circle1 = flip ? circleB : circleA;
    var circle2 = flip ? circleA : circleB;

    var distsq = MathUtils.vec_lengthsq(circle1.x - circle2.x, circle1.y - circle2.y);
    var size = circle1.transformedRadius + circle2.transformedRadius;

    if(distsq < size * size) {

      into = (into == null) ? new ShapeCollision() : into.clear();

      into.shape1 = circle1;
      into.shape2 = circle2;
        
      var delta = size - Math.sqrt(distsq);
      var unitVecX = circle1.x - circle2.x;
      var unitVecY = circle1.y - circle2.y;
      var unitVecLen = MathUtils.vec_length(unitVecX, unitVecY);

      unitVecX = MathUtils.vec_normalize(unitVecLen, unitVecX);
      unitVecY = MathUtils.vec_normalize(unitVecLen, unitVecY);

      into.unitVectorX = unitVecX;
      into.unitVectorY = unitVecY;

      into.separationX = into.unitVectorX * delta;
      into.separationY = into.unitVectorY * delta;

      into.overlap = delta;

      return into;
    }

    return null;
  }

}
