package games.vollybox;

import newp.components.*;
import newp.collision.shapes.Circle;
import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;
import newp.math.Motion;
import newp.math.Utils as MathUtils;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;
import openfl.display.Sprite;


class Player extends Entity {

  inline static var BASE_MOVE_SPEED:Int = 300;
  inline static var SERVICE_MOVE_SPEED:Int = 200;
  inline static var MAX_MOVE_SPEED:Int = 200;
  inline static var DRAG:Int = 300;

  var game:VollyBox;

  var field(get, never):PlayField;
  var ball(get, never):Ball;

  var playerNo:Int;
  var width:Float;
  var height:Float;
  var hitDistance:Float; // how far away from the player they can still hit the ball
  var speed:Float;
  var box:Sprite;
  var shadow:Sprite;
  var inputs:Map<String, Int>;

  public var boxCollider:Shape;
  public var hitCollider:Circle;
  public var hasBall:Bool = false;
  public var moving(get, never):Bool;


  public function new(player:Int, game:VollyBox) {
    super();
    this.playerNo = player;
    this.game = game;
    this.width = 20;
    this.height = 20;
    this.hitDistance = 20;

    this.makeSprites();
    this.makeColliders();
    this.makeMotion();
    this.makeInputs();
    
    this.initPosition();
  }

  // Init
  // ====

  // Sprites
  function makeSprites() {
    var parent = cast(this.body, Sprite);

    this.box = new Sprite();
    this.shadow = new Sprite();

    this.drawBox(this.box.graphics);
    this.drawShadow(this.shadow.graphics);

    parent.addChild(shadow);
    parent.addChild(box);

    this.addComponent(new SpriteComponent(parent));
  }

  inline function drawBox(g) {
    Draw.start(g)
      .beginFill(0xf5deb3)
      .lineStyle(1, 0xfff8dc)
      .drawRect(-width/2, -height/2, width, height)
      .endFill();
  }

  inline function drawShadow(g) {
    Draw.start(g)
      .beginFill(0x555555, 0.1)
      .drawEllipse(-width/2, height/2 - 5, width, 10)
      .endFill();
  }

  inline function drawMask(g) {
    Draw.start(g)
      .lineStyle(1, 0xffffff, 0)
      .drawRect(-width/2, 0, width, height/2);
  }

  // Colliders
  function makeColliders() {
    var maskSprite:Sprite = new Sprite();
    this.drawMask(maskSprite.graphics);
    this.addComponent(new SpriteComponent(maskSprite));

    this.boxCollider = new Shape(maskSprite);
    this.hitCollider = new Circle(this.body, this.width + this.hitDistance);

    this.addComponent(new ShapeComponent(hitCollider, ['ball']));
    this.addComponent(new ShapeComponent(boxCollider, ['net', 'player', 'score']));
  }

  // Motion
  function makeMotion() {
    var motion = new Motion();
    motion.drag = DRAG;
    motion.max_velocity = MAX_MOVE_SPEED;
    
    this.addComponent(new MotionComponent(motion));
  }

  function makeInputs() {
    switch (this.playerNo) {
      case 1:
        this.inputs = [
          'left'  => 65,
          'up'    => 87,
          'right' => 68,
          'down'  => 83,
          'bump'  => 0,
          'set'   => 0,
        ];
      case 2:
        this.inputs = [
          'left'  => 37,
          'up'    => 38,
          'right' => 39,
          'down'  => 40,
          'bump'  => 0,
          'set'   => 0,
        ];
    }
  }

  inline function initPosition() {
    this.y = field.centerY;
    switch(this.playerNo) {
      case 1:
        this.x = field.left + 50;
      case 2:
        this.x = field.right - 50;
    }
  }

  // Update
  // ======

  override public function update() {
    this.update_playerInput();

    super.update();

    this.update_playerAnimation();
  }


  function update_playerInput() {
    speed = this.hasBall ? SERVICE_MOVE_SPEED : BASE_MOVE_SPEED;

    var k = Lib.inputs.keyboard;
    if (k.down(this.inputs['up'])) {
      this.ay = -speed;
      if (this.vy != 0 && MathUtils.sign(this.ay) != MathUtils.sign(this.vy)) this.vy *= 0.25;
    } else if (k.down(this.inputs['down'])) {
      this.ay = speed;
      if (this.vy != 0 && MathUtils.sign(this.ay) != MathUtils.sign(this.vy)) this.vy *= 0.25;
    } else {
      this.ay = 0;
    }

    if (k.down(this.inputs['left'])) {
      this.motion.ax = -speed;
      if (this.vx != 0 && MathUtils.sign(this.ax) != MathUtils.sign(this.vx)) this.vx *= 0.25;
    } else if (k.down(this.inputs['right'])) {
      this.motion.ax = speed;
      if (this.vx != 0 && MathUtils.sign(this.ax) != MathUtils.sign(this.vx)) this.vx *= 0.25;
    } else {
      this.motion.ax = 0;
    }
  }

  function update_playerAnimation() {
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
  inline function get_ball():Ball { return this.game.ball; }

}
