package newp.display.collection;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;


interface Collection {

  public var length(get, never):Int;

  public var container(default, null):DisplayObjectContainer;

  // Layer Methods
  // =============

  // Add a layer to the top
  public function addLayer(name:String):Layer;

  public function getLayer(name:String):Layer;

  public function hideLayer(name:String):Void;

  public function sortLayer(name:String, ?sortFunc:Sprite->Sprite->Int):Void ;

  // Sprite Methods
  // ==============

  // add new, or adjust the layer of a sprite
  public function addSprite(sprite:Sprite, ?layer:String):Void;

  public function removeSprite(sprite:Sprite):Void;

  public function setSpriteIndex(sprite:Sprite, index:Int):Void;

}