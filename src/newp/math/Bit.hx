package newp.math;

// Helper for dealing with bit values
class Bit {

  public static function value(val:Int):Int {
    return 1 << val;
  }

  public static function remove(bits:Int, mask:Int):Int {
    return bits & ~mask;
  }

  public static function add(bits:Int, mask:Int):Int {
    return bits | mask;
  }

  public static function has(bits:Int, mask:Int):Bool {
    return bits & mask != 0;
  }

}