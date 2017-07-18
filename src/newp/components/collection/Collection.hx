package newp.components.collection;

import newp.collision.shapes.Shape;
import newp.components.*;
import openfl.display.Sprite;


interface Collection {

  // Properties
  // ==========

  public var updateables(default, null):Array<Updateable>;

  public var renderables(default, null):Array<Renderable>;

  public var collidables(default, null):Array<Collidable>;

  public var sprites(default, null):Array<Sprite>;

  public var colliders(default, null):Array<Shape>;


  // Methods
  // =======

  public function add(c:Component):Void;

  public function remove(c:Component):Void;

  public function has(type:Dynamic):Bool;

  public function iterator():Iterator<Component>;

}
