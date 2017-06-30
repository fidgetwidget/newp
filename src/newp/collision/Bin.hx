package newp.collision;

import newp.collision.shapes.Shape;


class Bin {

  var size:Int;
  var bounds:Bounds;

  var shapes:Array<Shape>;
  var shapeContainerMap:Map<Shape, Array<String>>;
  var containers:Map<String, Array<Shape>>;
  
  public function new(size:Int) {
    this.size = size;
    this.bounds = Bounds.make(0, 0, size, size);
    this.containers = new Map();
  }

  // Update the containers a shape is in
  public function update(shape:Shape) {
    thenKeys = this.shapeContainerMap.get(shape);
    nowKeys  = this.getContainerKeysForShape(shape);
    this.aNotInB(thenKeys, nowKeys, keys_to_remove);
    this.aNotInB(nowKeys, wasKeys, keys_to_add);

    for (key in keys_to_remove) {
      this.getContainer(key).remove(shape);
    }

    for (key in keys_to_add) {
      this.getContainer(key).push(shape);
    }
  }

  public function addShape(shape:Shape):Void {
    this.shapeContainerMap.set(shape, []);
    this.shapes.push(shape);

    var containerKeys = this.getContainerKeysForShape(shape);

    for (key in containerKeys) {
      this.getContainer(key).push(shape);
    }
  }

  public function removeShape(shape:Shape):Void {
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
    return []
  }


  var thenKeys:Array<String>;
  var nowKeys:Array<String>;
  var keys_to_remove:Array<String> [];
  var keys_to_add:Array<String> = [];

}
