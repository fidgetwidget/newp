package newp.math;

import haxe.Timer;


class Tween {

  var completed:Bool = false;

  public var delay(get, set):Float;
  public var duration(get, set):Float;
  public var paused(default, null):Bool = false;
  public var delta(default, null):Float = 0;
  public var percent(get, never):Float;

  public var onStep:Float->Tween->Void = null;
  public var onDone:Tween->Void = null;

  public function new(duration:Float, delay:Float = 0) {
    this.duration = duration;
    this.delay = delay;
    this.restart();
    this.pause();
  }

  public function restart():Tween {
    this.delta = 0;
    this.completed = false;
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
    if (this.completed || this.paused) return;

    this.delta += Lib.delta;

    if (this.percent >= 0 && this.percent <= 1) {
      this.step(this.percent);
    } else if (this.percent >= 1) {
      this.completed = true;
      this.done();
    }
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

  inline function get_delay():Float { return _delay; }
  inline function set_delay(val:Float):Float { 
    if (val < 0) throw "Tween delay can't be less than zero.";
    return _delay = val;
  }

  inline function get_percent():Float { return delta <= 0 ? 0 : (delta - delay) / duration; }

  var _duration:Float = 0;
  var _delay:Float = 0;

}