package newp.collision.sat;

import newp.collision.response.ShapeCollision;
import newp.collision.shapes.*;
import newp.math.Utils as MathUtils;


class CircleVsBounds {

  public static function test( circle:Circle, shape:Shape, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {
    
    var bounds = shape.bounds;
    var dx = bounds.centerX - circle.x;
    var px = (bounds.halfWidth + circle.radius) - Math.abs(dx);

    if (px > 0) {

      var dy = bounds.centerY - circle.y;
      var py = (bounds.halfHeight + circle.radius) - Math.abs(dy);

      if (py > 0) {

        into = (into == null) ? new ShapeCollision() : into.clear();
        into.shape1 = flip ? shape : circle;
        into.shape2 = flip ? circle : shape;

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
