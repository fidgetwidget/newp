package newp;

import newp.components.*;
import newp.collision.shapes.Shape;
import newp.collision.Bounds;
import newp.scenes.Scene;
import newp.math.Motion;
import openfl.display.Sprite;


class Entity {

  var components:Map<String, Component>;
  
  @:allow(newp.scenes.Scene)
  var scene:Scene = null;

  var parent:Entity = null;
  var children:Array<Entity>;


  public var sprite(get, never):Sprite;
  public var x(get, set):Float;
  public var y(get, set):Float;
  public var rotation(get, set):Float;
  public var scaleX(get, set):Float;
  public var scaleY(get, set):Float;

  public var collider(get, never):Shape;
  public var bounds(get, never):Bounds;

  public var motion(get, never):Motion;

  public function new() {
    this.components = new Map();
  }

  public function update():Void { 
    for (c in this.components) {
      if (c.updatable) cast(c, Updatable).update();
    }
  }

  // 
  // 
  // 

  public function addComponent(c:Component):Entity {
    this.components.set(c.type, c);
    c.addedToEntity(this);
    return this;
  }

  public function hasComponent(type:Dynamic):Bool {
    var key:String = Std.is(type, String) ? type : Type.getClassName(type);
    return this.components.exists(key);
  }

  public function getComponent(type:Dynamic):Component {
    var key:String = Std.is(type, String) ? type : Type.getClassName(type);
    return this.components.get(key);
  }

  public function removeComponent(c:Component):Entity {
    this.components.remove(c.type);
    c.removedFromEntity(this);
    return this;
  }

  // 
  // 
  // 

  public function addedToScene(s:Scene):Void {
    this.scene = s;
    for (c in this.components) {
      if (c.renderable) s.addSprite((cast(c, Renderable)).sprite);
      if (c.collidable) s.addCollider((cast(c, Collidable)).shape);
    }
  }

  public function removedFromScene(s:Scene):Void {
    this.scene = null;
    for (c in this.components) {
      if (c.renderable) s.removeSprite((cast(c, Renderable)).sprite);
      if (c.collidable) s.removeCollider((cast(c, Collidable)).shape);
    }
  }


  inline function get_sprite():Sprite { 
    return this.hasComponent(SpriteComponent) ? cast(this.getComponent(SpriteComponent), SpriteComponent).sprite : null;
  }

  inline function get_x():Float { return this.sprite == null ? 0 : this.sprite.x; }
  inline function set_x(val:Float):Float {
    if (this.sprite != null) this.sprite.x = val;
    return val;
  }

  inline function get_y():Float { return this.sprite == null ? 0 : this.sprite.y; }
  inline function set_y(val:Float):Float {
    if (this.sprite != null) this.sprite.y = val;
    return val;
  }

  inline function get_rotation():Float { return this.sprite == null ? 0 : this.sprite.rotation; }
  inline function set_rotation(val:Float):Float {
    if (this.sprite != null) this.sprite.rotation = val;
    return val;
  }

  inline function get_scaleX():Float { return this.sprite == null ? 0 : this.sprite.scaleX; }
  inline function set_scaleX(val:Float):Float {
    if (this.sprite != null) this.sprite.scaleX = val;
    return val;
  }

  inline function get_scaleY():Float { return this.sprite == null ? 0 : this.sprite.scaleY; }
  inline function set_scaleY(val:Float):Float {
    if (this.sprite != null) this.sprite.scaleY = val;
    return val;
  }

  inline function get_collider():Shape {
    return this.hasComponent(ShapeComponent) ? cast(this.getComponent(ShapeComponent), ShapeComponent).shape : null;
  }

  inline function get_bounds():Bounds {
    return this.collider == null ? null : this.collider.bounds;
  }

  inline function get_motion():Motion {
    return this.hasComponent(MotionComponent) ? cast(this.getComponent(MotionComponent), MotionComponent).motion : null;
  }

}
