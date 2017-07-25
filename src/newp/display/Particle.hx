package newp.display;

import newp.motion.Motion;
import newp.motion.MotionRange;
import newp.math.Range;
import newp.Lib;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;


class Particle {

  var _lifespan:Float = 0;
  var _motion:Motion = null;

  public var age(default, null):Float = 0;
  public var lifespan(default, null):Range;
  public var motion(default, null):MotionRange;
  public var percent(get, never):Float;

  public function new() {
    this.lifespan = new Range(); // the only thing every particle has is a lifespan/age
  }

  public function setLifespan(min:Float, max:Float):Void {
    this.lifespan.setup(min, max);
  }

  public function setMotion(range:MotionRange):Void {
    this.motion = range;
  }

  public function start():Void {
    this.age = 0;
    _lifespan = this.lifespan.random();
    if (this.motion != null) {
      this.motion.copyTo(_motion);
    }
  }

  public function update(target:Dynamic):Bool {
    this.age += Lib.delta;
    if (this.age > _lifespan) {
      return false;
    }

    if (_motion != null) {
      _motion.update(target);
    }
  }

  public function recycle(emitter:Emitter):Void {
    emitter.particles.remove(this);
    emitter._particles.push(this);
  }

  public function clone():Particle {
    var p = new Particle();
    p.copyFrom(this);
    return p;
  }

  public function copyFrom(particle:Particle) {
    this.lifespan.copyFrom(particle.lifespan);
    if (particle.motion != null) {
      this.motion.copyFrom(particle.motion);
    }
  }


  inline function get_percent():Float { return age <= 0 ? 0 : age >= _lifespan ? 1 : age / _lifespan }

}