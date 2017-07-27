package newp.collision.shapes;

import newp.collision.sat.*;
import newp.collision.response.ShapeCollision;
import newp.math.Utils as MathUtils;
import newp.utils.Draw;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.geom.Point;


class Polygon extends Shape {

  // public static function create(transformBody:DisplayObject, sides:Int, radius:Float):Polygon {

  // }

  public static function rectangle(transformBody:DisplayObject, width:Float, height:Float, centered:Bool = true):Polygon {
    var verts = [];
    if(centered) {
      verts.push( new Point( -width / 2, -height / 2) );
      verts.push( new Point(  width / 2, -height / 2) );
      verts.push( new Point(  width / 2,  height / 2) );
      verts.push( new Point( -width / 2,  height / 2) );
    } else {
      verts.push( new Point( 0, 0 ) );
      verts.push( new Point( width, 0 ) );
      verts.push( new Point( width, height) );
      verts.push( new Point( 0, height) );
    }

    return new Polygon(transformBody, verts);
  }

  public static function square(transformBody:DisplayObject, size:Float, centered:Bool = true):Polygon {
    return Polygon.rectangle(transformBody, size, size, centered);
  }


  // +-------------------------
  // | Instance
  // +-------------------------

  public var verts(default, null):Array<Point>;

  public var transformedVerts(get, never):Array<Point>;
  var _transformedVerts:Array<Point>;
  
  public function new(transformBody:DisplayObject, verts:Array<Point>) {
    super(transformBody);
    this.verts = verts;
    this.initTransformedVerts();
  }

  inline function initTransformedVerts():Void {
    var matrix = this.transformBody.transform.matrix;

    this._transformedVerts = [];
    for (vert in this.verts) {
      var p = new Point();
      MathUtils.transformPoint(vert, matrix, p);
      this._transformedVerts.push(p);
    }
  }

  // +-------------------------
  // | Collision Methods
  // +-------------------------

  override public function test(shape:Shape, ?into:ShapeCollision, flip:Bool = false ):ShapeCollision {
    return shape.testPolygon(this, into, !flip);
  }

  override public function testCircle(circle:Circle, ?into:ShapeCollision, flip:Bool = false ):ShapeCollision {
    return CircleVsPolygon.test(circle, this, into, flip);
  }

  override public function testPolygon(poly:Polygon, ?into:ShapeCollision, flip:Bool = false ):ShapeCollision {
    return PolygonVsPolygon.test(poly, this, into, flip);
  }

  // +-------------------------
  // | Properties
  // +-------------------------

  inline function get_transformedVerts():Array<Point> {
    if (_lastFetched != Lib.time) {
      _lastFetched = Lib.time;
      var matrix = this.transformBody.transform.matrix;
      var p; 
      var vert;
      for (i in 0...this.verts.length) {
        vert = this.verts[i];
        p = this._transformedVerts[i];
        MathUtils.transformPoint(vert, matrix, p);
      }
      if (Lib.debug) this.debug_draw(Lib.debugLayer.graphics);
    }
    return this._transformedVerts;
  }

  override public function debug_draw(g:Graphics) {
    var verts = _transformedVerts;
    for (i in 0...verts.length) {
      var p = this.verts[i];
      if (i == 0) {
        g.moveTo(p.x, p.y);
      } else {
        g.lineTo(p.x, p.y);
      }
    }
    var p = this.verts[0];
    g.lineTo(p.x, p.y);
  }
}
