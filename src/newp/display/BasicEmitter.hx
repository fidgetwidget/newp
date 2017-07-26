package newp.display;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

// TODO: make this a container of bitmaps with lifespans and tweens
class BasicEmitter extends Sprite extends Emitter {

  public static inline var DEFAULT_MAX_PARTICLES:Int = 256;
  public static inline var DEFAULT_FREQENCY:Float = 0.033333333; // 30 a second

  public var _particles:Array<Particle> = [];
  public var particles:Array<Particle> = [];
  public var delta(default, null):Float = 0;
  public var protoParticle(default, null):Particle;
  public var emitting(default, null):Bool = false;
  public var frequency(default, null):Float;
  public var max_particles(default, null):Int;

  var particleGraphics:Array<DisplayObject> = [];
  var _particleGraphics:Array<DisplayObject> = [];

  public function new(type:Particle, ?frequency:Float, ?max:Int) {
    super();
    this.set(type, frequency, max);
  }

  public function setup(type:Particle, ?frequency:Float, ?max:Int):Void {
    this.protoParticle = type;
    this.frequency = frequency == null ? DEFAULT_FREQENCY : frequency;
    this.max = max == null ? DEFAULT_MAX_PARTICLES : max;
    this.emitting = false;
  }

  public function start():Void {
    this.emitting = true;
    this.delta = 0;
  }

  public function reset():Void {
    this.emitting = false;
    this.delta = 0;
    for (p in this.particleGraphics) {
      this.removeChild(p);
    }
    for (p in this.particles) {
      p.recycle();
    }
  }

  public function makeGraphic():DisplayObject {
    throw "BasicEmitter makeGraphic not Implimented";
  }

  public function pause():Void { this.emitting = false; }

  public function resume():Void { this.emitting = true; }

  public function update():Void {
    if (!this.emitting) return;
    this.delta += Lib.delta;
    while (this.delta - this.frequency > 0) {
      this.delta -= this.frequency;
      this._emit();
    }
    var i = this.particles.length;
    while (i >= 0) {
      var p = this.particles[i];
      var g = this.particleGraphics[--i]
      if (!p.update(g)) {
        // on false, the particle is already recycled
        this.removeChild(g);
        this._particleGraphics.push(g);
      }
    }
  }

  inline public function _emit():Void {
    var l = this.particles.length;
    if (l >= this.max) return; // we are already at our maximum

    var p:Particle;
    if (this._particles.length > 0) {
      p = this._particles.pop();
    } else {
      p = this.protoParticle.clone();
    }
    // push it live
    this.particles.push(p);
    // make it's graphic and add it
    var g = this.makeGraphic();
    this.particleGraphics.push(g);
    this.addChild(g);
  }

}
