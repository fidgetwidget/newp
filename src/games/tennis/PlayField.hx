package games.tennis;

import openfl.display.Sprite;
import newp.utils.Draw;
import newp.Lib;


class PlayField extends Sprite {

  inline static var WIDTH:Int = 500;
  inline static var HEIGHT:Int = 300;
  inline static var FIELD_COLOR:Int = 0xfff8dc;

  var field:Sprite;
  var net:Sprite;
  
  public var centerX(get, never):Float;
  public var centerY(get, never):Float;

  public var top(get, never):Float;
  public var right(get, never):Float;
  public var bottom(get, never):Float;
  public var left(get, never):Float;

  public function new() {
    super();
    this.makeField();
    this.makeNet();

    this.addChild(this.field);
    this.addChild(this.net);
  }

  function makeField() {
    this.field = new Sprite();
    this.field.x = left;
    this.field.y = top;

    Draw.start(this.field.graphics)
      .clear()
      .beginFill(FIELD_COLOR)
      .drawRect(0, 0, WIDTH, HEIGHT)
      .endFill();

    trace('field made');
  }

  function makeNet() {
    this.net = new Sprite();
    this.net.x = centerX;
    this.net.y = 0;
    
    Draw.start(this.net.graphics)
      .clear()
      .beginFill(0x555555, 0.1)
      .drawLine([-25, 10, 0, HEIGHT-10, 25, -10], 0, top+5)
      .endFill()
      .lineStyle(2, 0x333333)
      .drawLine([0, 15], 0, top-10)
      .lineStyle(1, 0x555555)
      .drawLine([0, HEIGHT-10], 0, top-10)
      .lineStyle(2, 0x333333)
      .drawLine([0, 15], 0, bottom-20);

    trace('net made');
  }


  inline function get_centerX():Float { return Lib.stage.stageWidth * 0.5; }
  inline function get_centerY():Float { return Lib.stage.stageHeight * 0.5; }

  inline function get_top():Float     { return this.centerY - HEIGHT/2; }
  inline function get_right():Float   { return this.centerX + WIDTH/2; }
  inline function get_bottom():Float  { return this.centerY + HEIGHT/2; }
  inline function get_left():Float    { return this.centerX - WIDTH/2; }

}
