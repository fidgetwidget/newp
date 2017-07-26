package newp.collision.response;

import newp.collision.shapes.Shape;


@:publicFields
class ShapeCollision {

  var overlap :Float = 0;
  var separationX :Float = 0;
  var separationY :Float = 0;
  var unitVectorX :Float = 0;
  var unitVectorY :Float = 0;

  var otherOverlap :Float = 0;
  var otherSeparationX :Float = 0;
  var otherSeparationY :Float = 0;
  var otherUnitVectorX :Float = 0;
  var otherUnitVectorY :Float = 0;

  var shape1 :Shape;
  var shape2 :Shape;

  @:noCompletion
  inline function new() { }


  inline function set(
    overlap:Float = 0, 
    separationX:Float = 0, separationY:Float = 0, 
    unitVectorX:Float = 0, unitVectorY:Float = 0, 
    otherOverlap:Float = 0, 
    otherSeparationX:Float = 0, otherSeparationY:Float = 0, 
    otherUnitVectorX:Float = 0, otherUnitVectorY:Float = 0, 
    shape1:Shape = null, shape2:Shape = null):ShapeCollision {

    this.overlap = overlap;
    this.separationX = separationX;
    this.separationY = separationY;
    this.unitVectorX = unitVectorX;
    this.unitVectorY = unitVectorY;
    this.otherOverlap = otherOverlap;
    this.otherSeparationX = otherSeparationX;
    this.otherSeparationY = otherSeparationY;
    this.otherUnitVectorX = otherUnitVectorX;
    this.otherUnitVectorY = otherUnitVectorY;
    this.shape1 = shape1;
    this.shape2 = shape2;

    return this;
  } 

  inline function copy(other:ShapeCollision):ShapeCollision {
    return this.set(other.overlap, other.separationX, other.separationY,
      other.unitVectorX, other.unitVectorY, other.otherOverlap,
      other.otherSeparationX, other.otherSeparationY, other.otherUnitVectorX,
      other.otherUnitVectorY, other.shape1, other.shape2);
  }

  inline function clear():ShapeCollision {
    return this.set();
  } 

  inline function clone():ShapeCollision {

    var shapeCollision = new ShapeCollision();

    return shapeCollision.copy(this);

  } //clone

  public function toString():String {
    return 'o: $overlap sx: $separationX sy: $separationY ux: $unitVectorX uy: $unitVectorY';
  }

}
