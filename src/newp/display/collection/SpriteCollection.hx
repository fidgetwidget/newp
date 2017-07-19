package newp.display.collection;

import newp.display.Layer;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;


class SpriteCollection implements Collection {

  var layerNames:Array<String>;
  var layers:Map<String, Layer>;
  var spriteLayerMap:Map<Sprite, Layer>;
  var count:Int = 0;

  public var length(get, never):Int;

  public var container(default, null):DisplayObjectContainer;

  public function new(?layerNames:Array<String>) {
    this.container = new Sprite();
    this.layers = new Map();
    this.layerNames = [];
    this.spriteLayerMap = new Map();
    // if we have layers to add
    for (name in layerNames) {
      this.addLayer(name);
    }
  }

  // Layer Methods
  // =============

  // Add a layer to the top
  public function addLayer(name:String):Layer {
    var layer:Layer;
    if (this.layers.exists(name)) {
      layer = this.layers.get(name);
      // TODO: reorder things to have this layer be the last one instead
      return layer;
    }

    layer = new Layer(name);
    this.layerNames.push(name);
    this.container.addChild(layer.container);
    this.layers.set(name, layer);
    return layer;
  }

  public function getLayer(name:String):Layer {
    if (!this.layers.exists(name)) throw 'Layer[${name}] doesn\'t Exist';

    return this.layers[name];
  }

  public function hideLayer(name:String):Void {
    if (!this.layers.exists(name)) throw 'Layer[${name}] doesn\'t Exist';

    this.layers[name].container.visible = false;
  }

  public function sortLayer(name:String, ?sortFunc:Sprite->Sprite->Int):Void {
    if (!this.layers.exists(name)) throw 'Layer[${name}] doesn\'t Exist';
    
    var layer = this.layers[name];
    if (!layer.sortable && sortFunc == null) return;

    if (sortFunc != null) {
      layer.sortBy(sortFunc);
    } else {
      layer.sort();
    }
  }

  // Sprite Methods
  // ==============

  // add new, or adjust the layer of a sprite
  public function addSprite(sprite:Sprite, ?layer:String):Void {
    if (layer == null) {
      var i = this.layerNames.length - 1;
      if (i < 0) throw "There must be a layer before we can add a Sprite to it";
      layer = this.layerNames[i]; // default to the top layer
    }

    if (!this.layers.exists(layer)) throw 'Layer[${layer}] doesn\'t Exist';

    if (this.spriteLayerMap.exists(sprite)) {
      this.spriteLayerMap[sprite].remove(sprite);
    } else {
      count++;
    }

    this.spriteLayerMap.set(sprite, this.layers[layer]);
    this.layers[layer].add(sprite);
  }

  public function removeSprite(sprite:Sprite):Void {
    if (!this.spriteLayerMap.exists(sprite)) return;

    this.spriteLayerMap[sprite].remove(sprite);
    this.spriteLayerMap.remove(sprite);
    count--;
  }

  public function setSpriteIndex(sprite:Sprite, index:Int):Void {
    if (!this.spriteLayerMap.exists(sprite)) return;

    this.spriteLayerMap[sprite].setChildIndex(sprite, index);
  }

  // 

  inline function get_length():Int { return count; }
}