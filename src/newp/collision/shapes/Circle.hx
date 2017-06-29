package newp.collision.shapes;

import openfl.display.DisplayObject;
import newp.collision.SAT;
import newp.collision.ShapeCollision;


class Circle extends Shape {

  public var radius(default, null):Float;

  public var transformedRadius(get, never):Float;
  

  public function new(transformBody:DisplayObject, radius:Float) {
    super(transformBody);
    this.radius = radius;
  }


  override public function test(shape:Shape, ?into:ShapeCollision):ShapeCollision {
    return shape.testCircle(this, into, true);
  }

  override public function testCircle(circle:Circle, ?into:ShapeCollision, flip:Bool = false ):ShapeCollision {
    return SAT.testCircleVsCircle(this, circle, into, flip);
  }

  override public function testPolygon(poly:Polygon, ?into:ShapeCollision, flip:Bool = false ):ShapeCollision {
    return SAT.testCircleVsPolygon(this, poly, into, flip); 
  }
  

  inline function get_transformedRadius():Float { return this.radius * this.scaleX; }

  override function get_bounds():Bounds {
    return this._bounds.set(
      this.x - this.transformedRadius, 
      this.y - this.transformedRadius, 
      this.x + this.transformedRadius,
      this.y + this.transformedRadius);
  }

}
