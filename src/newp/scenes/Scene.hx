package newp.scenes;

import newp.Lib;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

class Scene {
  
  var sprites:Array<Sprite>;
  var renderTarget:Sprite;

  public var name (default, null) :String;
  // Scene display object container
  public var container (get, never) :DisplayObjectContainer;
  // Scene offset - camera positon
  public var x (get, set) :Float;
  public var y (get, set) :Float;
  
  public function new (name:String = '') { 
    this.name = name != '' ? name : Type.getClassName(Type.getClass(this));
    this.sprites = [];
    this.renderTarget = new Sprite();
  }

  public function rename (name:String) {
    this.name = name;
    // TODO: tell the list(s) it's in
  }

  public function update () :Void {
    // Logic goes here
  }

  // When the scene is made active
  public function begin () :Void {
    Lib.main.addChild(this.renderTarget);
  }

  // When the scene is removed
  public function end () :Void {
    Lib.main.removeChild(this.renderTarget);
  }

  public function addSprite (sprite:Sprite) :Int {
    this.addChild(sprite);
    this.sprites.push(sprite);
    return this.getChildIndex(sprite);
  }

  public function removeSprite (sprite:Sprite) :Bool {
    if (!this.contains(sprite)) { return false; }
    this.removeChild(sprite);
    return this.sprites.remove(sprite);
  }

  // DisplayObjectContainer Accessors
  public inline function addChild(child:DisplayObject):DisplayObject { return this.container.addChild(child); }
  public inline function addAtChild(child:DisplayObject, index:Int):DisplayObject { return this.container.addChildAt(child, index); }

  public inline function contains(child:DisplayObject):Bool { return this.container.contains(child); }

  public inline function getChildAt(index:Int):DisplayObject { return this.container.getChildAt(index); }
  public inline function getChildIndex(child:DisplayObject):Int { return this.container.getChildIndex(child); }
  
  public inline function removeChild(child:DisplayObject):DisplayObject { return this.container.removeChild(child); }
  public inline function removeChildAt(index:Int):DisplayObject { return this.container.removeChildAt(index); }
  public inline function removeChildren(beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void { this.container.removeChildren(beginIndex, endIndex); }

  public inline function setChildIndex(child:DisplayObject, index:Int):Void { this.container.setChildIndex(child, index); }

  public inline function swapChildren(childA:DisplayObject, childB:DisplayObject):Void { this.container.swapChildren(childA, childB); }
  public inline function swapChildrenAt(indexA:Int, indexB:Int):Void { this.container.swapChildrenAt(indexA, indexB); }
  
  // Properties
  
  inline function get_container():DisplayObjectContainer { return this.renderTarget; }

  inline function get_x():Float { return this.renderTarget.x; }
  inline function set_x(val:Float):Float { return this.renderTarget.x = val; }

  inline function get_y():Float { return this.renderTarget.y; }
  inline function set_y(val:Float):Float { return this.renderTarget.y = val; }
  
}