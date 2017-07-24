package newp.display.collection;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;


interface Collection {

  public var length(get, never):Int;

  public var container(default, null):DisplayObjectContainer;

  // Layer Methods
  // =============

  // Add a layer to the top
  public function addLayer(name:String):Layer;

  public function getLayer(name:String):Layer;

  public function hideLayer(name:String):Void;

  public function sortLayer(name:String, ?sortFunc:DisplayObject->DisplayObject->Int):Void ;

  // Sprite Methods
  // ==============

  // add new, or adjust the layer of a graphic
  public function addSprite(graphic:DisplayObject, ?layer:String):Void;

  public function removeSprite(graphic:DisplayObject):Void;

  public function setSpriteIndex(graphic:DisplayObject, index:Int):Void;

}