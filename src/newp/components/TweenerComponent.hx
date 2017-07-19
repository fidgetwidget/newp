package newp.components;

import openfl.geom.Point;
import openfl.display.DisplayObject;
import newp.math.Tween;
import newp.Entity;


// TODO: The tween interaction here should be it's own class - move it out into one.
class TweenerComponent implements Component implements Updateable {

  static var uid:Int = 0;

  public var name(default, null):String;
  public var entity(default, null):Entity;
  public var type(default, null):String;
  public var updateable(default, null):Bool = true;
  public var renderable(default, null):Bool = false;
  public var collidable(default, null):Bool = false;
  public var tweens:Map<String, Tween>;
  public var allTweens:Array<Tween>;

  public function new(?name:String) {
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++TweenerComponent.uid}' : name;
    this.tweens = new Map();
    this.allTweens = [];
  }

  public function add(name:String, duration:Float, ?onStep:Float->Tween->Void, ?onDone:Tween->Void):Tween {
    var tween:Tween;
    if (tweens.exists(name)) {
      tween = tweens.get(name).restart();
      tween.duration = duration;
    } else {
      tween = new Tween(duration);
      this.allTweens.push(tween);
    }
    tween.onStep = onStep;
    tween.onDone = onDone;
    tween.pause();
    this.tweens.set(name, tween);
    return tween;
  }

  public function get(name:String):Tween {
    return this.tweens.get(name);
  }

  public function start(name:String):Void {
    this.tweens.get(name).restart().unpause();
  }

  public function pause(name:String):Void {
    this.tweens.get(name).pause();
  }

  public function unpause(name:String):Void {
    this.tweens.get(name).unpause();
  }

  public function update():Void {
    for (t in allTweens) t.update();
  }

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
  }

}
