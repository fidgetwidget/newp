package newp.math;


class Range {

  public var min(get, set):Float;
  public var max(get, set):Float;

  public function new(?min:Float, ?max:Float) {
    this.setup(min, max);
  }

  public function setup(?min:Float, ?max:Float):Range {
    _min = min == null ? 0 : min;
    _max = max == null ? this.min : max;
    return this;
  }

  public function random():Float {
    return ( Math.random() * (max - min + 1) ) + min;
  }

  public function clamp(val:Float):Float {
    return Utils.clamp_float(val, min, max);
  }

  public function copyFrom(range:Range):Range {
    return this.setup(range.min, range.max);
  }

  inline function get_min():Float { return _min; }
  inline function set_min(val:Float):Float { 
    if (val > this.max) throw "Min value must be less  than or equal to Max value";
    return _min = val; 
  }

  inline function get_max():Float { return _max; }
  inline function set_max(val:Float):Float { 
    if (val < this.min) throw "Max value must be greater than or equal to Min value";
    return _max = val; 
  }

  var _min:Float = 0;
  var _max:Float = 0;

}
