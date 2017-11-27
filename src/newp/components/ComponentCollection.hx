package newp.components;

import newp.collision.shapes.Shape;
import newp.components.*;
import openfl.display.Sprite;


class ComponentCollection implements ICollection {

  var allComponents:Array<IComponent> = [];
  var componentTypeMap:Map<String, Array<IComponent>>;
  var componentsByName:Map<String, IComponent>;
  var renderable_type:String;
  var updateable_type:String;
  var collidable_type:String;

  // Properties
  public var updateables:Array<IUpdateable> = [];

  public var renderables:Array<IRenderable> = [];

  public var collidables:Array<ICollidable> = [];

  public var sprites(default, null):Array<Sprite> = [];

  public var colliders(default, null):Array<Shape> = [];

  public function new() {
    this.componentTypeMap = new Map();
    this.componentsByName = new Map();
    this.renderable_type = Type.getClassName(IRenderable);
    this.updateable_type = Type.getClassName(IUpdateable);
    this.collidable_type = Type.getClassName(ICollidable);
  }

  public function add(c:IComponent):Void {
    this.allComponents.push(c);
    if (c.updateable) this.addUpdateable(c);
    if (c.renderable) this.addRenderable(c);
    if (c.collidable) this.addCollidable(c);
    this.addToTypeMap(c);
    this.componentsByName.set(c.name, c);
  }

  public function remove(c:IComponent):Void {
    this.allComponents.remove(c);
    if (c.updateable) this.removeUpdateable(c);
    if (c.renderable) this.removeRenderable(c);
    if (c.collidable) this.removeCollidable(c);
    this.removeFromTypeMap(c);
    this.componentsByName.remove(c.name);
  }

  public function has(type:Dynamic):Bool {
    var key:String = Std.is(type, String) ? type : Type.getClassName(type);
    if (!componentTypeMap.exists(key)) return false;
    return componentTypeMap[key].length > 0;
  }

  public function get(name:String):IComponent {
    if (!componentsByName.exists(name)) return null;
    return componentsByName[name];
  }

  public function iterator():Iterator<IComponent> { return this.allComponents.iterator(); }

  // Internal Methods
  // ==============

  inline function addUpdateable(c:IComponent) { 
    this.updateables.push(cast(c, IUpdateable)); 
  }

  inline function removeUpdateable(c:IComponent) { 
    this.updateables.remove(cast(c, IUpdateable)); 
  }

  inline function addRenderable(c:IComponent) {
    var com:IRenderable = cast c;
    this.renderables.push(com);
    this.sprites.push(com.sprite);
  }

  inline function removeRenderable(c:IComponent) {
    var com:IRenderable = cast c;
    this.renderables.remove(com);
    this.sprites.remove(com.sprite);
  }

  inline function addCollidable(c:IComponent) {
    var com:ICollidable = cast c;
    this.collidables.push(com);
    this.colliders.push(com.shape);
  }

  inline function removeCollidable(c:IComponent) {
    var com:ICollidable = cast c;
    this.collidables.remove(com);
    this.colliders.remove(com.shape);
  }

  inline function addToTypeMap(c:IComponent) {
    if (c.renderable) this.addTypeToTypeMap(c, renderable_type);
    if (c.updateable) this.addTypeToTypeMap(c, updateable_type);
    if (c.collidable) this.addTypeToTypeMap(c, collidable_type);

    this.addTypeToTypeMap(c, c.type);
  }

  inline function removeFromTypeMap(c:IComponent) {
    if (c.renderable) this.componentTypeMap[renderable_type].remove(c);
    if (c.updateable) this.componentTypeMap[updateable_type].remove(c);
    if (c.collidable) this.componentTypeMap[collidable_type].remove(c);
    
    this.componentTypeMap[c.type].remove(c);
  }

  inline function addTypeToTypeMap(c:IComponent, type:String) {
    if (!this.componentTypeMap.exists(type)) this.componentTypeMap.set(type, []);
      this.componentTypeMap[type].push(c);
  }

}
