package newp.components;

import openfl.geom.Point;
import openfl.display.DisplayObject;
import newp.math.Motion;
import newp.Entity;


class MotionComponent implements Component implements Updateable {

  static var uid:Int = 0;

  public var name(default, null):String;
  public var entity:Entity;
  public var type:String;
  public var updateable:Bool = true;
  public var renderable:Bool = false;
  public var collidable:Bool = false;

  public var motion:Motion;

  public function new(?motion:Motion, ?name:String) {
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++MotionComponent.uid}' : name;
    this.motion = motion == null ? new Motion() : motion;
  }

  public function update():Void {
    this.motion.update();
  }

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
    this.motion.target = e.body;
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
    this.motion.target = null;
  }

}
