package newp.components;

import newp.scenes.Scene;
import openfl.display.Graphics;
import openfl.display.Sprite;

// TODO: expose emitter functions/features
class EmitterComponent implements Component implements Renderable implements Updateable {

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
  
  public var container(get, never):Sprite;
  public var emitter(default, null):Emitter;

  var sync:Bool;
  var _layer:String;

  public function new(?layer:String, syncPosition:Bool = false, ?name:String) { 
    this.type = Type.getClassName(Type.getClass(this));
    this.name = name == null ? '${this.type}${++SpriteComponent.uid}' : name;
    this.container = new Sprite();
    this.layer = layer;
    this.sync = syncPosition;
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
    this.scene.addSprite(this.container, this.layer);
  }

  public function removedFromScene():Void {
    this.scene.removeSprite(this.container);
    this.scene = null;
  }

  // Internal
  // ========

  inline function syncPosition(entity:Entity):Void {
    if (entity == null || sync == false) return;
    this.container.x = entity.x;
    this.container.y = entity.y;
  }

  inline function get_layer():String { return this._layer; }
  inline function set_layer(val:String):String {
    this._layer = val;
    if (this.scene != null)
      this.scene.addSprite(this.container, val); // changes the sprite layer
    return _layer;
  }

}
