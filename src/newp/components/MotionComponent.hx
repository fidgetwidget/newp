package newp.components;

import openfl.geom.Point;
import openfl.display.DisplayObject;
import newp.math.Motion;
import newp.Entity;


class MotionComponent implements Component implements Updatable {

  public var entity:Entity;
  public var type:String;
  public var updatable:Bool = true;
  public var renderable:Bool = false;
  public var collidable:Bool = false;

  public var motion:Motion;

  public function new(?motion:Motion) {
    this.type = Type.getClassName(Type.getClass(this));
    this.motion = motion == null ? new Motion() : motion;
  }

  public function update():Void {
    trace('motion component update');
    this.motion.update();
  }

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
    if (e.sprite != null) this.motion.target = e.sprite;
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
    this.motion.target = null;
  }

}
