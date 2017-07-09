package newp.collision;

import newp.collision.shapes.Shape;
import openfl.display.Sprite;

// A Simple Bin collection of colliders
// - only compare colliders in the same bins to reduce the number of computations
// TODO: create a taggable collection to do collision checking of tag groups, or single shape vs tag group(s)
class Collection {

  var container_w:Int;
  var container_h:Int;
  var shapeContainerMap:Map<Shape, Array<String>>;
  var containers:Map<String, Array<Shape>>;
  var shapeCollision:ShapeCollision;
  var debugShape:Sprite;

  public var shapes:Array<Shape> = [];
  
  public function new(width:Int = 256, ?height:Int = null) {
    this.container_w = width;
    this.container_h = height == null ? width : height;
    this.shapeContainerMap = new Map();
    this.containers = new Map();
    this.shapeCollision = new ShapeCollision();
    if (Lib.debug) {
      this.debugShape = new Sprite();
      Lib.main.addChild(debugShape);  
    }
  }

  // Update the containers a shape is in
  public function updateShape(shape:Shape) {
    keys_prev = this.shapeContainerMap.get(shape);
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

    this.shapeContainerMap.set(shape, keys);
  }

  public function collisionTestAll(callback:Shape->ShapeCollision->Void):Void {
    // Look through each container of shapes
    for (containerKey in containers.keys()) {
      var container = containers.get(containerKey);
      if (container.length == 0) continue;
      // test all shapes in the container with one another
      this.collisionTest_innerLoop(container, callback);
    }
  }

  public function collisionTestShape(shape:Shape, callback:Shape->ShapeCollision->Void):Void {
    var keys = this.shapeContainerMap.get(shape);
    for (containerKey in keys) {
      var container = containers.get(containerKey);
      if (container.length == 1) continue; // it's just our shape in there
      // test our shape against the container's other shapes
      this.collisionTest_shape(shape, container, callback);
    }
  }

  inline function collisionTest_innerLoop(container:Array<Shape>, callback):Void {
    for (i in 0...container.length) this.collisionTest_shape(container[i], container, callback);
  }

  inline function collisionTest_shape(shape:Shape, container:Array<Shape>, callback:Shape->ShapeCollision->Void):Void {
    for (i in 0...container.length) {
      var other:Shape = container[i];
      if (shape == other) continue;
      if (shape.test(other, shapeCollision) != null) callback(shape, shapeCollision);
    }
  }

  // public function collisionTestSweep(shape:Shape, )

  public function add(shape:Shape):Void {
    this.shapeContainerMap.set(shape, []);
    this.shapes.push(shape);

    var containerKeys = this.getContainerKeysForShape(shape);

    for (key in containerKeys) {
      this.getContainer(key).push(shape);
    }
  }

  public function remove(shape:Shape):Bool {
    if (this.shapes.indexOf(shape) == -1) return false;

    var containerKeys = this.shapeContainerMap.get(shape);

    // remove it from all containers it was in
    for (key in containerKeys) {
      this.getContainer(key).remove(shape);
    }

    // remove that list from the map
    this.shapeContainerMap.remove(shape);
    // remove the shape
    return this.shapes.remove(shape);
  }

  // +-------------------------
  // | Helpers
  // +-------------------------

  inline function aNotInB(a:Array<String>, b:Array<String>, out:Array<String>):Array<String> {
    // clear out
    while(out.length > 0) out.pop();

    for (o in a) {
      if (b.indexOf(o) == -1) out.push(o);
    }

    return out;
  }

  inline function getContainer(key:String):Array<Shape> {
    if (!this.containers.exists(key)) {
      this.containers.set(key, []);
      if (Lib.debug) this.debug_draw_rect(key);
    }
    return this.containers.get(key);
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

  inline function debug_draw_rect(key:String):Void {
    var xy = key.split('|');
    var x = Std.parseInt(xy[0]);
    var y = Std.parseInt(xy[1]);
    var g = debugShape.graphics;
    var xx = x * this.container_w;
    var yy = y * this.container_h;
    g.lineStyle(1, 0x999999, 0.3);
    g.moveTo(xx, yy);
    g.drawRect(xx, yy, this.container_w, this.container_h);
  }


  var keys_prev:Array<String>;
  var keys_to_remove:Array<String> = [];
  var keys_to_add:Array<String> = [];

}
