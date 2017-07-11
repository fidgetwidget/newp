package games.vollybox;

import openfl.display.Sprite;
import newp.collision.shapes.Shape;
import newp.utils.Draw;
import newp.Lib;


class PlayField extends Sprite {

  public inline static var WIDTH:Int = 500;
  public inline static var HEIGHT:Int = 300;
  inline static var FIELD_COLOR:Int = 0xfff8dc;

  var field:Sprite;
  var net:Sprite;
  public var netLine:Sprite;
  var netShadow:Sprite;

  var netColliderSprite:Sprite;
  public var netCollider:Shape;
  
  public var centerX(get, never):Float;
  public var centerY(get, never):Float;

  public var top(get, never):Float;
  public var right(get, never):Float;
  public var bottom(get, never):Float;
  public var left(get, never):Float;

  public function new() {
    super();
    this.field = new Sprite();
    this.field.x = left;
    this.field.y = top;
    this.drawField(this.field.graphics);
    this.addChild(this.field);
  }

  function drawField(g) {
    Draw.start(g)
      .clear()
      .beginFill(FIELD_COLOR)
      .drawRect(0, 0, WIDTH, HEIGHT)
      .endFill();
  }


  inline function get_centerX():Float { return Lib.stage.stageWidth * 0.5; }
  inline function get_centerY():Float { return Lib.stage.stageHeight * 0.5; }

  inline function get_top():Float     { return this.centerY - HEIGHT/2; }
  inline function get_right():Float   { return this.centerX + WIDTH/2; }
  inline function get_bottom():Float  { return this.centerY + HEIGHT/2; }
  inline function get_left():Float    { return this.centerX - WIDTH/2; }

}
