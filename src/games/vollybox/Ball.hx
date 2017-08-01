package games.vollybox;

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
import openfl.geom.Point;


class Ball extends Entity {

  static inline var MAX_HEIGHT:Float = 20;
  static inline var MAX_SCALE:Float = 3.8;
  static inline var HIT_TIME:Float = 1;
  static inline var HIT_RANGE:Float = 1.3333333;
  static inline var MAX_MOVE_SPEED:Float = 200;
  static inline var DRAG:Float = 280;
  static inline var AIR_DRAG:Float = 30;
  static inline var SCALE_Z_DIVISOR:Float = 8;
  static inline var HELD_Z_VAL:Float = 0.2;
  static inline var SLOW_GRAVITY:Float = 80;
  static inline var GRAVITY:Float = 100;
  static inline var SLOW_Z_HIT:Float = 45;
  static inline var Z_HIT:Float = 60;
  public static inline var RADIUS:Float = 8;

  var game:VollyBox;
  var field(get, never):Field;

  var ball:SpriteComponent;
  var ballSpr:Sprite;
  var shadow:SpriteComponent;
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
  public var slowdownCollider:Shape;
  public var moving(get, never):Bool;
  public var inSlowdownRange(get, never):Bool;
  public var inHitRange(get, never):Bool;
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
    this.shadow = SpriteComponent.make(this, 'background');
    this.drawShadow(this.shadow.graphics);

    this.ball = SpriteComponent.make(this, 'background');
    this.ballSpr = this.ball.addSprite();
    this.drawBall(this.ballSpr.graphics);
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
    this.collider = new Circle(this.shadow.sprite, RADIUS);
    ShapeComponent.make(this, this.collider, ['ball']);

    this.slowdownCollider = new Circle(this.shadow.sprite, RADIUS * 3);
    ShapeComponent.make(this, this.slowdownCollider, ['slowdown']);
  }

  function makeMotion() {
    this.addComponent(new MotionComponent());
    this.motion.drag = DRAG;
    this.motion.max = MAX_MOVE_SPEED;
  }

  // Methods
  // =======

  public function serving(player:Player) {
    if (player == null && this.inServiceTo != null) this.inServiceTo.hasBall = false;

    this.inServiceTo = player;
    this.vz = 0;
    this.az = 0;

    if (player != null) {
      this.ball.layer = 'foreground';
      this.z = HELD_Z_VAL;
      player.hasBall = true;  
      // trace('now serving player${player.playerNo}');
    } else {
      // ball hits some obstacle 
      this.airTime = 1;
      this.vz = -GRAVITY;
    }
  }

  public function hitBall(player:Player, ?x:Float, ?y:Float) {
    this.lastHitBy = player;
    this.inServiceTo = null;

    var xx = x != null ? x : this.x;
    var yy = y != null ? y : this.y;
    var dx = xx - this.x;
    var dy = yy - this.y;
    var d = MathUtil.vec_length(dx, dy); // distance
    var speed = 1; // TODO: change this to be based on an argument coming in.

    this.dirX = MathUtil.vec_normalize(d, dx);
    this.dirY = MathUtil.vec_normalize(d, dy);
    
    this.airTime = 1;
    this.z = 2;
    // set up hit vs hit over hit
    if (d < 5) { 
      speed = 30;
      this.vz = SLOW_Z_HIT;
      this.az = -SLOW_GRAVITY;
    } else {
      speed = 300;
      this.vz = Z_HIT;
      this.az = -GRAVITY;
    }

    this.vx = this.dirX * speed;
    this.vy = this.dirY * speed;

    this.ball.layer = 'foreground';
    // trace('hit ball: $d $x|$y : ${this.vx}|${this.vy}');
  }

  // Update
  // ======

  override public function update() {
    if (this.z > 0) {
      motion.drag = AIR_DRAG;
    } else {
      motion.drag = DRAG;
    }
    
    super.update();
    if (this.inService) {
      this.update_heldPosition();
    } else {
      if (this.airTime > 0) {
        this.update_inAir();
      }
    }
    this.update_ballScale();
    this.update_ballOffset();
  }

  inline function update_heldPosition():Void {
    var side = this.inServiceTo.x > this.field.centerX ? -1 : 1;
    this.x = this.inServiceTo.x + 10 * side;
    this.y = this.inServiceTo.y + 4;
  }

  inline function update_inAir():Void {
    if (this.z <= 0) {
      this.z = 0;
      this.vz = 0;
      this.az = 0;
      this.airTime = 0;
      this.game.ballHitGround();
      this.ball.layer = '';
    }
  } 

  inline function update_ballOffset() {
    this.yOffset = this.z;
    this.ballSpr.y = -this.yOffset;
  }

  inline function update_ballScale() {
    scale = (this.z/SCALE_Z_DIVISOR) + 1;
    if (scale < 1) scale = 1;
    this.ball.scaleX = scale;
    this.ball.scaleY = scale;
  }

  // Properties
  // ==========

  inline function get_moving():Bool { return Math.abs(this.vx) > 0.1 || Math.abs(this.vy) > 0.1; }

  inline function get_field():Field { return this.game.field; }
  
  inline function get_inService():Bool { return this.inServiceTo != null; }
  
  inline function get_inHitRange():Bool { return this.z <= HIT_RANGE; }

  inline function get_inSlowdownRange():Bool { return this.z <= HIT_RANGE * 2 && this.z > HELD_Z_VAL && this.vz < 0; }

}
