package samples.pong;

import openfl.display.Sprite;
import newp.collision.shapes.Shape;
import newp.collision.shapes.Circle;
import newp.components.*;
import newp.math.Dice;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;


class Ball extends Entity {
  
  static inline var DEFAULT_SPEED:Float = 150;

  public var size(get, set):Int;
  public var color(get, set):Int;
  public var speed:Float;
  public var collider:Shape;
  var sprite:Sprite;
  var initX:Float;
  var initY:Float;

  public function new (field:PlayField) {
    super();
    this.initX = field.centerX;
    this.initY = field.top + 50;
    this._size = 15;

    sprite = cast(body, Sprite);
    collider = new Circle(body, this.size);
    
    var motion = new MotionComponent();
    motion.drag = 0;
    motion.max = 250;

    this.addComponent(new SpriteComponent(sprite));
    this.addComponent(new ShapeComponent(collider));
    this.addComponent(motion);

    this.resetPosition();
    this.redraw();
  }

  public function resetPosition() {
    this.x = this.initX;
    this.y = this.initY;
  }

  public function startMotion(?dir:Int) {
    dir = dir == null ? (Dice.roll(2) > 1 ? 1 : -1) : dir;
    var maxAngle = (Math.PI / 6) * 5;
    var minAngle = Math.PI / 2;
    var angle:Float = (Math.random() * (maxAngle-minAngle)) + minAngle;
    angle = angle * dir;
    angle -= minAngle;
    this.speed = DEFAULT_SPEED;
    this.motion.moveAtAngle(this.speed, angle);
  }

  function redraw() {
    Draw.start(sprite.graphics)
      .clear()
      .beginFill(this.color)
      .drawCircle(0, 0, this.size)
      .endFill();
  }

  inline function get_size():Int { return this._size; }
  function set_size(val:Int):Int {
    this._size = val;
    this.redraw();
    return this._size;
  }

  inline function get_color():Int { return this._color; }
  function set_color(val:Int):Int {
    this._color = val;
    this.redraw();
    return this._color;
  }
  
  var _size:Int;
  var _color:Int;
  
}