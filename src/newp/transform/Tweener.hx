package newp.transform;


// TODO: The tween interaction here should be it's own class - move it out into one.
class Tweener {

  public var tweens:Map<String, Tween>;
  public var activeTweens:Array<Tween>;

  public function new(?name:String) {
    this.tweens = new Map();
    this.activeTweens = [];
  }

  // supports changing duration of existing tween
  public function add(name:String, target:Dynamic, duration:Float, playImmediately:Bool = false):Tween {
    var tween:Tween;

    if (tweens.exists(name)) {
      tween = tweens.get(name).setup(target, duration);
    } else {
      tween = new Tween(target, duration);
    }

    if (playImmediately) {
      this.activeTweens.push(tween);
    }
    
    this.tweens.set(name, tween);
    return tween;
  }

  public function get(name:String):Tween {
    return this.tweens.get(name);
  }

  public function start(name:String):Tweener {
    var tween = this.tweens.get(name);
    tween.restart().resume();
    this.activeTweens.push(tween);
    return this;
  }

  public function pause(name:String):Tweener {
    this.tweens.get(name).pause();
    return this;
  }

  public function resume(name:String):Tweener {
    this.tweens.get(name).resume();
    return this;
  }

  public function update():Void {
    var i = activeTweens.length;
    while (i > 0) {
      var t = this.activeTweens[--i];
      t.update();
      if (t.complete) this.activeTweens.remove(t);
    }
  }

}
