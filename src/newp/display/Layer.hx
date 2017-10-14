package newp.display;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

class Layer {

  var items:Array<DisplayObject>;
  var sortFunc:DisplayObject->DisplayObject->Int;

  public var name(default, null):String;
  public var sortable(default, null):Bool;
  public var container(default, null):DisplayObjectContainer;
  public var count(get, never):Int;

  public function new(name:String, ?sortFunc:DisplayObject->DisplayObject->Int) {
    this.name = name;
    this.items = [];
    this.container = new Sprite();
    this.sortFunc = sortFunc;
    this.sortable = sortFunc != null;
  }

  // remove the display objects from the other layer and add them to this layer
  public function merge(layer:Layer) {
    for (item in layer.items) {
      layer.remove(item);
      this.add(item);
    }
  }

  public function sort() {
    if (!this.sortable) return;
    this.items.sort(this.sortFunc);
    for (i in 0...items.length) {
      this.container.setChildIndex(items[i], i);
    }
  }

  public function sortBy(?func:DisplayObject->DisplayObject->Int) {
    this.sortFunc = func;
    this.sortable = this.sortFunc != null;
    if (this.sortable) this.sort();
  }

  // Sprite Methods
  // ==============

  public function contains(graphic:DisplayObject):Bool {
    return this.container.contains(graphic);
  }

  public function add(graphic:DisplayObject):Void {
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


  inline function get_count():Int { return this.items.length; }

}