package newp.scenes;

import newp.collision.shapes.Shape;
import newp.collision.collections.ShapeBins;
import newp.collision.response.ShapeCollision;
import newp.display.SpriteCollection;
import newp.Lib;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

// Basic Scene:
//  a single layer scene
class BasicScene implements Scene {
  
  var sprites:SpriteCollection;
  var entities:Array<Entity>;
  var colliders:ShapeBins;

  public var name (default, null) :String;
  public var container (get, never) :DisplayObjectContainer;
  public var x (get, set) :Float;
  public var y (get, set) :Float;

  public function new (?name:String) { 
    this.name = name != null ? name : Type.getClassName(Type.getClass(this));
    this.init();
    if (newp.Lib.debug) trace('Scene[${this.name}] created');
  }

  function init():Void {
    this.entities = [];
    this.init_sprites();
    this.init_colliders();
  }

  function init_sprites():Void {
    this.sprites = new SpriteCollection(['camera', 'hud', 'debug']);
  }

  function init_colliders():Void { 
    this.colliders = new ShapeBins(); 
  }

  public function begin () :Void { }

  public function end () :Void { }

  public function update():Void { }

  // Entity
  // ======

  public function addEntity (entity:Entity) :Void {
    entity.addedToScene(this);
    this.entities.push(entity);
  }

  public function removeEntity (entity:Entity) :Void {
    entity.removedFromScene(this);
    this.entities.remove(entity);
  }

  // Sprite
  // ======

  public function addSprite (sprite:Sprite, ?layer:String = 'camera') :Void {
    this.sprites.addSprite(sprite, layer);
  }

  public function removeSprite (sprite:Sprite) :Void {
    this.sprites.removeSprite(sprite);
  }

  public function setSpriteIndex (sprite:Sprite, index:Int) :Void {
    this.sprites.setSpriteIndex(sprite, index);
  }

  // Collider
  // ========

  public function addCollider (shape:Shape) :Void {
    this.colliders.add(shape);
  }

  public function removeCollider (shape:Shape) :Void {
    this.colliders.remove(shape);
  }

  // Properties
  
  function get_container():DisplayObjectContainer { return this.sprites; }

  inline function get_x():Float { return this.container.x; }
  inline function set_x(val:Float):Float { return this.container.x = val; }

  inline function get_y():Float { return this.container.y; }
  inline function set_y(val:Float):Float { return this.container.y = val; }

}