package games.vollybox;

import newp.components.*;
import newp.collision.shapes.Polygon;
import newp.collision.shapes.Shape;
import newp.collision.ShapeCollision;
import newp.math.Motion;
import newp.math.Utils as MathUtils;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;
import openfl.display.Sprite;


class Player extends Entity {

  inline static var BASE_MOVE_SPEED:Int = 300;
  inline static var MAX_MOVE_SPEED:Int = 200;
  inline static var DRAG:Int = 300;

  var game:VollyBox;
  var field(get, never):PlayField;
  var playerNo:Int;
  var width:Float;
  var height:Float;
  var hitDistance:Float; // how far away from the player they can still hit the ball
  var box:Sprite;
  public var boxCollider:Shape;
  var shadow:Sprite;

  public var moving(get, never):Bool;

  public function new(player:Int, game:VollyBox) {
    super();
    this.playerNo = player;
    this.game = game;
    this.width = 20;
    this.height = 20;
    this.hitDistance = 20;

    var sprite = new Sprite();
    this.makePlayerSprites(sprite);

    var collider = Polygon.rectangle(this.box, this.width + this.hitDistance, this.height + this.hitDistance);
    var collisionMask:Sprite = new Sprite();
    this.drawCollisionMask(collisionMask.graphics);
    this.shadow.addChild(collisionMask);
    this.boxCollider = new Shape(collisionMask);
    
    var motion = new Motion();

    motion.drag = DRAG;
    motion.max_velocity = MAX_MOVE_SPEED;

    this.addComponent(new SpriteComponent(sprite));
    this.addComponent(new ShapeComponent(collider));
    this.addComponent(new MotionComponent(motion));

    this.y = field.centerY;
    switch(this.playerNo) {
      case 1:
        this.x = field.left + 50;
      case 2:
        this.x = field.right - 50;
    }
  }

  function drawCollisionMask(g) {
    Draw.start(g)
      .lineStyle(1, 0xffffff, 0)
      .drawRect(-width/2, 0, width, height/2);
  }

  function makePlayerSprites(parent) {
    this.box = new Sprite();
    this.shadow = new Sprite();
    var g;
    g = this.box.graphics;
    Draw.start(g)
      .beginFill(0xf5deb3)
      .lineStyle(1, 0xfff8dc)
      .drawRect(-width/2, -height/2, width, height)
      .endFill();

    g = this.shadow.graphics;
    Draw.start(g)
      .beginFill(0x555555, 0.1)
      .drawEllipse(-width/2, height/2 - 5, width, 10)
      .endFill();

    parent.addChild(shadow);
    parent.addChild(box);
  }


  override public function update() {
    var k = Lib.inputs.keyboard;
    var up:Int=0, down:Int=0, left:Int=0, right:Int=0;
    switch (this.playerNo) {
      case 1:
        up = 87;
        down = 83;
        left = 65;
        right = 68;
      case 2:
        left = 37;
        up = 38;
        right = 39;
        down = 40;
    }

    var speed = BASE_MOVE_SPEED;

    if (k.down(up)) {
      this.ay = -speed;
      if (this.vy != 0 && MathUtils.sign(this.ay) != MathUtils.sign(this.vy)) this.vy *= 0.25;
    } else if (k.down(down)) {
      this.ay = speed;
      if (this.vy != 0 && MathUtils.sign(this.ay) != MathUtils.sign(this.vy)) this.vy *= 0.25;
    } else {
      this.ay = 0;
    }

    if (k.down(left)) {
      this.motion.ax = -speed;
      if (this.vx != 0 && MathUtils.sign(this.ax) != MathUtils.sign(this.vx)) this.vx *= 0.25;
    } else if (k.down(right)) {
      this.motion.ax = speed;
      if (this.vx != 0 && MathUtils.sign(this.ax) != MathUtils.sign(this.vx)) this.vx *= 0.25;
    } else {
      this.motion.ax = 0;
    }

    super.update();

    if (this.moving) {
      if (_bounceVal > _maxBounce) { _bounceDir = -1; _bounceVal = _maxBounce; }
      if (_bounceVal < 0) {_bounceDir = 1; _bounceVal = 0; }
      _bounceVal += _bounceDir * Lib.delta * _bounceSpeed;
      this.box.y = -_bounceVal;
    } else {
      this.box.y = 0;
      _bounceVal = 0;
      _bounceDir = 1;
    } // moving
  }

  var _bounceVal:Float = 0;
  var _maxBounce:Int = 8;
  var _bounceSpeed:Float = 68;
  var _bounceDir:Int = 1;
  var _min_speed:Float = 9;

  inline function get_moving():Bool { return Math.abs(this.vx) > _min_speed || Math.abs(this.vy) > _min_speed; }

  inline function get_field():PlayField { return this.game.playField; }

}
