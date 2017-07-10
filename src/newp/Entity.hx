package newp;

import newp.components.*;
import newp.collision.shapes.Shape;
import newp.collision.Bounds;
import newp.scenes.Scene;
import newp.math.Motion;
import openfl.display.Sprite;


class Entity {

  var components:Map<String, Component>;
  
  var parent:Entity = null;
  var children:Array<Entity>;

  public var scene(default, null):Scene;

  public var sprite(get, never):Sprite;
  public var x(get, set):Float;
  public var y(get, set):Float;
  public var rotation(get, set):Float;
  public var scaleX(get, set):Float;
  public var scaleY(get, set):Float;

  public var collider(get, never):Shape;
  public var bounds(get, never):Bounds;

  public var motion(get, never):Motion;
  public var vx(get, set):Float;
  public var vy(get, set):Float;
  public var ax(get, set):Float;
  public var ay(get, set):Float;
  public var rs(get, set):Float;
  public var ra(get, set):Float;


  public function new() {
    this.components = new Map();
  }

  public function update():Void { 
    for (c in this.components) {
      if (c.updatable) cast(c, Updatable).update();
    }
  }

  // +-------------------------
  // | Components 
  // +-------------------------

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

  // +-------------------------
  // | Scene 
  // +-------------------------

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

  // +-------------------------
  // | Properties
  // +-------------------------

  inline function get_sprite():Sprite { 
    return this.hasComponent(SpriteComponent) ? 
      cast(this.getComponent(SpriteComponent), SpriteComponent).sprite : 
      null;
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
    return this.hasComponent(ShapeComponent) ? 
      cast(this.getComponent(ShapeComponent), ShapeComponent).shape : 
      null;
  }

  inline function get_bounds():Bounds { 
    return this.collider != null ? 
      this.collider.bounds :
      null;
  }

  inline function get_motion():Motion {
    return this.hasComponent(MotionComponent) ? 
      cast(this.getComponent(MotionComponent), MotionComponent).motion : 
      null;
  }

  inline function get_vx():Float { return this.motion == null ? 0 : this.motion.vx; }
  inline function set_vx(val:Float):Float {
    if (this.motion != null) this.motion.vx = val;
    return val;
  }

  inline function get_vy():Float { return this.motion == null ? 0 : this.motion.vy; }
  inline function set_vy(val:Float):Float {
    if (this.motion != null) this.motion.vy = val;
    return val;
  }

  inline function get_ax():Float { return this.motion == null ? 0 : this.motion.ax; }
  inline function set_ax(val:Float):Float {
    if (this.motion != null) this.motion.ax = val;
    return val;
  }

  inline function get_ay():Float { return this.motion == null ? 0 : this.motion.ay; }
  inline function set_ay(val:Float):Float {
    if (this.motion != null) this.motion.ay = val;
    return val;
  }

  inline function get_rs():Float { return this.motion == null ? 0 : this.motion.rs; }
  inline function set_rs(val:Float):Float {
    if (this.motion != null) this.motion.rs = val;
    return val;
  }

  inline function get_ra():Float { return this.motion == null ? 0 : this.motion.ra; }
  inline function set_ra(val:Float):Float {
    if (this.motion != null) this.motion.ra = val;
    return val;
  }

}
