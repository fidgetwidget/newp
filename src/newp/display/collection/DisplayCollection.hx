package newp.display.collection;

import newp.display.Layer;
import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;
import openfl.display.Sprite;


class DisplayCollection implements Collection {

  var layerNames:Array<String>;
  var layers:Map<String, Layer>;
  var layerMap:Map<DisplayObject, Layer>;
  var count:Int = 0;

  public var length(get, never):Int;

  public var container(default, null):DisplayObjectContainer;

  public function new(?layerNames:Array<String>) {
    this.container = new Sprite();
    this.layers = new Map();
    this.layerNames = [];
    this.layerMap = new Map();
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

  public function sortLayer(name:String, ?sortFunc:DisplayObject->DisplayObject->Int):Void {
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

  // add new, or adjust the layer of a graphic
  public function addSprite(graphic:DisplayObject, ?layer:String):Void {
    if (layer == null) {
      var i = this.layerNames.length - 1;
      if (i < 0) throw "There must be a layer before we can add a Sprite to it";
      layer = this.layerNames[i]; // default to the top layer
    }

    if (!this.layers.exists(layer)) throw 'Layer[${layer}] doesn\'t Exist';

    if (this.layerMap.exists(graphic)) {
      this.layerMap[graphic].remove(graphic);
    } else {
      count++;
    }

    this.layerMap.set(graphic, this.layers[layer]);
    this.layers[layer].add(graphic);
  }

  public function removeSprite(graphic:DisplayObject):Void {
    if (!this.layerMap.exists(graphic)) return;

    this.layerMap[graphic].remove(graphic);
    this.layerMap.remove(graphic);
    count--;
  }

  public function setSpriteIndex(graphic:DisplayObject, index:Int):Void {
    if (!this.layerMap.exists(graphic)) return;

    this.layerMap[graphic].setChildIndex(graphic, index);
  }

  // 

  inline function get_length():Int { return count; }
}