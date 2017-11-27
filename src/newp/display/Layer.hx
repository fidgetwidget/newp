package newp.display;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

class Layer extends Group implements ICollection {

  // Group:
  // var items:Array<DisplayObject>;
  // public var name(default, null):String;
  // public var length(get, never):Int;
  
  var sortFunc:DisplayObject->DisplayObject->Int = null;

  // Properties

  public var container(default, null):DisplayObjectContainer;

  public var sortable(get, never):Bool;

  public function new(name:String) {
    super(name);
    this.container = new Sprite();
  }

  // Methods
  // =======

  override public function merge(collection:ICollection) {
    for (item in collection) {
      collection.remove(item);
      this.add(item);
    }
  }

  override public function add(graphic:DisplayObject, ?group:String):Void {
    this.items.push(graphic);
    this.container.addChild(graphic);
  }

  override public function remove(graphic:DisplayObject):Void {
    this.items.remove(graphic);
    this.container.removeChild(graphic);
  }

  public function setChildIndex(graphic:DisplayObject, index:Int):Void {
    if (!this.container.contains(graphic)) return;
    this.container.setChildIndex(graphic, index);
  }

  // Sortable
  // ========

  public function sort() {
    if (this.sortFunc == null) return;
    this.items.sort(this.sortFunc);
    for (i in 0...items.length) {
      this.container.setChildIndex(items[i], i);
    }
  }

  public function sortBy(?func:DisplayObject->DisplayObject->Int) {
    this.sortFunc = func;
    this.sort();
  }

  // Property Getters/Setters

  inline function get_sortable():Bool { return this.sortFunc != null; }

}