package newp;

import newp.components.*;
import newp.collision.shapes.Shape;
import newp.collision.Bounds;
import newp.scenes.Scene;
import newp.math.Motion;
import openfl.display.DisplayObject;
import openfl.display.Sprite;


class Entity {

  var components:ComponentCollection;
  var parent:Entity = null;
  var children:Array<Entity>;

  public var name(default, null):String; 

  public var scene(default, null):Scene;

  public var body(default, null):DisplayObject;
  public var sprites(get, never):Array<Sprite>;
  public var colliders(get, never):Array<Shape>;
  public var motion(default, null):Motion;

  public var x(get, set):Float;
  public var y(get, set):Float;
  public var rotation(get, set):Float;
  public var scaleX(get, set):Float;
  public var scaleY(get, set):Float;

  public var vx(get, set):Float;
  public var vy(get, set):Float;
  public var ax(get, set):Float;
  public var ay(get, set):Float;
  public var rs(get, set):Float;
  public var ra(get, set):Float;

  public var renderable(get, never):Bool;
  public var collidable(get, never):Bool;
  public var hasMotion(get, never):Bool;
  public var inScene(get, never):Bool;

  public function new(?name:String) {
    this.name = name != null ? name : Type.getClassName(Type.getClass(this));
    this.components = new ComponentCollection();
    this.addComponent(new TransformComponent());
    if (newp.Lib.debug) trace('Entity[${this.name}] created');
  }

  public function update():Void { 
    for (c in this.components.updateables) c.update();
  }

  // +-------------------------
  // | Components 
  // +-------------------------

  public function addComponent(c:Component):Entity {
    if (c.type == Type.getClassName(TransformComponent)) {
      if (this.hasComponent(TransformComponent)) throw "An Entity can have only one TransformComponent";
      this.body = cast (c, TransformComponent).body;
    }
    if (c.type == Type.getClassName(MotionComponent)) {
      if (this.hasComponent(MotionComponent)) throw "An Entity can have only one MotionComponent";
      this.motion = cast (c, MotionComponent).motion;
    }

    this.components.add(c);
    c.addedToEntity(this);

    if (this.inScene) this.addComponentToScene(c);

    trace('Entity[${this.name}] - adding component ${c.type}');
    return this;
  }

  public function hasComponent(type:Dynamic):Bool {
    return this.components.has(type);
  }

  public function removeComponent(c:Component):Entity {
    if (c.type == Type.getClassName(TransformComponent)) throw "An Entity must have a TransformComponent";
    if (c.type == Type.getClassName(MotionComponent)) { this.motion = null; }

    this.components.remove(c);
    c.removedFromEntity(this);

    if (this.inScene) this.removeComponentFromScene(c);

    return this;
  }

  // +-------------------------
  // | Scene 
  // +-------------------------

  public function addedToScene(s:Scene):Void {
    this.scene = s;
    for (c in this.components) this.addComponentToScene(c);
  }

  public function removedFromScene(s:Scene):Void {
    this.scene = null;
    for (c in this.components) this.removeComponentFromScene(c);
  }

  inline function addComponentToScene(c:Component) {
    if (c.renderable) this.addRenderableToScene(cast(c, Renderable));
    if (c.collidable) this.addCollidableToScene(cast(c, Collidable));
  }

  inline function removeComponentFromScene(c:Component) {
    if (c.renderable) this.removeRenderableFromScene(cast(c, Renderable));
    if (c.collidable) this.removeCollidableFromScene(cast(c, Collidable));
  }

  inline function addRenderableToScene(c:Renderable)      { this.scene.addSprite(c.sprite, c.layer); }

  inline function removeRenderableFromScene(c:Renderable) { this.scene.removeSprite(c.sprite); }

  inline function addCollidableToScene(c:Collidable)      { this.scene.addCollider(c.shape); }

  inline function removeCollidableFromScene(c:Collidable) { this.scene.removeCollider(c.shape); }

  // +-------------------------
  // | Properties
  // +-------------------------

  inline function get_sprites():Array<Sprite> { return this.components.sprites; }
  inline function get_colliders():Array<Shape> { return this.components.colliders; }

  inline function get_x():Float { return this.body.x; }
  inline function set_x(val:Float):Float { return this.body.x = val; }

  inline function get_y():Float { return this.body.y; }
  inline function set_y(val:Float):Float { return this.body.y = val; }

  inline function get_rotation():Float { return this.body.rotation; }
  inline function set_rotation(val:Float):Float { return this.body.rotation = val; }

  inline function get_scaleX():Float { return this.body.scaleX; }
  inline function set_scaleX(val:Float):Float { return this.body.scaleX = val; }

  inline function get_scaleY():Float { return this.body.scaleY; }
  inline function set_scaleY(val:Float):Float { return this.body.scaleY = val; }

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

  inline function get_renderable():Bool { return this.components.has(Renderable); }
  
  inline function get_collidable():Bool { return this.components.has(Collidable); }

  inline function get_hasMotion():Bool { return this.motion != null; }

  inline function get_inScene():Bool { return this.scene != null; }

}
