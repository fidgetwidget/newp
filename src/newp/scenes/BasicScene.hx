package newp.scenes;

import newp.collision.shapes.Shape;
import newp.collision.Collection as ShapeCollection;
import newp.collision.SAT;
import newp.collision.ShapeCollision;
import newp.Lib;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

// Basic Scene:
//  a single layer scene
class BasicScene implements Scene {
  
  var sprites:Array<Sprite>;
  var renderTarget:Sprite;  
  var layers:Map<String, Sprite>;
  var entities:Array<Entity>;
  var colliders:ShapeCollection;

  public var name (default, null) :String;
  public var container (get, never) :DisplayObjectContainer;
  public var x (get, set) :Float;
  public var y (get, set) :Float;

  public function new (?name:String) { 
    this.name = name != null ? name : Type.getClassName(Type.getClass(this));
    this.init();
  }

  function init():Void {
    this.entities = [];
    this.sprites = [];
    this.layers = [
      'container' => new Sprite(),
      'hud' => new Sprite(),
      'debug' => new Sprite()];
    this.colliders = new ShapeCollection();
    this.renderTarget = new Sprite();
    this.renderTarget.addChild(this.layers.get('container'));
    this.renderTarget.addChild(this.layers.get('hud'));
    this.renderTarget.addChild(this.layers.get('debug'));
  }

  public function update():Void { }

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

  public function addSprite (sprite:Sprite) :Void {
    this.container.addChild(sprite);
    this.sprites.push(sprite);
  }

  public function removeSprite (sprite:Sprite) :Void {
    if (!this.container.contains(sprite)) return;
    this.container.removeChild(sprite);
    this.sprites.remove(sprite);
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
  
  function get_container():DisplayObjectContainer { return this.layers.get('container'); }

  inline function get_x():Float { return this.container.x; }
  inline function set_x(val:Float):Float { return this.container.x = val; }

  inline function get_y():Float { return this.container.y; }
  inline function set_y(val:Float):Float { return this.container.y = val; }

}