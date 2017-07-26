package newp.display;

interface Emitter {

  public var _particles:Array<Particle>; // the particle pool
  public var particles:Array<Particle>; // the active particles

  public var protoParticle(default, null):Particle; // the proto particle

  public var delta(get, default):Float;
  public var emitting(default, null):Bool;
  public var frequency(default, null):Float;
  public var max_particles(default, null):Int;

  public function setup(type:Particle, ?frequency:Float, ?max:Int):Void;

  public function start():Void;

  public function reset():Void;

  public function pause():Void;

  public function resume():Void;

  public function update():Void;

}
