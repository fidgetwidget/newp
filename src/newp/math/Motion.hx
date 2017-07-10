package newp.math;

import openfl.geom.Point;
import openfl.display.DisplayObject;

class Motion {

  static var MIN_VALUE:Float = 0.0001;
  static var MAX_VALUE:Float = 1000;

  var acceleration:Point;
  var velocity:Point;
  var rotationAccel:Float;
  var rotationSpeed:Float;

  public var ax(get, set):Float;
  public var ay(get, set):Float;
  public var vx(get, set):Float;
  public var vy(get, set):Float;

  public var ra(get, set):Float;
  public var rs(get, set):Float;

  public var drag:Float;
  public var rDrag:Float;

  public var target:DisplayObject;

  public var hasTarget(get, never):Bool;

  public var max_velocity:Float;
  public var max_rotation:Float;

  public function new(drag:Float = 0.2, ?rDrag:Float = null) {
    this.max_velocity = MAX_VALUE;
    this.max_rotation = MAX_VALUE;
    this.acceleration = new Point(0,0);
    this.velocity = new Point(0,0);
    this.rotationAccel = 0;
    this.rotationSpeed = 0;
    this.drag = drag;
    this.rDrag = rDrag == null ? drag : rDrag;
  }

  public function update():Void {
    var d = Lib.delta;
    this.vx = this.update_velocity(this.vx, this.ax, this.drag,  this.max_velocity, d);
    this.vy = this.update_velocity(this.vy, this.ay, this.drag,  this.max_velocity, d);
    this.rs = this.update_velocity(this.rs, this.ra, this.rDrag, this.max_rotation, d);
    if (hasTarget) { this.apply(this.target); }
  }

  public function apply(thing:DisplayObject):Void {
    var d = Lib.delta;
    thing.x += this.vx * d;
    thing.y += this.vy * d;
    thing.rotation += this.rs * d;
  }

  // +-------------------------
  // | Setters
  // +-------------------------

  // TODO: add moveTowards, accelerateTowards, etc functions that set the values for you
  
  public function moveAtAngle(speed:Float, angle:Float):Motion {
    this.vx = Math.cos(angle) * speed;
    this.vy = Math.sin(angle) * speed;
    return this;
  }

  // +-------------------------
  // | Helpers
  // +-------------------------

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

  // +-------------------------
  // | Properties
  // +-------------------------

  inline function get_ax():Float { return this.acceleration.x; }
  inline function set_ax(val:Float):Float { return this.acceleration.x = val; }
  inline function get_ay():Float { return this.acceleration.y; }
  inline function set_ay(val:Float):Float { return this.acceleration.y = val; }
  inline function get_vx():Float { return this.velocity.x; }
  inline function set_vx(val:Float):Float { return this.velocity.x = val; }
  inline function get_vy():Float { return this.velocity.y; }
  inline function set_vy(val:Float):Float { return this.velocity.y = val; }

  inline function get_ra():Float { return this.rotationAccel; }
  inline function set_ra(val:Float):Float { return this.rotationAccel = val; }
  inline function get_rs():Float { return this.rotationSpeed; }
  inline function set_rs(val:Float):Float { return this.rotationSpeed = val; }

  inline function get_hasTarget():Bool { return this.target != null; }

}
