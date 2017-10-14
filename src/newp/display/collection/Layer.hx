package newp.display.collection;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

class Layer implements Collection {

  var items:Array<DisplayObject>;
  var sortFunc:DisplayObject->DisplayObject->Int = null;

  // Properties

  public var name(default, null):String;

  public var container(default, null):DisplayObjectContainer;

  public var length(get, never):Int;

  public var sortable(get, never):Bool;

  public function new(name:String) {
    this.name = name;
    this.items = [];
    this.container = new Sprite();
  }

  // Collection Interface
  // ====================

  public function iterator():Iterator<DisplayObject> {
    return this.items.iterator();
  }

  public function merge(collection:Collection) {
    for (item in collection) {
      collection.remove(item);
      this.add(item);
    }
  }

  public function contains(graphic:DisplayObject):Bool {
    return this.container.contains(graphic);
  }

  public function add(graphic:DisplayObject, ?group:String):Void {
    this.items.push(graphic);
    this.container.addChild(graphic);
  }

  public function remove(graphic:DisplayObject):Void {
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

  inline function get_length():Int { return this.items.length; }

  inline function get_sortable():Bool { return this.sortFunc != null; }

}