package newp.collision.collections;

import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;
import openfl.display.Sprite;

// A Simple Bin collection of colliders
// - only compare colliders in the same bins to reduce the number of computations
class ShapeBins implements Collection {

  var container_w:Int;
  var container_h:Int;
  var shapeBinMap:Map<Shape, Array<String>>;
  var bins:Map<String, Array<Shape>>;

  public var drawDebug(get, set):Bool;
  public var shapes:Array<Shape> = [];


  public function new(width:Int = 256, ?height:Int = null) {
    this.container_w = width;
    this.container_h = height == null ? width : height;
    
    this.bins = new Map();
    this.shapeBinMap = new Map();
  }


  // +-------------------------
  // | Updates 
  // +-------------------------

  public function update(shape:Shape) {
    keys_prev = this.shapeBinMap.get(shape);
    var keys = this.getContainerKeysForShape(shape);
    
    this.aNotInB(keys_prev, keys, keys_to_remove);
    this.aNotInB(keys, keys_prev, keys_to_add);
    
    for (key in keys_to_remove) {
      this.getContainer(key).remove(shape);
    }

    for (key in keys_to_add) {
      var container = this.getContainer(key);
      if (container.indexOf(shape) < 0) container.push(shape);
    }

    this.shapeBinMap.set(shape, keys);
  }

  public function updateAll():Void {
    for (shape in shapes) {
      this.update(shape); 
    }
  }

  // +-------------------------
  // | Collision Tests 
  // +-------------------------

  public function collisionTest(shape:Shape, callback:Shape->ShapeCollision->Void):Void {
    this.collisionTestWithTag(shape, [], callback);
  }

  public function collisionTestWithTag(shape:Shape, tags:Dynamic, callback:Shape->ShapeCollision->Void):Void {
    var tagArray:Array<String> = this.getTagArray(tags);
    var keys = this.shapeBinMap.get(shape);
    for (containerKey in keys) {
      var container = bins.get(containerKey);
      if (container.length == 1) continue; // it's just our shape in there
      // test our shape against the container's other shapes
      this.collisionTest_shape(shape, tagArray, container, callback);
    }
  }

  public function collisionTestAll(callback:Shape->ShapeCollision->Void):Void {
    this.collisionTestAllWithTag([], callback);
  }

  public function collisionTestAllWithTag(tags:Dynamic, callback:Shape->ShapeCollision->Void):Void {
    var tagArray:Array<String> = this.getTagArray(tags);
    // Look through each container of shapes
    for (containerKey in bins.keys()) {
      var container = bins.get(containerKey);
      if (container.length == 0) continue;
      // test all shapes in the container with one another
      this.collisionTestAll_innerLoop(tagArray, container, callback);
    }
  }

  // +-------------------------
  // | Add / Remove 
  // +-------------------------

  public function add(shape:Shape):Void {
    this.shapeBinMap.set(shape, []);
    this.shapes.push(shape);

    var keys = this.getContainerKeysForShape(shape);

    for (key in keys) {
      this.getContainer(key).push(shape);
    }
  }

  public function remove(shape:Shape):Void {
    if (this.shapes.indexOf(shape) == -1) return;

    var keys = this.shapeBinMap.get(shape);

    // remove it from all bins it was in
    for (key in keys) {
      this.getContainer(key).remove(shape);
    }

    // remove that list from the map
    this.shapeBinMap.remove(shape);
    // remove the shape
    this.shapes.remove(shape);
  }

  // +-------------------------
  // | Internal 
  // +-------------------------

  inline function collisionTestAll_innerLoop(tags:Array<String>, container:Array<Shape>, callback):Void {
    for (i in 0...container.length) this.collisionTest_shape(container[i], tags, container, callback);
  }

  inline function collisionTest_shape(shape:Shape, tags:Array<String>, container:Array<Shape>, callback:Shape->ShapeCollision->Void):Void {
    for (i in 0...container.length) {
      var other:Shape = container[i];
      if (shape == other) continue;
      if (!this.hasTag(shape, tags)) continue;
      if (shape.test(other, shapeCollision) != null) callback(shape, shapeCollision);
    }
  }

  // +-------------------------
  // | Helpers
  // +-------------------------

  inline function getTagArray(tags:Dynamic):Array<String> {
    var tagArray:Array<String>;
    if ( Std.is(tags, String) ) { 
      tagArray = [tags]; 
    } else if ( Std.is(tags, Array) ) { 
      tagArray = tags; 
    } else { 
      throw "tags must be either a String, or an Array of Strings"; 
    }
    return tagArray;
  }

  inline function hasTag(shape:Shape, tags:Array<String>):Bool {
    return tags.length == 0 || this.mapContainsValue(shape.tags, tags);
  }

  function mapContainsValue(map:Map<String, String>, array:Array<String>):Bool {
    for (str in array) { 
      if (map.exists(str)) return true; 
    }
    return false;
  }

  inline function aNotInB(a:Array<String>, b:Array<String>, out:Array<String>):Array<String> {
    // clear out
    while(out.length > 0) out.pop();
    for (o in a) { if (b.indexOf(o) == -1) out.push(o); }
    return out;
  }

  inline function getContainer(key:String):Array<Shape> {
    if (!this.bins.exists(key)) {
      this.bins.set(key, []);
      if (this.drawDebug) this.debugDraw_bin(key);
    }
    return this.bins.get(key);
  }

  inline function getContainerKeysForShape(shape:Shape):Array<String> {
    var bounds = shape.bounds;
    var minX = bounds.minX;
    var maxX = bounds.maxX;
    var minY = bounds.minY;
    var maxY = bounds.maxY;
    var cx = Math.floor(minX / this.container_w);
    var dx = Math.floor(maxX / this.container_w) - cx;
    var cy = Math.floor(minY / this.container_h);
    var dy = Math.floor(maxY / this.container_h) - cy;
    var keys = [];
    // trace('${cx} ${dx} ${cy} ${dy}');
    for (x in 0...dx+1) {
      for (y in 0...dy+1) {
        keys.push('${x + cx}|${y + cy}');  
      }
    }
    // trace(keys);
    return keys;
  }

  inline function debugDraw_bin(key:String):Void {
    var xy = key.split('|');
    var x = Std.parseInt(xy[0]);
    var y = Std.parseInt(xy[1]);
    var g = debugSprite.graphics;
    var xx = x * this.container_w;
    var yy = y * this.container_h;
    g.lineStyle(1, 0x999999, 0.3);
    g.moveTo(xx, yy);
    g.drawRect(xx, yy, this.container_w, this.container_h);
  }


  // +-------------------------
  // | Properties
  // +-------------------------

  inline function get_drawDebug():Bool { return this._drawDebug; }
  inline function set_drawDebug(val:Bool):Bool {
    this._drawDebug = val;
    if (val) {
      if (this.debugSprite == null) this.debugSprite = new Sprite();
      Lib.main.addChild(this.debugSprite);
    } else {
      Lib.main.removeChild(this.debugSprite);
    }
    return val;
  }


  var shapeCollision:ShapeCollision = new ShapeCollision();
  var debugSprite:Sprite;
  var _drawDebug:Bool = false;
  // reused pointer
  var keys_prev:Array<String>;
  // reused arrays
  var keys_to_remove:Array<String> = [];
  var keys_to_add:Array<String> = [];

}
