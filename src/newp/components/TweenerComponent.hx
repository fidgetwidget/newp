package newp.components;

import newp.tween.Tween;
import newp.tween.Tweener;
import newp.Entity;


class TweenerComponent implements Component implements Updateable {

  public static function make(e:Entity, ?name:String):TweenerComponent {
    var t = new TweenerComponent(name);
    e.addComponent(t);
    return t;
  }


  static var uid:Int = 0;

  public var name(default, null):String;
  public var entity(default, null):Entity;
  public var type(default, null):String;
  public var updateable(default, null):Bool = true;
  public var renderable(default, null):Bool = false;
  public var collidable(default, null):Bool = false;
  public var tweener:Tweener;

  public function new(?name:String) {
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++TweenerComponent.uid}' : name;
    this.tweener = new Tweener();
  }

  // Updateable
  // ==========

  public function update():Void {
    this.tweener.update();
  }

  // Component
  // =========

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
  }

  // Methods
  // =======

  public function add(name:String, duration:Float):Tween {
    return this.tweener.add(name, this.entity, duration);
  }

  public function get(name:String):Tween {
    return this.tweener.get(name);
  }

  public function start(name:String):Void {
    this.tweener.start(name);
  }

  public function pause(name:String):Void {
    this.tweener.pause(name);
  }

  public function resume(name:String):Void {
    this.tweener.resume(name);
  }

}
