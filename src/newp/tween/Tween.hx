package newp.tween;

import newp.math.NullableRange;
import haxe.Timer;


class Tween {

  public var target(default, null):Dynamic;
  public var properties(default, null):Map<String, NullableRange>;
  public var duration(default, null):Float;
  public var paused(default, null):Bool = false;
  public var delta(default, null):Float = 0;
  public var percent(get, never):Float;
  var hasRepeats(get, never):Bool;
  var shouldReflect(get, never):Bool;


  public function new(target:Dynamic, duration:Float) {
    this.properties = new Map();
    this.setup(target, duration);
  }

  public function setup(target:Dynamic, duration:Float):Tween {
    if (duration < 0) throw "Duration must be greater than or equal to 0";
    this.target = target;
    this.duration = duration;
    this.delta = 0;
    this.complete = false;
    return this;
  }

  public function recycle():Void {
    this.complete = false;
    for (key in this.properties.keys()) this.properties.remove(key);
    this._direction = 1;
    this._reflect = false;
    this._repeate = 0;
    this._easing = Easing.linear;
    this._onStep = null;
    this._onStepArgs = null;
    this._onDone = null;
    this._onDoneArgs = null;
    this._onPause = null;
    this._onPauseArgs = null;
    this._onResume = null;
    this._onResumeArgs = null;
    this._onRepeate = null;
    this._onRepeateArgs = null;
    this._onReflect = null;
    this._onReflectArgs = null;
  }

  public function restart():Tween {
    this.delta = 0;
    this.complete = false;
    return this;
  }

  public function pause():Tween {
    this.paused = true;
    this.callMethod(this._onPause, this._onPauseArgs);
    return this;
  }

  public function resume():Tween {
    this.paused = false;
    this.callMethod(this._onResume, this._onResumeArgs);
    return this;
  }

  public function delay(duration:Float):Tween {
    this._delay = duration;
    return this;
  }

  public function reflect():Tween {
    this._reflect = true;
    return this;
  }

  public function repeate(count:Int):Tween {
    this._repeate = count;
    return this;
  }

  public function ease(func:Float->Float):Tween {
    this._easing = func;
    return this;
  }

  public function prop(name:String, from:Float, ?to:Float):Tween {
    if (to == null) {
      to = from;
      from = Reflect.getProperty(target, name);
    }
    this.properties.set(name, { from: from, to: to });
    return this;
  }

  // Callback Requests
  // =================

  public function onStep(func:Dynamic, ?args:Array<Dynamic>):Tween {
    this._onStep = func;
    this._onStepArgs = args == null ? [] : args;
    return this;
  }

  public function onDone(func:Dynamic, ?args:Array<Dynamic>):Tween {
    this._onDone = func;
    this._onDoneArgs = args == null ? [] : args;
    return this;
  }

  public function onPause(func:Dynamic, ?args:Array<Dynamic>):Tween {
    this._onPause = func;
    this._onPauseArgs = args == null ? [] : args;
    return this;
  }

  public function onResume(func:Dynamic, ?args:Array<Dynamic>):Tween {
    this._onResume = func;
    this._onResumeArgs = args == null ? [] : args;
    return this;
  }

  public function onRepeate(func:Dynamic, ?args:Array<Dynamic>):Tween {
    this._onRepeate = func;
    this._onRepeateArgs = args == null ? [] : args;
    return this;
  }

  public function onReflect(func:Dynamic, ?args:Array<Dynamic>):Tween {
    this._onReflect = func;
    this._onReflectArgs = args == null ? [] : args;
    return this;
  }

  // Internal
  // ========

  @:allow(newp.tween.Tweener)
  function update():Void {
    if (this.complete || this.paused) return;

    this.delta += Lib.delta;

    if (this.percent >= 0 && this.percent <= 1) {
      this.updateProperties();
      this.callMethod(this._onStep, this._onStepArgs);
    } else if (this.percent >= 1) {

      if (this.hasRepeats || this.shouldReflect) {
        var overage:Float = (this.delta - this._delay) - this.duration;
        this.delta = overage;
        if (this.shouldReflect) {
          this._direction = -1;
          this.callMethod(this._onReflect, this._onReflectArgs); // Reflect
        } else if (this.hasRepeats) {
          this._repeate--;
          if (this._reflect && this._direction == -1) this._direction = 1;
          this.callMethod(this._onRepeate, this._onRepeateArgs); // Repeate
        }
      } else {
        this.complete = true;
        this.callMethod(this._onDone, this._onDoneArgs);
      }
    } else {
      throw "Percent is somehow negative. This isn't supported";
    }
  }

  inline function updateProperties() {
    for (p in this.properties.keys()) {

      var range = this.properties.get(p);
      var t = this.percent > 1 ? 1 : this.percent;
      var val = Easing.lerp(range.from, range.to, t, this._easing);
      Reflect.setProperty(this.target, p, val);

    }

  }

  inline function callMethod(method:Dynamic, args:Array<Dynamic>):Dynamic {
    if (method == null) return null;
    if (args == null) args = [];
    return Reflect.callMethod(method, method, args);
  }

  // Properties
  // ==========

  inline function get_percent():Float { return delta == 0 ? 0 : (delta - _delay) / duration; }

  inline function get_hasRepeats():Bool { return this._repeate > 0; }

  inline function get_shouldReflect():Bool { return this._reflect && this._direction == 1; }

  @:allow(newp.tween.Tweener)
  var complete:Bool = false;

  var _delay:Float = 0;
  var _direction:Int = 1;
  var _reflect:Bool = false;
  var _repeate:Int = 0;
  var _easing:Float->Float = Easing.linear;
  // 
  var _onStep:Dynamic;
  var _onStepArgs:Array<Dynamic>;
  var _onDone:Dynamic;
  var _onDoneArgs:Array<Dynamic>;
  var _onPause:Dynamic;
  var _onPauseArgs:Array<Dynamic>;
  var _onResume:Dynamic;
  var _onResumeArgs:Array<Dynamic>;
  var _onRepeate:Dynamic;
  var _onRepeateArgs:Array<Dynamic>;
  var _onReflect:Dynamic;
  var _onReflectArgs:Array<Dynamic>;

}