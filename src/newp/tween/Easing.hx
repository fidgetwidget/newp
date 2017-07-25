package newp.tween;


class Easing {

  public static inline function lerp(start:Float, end:Float, t:Float, ?easeFunc:Float->Float):Float {
    if (easeFunc != null) t *= easeFunc(t);
    return (1 - t) * start + t * end;
  }

  public static inline function linear(k:Float):Float {
    return k;
  }

  public static inline function quadIn(k:Float):Float {
    return k * k;
  }

  public static inline function quadOut(k:Float):Float {
    return -k * (k - 2);
  }

  public static inline function quadInOut(k:Float):Float {
    return k <= .5 ? k * k * 2 : 1 - (--k) * k * 2;
  }

  public static inline function expoIn(k:Float):Float {
    return Math.pow(2, 10 * (k - 1));
  }

  public static inline function expoOut(k:Float):Float {
    return -Math.pow(2, -10 * k) + 1;
  }
   
  public static inline function expoInOut(k:Float):Float {
    return k < .5 ? Math.pow(2, 10 * (k * 2 - 1)) / 2 : (-Math.pow(2, -10 * (k * 2 - 1)) + 2) / 2;
  } 

  public static inline function sineIn(k:Float):Float {
    return -Math.cos(PI2 * k) + 1;
  }

  public static inline function sineOut(k:Float):Float {
    return Math.sin(PI2 * k);
  }

  public static inline function sineInOut(k:Float):Float {
    return -Math.cos(PI * k) / 2 + .5;
  }



  // Faster
  static inline var PI:Float = 3.141592653589793;
  static inline var PI2:Float = PI / 2;

}
