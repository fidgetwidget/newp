package newp.collision.shapes;

import openfl.display.DisplayObject;
import newp.collision.SAT;
import newp.collision.ShapeCollision;
import newp.collision.Bounds;


class Shape {

  public var tags:Map<String, String>;

  public var valid(get, never):Bool;

  public var x(get, set):Float;

  public var y(get, set):Float;

  public var rotation(get, set):Float;

  public var scaleX(get, set):Float;

  public var scaleY(get, set):Float;

  public var bounds(get, never):Bounds;

  public var transformBody(default, null):DisplayObject;


  public function new(?transformBody:DisplayObject) {
    this._bounds = new Bounds();
    this.tags = new Map();
    this.transformBody = transformBody;
  }

  // +-------------------------
  // | Collision Methods
  // +-------------------------

  public function test(shape:Shape, ?into:ShapeCollision):ShapeCollision {
    if (Std.is(shape, Circle))
      return this.testCircle(cast shape, into, true);
    
    if (Std.is(shape, Polygon))
      return this.testPolygon(cast shape, into, true);

    return SAT.testBoundsVsBounds(this, shape, into);
  } 

  public function testCircle(circle:Circle, ?into:ShapeCollision, flip:Bool = false):ShapeCollision {
    return SAT.testCircleVsBounds(circle, this, into, flip);
  }

  public function testPolygon(poly:Polygon, ?into:ShapeCollision, flip:Bool = false):ShapeCollision {
    return SAT.testPolygonVsBounds(poly, this, into, flip);
  }


  // +-------------------------
  // | Properties
  // +-------------------------

  inline function get_valid():Bool { return this.transformBody != null; }

  inline function get_x():Float { return this.valid ? this.transformBody.x : 0; }
  inline function set_x(val:Float):Float { 
    if (this.valid) this.transformBody.x = val;
    return val; 
  }

  inline function get_y():Float { return this.valid ? this.transformBody.y : 0; }
  inline function set_y(val:Float):Float { 
    if (this.valid) this.transformBody.y = val;
    return val; 
  }

  inline function get_rotation():Float { return this.valid ? this.transformBody.rotation : 0; }
  inline function set_rotation(val:Float):Float { 
    if (this.valid) this.transformBody.rotation = val;
    return val; 
  }

  inline function get_scaleX():Float { return this.valid ? this.transformBody.scaleX : 0; }
  inline function set_scaleX(val:Float):Float { 
    if (this.valid) this.transformBody.scaleX = val;
    return val; 
  }

  inline function get_scaleY():Float { return this.valid ? this.transformBody.scaleY : 0; }
  inline function set_scaleY(val:Float):Float { 
    if (this.valid) this.transformBody.scaleY = val;
    return val; 
  }

  // Just use the transformBody's get bounds method
  // NOTE: we don't inline it because we want to be able to override it
  function get_bounds():Bounds {
    if (!this.valid) return null;
    var _rect = this.transformBody.getBounds(Lib.stage);
    return this._bounds.copyFromRectangle( _rect );
  }


  var _bounds:Bounds;

}
