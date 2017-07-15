package newp.math;

import haxe.Timer;

class Tween {

  var complete:Bool = false;
  public var duration(get, set):Float;
  public var paused(default, null):Bool = false;
  public var delta(default, null):Float = 0;
  public var percent(get, never):Float;

  public var onStart:Tween->Void = null;
  public var onStep:Float->Tween->Void = null;
  public var onDone:Tween->Void = null;

  public function new(length:Float) {
    this.duration = length;
    this.restart();
  }

  public function restart():Tween {
    this.delta = 0;
    this.complete = false;
    this.begin();
    return this;
  }

  public function pause():Tween {
    this.paused = true;
    return this;
  }

  public function unpause():Tween {
    this.paused = false;
    return this;
  }

  public function update():Void {
    this.delta += Lib.delta;
    if (this.percent >= 0 && this.percent <= 1) {
      this.step(this.percent);
    } else if (this.percent >= 1) {
      this.complete = true;
      this.done();
    }
  }

  inline function begin():Void {
    if (this.onStart != null) this.onStart(this);
  }

  inline function step( value:Float ):Void {
    if (this.onStep != null) this.onStep(value, this);
  }

  inline function done():Void {
    if (this.onDone != null) this.onDone(this);
  }

  inline function get_duration():Float { return _duration; }
  inline function set_duration(val:Float):Float { 
    if (val < 0) throw "Tween duration can't be less than zero.";
    return _duration = val;
  }

  inline function get_percent():Float { return delta <= 0 ? 1 : delta / duration; }

  var _duration:Float = 0;

}