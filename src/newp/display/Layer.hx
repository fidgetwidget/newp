package newp.display;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;

class Layer {

  var items:Array<Sprite>;
  var sortFunc:Sprite->Sprite->Int;

  public var name(default, null):String;
  public var sortable(default, null):Bool;
  public var container(default, null):DisplayObjectContainer;
  public var sprtieCount(get, never):Int;

  public function new(name:String, ?sortFunc:Sprite->Sprite->Int) {
    this.name = name;
    this.items = [];
    this.container = new Sprite();
    this.sortFunc = sortFunc;
    this.sortable = sortFunc != null;
  }

  public function sort() {
    if (!this.sortable) return;
    this.items.sort(this.sortFunc);
    for (i in 0...items.length) {
      this.container.setChildIndex(items[i], i);
    }
  }

  public function sortBy(?func:Sprite->Sprite->Int) {
    this.sortFunc = func;
    this.sortable = this.sortFunc != null;
    if (this.sortable) this.sort();
  }

  // Sprite Methods
  // ==============

  public function contains(sprite:Sprite):Bool {
    return this.container.contains(sprite);
  }

  public function add(sprite:Sprite):Void {
    this.items.push(sprite);
    this.container.addChild(sprite);
  }

  public function remove(sprite:Sprite):Void {
    this.items.remove(sprite);
    this.container.removeChild(sprite);
  }

  public function setChildIndex(sprite:Sprite, index:Int):Void {
    if (!this.container.contains(sprite)) return;
    this.container.setChildIndex(sprite, index);
  }


  inline function get_sprtieCount():Int { return this.items.length; }

}