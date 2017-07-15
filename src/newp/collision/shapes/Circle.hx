package newp.collision.shapes;

import openfl.display.DisplayObject;
import newp.collision.sat.*;
import newp.collision.response.ShapeCollision;
import newp.utils.Draw;


class Circle extends Shape {

  public var radius:Float;

  public var transformedRadius(get, never):Float;
  

  public function new(transformBody:DisplayObject, radius:Float) {
    super(transformBody);
    this.radius = radius;
  }

  // +-------------------------
  // | Collision Methods
  // +-------------------------

  override public function test(shape:Shape, ?into:ShapeCollision, flip:Bool = false ):ShapeCollision {
    return shape.testCircle(this, into, !flip);
  }

  override public function testCircle(circle:Circle, ?into:ShapeCollision, flip:Bool = false ):ShapeCollision {
    return CircleVsCircle.test(this, circle, into, flip);
  }

  override public function testPolygon(poly:Polygon, ?into:ShapeCollision, flip:Bool = false ):ShapeCollision {
    return CircleVsPolygon.test(this, poly, into, flip); 
  }

  // +-------------------------
  // | Properties
  // +-------------------------
  

  inline function get_transformedRadius():Float { 
    var tr = this.radius * this.scaleX;
    if (Lib.debug) {
      var g = Lib.debugLayer.graphics;
      g.drawCircle(x, y, tr);
    }
    return tr; 
  }

  override function get_bounds():Bounds {
    return this._bounds.setCenterHalfs(this.x, this.y, this.transformedRadius, this.transformedRadius);
  }

}
