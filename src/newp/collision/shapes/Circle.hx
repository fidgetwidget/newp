package newp.collision.shapes;

import newp.collision.sat.*;
import newp.collision.response.ShapeCollision;
import newp.utils.Draw;
import openfl.display.DisplayObject;
import openfl.display.Graphics;


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
    if (_lastFetched != Lib.time) {
      _lastFetched = Lib.time;
      _transformedRadius = this.radius * this.scaleX;
      if (Lib.debug) this.debug_draw(Lib.debugLayer.graphics);  
    }
    return _transformedRadius; 
  }
  var _transformedRadius:Float;

  override function get_bounds():Bounds {
    return this._bounds.setCenterHalfs(this.x, this.y, this.transformedRadius, this.transformedRadius);
  }

  override public function debug_draw(g:Graphics) {
    g.drawCircle(x, y, _transformedRadius); 
  }

}
