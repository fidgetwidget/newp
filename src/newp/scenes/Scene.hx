package newp.scenes;

import newp.collision.shapes.Shape;
import newp.display.collection.Collection as SpriteCollection;
import newp.entity.collection.Collection as EntityCollection;
import newp.Lib;
import openfl.display.Sprite;
import openfl.display.DisplayObjectContainer;

interface Scene {
  
  public var name (default, null) :String;
  public var container (get, never) :DisplayObjectContainer;
  public var x (get, set) :Float;
  public var y (get, set) :Float;

  // public var entities:EntityCollection;
  // public var sprites:SpriteCollection;


  public function update () :Void;

  public function begin () :Void;

  public function end () :Void;

  // Entity
  // ======

  public function addEntity (entity:Entity) :Void;
  public function removeEntity (entity:Entity) :Void;
  public function getEntity (name:String) :Entity;
  public function hasEntity (target:Dynamic) :Bool;

  // Sprite
  // ======

  public function addSprite (sprite:Sprite, ?layer:String) :Void;
  public function removeSprite (sprite:Sprite) :Void;
  public function setSpriteIndex (sprite:Sprite, index:Int) :Void;

  // Collider
  // ========

  public function addCollider (shape:Shape) :Void;
  public function removeCollider (shape:Shape) :Void;

}