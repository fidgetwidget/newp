package newp.utils;

class MathUtils {

  // Beacuse Math doesn't have a sign function
  public static function sign(val:Float):Float { return val > 0 ? 1 : -1; }

}
