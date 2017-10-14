package newp.display.collection;

// import newp.display.Layer;
import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;
import openfl.display.Sprite;


class DisplayCollection implements LayerCollection implements Collection {

  var layerByName:Map<String, Layer>;
  var layerByGraphic:Map<DisplayObject, Layer>;
  var count:Int = 0;

  public var name(default, null):String;

  public var length(get, never):Int;

  // This also indicates the layer order
  public var layerNames(default, null):Array<String>;

  public var container(default, null):DisplayObjectContainer;

  public function new(name:String, ?layerNames:Array<String>) {
    this.name = name;
    this.container = new Sprite();
    this.layerNames = [];
    this.layerByName = new Map();
    this.layerByGraphic = new Map();
    // if we have layers to add
    for (name in layerNames) {
      this.makeLayer(name);
    }
  }

  public function iterator():Iterator<DisplayObject> {
    return this.layerByGraphic.keys();
  }

  public function layers():Iterator<Layer> {
    return this.layerByName.iterator();
  }

  public function merge(collection:Collection):Void {
    if (Std.is(collection, GroupCollection)) {
      var spriteList = cast(collection, GroupCollection);
      for (name in spriteList.groupNames) {
        var sprites = spriteList.getGroup(name);
        for (sprite in sprites) {
          this.layerByName[name].add(sprite);
        }
      }
    }
    else if (Std.is(collection, LayerCollection)) {
      var layerCollection = cast(collection, LayerCollection);
      for (name in layerCollection.layerNames) {
        var layer = layerCollection.getLayer(name);
        this.layerByName[name].merge(layer);
      }
    } 
    else {
      for (sprite in collection) {
        collection.remove(sprite);
        this.add(sprite);
      }
    }
  }

  // Layer Methods
  // =============

  // Add a layer to the top
  public function makeLayer(name:String):Layer {
    var layer:Layer;
    if (this.layerByName.exists(name)) {
      layer = this.layerByName.get(name);
      // TODO: reorder things to have this layer be the last one instead
      return layer;
    }

    layer = new Layer(name);
    this.layerNames.push(name);
    this.container.addChild(layer.container);
    this.layerByName.set(name, layer);
    return layer;
  }

  public function getLayer(name:String):Layer {
    if (!this.layerByName.exists(name)) throw 'Layer[${name}] doesn\'t Exist';

    return this.layerByName[name];
  }

  public function hideLayer(name:String):Void {
    if (!this.layerByName.exists(name)) throw 'Layer[${name}] doesn\'t Exist';
    var layer:Layer = this.layerByName[name];
    layer.container.visible = false;
  }

  public function sortLayer(name:String, ?sortFunc:DisplayObject->DisplayObject->Int):Void {
    if (!this.layerByName.exists(name)) throw 'Layer[${name}] doesn\'t Exist';
    
    var layer:Layer = this.layerByName[name];
    if (!layer.sortable && sortFunc == null) return;

    if (sortFunc != null) {
      layer.sortBy(sortFunc);
    } else {
      layer.sort();
    }
  }

  // Collection Methods
  // ==================

  // add new, or adjust the layer of a graphic
  public function add(graphic:DisplayObject, ?group:String):Void {
    if (group == null) {
      var i = this.layerNames.length - 1;
      if (i < 0) throw "There must be a layer before we can add a Sprite to it";
      group = this.layerNames[i]; // default to the top layer
    }

    if (!this.layerByName.exists(group)) throw 'Layer[${group}] doesn\'t Exist';

    if (this.layerByGraphic.exists(graphic)) {
      this.layerByGraphic[graphic].remove(graphic);
    } else {
      count++;
    }

    this.layerByGraphic.set(graphic, this.layerByName[group]);
    this.layerByName[group].add(graphic);
  }

  public function remove(graphic:DisplayObject):Void {
    if (!this.layerByGraphic.exists(graphic)) return;

    this.layerByGraphic[graphic].remove(graphic);
    this.layerByGraphic.remove(graphic);
    count--;
  }

  public function setChildIndex(graphic:DisplayObject, index:Int):Void {
    if (!this.layerByGraphic.exists(graphic)) return;

    this.layerByGraphic[graphic].setChildIndex(graphic, index);
  }

  // 

  inline function get_length():Int { return count; }
}