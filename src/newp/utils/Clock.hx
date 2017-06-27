package newp.utils;

import haxe.Timer;

class Clock {

  var start:Float;
  var prev:Float;
  var now:Float;

  public var delta(default, null):Float;
  public var elapsed(get, never):Float;

  public function new() {
    this.restart();
  }

  public function restart():Void {
    this.start = Timer.stamp();
    this.now = this.prev = this.start;
  }

  public function tick():Float {
    this.prev = this.now;
    this.now = Timer.stamp();
    this.delta = this.now - this.prev;
    return this.delta;
  }

  // Properties
  function get_elapsed():Float { return this.now - this.start; }

}