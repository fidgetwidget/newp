package newp.display;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

// TODO: make this a container of bitmaps with lifespans and tweens
class Emitter extends Sprite {

  public static inline var DEFAULT_MAX_PARTICLES:Int = 256;
  public static inline var DEFAULT_FREQENCY:Float = 0.033333333; // 30 a second

  @:allow(newp.display.Particle);
  var _particles:Array<Particle> = [];

  var particles:Array<Particle> = [];
  var particleGraphics:Array<DisplayObject> = [];
  var delta:Float = 0;
  public var factoryParticle(default, null):Particle;
  public var emitting(default, null):Bool = false;
  public var frequency(default, null):Float = ;
  public var max_particles(default, null):Int;

  public function new(type:Particle, ?frequency:Float, ?max:Int) {
    super();
    this.set(type, frequency, max);
  }

  public function setup(type:Particle, ?frequency:Float, ?max:Int):Void {
    this.factoryParticle = type;
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

  public function pause():Void {
    this.emitting = false;
  }

  public function update():Void {
    if (!this.emitting) return;
    this.delta += Lib.delta;
    while (this.delta - this.frequency > 0) {
      this.delta -= this.frequency;
      this._emit();
    }
  }

  inline public function _emit():Void {
    
  }

}
