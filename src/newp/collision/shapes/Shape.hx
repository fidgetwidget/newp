package newp.collision.shapes;

import openfl.display.DisplayObject;
import newp.collision.sat.*;
import newp.collision.response.ShapeCollision;
import newp.collision.Bounds;


// TODO: change transformBody to just the transform 
//   just need to build a transform helper to 
//   get the x, y, rotation, scaleX, scaleY from a transform
class Shape {

  public var tags:Map<String, String>; // categorization of the shape / collision groups

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

  public function test(shape:Shape, ?into:ShapeCollision, flip:Bool = false):ShapeCollision {
    if (Std.is(shape, Circle)) return this.testCircle(cast shape, into, !flip);
    
    if (Std.is(shape, Polygon)) return this.testPolygon(cast shape, into, !flip);

    return BoundsVsBounds.test(flip ? shape : this, flip ? this : shape, into);
  } 

  public function testCircle(circle:Circle, ?into:ShapeCollision, flip:Bool = false):ShapeCollision {
    return CircleVsBounds.test(circle, this, into, flip);
  }

  public function testPolygon(poly:Polygon, ?into:ShapeCollision, flip:Bool = false):ShapeCollision {
    return PolygonVsBounds.test(poly, this, into, flip);
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
