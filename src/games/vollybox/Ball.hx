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

  var dirX:Float = 0;
  var dirY:Float = 0;
  var destZ:Float = 0;
  var hitX:Float = 0;
  var hitY:Float = 0;
  var airTime:Float = 0; // how long the hit is going to keep the ball in the air
  var travelSpeed:Float = 0;
  var travel:Float = 0;
  var scale:Float = 1;
  var yOffset:Float = 0;
  


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

    var xx = x != null ? x : this.x;
    var yy = y != null ? y : this.y;
    var dx = xx - this.x;
    var dy = yy - this.y;
    var d = MathUtil.vec_length(dx, dy); // distance
    this.dirX = MathUtil.vec_normalize(d, dx);
    this.dirY = MathUtil.vec_normalize(d, dy);
    // NOTE: HIT_TIME is temp - how long the ball will take to get to it's destination
    //  this should be determined by a number of factors, and not just be a constant
    this.airTime = HIT_TIME;
    this.travelSpeed = d / HIT_TIME;
    trace('dx: $dx dy: $dy dirX: $dirX dirY: $dirY d: $d');
  }

  // Update
  // ======

  override public function update() {
    if (this.inService) {
      update_heldPosition();
    } else {
      if (this.airTime > 0) update_inPlayPosition();
    }

    this.yOffset = this.z;
    this.ballSpr.y = -this.yOffset;

    super.update();
  }

  function update_heldPosition():Void {
    var side = this.inServiceTo.x > this.field.centerX ? -1 : 1;
    this.x = this.inServiceTo.x + 10 * side;
    this.y = this.inServiceTo.y + 4;
    this.z = 2;
  }

  function update_inPlayPosition():Void {
    var d = Lib.delta;
    this.airTime -= d;

    var p = (HIT_TIME - this.airTime) / HIT_TIME;
    if (this.airTime < HIT_TIME / 2) {
      scale = MathUtil.lerp(5, 1, p);
    } else {
      scale = MathUtil.lerp(1, 5, p);
    }
    if (scale < 1) scale = 1;
    this.ball.scaleX = scale;
    this.ball.scaleY = scale;

    // update it's movement towards it's destination
    this.travel += travelSpeed * d;
    this.x += dirX * travelSpeed * d;
    this.y += dirY * travelSpeed * d;
    trace('pos: $x | $y');

    this.z = (scale * 5) - 5;
    if (this.z == 0) {
      this.game.ballHitGround();
    }
  } 

  // Properties
  // ==========

  inline function get_field():PlayField { return this.game.playField; }
  inline function get_inService():Bool { return this.inServiceTo != null; }
  inline function get_onGround():Bool { return this.z <= 1.333; }

}
