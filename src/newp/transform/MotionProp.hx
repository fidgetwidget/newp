package newp.transform;

import newp.math.Utils as MathUtils;


class MotionProp {

  static var MIN_VALUE:Float = 0.0001;
  static var MAX_VALUE:Float = 1000;
  static var DEFAULT_DRAG:Float = 0.2;

  public var acceleration(get, set):Float;
  public var velocity(get, set):Float;
  public var a(get, set):Float;
  public var v(get, set):Float;
  public var drag:Float;
  public var max:Float;

  public function new(?drag:Float, ?max:Float) {
    this.drag = drag == null ? DEFAULT_DRAG : drag;
    this.max = max == null ? MAX_VALUE : max;
    _a = 0;
    _v = 0;
  }

  public function update():MotionProp {
    this.v = this.update_velocity(this.v, this.a, this.drag, this.max, Lib.delta);
    return this;
  }

  public function apply(prop:String, target:Dynamic):MotionProp {
    var val = Reflect.getProperty(target, prop);
    // if (val == null) return this;
    val += this.v * Lib.delta;
    Reflect.setProperty(target, prop, val);
    return this;
  }

  public function copyFrom(mProp:MotionProp):MotionProp {
    this.drag = mProp.drag;
    this.max = mProp.max;
    this._a = mProp.a;
    this._v = mProp.v;
    return this;
  }

  // Helpers
  // =======

  inline function update_velocity(vel:Float, accel:Float, drag:Float, max:Float, delta:Float):Float {
    if (accel != 0) {
      vel += accel * delta;
    } else if (drag != 0) {
      var d = drag * delta;
      if (vel - d > 0) {
        vel -= d;
      } else if (vel + d < 0) {
        vel += d;
      } else {
        vel = 0;
      }
    }
    return MathUtils.clamp_float(vel, -max, max);
  }

  // Properties
  // ==========

  inline function get_acceleration():Float { return this._a; }
  inline function set_acceleration(val:Float):Float { return this._a = val; }

  inline function get_velocity():Float { return this._v; }
  inline function set_velocity(val:Float):Float { return this._v = val; }

  inline function get_a():Float { return this._a; }
  inline function set_a(val:Float):Float { return this._a = val; }

  inline function get_v():Float { return this._v; }
  inline function set_v(val:Float):Float { return this._v = val; }

  var _a:Float = 0;
  var _v:Float = 0;

}
