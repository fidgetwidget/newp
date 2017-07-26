package newp.display;

import newp.motion.Motion;
import newp.motion.MotionRange;
import newp.math.NullableRange;
import newp.Lib;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;


class Particle {

  static var DEFAULT_PROPS:Array<String> = ['x', 'y', 'motion', 'color', 'alpha', 'scaleX', 'scaleY'];

  public var lifespan:Float = 0;
  public var age(default, null):Float = 0;
  public var percent(get, never):Float;

  // Properties
  public var x:Float;
  public var y:Float;
  public var r:Float;
  public var motion:Motion;
  
  // Ranges
  public var xx:NullableRange;
  public var yy:NullableRange;
  public var zz:NullableRange;
  public var vx:NullableRange;
  public var vy:NullableRange;
  public var vz:NullableRange;
  public var rs:NullableRange;
  public var xDrag:NullableRange;
  public var yDrag:NullableRange;
  public var zDrag:NullableRange;
  public var rDrag:NullableRange;
  // public var color:ColorRange;
  public var alpha:NullableRange;
  public var scaleX:NullableRange;
  public var scaleY:NullableRange;

  var propertiesMap:Map<String, String>;
  
  public function new(lifespan:Float, ?props:Array<String>) {
    this.lifespan = lifespan;
    this.xx = { from: null, to: null };
    this.yy = { from: null, to: null };
    this.zz = { from: null, to: null };
    this.vx = { from: 0, to: 0 };
    this.vy = { from: 0, to: 0 };
    this.vz = { from: 0, to: 0 };
    this.rs = { from: 0, to: 0 };
    this.xDrag = { from: 0, to: 0 };
    this.yDrag = { from: 0, to: 0 };
    this.zDrag = { from: 0, to: 0 };
    this.rDrag = { from: 0, to: 0 };
    // this.color = { from: null, to: null };
    this.alpha = { from: 1, to: 1 };
    this.scaleX = { from: 1, to: 1 };
    this.scaleY = { from: 1, to: 1 };
    this.propertiesMap = new Map();
    props = props == null ? DEFAULT_PROPS : props;
    for (prop in props) {
      this.propertiesMap.set(prop, prop);
    }
  }

  public function update(target:Dynamic):Bool {
    this.age += Lib.delta;
    if (this.age >= this.lifespan) return false;

    ignore = ignore == null ? empty_array : ignore; 

    if (this.motion != null && hasProperty('motion')) 
      this.update_motion(target);
    else {
      if (this.xx.from != null && hasProperty('x')) this.update_prop(target, 'x', Easing.lerp(this.xx.from, this.xx.to, percent));
      if (this.yy.from != null && hasProperty('y')) this.update_prop(target, 'y', Easing.lerp(this.yy.from, this.yy.to, percent));
      if (this.zz.from != null && hasProperty('z')) this.update_prop(target, 'z', Easing.lerp(this.zz.from, this.zz.to, percent));
    }
    // TODO: support color interpolation
    // if (this.color.from != null) this.update_prop(target, 'color', Color.lerp(this.color.from, this.color.to, percent));
    if (this.alpha.from != null && hasProperty('alpha')) this.update_prop(target, 'alpha', Easing.lerp(this.alpha.from, this.alpha.to, percent));
    if (this.scaleX.from != null && hasProperty('scaleX')) this.update_prop(target, 'scaleX', Easing.lerp(this.scaleX.from, this.scaleX.to, percent));
    if (this.scaleY.from != null && hasProperty('scaleY')) this.update_prop(target, 'scaleY', Easing.lerp(this.scaleY.from, this.scaleY.to, percent));
  }
  var empty_array = [];

  function update_motion(target:Dynamic) {
    if (this.motion.hasProperty('x')) {
      if (this.vx.from != null) this.motion.v('x', Easing.lerp(vx.from, vx.to, percent));
      if (this.xDrag.from != null) this.motion.drag('x', Easing.lerp(xDrag.from, xDrag.to, percent));
    }
    if (this.motion.hasProperty('y')) {
      if (this.vy.from != null) this.motion.v('y', Easing.lerp(vy.from, vy.to, percent));
      if (this.yDrag.from != null) this.motion.drag('y', Easing.lerp(yDrag.from, yDrag.to, percent));
    }
    if (this.motion.hasProperty('z')) {
      if (this.vz.from != null) this.motion.v('z', Easing.lerp(vz.from, vz.to, percent));
      if (this.zDrag.from != null) this.motion.drag('z', Easing.lerp(zDrag.from, zDrag.to, percent));
    }
    if (this.motion.hasProperty('rotation')) {
      if (this.rs.from != null) this.motion.v('rotation', Easing.lerp(rs.from, rs.to, percent));
      if (this.rDrag.from != null) this.motion.drag('rotation', Easing.lerp(rDrag.from, rDrag.to, percent));
    }
    this.motion.update(target);
  }

  function update_prop(target:Dynamic, prop:String, value:Float) {
    // var val = Reflect.getProperty(target, prop);
    // if (val == null) return this;
    Reflect.setProperty(target, prop, value);
  }

  public function recycle(emitter:Emitter):Void {
    emitter.particles.remove(this);
    emitter._particles.push(this);
    this.age = 0;
  }

  public function clone():Particle {
    var p = new Particle();
    p.copyFrom(this);
    // NOTE: if you want randomness to a particle, put it here
    return p;
  }

  public function copyFrom(particle:Particle) {
    this.lifespan = particle.lifespan;
    this.xx =     { from: particle.xx.from,     to: particle.xx.to };
    this.yy =     { from: particle.yy.from,     to: particle.yy.to };
    this.zz =     { from: particle.zz.from,     to: particle.zz.to };
    this.vx =     { from: particle.vx.from,     to: particle.vx.to };
    this.vy =     { from: particle.vy.from,     to: particle.vy.to };
    this.vz =     { from: particle.vz.from,     to: particle.vz.to };
    this.rs =     { from: particle.rs.from,     to: particle.rs.to };
    this.xDrag =  { from: particle.xDrag.from,  to: particle.xDrag.to };
    this.yDrag =  { from: particle.yDrag.from,  to: particle.yDrag.to };
    this.zDrag =  { from: particle.zDrag.from,  to: particle.zDrag.to };
    this.rDrag =  { from: particle.rDrag.from,  to: particle.rDrag.to };
    // this.color =  { from: particle.color.from,  to: particle.color.to };
    this.alpha =  { from: particle.alpha.from,  to: particle.alpha.to };
    this.scaleX = { from: particle.scaleX.from, to: particle.scaleX.to };
    this.scaleY = { from: particle.scaleY.from, to: particle.scaleY.to };
  }

  inline function hasProperty(prop:String):Bool {
    return this.propertiesMap.exists(prop);
  }

  inline function get_percent():Float { return age <= 0 ? 0 : age >= lifespan ? 1 : age / lifespan }

}