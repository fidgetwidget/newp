package newp.components;

import openfl.geom.Point;
import openfl.display.DisplayObject;
import newp.math.Motion;
import newp.math.Utils as MathUtils;
import newp.Entity;


class MotionComponent implements Component implements Updateable {

  static var uid:Int = 0;

  public var name(default, null):String;
  public var entity(default, null):Entity;
  public var type(default, null):String;
  public var updateable(default, null):Bool = true;
  public var renderable(default, null):Bool = false;
  public var collidable(default, null):Bool = false;

  public var motion:Motion;
  public var ax(get, set):Float;
  public var ay(get, set):Float;
  public var az(get, set):Float;
  public var ra(get, set):Float;

  public var vx(get, set):Float;
  public var vy(get, set):Float;
  public var vz(get, set):Float;
  public var rs(get, set):Float;

  public var drag(never, set):Float;
  public var max(never, set):Float;

  public function new(?name:String) {
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++MotionComponent.uid}' : name;
    this.motion = new Motion(['x', 'y', 'z', 'rotation']);
  }

  // Updateable
  // ==========

  public function update():Void {
    if (this.entity == null) return;
    this.motion.update(this.entity);
  }

  // Component
  // =========

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
  }

  // Methods
  // =======

  public function moveAtAngle(speed:Float, angle:Float):MotionComponent {
    this.vx = Math.cos(angle) * speed;
    this.vy = Math.sin(angle) * speed;
    return this;
  }

  public function moveTowards(speed:Float, x:Float, y:Float):MotionComponent {
    if (this.entity == null) return this;
    var dx = x - this.entity.x;
    var dy = y - this.entity.y;
    var l = MathUtils.vec_length(dx, dy);
    this.vx = MathUtils.vec_normalize(l, dx) * speed;
    this.vy = MathUtils.vec_normalize(l, dy) * speed;
    return this;
  }

  public function accelerateTowards(accel:Float, x:Float, y:Float):MotionComponent {
    if (this.entity == null) return this;
    var dx = x - this.entity.x;
    var dy = y - this.entity.y;
    var l = MathUtils.vec_length(dx, dy);
    this.ax = MathUtils.vec_normalize(l, dx) * accel;
    this.ay = MathUtils.vec_normalize(l, dy) * accel;
    return this;
  }

  // Properites
  // ==========

  inline function get_ax():Float { return this.motion.a('x'); }
  inline function set_ax(val:Float):Float { return this.motion.a('x', val); }

  inline function get_ay():Float { return this.motion.a('y'); }
  inline function set_ay(val:Float):Float { return this.motion.a('y', val); }

  inline function get_az():Float { return this.motion.a('z'); }
  inline function set_az(val:Float):Float { return this.motion.a('z', val); }

  inline function get_ra():Float { return this.motion.a('rotation'); }
  inline function set_ra(val:Float):Float { return this.motion.a('rotation', val); }

  inline function get_vx():Float { return this.motion.v('x'); }
  inline function set_vx(val:Float):Float { return this.motion.v('x', val); }

  inline function get_vy():Float { return this.motion.v('y'); }
  inline function set_vy(val:Float):Float { return this.motion.v('y', val); }

  inline function get_vz():Float { return this.motion.v('z'); }
  inline function set_vz(val:Float):Float { return this.motion.v('z', val); }

  inline function get_rs():Float { return this.motion.v('rotation'); }
  inline function set_rs(val:Float):Float { return this.motion.v('rotation', val); }

  inline function set_drag(val:Float) { return this.motion.setDrag(val); }

  inline function set_max(val:Float) { return this.motion.setMax(val); }

}
