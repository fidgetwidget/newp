package samples.pong;

import openfl.display.Sprite;
import newp.collision.shapes.Polygon;
import newp.components.*;
import newp.math.Motion;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;


class Player extends Entity {

  public static inline var LEFT_SIDE:Int = 1;
  public static inline var RIGHT_SIDE:Int = 2;
  
  public var side:Int;
  public var thickness(get, set):Int;
  public var width(get, set):Int;
  public var color(get, set):Int;
  public var top(get, set):Float;
  public var bottom(get, set):Float;
  var middle:Float;

  public function new (side:Int = Player.LEFT_SIDE, field:PlayField) {
    super();
    this.side = side;
    this.middle = field.centerY;
    this._thickness = 10;
    this._width = 80;
    this._color = 0x555555;

    var sprite = new Sprite();
    var collider = Polygon.rectangle(sprite, this.thickness, this.width);
    var motion = new Motion();
    motion.drag = 200;
    motion.max_velocity = 200;

    this.addComponent(new SpriteComponent(sprite));
    this.addComponent(new ShapeComponent(collider));
    this.addComponent(new MotionComponent(motion));

    this.initPosition(side, field);
    this.redrawSprite();
  }

  function initPosition(side:Int, field:PlayField) {
    switch (this.side) {
      case Player.LEFT_SIDE:  this.sprite.x = field.left + 30;
      case Player.RIGHT_SIDE: this.sprite.x = field.right - 30;
    }
    this.resetPosition();
  }

  public function resetPosition() {
    this.sprite.y = this.middle;
    this.motion.ay = 0;
    this.motion.vy = 0;
  }

  function redrawSprite():Void {
    Draw.start( this.sprite.graphics )
      .clear()
      .beginFill(this.color)
      .drawRect(-this.thickness * 0.5, -this.width * 0.5, this.thickness, this.width)
      .endFill();
  }



  inline function get_top():Float { return this.sprite.y - width * 0.5; }
  inline function set_top(val:Float):Float { return this.sprite.y = val + width * 0.5; }

  inline function get_bottom():Float { return this.sprite.y + width * 0.5; }
  inline function set_bottom(val:Float):Float { return this.sprite.y = val - width * 0.5; }

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