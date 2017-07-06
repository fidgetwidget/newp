package newp.collision;

import newp.collision.shapes.Shape;


class Collection {

  var size:Int;
  var containerWidth:Int;
  var containerHeight:Int;
  var shapeContainerMap:Map<Shape, Array<String>>;
  var containers:Map<String, Array<Shape>>;
  var shapeCollision:ShapeCollision;

  public var shapes:Array<Shape> = [];
  
  public function new(size:Int) {
    this.size = size;
    this.containerWidth = size;
    this.containerHeight = size;
    this.shapeContainerMap = new Map();
    this.containers = new Map();
    this.shapeCollision = new ShapeCollision();
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

  public inline function collisionTest(callback:Shape->ShapeCollision->Void):Void {
    // Look through each container of shapes
    for (containerKey in containers.keys()) {
      var container = containers.get(containerKey);
      if (container.length == 0) continue;
      // test all shapes in the container with one another
      this.collisionTest_container(container, callback);
    }
  }

  public inline function collisionTest_container(container:Array<Shape>, callback):Void {
    for (i in 0...container.length) this.collisionTest_shape(container[i], container, callback);
  }

  public inline function collisionTest_shape(shape:Shape, container:Array<Shape>, callback):Void {
    for (i in 0...container.length) {
      var other:Shape = container[i];
      if (shape == other) continue;
      if (shape.test(other, shapeCollision) != null) callback(shape, shapeCollision);
    }
  }

  public function add(shape:Shape):Void {
    this.shapeContainerMap.set(shape, []);
    this.shapes.push(shape);

    var containerKeys = this.getContainerKeysForShape(shape);

    for (key in containerKeys) {
      this.getContainer(key).push(shape);
    }
  }

  public function remove(shape:Shape):Void {
    if (this.shapes.indexOf(shape) == -1) return;

    var containerKeys = this.shapeContainerMap.get(shape);

    // remove it from all containers it was in
    for (key in containerKeys) {
      this.getContainer(key).remove(shape);
    }

    // remove that list from the map
    this.shapeContainerMap.remove(shape);
    // remove the shape
    this.shapes.remove(shape);
  }

  

  function aNotInB(a:Array<String>, b:Array<String>, out:Array<String>):Array<String> {
    // clear out
    while(out.length > 0) out.pop();

    for (o in a) {
      if (b.indexOf(o) == -1) out.push(o);
    }

    return out;
  }


  function getContainer(key:String):Array<Shape> {
    if (!this.containers.exists(key)) {
      this.containers.set(key, []);
    }
    return this.containers.get(key);
  }


  function getContainerKeysForShape(shape:Shape):Array<String> {
    var bounds = shape.bounds;
    var minX = bounds.minX;
    var maxX = bounds.maxX;
    var minY = bounds.minY;
    var maxY = bounds.maxY;
    var cx = Math.floor(minX / this.containerWidth);
    var dx = Math.floor(maxX / this.containerWidth) - cx;
    var cy = Math.floor(minY / this.containerHeight);
    var dy = Math.floor(maxY / this.containerHeight) - cy;
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


  var keys_prev:Array<String>;
  var keys_curr:Array<String>;
  var keys_to_remove:Array<String> = [];
  var keys_to_add:Array<String> = [];

}
