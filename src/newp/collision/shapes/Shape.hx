package newp.collision.shapes;

import openfl.display.DisplayObject;
import newp.collision.SAT;
import newp.collision.ShapeCollision;
import newp.collision.Bounds;


class Shape {

  public var tags:Map<String, String>;

  public var x(get, set):Float;

  public var y(get, set):Float;

  public var rotation(get, set):Float;

  public var scaleX(get, set):Float;

  public var scaleY(get, set):Float;

  public var bounds(get, never):Bounds;
  var _bounds:Bounds;

  public var transformBody(default, null):DisplayObject;


  public function new(transformBody:DisplayObject) {
    this._bounds = new Bounds();
    this.tags = new Map();
    this.transformBody = transformBody;
  }

  // +-------------------------
  // | Methods
  // +-------------------------

  public function test(shape:Shape, ?into:ShapeCollision):ShapeCollision {
    return SAT.testBoundsVsBounds(this.bounds, shape.bounds, into);
  } 

  public function testCircle(circle:Circle, ?into:ShapeCollision, flip:Bool = false):ShapeCollision {
    return SAT.testCircleVsBounds(circle, this.bounds, into, flip);
  }

  public function testPolygon(poly:Polygon, ?into:ShapeCollision, flip:Bool = false):ShapeCollision {
    return SAT.testPolygonVsBounds(poly, this.bounds, into, flip);
  }


  // +-------------------------
  // | Properties
  // +-------------------------

  inline function get_x():Float { return this.transformBody.x; }
  inline function set_x(val:Float):Float { return this.transformBody.x = val; }

  inline function get_y():Float { return this.transformBody.y; }
  inline function set_y(val:Float):Float { return this.transformBody.y = val; }

  inline function get_rotation():Float { return this.transformBody.rotation; }
  inline function set_rotation(val:Float):Float { return this.transformBody.rotation = val; }

  inline function get_scaleX():Float { return this.transformBody.scaleX; }
  inline function set_scaleX(val:Float):Float { return this.transformBody.scaleX = val; }

  inline function get_scaleY():Float { return this.transformBody.scaleY; }
  inline function set_scaleY(val:Float):Float { return this.transformBody.scaleY = val; }

  // Just use the transformBody's get bounds method
  // NOTE: we don't inline it because we want to be able to override it
  function get_bounds():Bounds {
    var _rect = this.transformBody.getBounds(Lib.stage);
    return this._bounds.copyFromRectangle( _rect );
  }

}
