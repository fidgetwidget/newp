package games.vollybox;

import openfl.display.Sprite;
import openfl.display.Shape;
import newp.collision.shapes.Shape as Collider;
import newp.utils.Draw;
import newp.Lib;


class PlayField extends Sprite {

  public inline static var WIDTH:Int = 500;
  public inline static var HEIGHT:Int = 300;

  var field:Shape;
  var prints:Shape;
  var printsMask:Shape;
  
  public var centerX(get, never):Float;
  public var centerY(get, never):Float;

  public var top(get, never):Float;
  public var right(get, never):Float;
  public var bottom(get, never):Float;
  public var left(get, never):Float;

  public function new() {
    super();
    this.field = new Shape();
    this.field.x = left;
    this.field.y = top;
    this.drawField(this.field.graphics);
    this.addChild(this.field);

    this.prints = new Shape();
    this.drawPrints(this.prints.graphics);

    this.printsMask = new Shape();
    this.drawPrintsMask(this.printsMask.graphics);
    this.prints.mask = this.printsMask;

    this.addChild(this.printsMask);
    this.addChild(this.prints);
  }

  function drawField(g) {
    Draw.start(g)
      .clear()
      .beginFill(VollyBox.SAND)
      .drawRect(0, 0, WIDTH, HEIGHT)
      .endFill();
  }

  function drawPrints(g) {
    Draw.start(g)
      .clear()
      .lineStyle(1, VollyBox.SAND)
      .drawRect(left, top, WIDTH, HEIGHT)
      .lineStyle(0, 0, 0);
  }

  function drawPrintsMask(g) {
    Draw.start(g)
      .clear()
      .beginFill(0x000000)
      .drawRect(left, top, WIDTH, HEIGHT)
      .endFill();
  }

  public function drawOnSand(shape:Dynamic) {
    var g = this.prints.graphics;
    g.beginFill(VollyBox.PRINTS, 0.8);
    if (Std.is(shape, Collider)) {
      shape.debug_draw( g );  
    } else {
      if (Reflect.hasField(shape, 'radius'))
        g.drawCircle(shape.x, shape.y, shape.radius);
      else if (Reflect.hasField(shape, 'width') && Reflect.hasField(shape, 'height'))
        g.drawRect(shape.x, shape.y, shape.width, shape.height);
    }
    g.endFill();
  }


  inline function get_centerX():Float { return Lib.stage.stageWidth * 0.5; }
  inline function get_centerY():Float { return Lib.stage.stageHeight * 0.5; }

  inline function get_top():Float     { return this.centerY - HEIGHT/2; }
  inline function get_right():Float   { return this.centerX + WIDTH/2; }
  inline function get_bottom():Float  { return this.centerY + HEIGHT/2; }
  inline function get_left():Float    { return this.centerX - WIDTH/2; }

}
