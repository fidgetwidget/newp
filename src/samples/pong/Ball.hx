package samples.pong;

import openfl.display.Sprite;
import newp.collision.shapes.Circle;
import newp.components.*;
import newp.math.Motion;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;


class Ball extends Entity {
  
  public var size(get, set):Int;
  public var color(get, set):Int;
  public var speed:Float;

  public function new () {
    super();
    this._size = 15;
    var sprite = new Sprite();
    var collider = new Circle(sprite, this.size);
    var motion = new Motion();
    motion.drag = 0;
    this.addComponent(new SpriteComponent(sprite));
    this.addComponent(new ShapeComponent(collider));
    this.addComponent(new MotionComponent(motion));
    this.resetPosition();
    this.redrawSprite();
  }

  public function resetPosition() {
    this.sprite.x = Lib.stage.stageWidth * 0.5;
    this.sprite.y = 80;
  }

  public function startMotion() {
    var dir:Int = (Std.random(1)+1) > 1 ? 1 : -1;
    var angle:Float = Math.random() * Math.PI;
    this.speed = 10;
    this.motion.moveAtAngle(this.speed, angle * dir);
  }

  function redrawSprite() {
    Draw.start(this.sprite.graphics)
      .clear()
      .beginFill(this.color)
      .drawCircle(0, 0, this.size)
      .endFill();
  }


  inline function get_size():Int { return this._size; }
  function set_size(val:Int):Int {
    this._size = val;
    this.redrawSprite();
    return this._size;
  }

  inline function get_color():Int { return this._color; }
  function set_color(val:Int):Int {
    this._color = val;
    this.redrawSprite();
    return this._color;
  }
  
  var _size:Int;
  var _color:Int;
  
}