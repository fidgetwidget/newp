package newp.math;


class Dice {

  public static function roll(n:Null<Int> = null, d:Null<Int> = null, arr:Dynamic = false):Dynamic {
    if (n == null) { n = 1; d = 6; } // default no args to 1 die with 6 sides
    if (d == null) { d = n; n = 1; } // default first arg only to be sides (1 die)
    
    var results:Array<Int> = null;
    var resultArray:Bool;

    if (Std.is(arr, Bool)) {
      resultArray = cast arr;
      results = [];
    } else if (Std.is(arr, Array)) {
      resultArray = true;
      results = cast arr;
    } else {
      throw "Invalid third argument.";
    }

    for (i in 0...n) { results.push(Std.random(d) + 1); }

    return !resultArray ? Dice.sumArray(results) : results;
  }

  public static function parse(s:String, resultArray:Bool = false):Dynamic {
    var rolls = s.split(" ");
    var results = [];
    for (roll in rolls) {
      var parts:Array<String> = roll.split('d');
      var n:Int, d:Int;
      n = parts[0] == '' ? 1 : Std.parseInt(parts[0]);
      d = parts[1] == '' ? 6 : Std.parseInt(parts[1]);
      Dice.roll(n, d, results);
    }
    return !resultArray ? Dice.sumArray(results) : results;
  }

  static inline function sumArray(arr:Array<Int>):Int {
    var sum = 0;
    for (val in arr) { sum += val; }
    return sum;
  }

}