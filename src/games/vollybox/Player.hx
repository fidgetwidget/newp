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
  inline static var ACTION_TIME:Float = 0.3;

  inline static var HIT_SIZE:Float = 5;
  inline static var MAX_HIT_SIZE:Float = 19;

  var game:VollyBox;

  var field(get, never):PlayField;
  var ball(get, never):Ball;

  var playerNo:Int;
  var width:Float;
  var height:Float;
  var hitDistance:Float; // how far away from the player they can still hit the ball
  var speed:Float;

  var tweener:TweenerComponent;
  var inputs:Map<String, Int>;
  // Sprites
  var box:Sprite;
  var shadow:Sprite;
  var mask:Sprite;

  public var boxCollider:Shape;
  public var hitCollider:Circle;
  public var hasBall:Bool = false;
  public var moving(get, never):Bool;

  var actionDelayed:Bool = false;

  public function new(player:Int, game:VollyBox) {
    super();
    this.playerNo = player;
    this.game = game;
    this.width = 20;
    this.height = 20;
    this.hitDistance = HIT_SIZE;

    this.makeSprites();
    this.makeColliders();
    this.makeMotion();
    this.makeTweener();
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
    this.shadow.y = height/2;

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
      .drawEllipse(-width/2, -5, width, 10)
      .endFill();
  }

  inline function drawMask(g) {
    Draw.start(g)
      .lineStyle(1, 0xffffff, 0)
      .drawRect(-width/2, 0, width, height/2);
  }

  // Colliders
  function makeColliders() {
    this.mask = new Sprite();
    this.drawMask(mask.graphics);
    this.shadow.addChild(this.mask);

    this.addComponent(new SpriteComponent(mask));

    this.boxCollider = new Shape(this.mask);
    this.hitCollider = new Circle(this.body, this.width/2 + this.hitDistance);
    this.hitCollider.offsetY = height/4;

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

  function makeTweener() {
    this.tweener = new TweenerComponent();
    this.addComponent(tweener);
    this.tweener.add('bump', ACTION_TIME, _updateHitRadius, _hitRadiusReset);
  }

  function makeInputs() {
    switch (this.playerNo) {
      case 1:
        this.inputs = [
          'left'  => 65, // A
          'up'    => 87, // W
          'right' => 68, // D
          'down'  => 83, // S
          'bump'  => 69, // E
          'hit'   => 82, // R
        ];
      case 2:
        this.inputs = [
          'left'  => 37, // ARROW_LEFT
          'up'    => 38, // ARROW_UP
          'right' => 39, // ARROW_RIGHT
          'down'  => 40, // ARROW_DOWN
          'bump'  => 191, // /
          'hit'   => 190, // .
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

    if (!this.actionDelayed) {
      if (k.pressed(this.inputs['bump']) || k.pressed(this.inputs['hit'])) {
        this.actionDelayed = true;
      }

      if (k.pressed(this.inputs['bump'])) {
        this.hitDistance = MAX_HIT_SIZE;
        this.tweener.start('bump');
        if (this.hasBall) {} else {}
        // TODO: test for collision with ball
        //  and respond with a no direction hit (mostly straight up)
      }
      if (k.pressed(this.inputs['hit'])) {
        if (this.hasBall) {} else {}
        // TODO: test for collision with ball
        //  and respond with a directional hit
      }
    } else {
      this.hitCollider.radius = this.width/1 + this.hitDistance;
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

  function update_hitAnimation() {

  }


  function _updateHitRadius(val:Float, tween):Void {
    this.hitDistance = lerp(MAX_HIT_SIZE, HIT_SIZE, val);
  }

  function _hitRadiusReset(tween):Void {
    this.hitDistance = HIT_SIZE;
    this.actionDelayed = false;
  }

  var _bounceVal:Float = 0;
  var _maxBounce:Int = 8;
  var _bounceSpeed:Float = 68;
  var _bounceDir:Int = 1;
  var _min_speed:Float = 9;

  inline function get_moving():Bool { return Math.abs(this.vx) > _min_speed || Math.abs(this.vy) > _min_speed; }

  inline function get_field():PlayField { return this.game.playField; }
  inline function get_ball():Ball { return this.game.ball; }


  inline function lerp(start:Float, end:Float, t:Float) {
    return (1 - t) * start + t * end;
  }

}
