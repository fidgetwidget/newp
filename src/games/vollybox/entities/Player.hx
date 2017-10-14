package games.vollybox.entities;

import games.vollybox.*;
import games.vollybox.components.PlayerInput;
import games.vollybox.components.CPUInput;

import newp.components.*;
import newp.collision.shapes.Circle;
import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;
import newp.math.Utils as MathUtil;
import newp.transform.Easing;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;
import openfl.display.Sprite;
import openfl.display.Shape as Graphic;
import openfl.geom.Point;
import openfl.ui.Keyboard as Key;


class Player extends Entity {

  public inline static var BASE_MOVE_SPEED:Int = 300;
  public inline static var SERVICE_MOVE_SPEED:Int = 200;
  public inline static var MAX_MOVE_SPEED:Int = 200;
  public inline static var DRAG:Int = 300;
  public inline static var BOX_SIZE:Int = 20;

  public inline static var BUMP_TIME:Float = 0.4;
  public inline static var HIT_TIME:Float = 0.25;

  public inline static var BUMP_SCALE:Float = 1.33;
  public inline static var HIT_SCALE:Float = 1.25;

  public inline static var HIT_SIZE:Float = 2;
  public inline static var MAX_HIT_SIZE:Float = 19;
  public inline static var MAX_CHARGE:Float = 48;

  var game:VollyBox;
  var field(get, never):Field;
  var ball(get, never):Ball;
  var tweener:TweenerComponent;

  // Visual
  var width:Float;
  var height:Float;
  var scale:Float = 1;
  var boxSpr:Graphic;
  var shadowSpr:Sprite;
  var hitEffectSpr:Graphic;
  // Collision
  var hitDistance(get, set):Float; // how far away from the player they can still hit the ball
  var hitRadius(get, never):Float;
  var hitScale:Float = 0;

  public var isCpu(default, null):Bool = false;
  public var playerNo(default, null):Int;
  public var moving(get, never):Bool;
  public var hasBall(default, default):Bool = false;

  public var hitType(default, null):String = HitTypes.NONE; // which type of hitting the ball the player has triggered 
  public var charging(default, default):Bool = false;
  var chargeDir:Point = new Point();

  public var actionDelayed(default, default):Bool = false; // if the player is trying to hit the ball

  public var boxCollider:Shape;
  public var hitCollider:Circle;

  public function new(player:Int, game:VollyBox) {
    super();
    this.playerNo = player;
    // TODO: make this a game option
    if (player == 2) { this.isCpu = true; }
    this.name = 'player_'+this.playerNo;
    this.game = game;
    this.width = BOX_SIZE;
    this.height = BOX_SIZE;

    this.makeSprites();
    this.makeColliders();
    this.makeMotion();
    this.makeTweener();

    this.hitDistance = HIT_SIZE;
    
    this.initPosition();
  }

  // Init
  // ====

  // Sprites
  function makeSprites() {
    var parent = cast(this.body, Sprite);

    this.boxSpr = new Graphic();

    this.hitEffectSpr = new Graphic();
    this.hitEffectSpr.y = height / 2;

    this.shadowSpr = new Sprite();
    this.shadowSpr.y = height / 2;

    this.drawBox(this.boxSpr.graphics);
    this.drawHitEffect(this.hitEffectSpr.graphics);
    this.drawShadow(this.shadowSpr.graphics);

    parent.addChild(this.shadowSpr);
    parent.addChild(this.hitEffectSpr);
    parent.addChild(this.boxSpr);

    this.addComponent(new SpriteComponent(parent));

    if (!this.isCpu) {
      this.addComponent(new PlayerInput());
    } else {
      this.addComponent(new CPUInput(this.game));
    }

    this.hitEffectSpr.width = HIT_SIZE;
  }

  inline function drawBox(g) {
    Draw.start(g)
      .beginFill(VollyBox.DIRT)
      .lineStyle(1, VollyBox.DARK_SAND)
      .drawRect(-width/2, -height/2, width, height)
      .endFill();
  }

  inline function drawHitEffect(g) {
    var hitSize = (MAX_HIT_SIZE - HIT_SIZE) / 2;
    Draw.start(g)
      .beginFill(VollyBox.DARK_SAND, 1)
      .drawEllipse(-width/2-hitSize, -width/4-hitSize/2, width+hitSize*2, width/2+hitSize)
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
    var mask = SpriteComponent.make(this);
    this.drawMask(mask.graphics);
    this.shadowSpr.addChild(mask.sprite);

    this.boxCollider = new Shape(mask.sprite);
    ShapeComponent.make(this, boxCollider, ['player']);

    this.hitCollider = new Circle(this.body, this.hitRadius);
    this.hitCollider.offsetY = height/4;
    ShapeComponent.make(this, hitCollider, ['hit']);
    
  }

