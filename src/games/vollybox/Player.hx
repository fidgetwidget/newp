package games.vollybox;

import newp.components.*;
import newp.collision.shapes.Circle;
import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;
import newp.math.Motion;
import newp.math.Utils as MathUtil;
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

  // Hit types
  inline static var BUMPING:String = "bumping";
  inline static var HITTING:String = "hitting";
  inline static var NONE:String = "";

  var game:VollyBox;

  var field(get, never):PlayField;
  var ball(get, never):Ball;
  var width:Float;
  var height:Float;
  var scale:Float = 1;
  var speed:Float;
  var hitDistance(get, set):Float; // how far away from the player they can still hit the ball
  var hitRadius(get, never):Float;
  var actionDelayed:Bool = false; // if the player is trying to hit the ball
  var hitType:String = NONE; // which type of hitting the ball the player has triggered
  var tweener:TweenerComponent;
  var inputs:Map<String, Int>;
  // Sprites
  var box:Sprite;
  var shadow:Sprite;
  var mask:Sprite;

  public var playerNo(default, null):Int;
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
    this.collisionData = new ShapeCollision();

    this.makeSprites();
    this.makeColliders();
    this.makeMotion();
    this.makeTweener();
    this.makeInputs();

    this.hitDistance = HIT_SIZE;
    
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
    this.hitCollider = new Circle(this.body, this.hitRadius);
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
    this.tweener.add('bump', ACTION_TIME, _bumpUpdate, _bumpDone);
    this.tweener.add('hit', ACTION_TIME, _hitUpdate, _hitDone);
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

    this.update_playerAnimations();
    this.update_hitAnimation();
  }


  function update_playerInput() {
    speed = this.hasBall ? SERVICE_MOVE_SPEED : BASE_MOVE_SPEED;
    var canHitBall = this.ball.onGround || this.hasBall;

    var k = Lib.inputs.keyboard;
    if (k.down(this.inputs['up'])) {
      this.ay = -speed;
      if (this.vy != 0 && MathUtil.sign(this.ay) != MathUtil.sign(this.vy)) this.vy *= 0.25;
    } else if (k.down(this.inputs['down'])) {
      this.ay = speed;
      if (this.vy != 0 && MathUtil.sign(this.ay) != MathUtil.sign(this.vy)) this.vy *= 0.25;
    } else {
      this.ay = 0;
    }

    if (k.down(this.inputs['left'])) {
      this.motion.ax = -speed;
      if (this.vx != 0 && MathUtil.sign(this.ax) != MathUtil.sign(this.vx)) this.vx *= 0.25;
    } else if (k.down(this.inputs['right'])) {
      this.motion.ax = speed;
      if (this.vx != 0 && MathUtil.sign(this.ax) != MathUtil.sign(this.vx)) this.vx *= 0.25;
    } else {
      this.motion.ax = 0;
    }

    if (!this.actionDelayed) {
      if (k.pressed(this.inputs['bump']) || k.pressed(this.inputs['hit'])) {
        this.actionDelayed = true;
      }

      if (k.pressed(this.inputs['bump'])) 
        this._bump();

      if (k.pressed(this.inputs['hit'])) 
        this._hit();
    }

    // if we are attempting to hit the ball, check if we did
    if (this.hitType != NONE && canHitBall)
      this.game.colliders.collisionTestWithTag(this.hitCollider, ['ball'], _hitBall);
  }
  var collisionData:ShapeCollision;

  function update_playerAnimations() {
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
    this.box.scaleX = scale;
    this.box.scaleY = scale;
  }

  function update_hitAnimation() {

  }

  function _bump() {
    this.hitDistance = MAX_HIT_SIZE; // bump expands your hit range briefly
    this.tweener.start('bump'); 
    this.hitType = BUMPING;
    this.scale = 1.2;
    // start the bump animation
  }

  function _bumpUpdate(val:Float, tween) {
    this._updateHitRadius(val);
    this._updateScale();
  }

  function _bumpDone(tween) {
    this._hitRadiusReset();
  }

  function _hit() {
    this.tweener.start('hit'); 
    this.hitType = HITTING;
    this.scale = 1.15;
  }

  function _hitUpdate(val:Float, tween) {

  }

  function _hitDone(tween) {
    this._hitRadiusReset();
  }

  function _updateHitRadius(val):Void {
    this.hitDistance = MathUtil.lerp(MAX_HIT_SIZE, HIT_SIZE, val);
    this.setHitRadius();
  }

  function _updateScale():Void {
    if (this.scale > 1) this.scale -= Lib.delta;
    if (this.scale < 1) this.scale = 1;
  }

  function _hitRadiusReset():Void {
    this.actionDelayed = false;
    this.hitType = NONE;
    this.hitDistance = HIT_SIZE;
    this.setHitRadius();
  }

  function _hitBall(shape, collisionData):Void {
    trace('hit ball');
    var dx:Float = this.ball.x;
    var dy:Float = this.ball.y;
    switch (this.hitType) {
      case (HITTING): 
        if (this.x < this.field.centerX) {
          dx = this.field.centerX + 60;
        } else {
          dx = this.field.centerX - 60;
        }
        dy = this.field.centerY;
        this.ball.hitBall(this, dx, dy);
      case (BUMPING):
        dx += Math.random() * 6 - 3;
        dy += Math.random() * 6 - 3;
        this.ball.hitBall(this, dx, dy);
    }
    this.hasBall = false;
    this.actionDelayed = false;
    this.hitType = NONE;
  }

  inline function setHitRadius() {
    this.hitCollider.radius = this.hitRadius;
  }


  inline function get_moving():Bool { return Math.abs(this.vx) > _min_speed || Math.abs(this.vy) > _min_speed; }

  inline function get_field():PlayField { return this.game.playField; }
  inline function get_ball():Ball { return this.game.ball; }

  inline function get_hitRadius():Float { return this.width/2 + this.hitDistance; }

  inline function get_hitDistance():Float { return _hitDidstance; }
  inline function set_hitDistance(val:Float):Float { 
    _hitDidstance = val;
    if (this.hitCollider != null) this.hitCollider.radius = this.hitRadius;
    return _hitDidstance;
  }

  var _hitDidstance:Float = 0;
  var _bounceVal:Float = 0;
  var _maxBounce:Int = 8;
  var _bounceSpeed:Float = 68;
  var _bounceDir:Int = 1;
  var _min_speed:Float = 9;

}
