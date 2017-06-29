package newp.utils;

import openfl.geom.Point;
import openfl.geom.Matrix;


class PointUtils {

  // Because Point doesn't have matrix transformation support
  public static function transformPoint(point:Point, transform:Matrix, ?out:Point = null):Void {
    if (out == null) { out = point; }
    var x = point.x;
    out.x = x*transform.a + point.y*transform.c + transform.tx;
    out.y = x*transform.b + point.y*transform.d + transform.ty;
  }

}