  // Motion
  function makeMotion() {    
    this.addComponent(new MotionComponent());
    this.motion.drag = DRAG;
    this.motion.max = MAX_MOVE_SPEED;
  }

  function makeTweener() {
    this.tweener = new TweenerComponent();
    this.addComponent(tweener);
    this.tweener.add('bump', BUMP_TIME)
      .onStep(_bumpUpdate)
      .onDone(_bumpDone);
    this.tweener.add('hit', HIT_TIME)
      .onStep(_hitUpdate)
      .onDone(_hitDone);
  }

  inline function initPosition() {
    this.y = field.centerY;
    switch(this.playerNo) {
      case 1:
        this.x = field.centerX - field.width / 4;
      case 2:
        this.x = field.centerX + field.width / 4;
    }
  }

  // Update
  // ======

  override public function update() {
    super.update();

    this.update_playerAnimations();
    this.update_hitAnimation();
  }

  inline function update_playerAnimations() {
    if (this.moving) {
      if (_bounceVal > _maxBounce) { _bounceDir = -1; _bounceVal = _maxBounce; }
      if (_bounceVal <= 0) {
        _bounceVal = 0; 
        _bounceDir = 1; 
        this.effect_hitGround();
      }
      _bounceVal += _bounceDir * Lib.delta * _bounceSpeed;
      this.boxSpr.y = -_bounceVal;
    } else {
      // not moving, not bouncing
      this.boxSpr.y = 0;
      _bounceVal = 0; 
      _bounceDir = 1; 
    } // moving

    if (this.charging) {
      var w = this.hitEffectSpr.width;
      this.hitEffectSpr.width = w == 20 ? 25 : 20;
    }
  }

  inline function update_hitAnimation() {
    if (this.hitType == HitTypes.BUMPING) {
      this.hitEffectSpr.width = this.hitRadius * 2;
    } else {
      this.hitEffectSpr.width = 0;
    }
    // player scale from hitting the ball
    this.boxSpr.scaleX = scale;
    this.boxSpr.scaleY = scale;
  }

  public function _bump() {
    // start the bump animation
    this.hitDistance = MAX_HIT_SIZE; // bump expands your hit range briefly
    this.tweener.start('bump'); 
    this.hitType = HitTypes.BUMPING;
    this.scale = this.hitScale = BUMP_SCALE;
    this.setHitRadius();
    this.effect_bump();
  }

  function _bumpUpdate() {
    var val = this.tweener.get('bump').percent;
    this._updateHitRadius(val);
    this._updateScale(val);
  }

  function _bumpDone() {
    this._hitRadiusReset();
  }

  public function _chargeHit(dx:Float, dy:Float) {
    var l:Float = 0;
    this.charging = true;

    dx += this.chargeDir.x;
    dy += this.chargeDir.y;

    l = MathUtil.vec_length(dx, dy);
    if (l > MAX_CHARGE) {
      dx = MathUtil.vec_normalize(l, dx) * MAX_CHARGE;
      dy = MathUtil.vec_normalize(l, dy) * MAX_CHARGE;
    }

    this.chargeDir.x = dx;
    this.chargeDir.y = dy;
  }

  public function _hit() {
    this.tweener.start('hit'); 
    this.hitType = HitTypes.HITTING;
    this.scale = this.hitScale = HIT_SCALE;
  }

  function _hitUpdate() {
    var val = this.tweener.get('hit').percent;
    this._updateScale(val);
  }

  function _hitDone() {
    this.chargeDir.x = 0;
    this.chargeDir.y = 0;
    this.charging = false;
    this._hitRadiusReset();
  }

  inline function _updateHitRadius(val):Void {
    this.hitDistance = MathUtil.lerp(MAX_HIT_SIZE, HIT_SIZE, val);
    this.setHitRadius();
  }

  inline function _updateScale(val):Void {
    this.scale = Easing.lerp(this.hitScale, 1, val);
    if (this.scale < 1) this.scale = 1;
  }

  inline function _hitRadiusReset():Void {
    this.actionDelayed = false;
    this.hitType = HitTypes.NONE;
    this.hitDistance = HIT_SIZE;
    this.setHitRadius();
  }



  // play the movement sound when the players body hits ground
  inline function effect_hitGround() {
    this.game.array_random(this.game.sounds['move']).play(0, 0, this.game.halfVolume);
    this.field.drawOnSand(this.boxCollider);
  }

  inline function effect_bump() {
    // play the bump sound effect
    this.game.array_random(this.game.sounds['smash']).play(0, 0, this.game.halfVolume);
    this.field.drawOnSand({x: this.hitCollider.x, y: this.hitCollider.y, radius: this.hitRadius });
  }


  inline function setHitRadius() { this.hitCollider.radius = this.hitRadius; }

  // Properties
  // ==========

  inline function get_moving():Bool { return Math.abs(this.vx) > _min_speed || Math.abs(this.vy) > _min_speed; }

  inline function get_field():Field { return this.game.field; }
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
