package newp.components;

import newp.collision.shapes.Shape;
import newp.components.*;
import openfl.display.Sprite;


interface ICollection {

  // Properties
  // ==========

  public var updateables(default, null):Array<IUpdateable>;

  public var renderables(default, null):Array<IRenderable>;

  public var collidables(default, null):Array<ICollidable>;

  public var sprites(default, null):Array<Sprite>;

  public var colliders(default, null):Array<Shape>;


  // Methods
  // =======

  public function add(c:IComponent):Void;

  public function remove(c:IComponent):Void;

  public function has(type:Dynamic):Bool;

  public function get(name:String):IComponent;

  public function iterator():Iterator<IComponent>;

}
