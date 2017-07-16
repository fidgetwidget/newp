package games.vollybox;

import newp.components.*;
import newp.collision.shapes.Circle;
import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;
import newp.math.Utils as MathUtil;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;
import openfl.display.Sprite;
import openfl.geom.Point;


class Ball extends Entity {

  static inline var MAX_HEIGHT:Float = 20;
  static inline var RADIUS:Float = 8;
  static inline var HIT_TIME:Float = 3;

  var game:VollyBox;
  var field(get, never):PlayField;

  var ball:Sprite;
  var ballSpr:Sprite;
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
  var hitX:Float = 0;
  var hitY:Float = 0;
  var hitDist:Float = 0;
  
  public var collider:Shape;
  public var onGround(get, never):Bool;
  public var inService(get, never):Bool;

  public function new(game:VollyBox) {
    super();
    this.game = game;

    this.makeSprites();
    this.makeColliders();

    this.x = field.centerX - 60;
    this.y = field.centerY;
  }

  function makeSprites() {
    this.shadow = new Sprite();
    this.drawShadow(this.shadow.graphics);
    this.addComponent(new SpriteComponent(shadow, 'background'));

    this.ball = new Sprite();
    this.ballSpr = new Sprite();
    this.ball.addChild(ballSpr);
    this.drawBall(this.ballSpr.graphics);
    this.addComponent(new SpriteComponent(ball, 'foreground'));
  }

  inline function drawBall(g) {
    Draw.start(g)
      .beginFill(0xffffff)
      .lineStyle(1, 0x999999, 0.2)
      .drawCircle(0, 0, RADIUS)
      .endFill();
  }

  inline function drawShadow(g) {
    Draw.start(g)
      .beginFill(0x555555, 0.1)
      .drawEllipse(-RADIUS, RADIUS/2, RADIUS*2, RADIUS)
      .endFill();
  }

  function makeColliders() {
    this.collider = new Circle(this.shadow, RADIUS);
    this.addComponent(new ShapeComponent(collider, ['ball']));
  }

  // Methods
  // =======

  public function serving(player:Player) {
    this.inServiceTo = player;
    player.hasBall = true;
    trace('now serving player${player.playerNo}');
  }

  public function hitBall(player:Player, ?x:Float, ?y:Float) {
    this.lastHitBy = player;
    this.inServiceTo = null;

    this.hitX = x != null ? x : this.x;
    this.hitY = y != null ? y : this.y;
    var dx = this.x - this.hitX;
    var dy = this.y - this.hitY;
    this.hitDist = MathUtil.vec_length(dx, dy);
    this.hitHeight = 30;
    this.speed = this.hitDist / 30;
    this.hitTimer = HIT_TIME;
  }

  // Update
  // ======

  override public function update() {
    if (this.inService) {
      update_heldPosition();
    } else {
      if (this.hitTimer > 0) update_inPlayPosition();
    }

    this._ballY = this.height;
    this.ballSpr.y = -this._ballY;

    super.update();
  }

  function update_heldPosition():Void {
    var side = this.inServiceTo.x > this.field.centerX ? -1 : 1;
    this.x = this.inServiceTo.x + 10 * side;
    this.y = this.inServiceTo.y + 4;
    this.height = 2;
  }

  function update_inPlayPosition():Void {
    var d = Lib.delta;
    this.hitTimer -= d;

    // update it's movement towards it's destination
    _curDist += speed * d;
    var p = (HIT_TIME - this.hitTimer) / HIT_TIME;
    if (this.hitTimer < HIT_TIME / 2) {
      _scale = MathUtil.lerp(5, 1, p);
    } else {
      _scale = MathUtil.lerp(1, 5, p);
    }
    if (_scale < 1) _scale = 1;

    this.ball.scaleX = _scale;
    this.ball.scaleY = _scale;

    this.x += dirX * speed * d;
    this.y += dirY * speed * d;
    this.height = (_scale * 5) - 5;
    if (this.height == 0) {
      this.game.ballHitGround();
    }
  } 

  var _scale:Float = 1;
  var _ballY:Float = 0;
  var _curDist:Float = 0;

  // Properties
  // ==========

  inline function get_field():PlayField { return this.game.playField; }
  inline function get_inService():Bool { return this.inServiceTo != null; }
  inline function get_onGround():Bool { return this.height <= 1.333; }

}
