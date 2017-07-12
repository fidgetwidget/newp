package newp.collision.sat;

import newp.collision.response.ShapeCollision;
import newp.collision.shapes.*;
import newp.math.Utils as MathUtils;


class BoundsVsBounds {

  public static function test( shapeA:Shape, shapeB:Shape, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

    var bounds1 = flip ? shapeB.bounds : shapeA.bounds;
    var bounds2 = flip ? shapeA.bounds : shapeB.bounds;

    var dx = bounds2.centerX - bounds1.centerX;
    var px = (bounds1.halfWidth + bounds2.halfWidth) - Math.abs(dx);

    if (px > 0) {

      var dy = bounds2.centerY - bounds1.centerY;
      var py = (bounds1.halfHeight + bounds2.halfHeight) - Math.abs(dy);

      if (py > 0) {

        into = (into == null) ? new ShapeCollision() : into.clear();
        into.shape1 = flip ? shapeB : shapeA;
        into.shape2 = flip ? shapeA : shapeB;

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

}
