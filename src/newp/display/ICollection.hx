package newp.display;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;


interface ICollection {

  public var name(default, null):String;

  public var length(get, never):Int;

  public function iterator():Iterator<DisplayObject>;

  public function merge(collection:ICollection):Void;

  public function add(graphic:DisplayObject, ?group:String):Void;

  public function remove(graphic:DisplayObject):Void;

}