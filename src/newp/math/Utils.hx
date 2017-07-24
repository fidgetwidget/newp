package newp.math;

import openfl.geom.Point;
import openfl.geom.Matrix;


class Utils {

  public static inline function sign(val:Float):Int { 
    return val > 0 ? 1 : val < 0 ? -1 : 0; 
  }

  public static inline function lerp(start:Float, end:Float, t:Float) {
    return (1 - t) * start + t * end;
  }

  public static inline function vec_dot(xa:Float, ya:Float, xb:Float, yb:Float) :Float {
    return xa * xb + ya * yb;
  }

  public static inline function vec_length(x:Float, y:Float) :Float {
    return Math.sqrt(vec_lengthsq(x, y));
  }

  public static inline function vec_lengthsq(x:Float, y:Float) :Float {
    return x * x + y * y;
  }

  public static inline function vec_normalize(length:Float, val:Float) :Float {
    if (length == 0) return 0;
    return val /= length;
  }

  public static inline function clamp_float(val:Float, min:Float, max:Float):Float {
    return (val > max) ? max : (val < min) ? min : val;
  }

  public static inline function clamp_int(val:Int, min:Int, max:Int):Int {
    return (val > max) ? max : (val < min) ? min : val;
  }

  public static function transformPoint(point:Point, transform:Matrix, ?out:Point = null):Void {
    if (out == null) { out = point; }
    var x = point.x;
    out.x = x*transform.a + point.y*transform.c + transform.tx;
    out.y = x*transform.b + point.y*transform.d + transform.ty;
  }

}
