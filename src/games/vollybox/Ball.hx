package games.vollybox;

import newp.components.*;
import newp.collision.shapes.Circle;
import newp.collision.shapes.Shape;
import newp.collision.ShapeCollision;
import newp.math.Utils as MathUtils;
import newp.utils.Draw;
import newp.Entity;
import newp.Lib;
import openfl.display.Sprite;


class Ball extends Entity {

  static inline var MAX_HEIGHT:Float = 20;

  var game:VollyBox;
  var field(get, never):PlayField;

  public var ball:Sprite;
  var shadow:Sprite;
  
  var lastHitBy:Player;
  var speed:Float = 0;
  var height:Float = 1;
  var hitHeight:Float = 0;
  var dirX:Float = 0;
  var dirY:Float = 0;
  var dist:Float = 0;
  var hitTimer:Float = 0;
  public var onGround:Bool = false;
  public var inService:Bool = true;

  public function new(game:VollyBox) {
    super();
    this.game = game;

    var sprite = new Sprite();
    this.ball = new Sprite();
    this.shadow = new Sprite();
    sprite.addChild(shadow);
    this.drawSprites();

    var collider = new Circle(this.shadow, 10);
    this.addComponent(new SpriteComponent(sprite));
    this.addComponent(new ShapeComponent(collider));

    this.x = field.centerX - 60;
    this.y = field.centerY;
  }

  function drawSprites() {
    var g = this.ball.graphics;
    Draw.start(g)
      .beginFill(0xffffff)
      .drawCircle(0, 0, 7)
      .endFill();

    g = this.shadow.graphics;
    Draw.start(g)
      .beginFill(0x555555, 0.2)
      .drawEllipse(-7, 7, 14, 10)
      .endFill();
  }

  override public function update() {
    var d = Lib.delta;

    if (!this.inService) {

      if (this.hitTimer > 0 && this.lastHitBy != null) this.updateHit();
      this.hitTimer -= d;

      // update it's movement towards it's destination
      _curDist += speed * d;

      _scale = (this.height / MAX_HEIGHT) + 1;
      
      this.ball.scaleX = _scale;
      this.ball.scaleY = _scale;

      this.x += dirX * speed * d;
      this.y += dirY * speed * d;
    }

    if (_curDist > dist) { 
      height = 1; 
      _ballY = 0;
      onGround = true;
    }
    _ballY = _scale * 3;

    this.ball.x = this.x;
    this.ball.y = this.y + _ballY;
  }
  var _scale:Float = 1;
  var _ballY:Float = 0;
  var _curDist:Float = 0;

  function updateHit() {
    this.dirX += prevX - initX;
    this.dirY += prevY - initY;
    this.prevX = this.lastHitBy.x;
    this.prevY = this.lastHitBy.y;
    this.dirX += prevX - initX;
    this.dirY += prevY - initY;
    var l = MathUtils.vec_length(this.dirX, this.dirY);
    this.dirX = MathUtils.vec_normalize(l, this.dirX);
    this.dirY = MathUtils.vec_normalize(l, this.dirY);
    this.dist = 100 * l;
  }
  var initX:Float;
  var initY:Float;
  var prevX:Float;
  var prevY:Float;

  public function ballHit(player:Player) {
    this.lastHitBy = player;
    this.hitTimer = 1;
    this.prevX = this.initX = player.x;
    this.prevY = this.initY = player.y;
  }


  inline function get_field():PlayField { return this.game.playField; }

}
