package games.vollybox;

import newp.components.*;
import newp.collision.shapes.Circle;
import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;
import newp.math.Utils as MathUtils;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;
import openfl.display.Sprite;


class Ball extends Entity {

  static inline var MAX_HEIGHT:Float = 20;
  static inline var RADIUS:Float = 8;

  var game:VollyBox;
  var field(get, never):PlayField;

  
  var shadow:Sprite;
  var lastHitBy:Player = null;
  var inServiceTo:Player = null;
  var speed:Float = 0;
  var height:Float = 1;
  var hitHeight:Float = 0;
  var dirX:Float = 0;
  var dirY:Float = 0;
  var dist:Float = 0;
  var hitTimer:Float = 0;

  public var ball:Sprite;

  public var onGround(get, never):Bool;
  public var inService(get, never):Bool;

  public function new(game:VollyBox) {
    super();
    this.game = game;

    var sprite = this.makeSprites();
    var collider = this.makeColliders();

    this.addComponent(new SpriteComponent(sprite));
    this.addComponent(new ShapeComponent(collider));

    this.x = field.centerX - 60;
    this.y = field.centerY;
  }

  function makeSprites() {
    var parent = new Sprite();
    this.ball = new Sprite();
    this.shadow = new Sprite();

    this.drawBall(this.ball.graphics);
    this.drawShadow(this.shadow.graphics);

    parent.addChild(shadow);
    return parent;
  }

  inline function drawBall(g) {
    Draw.start(g)
      .beginFill(0xffffff)
      .drawCircle(0, 0, RADIUS)
      .endFill();
  }

  inline function drawShadow(g) {
    Draw.start(g)
      .beginFill(0x555555, 0.2)
      .drawEllipse(-7, 7, 14, RADIUS)
      .endFill();
  }

  function makeColliders() {
    return new Circle(this.shadow, RADIUS);
  }

  // Methods
  // =======

  public function serving(player:Player) {
    this.inServiceTo = player;
  }

  public function ballHit(player:Player) {
    this.lastHitBy = player;
    this.hitTimer = 1;
    this._prevX = this._hitX = player.x;
    this._prevY = this._hitY = player.y;
  }

  // Update
  // ======

  override public function update() {
    if (this.inService) {
      update_heldPosition();
    } else {
      update_inPlayPosition();
    }

    this.ball.x = this.x;
    this.ball.y = this.y;
  }

  function update_heldPosition():Void {
    var side = this.inServiceTo.x > this.field.centerX ? -1 : 1;
    this.x = this.inServiceTo.x + 10 * side;
    this.y = this.inServiceTo.y + 4;
  }

  function update_inPlayPosition():Void {
    var d = Lib.delta;
    if (this.hitTimer > 0 && this.lastHitBy != null) this.update_beingHit();
    this.hitTimer -= d;

    // update it's movement towards it's destination
    _curDist += speed * d;
    _scale = 1;
    
    this.ball.scaleX = _scale;
    this.ball.scaleY = _scale;

    this.x += dirX * speed * d;
    this.y += dirY * speed * d;

    if (_curDist > dist) { 
      height = 1; 
      _ballY = 0;
    }
    _ballY = _scale * 3;
  } 

  function update_beingHit() {
    this.dirX += _prevX - _hitX;
    this.dirY += _prevY - _hitY;
    this._prevX = this.lastHitBy.x;
    this._prevY = this.lastHitBy.y;
    this.dirX += _prevX - _hitX;
    this.dirY += _prevY - _hitY;
    var l = MathUtils.vec_length(this.dirX, this.dirY);
    this.dirX = MathUtils.vec_normalize(l, this.dirX);
    this.dirY = MathUtils.vec_normalize(l, this.dirY);
    this.dist = 100 * l;
  }

  var _hitX:Float;
  var _hitY:Float;
  var _prevX:Float;
  var _prevY:Float;
  var _scale:Float = 1;
  var _ballY:Float = 0;
  var _curDist:Float = 0;

  // Properties
  // ==========

  inline function get_field():PlayField { return this.game.playField; }
  inline function get_inService():Bool { return this.inServiceTo != null; }
  inline function get_onGround():Bool { return this.height <= 1; }

}
