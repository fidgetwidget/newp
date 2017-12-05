package newp.components;

import newp.collision.shapes.Shape;


class ShapeComponent implements IComponent implements ICollidable {

  // Static
  // ======

  public static function make(e:Entity, ?shape:Shape, ?tags:Array<String>) :ShapeComponent {
    var sc = new ShapeComponent(shape, tags);
    e.addComponent(sc);
    return sc;
  }

  static var uid:Int = 0;

  // Interfaces
  // ==========

  // IComponent

  public var name(default, null):String;
  public var entity(default, null):Entity;
  public var type(default, null):String;
  public var updateable(default, null):Bool = false;
  public var renderable(default, null):Bool = false;
  public var collidable(default, null):Bool = true;

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

  // ICollidable

  public var shape(default, null):Shape;

  // Instance
  // ========

  public function new(?shape:Shape, ?tags:Array<String>, ?name:String) { 
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++ShapeComponent.uid}' : name;
    this.shape = shape == null ? new Shape() : shape;
    if (tags != null && tags.length > 0) {
      for (tag in tags) this.shape.tags.set(tag, tag);
    }
  }

}
