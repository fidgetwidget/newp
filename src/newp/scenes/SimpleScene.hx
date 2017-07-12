package newp.scenes;

import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;
import newp.Lib;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

// Simple Scene:
//  a single layer scene without the colliders or entitites parts
class SimpleScene implements Scene {
  
  var sprites:Array<Sprite>;
  var renderTarget:Sprite;

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

  public function update () :Void { }

  // When the scene is made active
  public function begin () :Void {
    Lib.main.addChild(this.renderTarget);
  }

  // When the scene is removed
  public function end () :Void {
    Lib.main.removeChild(this.renderTarget);
  }

  // Entity
  // ======

  public function addEntity (entity:Entity) :Void { }
  public function removeEntity (entity:Entity) :Void { }

  // Sprite
  // ======

  public function addSprite (sprite:Sprite) :Void {
    this.container.addChild(sprite);
    this.sprites.push(sprite);
  }

  public function removeSprite (sprite:Sprite) :Void {
    if (!this.container.contains(sprite)) return;
    this.container.removeChild(sprite);
    this.sprites.remove(sprite);
  }

  public function setSpriteIndex (sprite:Sprite, index:Int) :Void {
    this.container.setChildIndex(sprite, index);
  }

  // Collider
  // ========

  public function addCollider (shape:Shape) :Void { }
  public function removeCollider (shape:Shape) :Void { }
  
  // Properties
  
  function get_container():DisplayObjectContainer { return this.renderTarget; }

  inline function get_x():Float { return this.renderTarget.x; }
  inline function set_x(val:Float):Float { return this.renderTarget.x = val; }

  inline function get_y():Float { return this.renderTarget.y; }
  inline function set_y(val:Float):Float { return this.renderTarget.y = val; }

}