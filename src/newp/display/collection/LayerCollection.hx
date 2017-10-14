package newp.display.collection;

import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;


interface LayerCollection extends Collection {

  public var layerNames(default, null):Array<String>;

  // Layer Methods
  // =============

  public function layers():Iterator<Layer>;

  // Add a layer to the top
  public function makeLayer(name:String):Layer;

  public function getLayer(name:String):Layer;

  public function hideLayer(name:String):Void;

  public function sortLayer(name:String, ?sortFunc:DisplayObject->DisplayObject->Int):Void;

}