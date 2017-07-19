package newp.entity;

import newp.math.Motion;
import newp.math.Utils as MathUtils;
import newp.Entity;
import openfl.geom.Point;


class EntityMotion {

  var motionPropertiesMap:Map<String, Motion>;
  var entity:Entity;

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

  public function new(entity:Entity) {
    this.entity = entity;
    this.motionPropertiesMap = new Map();
    this.addMotionProp('x')
        .addMotionProp('y')
        .addMotionProp('z')
        .addMotionProp('rotation');
  }

  public function update():Void {
    for (p in this.motionPropertiesMap.keys()) this.updateMotionProp(p);
  }

  public function setDrag(val:Float, ?prop:String) {
    if (prop != null) {
      this.motionPropertiesMap[prop].drag = val;
    } else {
      for (p in this.motionPropertiesMap.keys()) this.motionPropertiesMap[p].drag = val;
    }
    return val;
  }

  public function setMax(val:Float, ?prop:String) {
    if (prop != null) {
      this.motionPropertiesMap[prop].max = val;
    } else {
      for (p in this.motionPropertiesMap.keys()) this.motionPropertiesMap[p].max = val;
    }
    return val;
  }

  // Actions
  // =======

  public function moveAtAngle(speed:Float, angle:Float):EntityMotion {
    this.vx = Math.cos(angle) * speed;
    this.vy = Math.sin(angle) * speed;
    return this;
  }

  public function moveTowardTarget(speed:Float, target:Point):EntityMotion {
    var dx = this.entity.x - target.x;
    var dy = this.entity.y - target.y;
    var l = MathUtils.vec_length(dx, dy);
    this.vx = MathUtils.vec_normalize(l, dx) * speed;
    this.vy = MathUtils.vec_normalize(l, dy) * speed;
    return this;
  }

  // Internal
  // ========

  inline function updateMotionProp(prop:String) {
    this.motionPropertiesMap[prop]
        .update()
        .apply(prop, this.entity);
  }

  inline function addMotionProp(prop:String):EntityMotion {
    this.motionPropertiesMap.set(prop, new Motion());
    return this;
  }

  // Properites
  // ==========

  inline function get_ax():Float { return this.motionPropertiesMap['x'].a; }
  inline function set_ax(val:Float):Float { return this.motionPropertiesMap['x'].a = val; }

  inline function get_ay():Float { return this.motionPropertiesMap['y'].a; }
  inline function set_ay(val:Float):Float { return this.motionPropertiesMap['y'].a = val; }

  inline function get_az():Float { return this.motionPropertiesMap['z'].a; }
  inline function set_az(val:Float):Float { return this.motionPropertiesMap['z'].a = val; }

  inline function get_ra():Float { return this.motionPropertiesMap['rotation'].a; }
  inline function set_ra(val:Float):Float { return this.motionPropertiesMap['rotation'].a = val; }

  inline function get_vx():Float { return this.motionPropertiesMap['x'].v; }
  inline function set_vx(val:Float):Float { return this.motionPropertiesMap['x'].v = val; }

  inline function get_vy():Float { return this.motionPropertiesMap['y'].v; }
  inline function set_vy(val:Float):Float { return this.motionPropertiesMap['y'].v = val; }

  inline function get_vz():Float { return this.motionPropertiesMap['z'].v; }
  inline function set_vz(val:Float):Float { return this.motionPropertiesMap['z'].v = val; }

  inline function get_rs():Float { return this.motionPropertiesMap['rotation'].v; }
  inline function set_rs(val:Float):Float { return this.motionPropertiesMap['rotation'].v = val; }

  inline function set_drag(val:Float) { return this.setDrag(val); }

  inline function set_max(val:Float) { return this.setMax(val); }

}