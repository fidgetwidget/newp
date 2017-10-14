package newp.display.collection;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;


interface Collection {

  public var name(default, null):String;

  // public var container(default, null):DisplayObjectContainer;

  public var length(get, never):Int;

  public function iterator():Iterator<DisplayObject>;

  // Add another Collection into this one.
  public function merge(collection:Collection):Void;

  public function add(graphic:DisplayObject, ?group:String):Void;

  public function remove(graphic:DisplayObject):Void;

  // public function setChildIndex(graphic:DisplayObject, index:Int):Void;

}