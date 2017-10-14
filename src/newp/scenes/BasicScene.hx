package newp.scenes;

import newp.collision.collections.Collection as ShapeCollection;
import newp.collision.collections.ShapeBins;
import newp.collision.response.ShapeCollision;
import newp.collision.shapes.Shape;
import newp.display.collection.DisplayCollection;
import newp.entity.collection.Collection as EntityCollection;
import newp.entity.collection.EntityCollection;
import newp.Lib;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

// Basic Scene:
//  a single layer scene
class BasicScene implements Scene {
  
  public var sprites:DisplayCollection;
  
  public var entities:EntityCollection;

  public var colliders:ShapeCollection;
  
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
    this.init_entities();
    this.init_sprites();
    this.init_colliders();
  }

  public function begin () :Void { }

  public function end () :Void { }

  public function update () :Void { }

  // Default Behaviour
  // =================
  
  function init_entities():Void   { this.entities = new EntityCollection();  }

  function init_sprites():Void    { this.sprites = new DisplayCollection('scene-layers', ['camera', 'hud', 'debug']); }

  function init_colliders():Void  { this.colliders = new ShapeBins(); }

  // Entity
  // ======

  public inline function addEntity (entity:Entity) :Void {
    entity.addedToScene(this);
    this.entities.addEntity(entity, entity.name);
  }

  public inline function removeEntity (entity:Entity) :Void {
    entity.removedFromScene(this);
    this.entities.removeEntity(entity);
  }

  public inline function hasEntity (target:Dynamic) :Bool { return entities.hasEntity(target); }

  public inline function getEntity (name:String) :Entity { return entities.getEntity(name); }

  // Sprite
  // ======

  public inline function addSprite (sprite:DisplayObject, ?layer:String) :Void {
    layer = layer == null ? 'camera' : layer == '' ? 'camera' : layer;
    this.sprites.add(sprite, layer);
  }

  public inline function removeSprite (sprite:DisplayObject) :Void {
    this.sprites.remove(sprite);
  }

  public inline function setChildIndex (sprite:DisplayObject, index:Int) :Void {
    this.sprites.setChildIndex(sprite, index);
  }

  // Collider
  // ========

  public inline function addCollider (shape:Shape) :Void {
    this.colliders.add(shape);
  }

  public inline function removeCollider (shape:Shape) :Void {
    this.colliders.remove(shape);
  }

  // Properties
  
  function get_container():DisplayObjectContainer { return this.sprites.container; }

  inline function get_x():Float { return this.container.x; }
  inline function set_x(val:Float):Float { return this.container.x = val; }

  inline function get_y():Float { return this.container.y; }
  inline function set_y(val:Float):Float { return this.container.y = val; }

}