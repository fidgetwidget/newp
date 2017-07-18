package newp.components.collection;

import newp.collision.shapes.Shape;
import newp.components.*;
import openfl.display.Sprite;


class ComponentCollection implements Collection {

  var allComponents:Array<Component> = [];
  var componentTypeMap:Map<String, Array<Component>>;
  var renderable_type:String;
  var updateable_type:String;
  var collidable_type:String;

  // Properties
  public var updateables:Array<Updateable> = [];

  public var renderables:Array<Renderable> = [];

  public var collidables:Array<Collidable> = [];

  public var sprites(default, null):Array<Sprite> = [];

  public var colliders(default, null):Array<Shape> = [];

  public function new() {
    this.componentTypeMap = new Map();
    this.renderable_type = Type.getClassName(Renderable);
    this.updateable_type = Type.getClassName(Updateable);
    this.collidable_type = Type.getClassName(Collidable);
  }

  public function add(c:Component):Void {
    this.allComponents.push(c);
    if (c.updateable) this.addUpdateable(c);
    if (c.renderable) this.addRenderable(c);
    if (c.collidable) this.addCollidable(c);
    this.addToTypeMap(c);
  }

  public function remove(c:Component):Void {
    this.allComponents.remove(c);
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

  public function iterator():Iterator<Component> { return this.allComponents.iterator(); }

  // Internal Methods
  // ==============

  inline function addUpdateable(c:Component) { 
    this.updateables.push(cast(c, Updateable)); 
  }

  inline function removeUpdateable(c:Component) { 
    this.updateables.remove(cast(c, Updateable)); 
  }

  inline function addRenderable(c:Component) {
    var com:Renderable = cast c;
    this.renderables.push(com);
    this.sprites.push(com.sprite);
  }

  inline function removeRenderable(c:Component) {
    var com:Renderable = cast c;
    this.renderables.remove(com);
    this.sprites.remove(com.sprite);
  }

  inline function addCollidable(c:Component) {
    var com:Collidable = cast c;
    this.collidables.push(com);
    this.colliders.push(com.shape);
  }

  inline function removeCollidable(c:Component) {
    var com:Collidable = cast c;
    this.collidables.remove(com);
    this.colliders.remove(com.shape);
  }

  inline function addToTypeMap(c:Component) {
    if (c.renderable) this.addTypeToTypeMap(c, renderable_type);
    if (c.updateable) this.addTypeToTypeMap(c, updateable_type);
    if (c.collidable) this.addTypeToTypeMap(c, collidable_type);

    this.addTypeToTypeMap(c, c.type);
  }

  inline function removeFromTypeMap(c:Component) {
    if (c.renderable) this.componentTypeMap[renderable_type].remove(c);
    if (c.updateable) this.componentTypeMap[updateable_type].remove(c);
    if (c.collidable) this.componentTypeMap[collidable_type].remove(c);
    
    this.componentTypeMap[c.type].remove(c);
  }

  inline function addTypeToTypeMap(c:Component, type:String) {
    if (!this.componentTypeMap.exists(type)) this.componentTypeMap.set(type, []);
      this.componentTypeMap[type].push(c);
  }

}
