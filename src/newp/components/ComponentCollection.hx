package newp.components;

import newp.collision.shapes.Shape;
import openfl.display.Sprite;


class ComponentCollection {

  public var updateables:Array<Updateable> = [];
  public var renderables:Array<Renderable> = [];
  public var collidables:Array<Collidable> = [];

  public var sprites(get, never):Array<Sprite>;
  public var colliders(get, never):Array<Shape>;

  var components:Array<Component> = [];
  var componentTypeMap:Map<String, Array<Component>>;

  var renderable_type:String;
  var updateable_type:String;
  var collidable_type:String;

  public function new() {
    this.componentTypeMap = new Map();
    this.renderable_type = Type.getClassName(Renderable);
    this.updateable_type = Type.getClassName(Updateable);
    this.collidable_type = Type.getClassName(Collidable);
  }

  public function add(c:Component):Void {
    this.components.push(c);
    if (c.updateable) this.addUpdateable(c);
    if (c.renderable) this.addRenderable(c);
    if (c.collidable) this.addCollidable(c);
    this.addToTypeMap(c);
  }

  public function remove(c:Component):Void {
    this.components.remove(c);
    if (c.updateable) this.removeUpdateable(c);
    if (c.renderable) this.removeRenderable(c);
    if (c.collidable) this.removeCollidable(c);
    this.removeFromTypeMap(c);
  }

  public function has(type:Dynamic):Bool {
    var key:String = Std.is(type, String) ? type : Type.getClassName(type);
    if (!componentTypeMap.exists(key)) return false;
    return componentTypeMap[key].length > 0;
  }


  public function iterator():Iterator<Component> { return this.components.iterator(); }


  inline function addUpdateable(c:Component) { this.updateables.push(cast(c, Updateable)); }

  inline function removeUpdateable(c:Component) { this.updateables.remove(cast(c, Updateable)); }

  inline function addRenderable(c:Component) {
    var com:Renderable = cast c;
    this.renderables.push(com);
    this._sprites.push(com.sprite);
  }

  inline function removeRenderable(c:Component) {
    var com:Renderable = cast c;
    this.renderables.remove(com);
    this._sprites.remove(com.sprite);
  }

  inline function addCollidable(c:Component) {
    var com:Collidable = cast c;
    this.collidables.push(com);
    this._colliders.push(com.shape);
  }

  inline function removeCollidable(c:Component) {
    var com:Collidable = cast c;
    this.collidables.remove(com);
    this._colliders.remove(com.shape);
  }

  inline function addToTypeMap(c:Component) {
    if (c.renderable) {
      if (!componentTypeMap.exists(renderable_type)) componentTypeMap.set(renderable_type, []);
      componentTypeMap[renderable_type].push(c);  
    }

    if (c.updateable) {
      if (!componentTypeMap.exists(updateable_type)) componentTypeMap.set(updateable_type, []);
      componentTypeMap[updateable_type].push(c);  
    }

    if (c.collidable) {
      if (!componentTypeMap.exists(collidable_type)) componentTypeMap.set(collidable_type, []);
      componentTypeMap[collidable_type].push(c);
    }

    if (!componentTypeMap.exists(c.type)) componentTypeMap.set(c.type, []);
    componentTypeMap[c.type].push(c);
  }

  inline function removeFromTypeMap(c:Component) {
    if (c.renderable) componentTypeMap[renderable_type].remove(c);
    if (c.updateable) componentTypeMap[updateable_type].remove(c);
    if (c.collidable) componentTypeMap[collidable_type].remove(c);

    componentTypeMap[c.type].remove(c);
  }


  inline function get_sprites():Array<Sprite> { return this._sprites; }
  var _sprites:Array<Sprite> = [];

  inline function get_colliders():Array<Shape> { return this._colliders; }
  var _colliders:Array<Shape> = [];

}
