package newp.collision.collections;

import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;


interface Collection {

  // Properties

  public var shapes:Array<Shape>;

  public function iterator():Iterator<Shape>;

  // Methods

  public function update(shape:Shape):Void;

  public function updateAll():Void;

  public function collisionTest(shape:Shape, callback:Shape->ShapeCollision->Void):Void;

  public function collisionTestWithTag(shape:Shape, tags:Dynamic, callback:Shape->ShapeCollision->Void):Void;

  public function collisionTestAll(callback:Shape->ShapeCollision->Void):Void;

  public function collisionTestAllWithTag(tags:Dynamic, callback:Shape->ShapeCollision->Void):Void;

  public function add(shape:Shape):Void;

  public function remove(shape:Shape):Void;

}
