package newp.components;

import openfl.display.Sprite;

class SpriteComponent implements Component implements Renderable {

  public var entity:Entity;
  public var type:String;
  public var updatable:Bool = false;
  public var renderable:Bool = true;
  public var collidable:Bool = false;
  public var sprite:Sprite;

  public function new(?sprite:Sprite) { 
    this.type = Type.getClassName(Type.getClass(this));
    this.sprite = sprite == null ? new Sprite() : sprite; 
  }

  @:access(newp.math.Motion.target)
  @:access(newp.collision.shapes.Shape.transformBody)
  public function addedToEntity(e:Entity):Void {
    this.entity = e;
    if (e.motion != null) e.motion.target = this.sprite;
    if (e.collider != null) e.collider.transformBody = this.sprite;
  }

  @:access(newp.math.Motion.target)
  @:access(newp.collision.shapes.Shape.transformBody)
  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
    if (e.motion != null) e.motion.target = null;
    if (e.collider != null) e.collider.transformBody = null;
  }

}
