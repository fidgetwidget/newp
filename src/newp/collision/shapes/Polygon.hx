package newp.collision.shapes;

import openfl.display.DisplayObject;
import openfl.geom.Point;
import newp.collision.SAT;
import newp.collision.ShapeCollision;
import newp.math.Utils as MathUtils;


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


  override public function test(shape:Shape, ?into:ShapeCollision):ShapeCollision {
    return shape.testPolygon(this, into, true);
  }

  override public function testCircle(circle:Circle, ?into:ShapeCollision, flip:Bool = false ):ShapeCollision {
    return SAT.testCircleVsPolygon(circle, this, into, flip);
  }

  override public function testPolygon(poly:Polygon, ?into:ShapeCollision, flip:Bool = false ):ShapeCollision {
    return SAT.testPolygonVsPolygon(poly, this, into, flip);
  }


  inline function get_transformedVerts():Array<Point> {
    var matrix = this.transformBody.transform.matrix;

    for (i in 0...this.verts.length) {
      var vert = this.verts[i];
      var p = this._transformedVerts[i];
      MathUtils.transformPoint(vert, matrix, p);
    }
    return this._transformedVerts;
  }
}
