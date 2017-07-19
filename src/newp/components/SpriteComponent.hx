package newp.components;

import newp.scenes.Scene;
import openfl.display.Graphics;
import openfl.display.Sprite;


class SpriteComponent implements Component implements Renderable implements Updateable {

  public static function make(?layer:String) :SpriteComponent {
    return new SpriteComponent(new Sprite(), layer);
  }

  static var uid:Int = 0;

  // Instance
  // ========

  public var name(default, null):String;
  public var entity(default, null):Entity;
  public var type(default, null):String;
  public var updateable(default, null):Bool = true;
  public var renderable(default, null):Bool = true;
  public var collidable(default, null):Bool = false;
  public var layer(get, set):String;
  public var scene(default, null):Scene;
  
  public var sprite(default, null):Sprite;
  public var graphics(get, never):Graphics;
  public var scaleX(get, set):Float;
  public var scaleY(get, set):Float;

  var sync:Bool;
  var _layer:String;

  public function new(?sprite:Sprite, ?layer:String, syncPosition:Bool = true, ?name:String) { 
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++SpriteComponent.uid}' : name;
    this.sprite = sprite == null ? new Sprite() : sprite;
    this.layer = layer;
    this.sync = syncPosition;
  }

  // Methods
  // =======

  public function addChild(?sprite:Sprite):Sprite {
    var s:Sprite = sprite == null ? new Sprite() : sprite;
    this.sprite.addChild(s);
    return s;
  }

  public function removeSprite(s:Sprite) {
    this.sprite.removeChild(s);
  }

  // Updateable
  // ==========

  public function update():Void {
    if (this.sync) this.syncPosition(this.entity);
  }

  // Component
  // =========

  public function addedToEntity(e:Entity):Void {
    this.entity = e;
    if (this.sync) this.syncPosition(e);
  }

  public function removedFromEntity(e:Entity):Void {
    this.entity = null;
  }

  // Renderable
  // ==========

  public function addedToScene(scene:Scene):Void {
    this.scene = scene;
    this.scene.addSprite(this.sprite, this.layer);
  }

  public function removedFromScene():Void {
    this.scene.removeSprite(this.sprite);
    this.scene = null;
  }

  // Internal
  // ========

  inline function syncPosition(entity:Entity):Void {
    if (entity == null) return;
    this.sprite.x = entity.x;
    this.sprite.y = entity.y;
  }

  inline function get_layer():String { return this._layer; }
  inline function set_layer(val:String):String {
    this._layer = val;
    if (this.scene != null)
      this.scene.addSprite(this.sprite, val); // changes the sprite layer
    return _layer;
  }

  inline function get_graphics():Graphics { return this.sprite.graphics; }

  inline function get_scaleX():Float { return this.sprite.scaleX; }
  inline function set_scaleX(val:Float):Float { return this.sprite.scaleX = val; }

  inline function get_scaleY():Float { return this.sprite.scaleY; }
  inline function set_scaleY(val:Float):Float { return this.sprite.scaleY = val; }

}
