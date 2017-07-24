package newp.display;

import newp.math.Motion;
import newp.math.MotionRange;
import newp.math.Range;
import newp.Lib;
import openfl.display.DisplayObject;
import openfl.display.Shape;
import openfl.display.Sprite;


class Particle {

  var age:Float = 0;
  var _lifespan:Float = 0;
  var _motion:Motion = null;
  public var lifespan(default, null):Range;
  public var motion(default, null):MotionRange;
  public var percent(get, never):Float;
  public var emitter(default, null):Emitter = null;

  public function new(emitter:Emitter) {
    this.emitter = emitter;
    this.lifespan = new Range();
  }

  public function setLifespan(min:Float, max:Float):Void {
    this.lifespan.setup(min, max);
  }

  public function update(target:Dynamic):Void {
    this.age += Lib.delta;
    if (this.age > this._lifespan) {
      this.recycle();
      return;
    }

    if (this._motion != null) {
      this._motion.update(target);
    }
  }

  public function recycle():Void {
    this.emitter.particles.remove(this);
    this.emitter._particles.push(this);
    this.copyFrom(this.emitter.factoryParticle);
  }

  public function copyFrom(particle:Particle) {
    if (particle._motion != null) {
      this._motion.copyFrom(particle._motion);
    }
  }


  inline function get_percent():Float { return age <= 0 ? 0 : age >= _lifespan ? 1 : age / _lifespan }

}