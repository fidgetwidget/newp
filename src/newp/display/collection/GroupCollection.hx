package newp.display.collection;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;


interface GroupCollection extends Collection {

  public var groupNames(default, null):Array<String>;

  public function groups():Iterator<Collection>;

  public function makeGroup(name:String):Collection;

  public function getGroup(name:String):Collection;

  public function hideGroup(name:String):Void;

  public function sortGroup(name:String, ?sortFunc:DisplayObject->DisplayObject->Int):Void;

}