package samples.pong;

import openfl.display.Sprite;
import newp.collision.shapes.Polygon;
import newp.math.Motion;
import newp.utils.Draw;
import newp.Lib;


class Player {

  public static inline var LEFT_SIDE:Int = 1;
  public static inline var RIGHT_SIDE:Int = 2;
  
  public var side:Int;
  public var thickness(get, set):Int;
  public var width(get, set):Int;
  public var color(get, set):Int;
  public var sprite:Sprite;
  public var collider:Polygon;
  public var motion:Motion;
  public var x(get, set):Float;
  public var y(get, set):Float;
  public var top(get, never):Float;
  public var bottom(get, never):Float;

  public function new (side:Int = Player.LEFT_SIDE) {
    this.side = side;
    
    this._thickness = 10;
    this._width = 80;
    this._color = 0x555555;

    this.sprite = new Sprite();
    this.sprite.y = Lib.stage.stageHeight * 0.5;
    switch (this.side) {
      case Player.LEFT_SIDE:
        this.sprite.x = 60;
      case Player.RIGHT_SIDE:
        this.sprite.x = Lib.stage.stageWidth - 60;
    }
    this.collider = Polygon.rectangle(this.sprite, this.thickness, this.width);
    this.motion = new Motion();
    this.motion.target = this.sprite;
    this.motion.drag = 10;

    this.redrawSprite();
  }

  public function update():Void {
    this.motion.update();
  } 

  function redrawSprite():Void {
    Draw.start( this.sprite.graphics )
      .clear()
      .beginFill(this.color)
      .drawRect(-this.thickness * 0.5, -this.width * 0.5, this.thickness, this.width)
      .endFill();
  }


  inline function get_x():Float { return this.sprite.x; }
  inline function set_x(val:Float):Float { return this.sprite.x = val; }

  inline function get_y():Float { return this.sprite.y; }
  inline function set_y(val:Float):Float { return this.sprite.y = val; }

  inline function get_top():Float { return this.sprite.y - width * 0.5; }
  inline function get_bottom():Float { return this.sprite.y + width * 0.5; }

  inline function get_thickness():Int { return this._thickness; }
  function set_thickness(val:Int):Int {
    this._thickness = val;
    this.redrawSprite();
    return this._thickness;
  }

  inline function get_width():Int { return this._width; }
  function set_width(val:Int):Int {
    this._width = val;
    this.redrawSprite();
    return this._width;
  }

  inline function get_color():Int { return this._color; }
  function set_color(val:Int):Int {
    this._color = val;
    this.redrawSprite();
    return this._color;
  }

  var _thickness:Int;
  var _width:Int;
  var _color:Int;
  
}