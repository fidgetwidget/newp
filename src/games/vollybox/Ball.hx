package games.vollybox;

import newp.components.*;
import newp.collision.shapes.Circle;
import newp.collision.shapes.Shape;
import newp.collision.response.ShapeCollision;
import newp.entity.EntityMotion;
import newp.math.Utils as MathUtil;
import newp.math.Easing;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;
import openfl.display.Sprite;
import openfl.geom.Point;


class Ball extends Entity {

  static inline var MAX_HEIGHT:Float = 20;
  static inline var MAX_SCALE:Float = 3.8;
  static inline var RADIUS:Float = 8;
  static inline var HIT_TIME:Float = 1;
  inline static var MAX_MOVE_SPEED:Float = 200;
  inline static var DRAG:Float = 300;
  inline static var AIR_DRAG:Float = 90;
  inline static var Z_DRAG:Float = 200;

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
    this.name = 'ball';
    this.game = game;

    this.makeSprites();
    this.makeColliders();
    this.makeMotion();

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

  function makeMotion() {
    var motion = new EntityMotion(this);
    motion.drag = DRAG;
    motion.setDrag(AIR_DRAG, 'z');
    motion.max = MAX_MOVE_SPEED;
    
    this.addComponent(new MotionComponent(motion));
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
    this.airTime = 1;
    this.vx = this.dirX * 500;
    this.vy = this.dirY * 500;
    this.vz = 100;

    trace('hit ball: ${this.vx}|${this.vy}|${this.vz}');
  }

  // Update
  // ======

  override public function update() {
    if (this.z > 0) {
      motion.drag = AIR_DRAG;
      motion.setDrag(Z_DRAG, 'z');
    } else {
      motion.drag = DRAG;
      motion.setDrag(Z_DRAG, 'z');
    }
    
    super.update();
    if (this.inService) {
      update_heldPosition();
    } else {
      if (this.airTime > 0) {
        update_inPlayPosition();
        trace('${this.z} : ${this.vx}|${this.vy}|${this.vz}');
      }
    }

    this.yOffset = this.z;
    this.ballSpr.y = -this.yOffset;
  }

  function update_heldPosition():Void {
    var side = this.inServiceTo.x > this.field.centerX ? -1 : 1;
    this.x = this.inServiceTo.x + 10 * side;
    this.y = this.inServiceTo.y + 4;
    this.z = 2;
  }

  function update_inPlayPosition():Void {
    this.z -= 19 * Lib.delta;
    scale = (this.z/2) + 1;
    if (scale < 1) scale = 1;
    this.ball.scaleX = scale;
    this.ball.scaleY = scale;

    if (this.z <= 0) {
      this.z = 0;
      this.airTime = 0;
      this.game.ballHitGround();
    }
  } 

  // Properties
  // ==========

  inline function get_field():PlayField { return this.game.playField; }
  inline function get_inService():Bool { return this.inServiceTo != null; }
  inline function get_onGround():Bool { return this.z <= 1.333; }

}
