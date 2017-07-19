package newp.math;

import openfl.geom.Point;
import openfl.display.DisplayObject;

class Motion {

  static var MIN_VALUE:Float = 0.0001;
  static var MAX_VALUE:Float = 1000;
  static var DEFAULT_DRAG:Float = 0.2;

  public var acceleration:Float;
  public var a(get, set):Float;
  public var velocity:Float;
  public var v(get, set):Float;
  public var drag:Float;
  public var max:Float;

  public function new(?drag:Float, ?max:Float) {
    this.drag = drag == null ? DEFAULT_DRAG : drag;
    this.max = max == null ? MAX_VALUE : max;
    this.acceleration = 0;
    this.velocity = 0;
  }

  public function update():Motion {
    this.v = this.update_velocity(this.v, this.a, this.drag, this.max, Lib.delta);
    return this;
  }

  public function apply(prop:String, thing:Dynamic):Motion {
    var val = Reflect.getProperty(thing, prop);
    // if (val == null) return this;
    val += this.v * Lib.delta;
    Reflect.setProperty(thing, prop, val);
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
    return Utils.clamp_float(vel, -max, max);
  }

  // Properties
  // ==========

  inline function get_a():Float { return this.acceleration; }
  inline function set_a(val:Float):Float { return this.acceleration = val; }

  inline function get_v():Float { return this.velocity; }
  inline function set_v(val:Float):Float { return this.velocity = val; }

}
