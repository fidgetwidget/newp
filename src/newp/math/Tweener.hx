package newp.math;


// TODO: The tween interaction here should be it's own class - move it out into one.
class Tweener {

  public var tweens:Map<String, Tween>;
  public var allTweens:Array<Tween>;

  public function new(?name:String) {
    this.tweens = new Map();
    this.allTweens = [];
  }

  // supports changing duration of existing tween
  public function add(name:String, duration:Float, playImmediately:Bool = false):Tween {
    var tween:Tween;

    if (tweens.exists(name)) {
      tween = tweens.get(name).restart();
      tween.duration = duration;
    } else {
      tween = new Tween(duration);
      this.allTweens.push(tween);
    }

    if (playImmediately) tween.unpause();
    
    this.tweens.set(name, tween);
    return tween;
  }

  public function get(name:String):Tween {
    return this.tweens.get(name);
  }

  public function start(name:String):Tweener {
    this.tweens.get(name).restart().unpause();
    return this;
  }

  public function pause(name:String):Tweener {
    this.tweens.get(name).pause();
    return this;
  }

  public function unpause(name:String):Tweener {
    this.tweens.get(name).unpause();
    return this;
  }

  public function update():Void {
    for (t in allTweens) t.update();
  }

}
