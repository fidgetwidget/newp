package newp.display.collection;

import openfl.display.DisplayObject;

class Group implements Collection {

  var items:Array<DisplayObject>;

  // Properties

  public var name(default, null):String;

  public var length(get, never):Int;

  public function new(name:String) {
    this.name = name;
    this.items = [];
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
    for (item in items) {
      if (item == graphic) return true;
    }
    return false;
  }

  public function add(graphic:DisplayObject, ?group:String):Void {
    this.items.push(graphic);
  }

  public function remove(graphic:DisplayObject):Void {
    this.items.remove(graphic);
  }

  // Property Getters/Setters

  inline function get_length():Int { return this.items.length; }

}