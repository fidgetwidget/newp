package newp.scenes;

import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;
import newp.Lib;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

// Simple Scene:
//  a single layer scene without the colliders or entitites parts
class SimpleScene implements Scene {
  
  var sprites:Array<DisplayObject>;
  var renderTarget:Sprite;

  public var entities(default, null):Map<String,Entity>; // never initialized

  public var name (default, null) :String;
  public var container (get, never) :DisplayObjectContainer;
  public var x (get, set) :Float;
  public var y (get, set) :Float;
  
  public function new (?name:String) { 
    this.name = name != null ? name : Type.getClassName(Type.getClass(this));
    this.init();
  }

  function init():Void {
    this.sprites = [];
    this.renderTarget = new Sprite();
  }

  public function begin () :Void { }

  public function end () :Void { }

  public function update () :Void { }

  // Entity
  // ======

  public function addEntity (entity:Entity) :Void { }
  public function removeEntity (target:Dynamic) :Void { }
  public function hasEntity (target:Dynamic) :Bool { return false; }
  public function getEntity (name:String) :Entity { return null; }

  // Sprite
  // ======

  public function addSprite (sprite:DisplayObject, ?layer:String) :Void {
    this.container.addChild(sprite);
    this.sprites.push(sprite);
  }

  public function removeSprite (sprite:DisplayObject) :Void {
    if (!this.container.contains(sprite)) return;
    this.container.removeChild(sprite);
    this.sprites.remove(sprite);
  }

  public function setChildIndex (sprite:DisplayObject, index:Int) :Void {
    this.container.setChildIndex(sprite, index);
  }

  // Collider
  // ========

  public function addCollider (shape:Shape) :Void { }
  public function removeCollider (shape:Shape) :Void { }
  
  // Properties
  
  function get_container():DisplayObjectContainer { return this.renderTarget; }

  inline function get_x():Float { return this.container.x; }
  inline function set_x(val:Float):Float { return this.container.x = val; }

  inline function get_y():Float { return this.container.y; }
  inline function set_y(val:Float):Float { return this.container.y = val; }

}