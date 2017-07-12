package newp.collision.sat;

import newp.collision.response.ShapeCollision;
import newp.collision.shapes.*;


class PolygonVsBounds {

  // TODO: handle this better, because this is wasteful...
  public static function test( poly:Polygon, shape:Shape, ?into:ShapeCollision, flip:Bool = false ) :ShapeCollision {

    var b:Bounds = shape.bounds;
    var poly2:Polygon = Polygon.rectangle(shape.transformBody, b.width, b.height);
    return PolygonVsPolygon.test(poly, poly2, into, flip);

  }

}
