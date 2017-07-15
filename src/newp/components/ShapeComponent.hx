package newp.components;

import newp.collision.shapes.Shape;

class ShapeComponent implements Component implements Collidable {

  public var entity:Entity;
  public var type:String;
  public var updateable:Bool = false;
  public var renderable:Bool = false;
  public var collidable:Bool = true;
  public var shape:Shape;

  public function new(?shape:Shape, ?tags:Array<String>) { 
    this.type = Type.getClassName(Type.getClass(this));
    this.shape = shape == null ? new Shape() : shape;
    if (tags != null && tags.length > 0) {
      for (tag in tags) this.shape.tags.set(tag, tag);
    }
  }

  @:access(newp.collision.shapes.Shape.transformBody)
  public function addedToEntity(e:Entity):Void {
    this.entity = e;
    if (this.shape.transformBody == null) this.shape.transformBody = e.body;
  }

  @:access(newp.collision.shapes.Shape.transformBody)
  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
    this.shape.transformBody = null;
  }

}
