package newp.components;

import openfl.geom.Point;
import openfl.display.DisplayObject;
import newp.entity.EntityMotion;
import newp.Entity;


class MotionComponent implements Component implements Updateable {

  static var uid:Int = 0;

  public var name(default, null):String;
  public var entity:Entity;
  public var type:String;
  public var updateable:Bool = true;
  public var renderable:Bool = false;
  public var collidable:Bool = false;

  public var motion:EntityMotion;

  public function new(?motion:EntityMotion, ?name:String) {
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++MotionComponent.uid}' : name;
    this.motion = motion == null ? new EntityMotion(null) : motion;
  }

  public function update():Void {
    this.motion.update();
  }

  @:access(newp.entity.EntityMotion.entity)
  public function addedToEntity(e:Entity):Void {
    this.entity = e;
    this.motion.entity = e;
  }

  @:access(newp.entity.EntityMotion.entity)
  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
    this.motion.entity = null;
  }

}
