package games.vollybox;

import newp.collision.collections.ShapeBins;
import newp.collision.response.ShapeCollision;
import newp.collision.shapes.Shape;
import newp.display.collection.DisplayCollection;
import newp.math.Utils as MathUtil;
import newp.scenes.BasicScene;
import newp.tween.Easing;
import newp.utils.Draw;
import newp.Lib;
import openfl.display.Sprite;
import openfl.ui.Keyboard as Key;
import openfl.media.Sound;
import openfl.media.SoundTransform;
import openfl.Assets;


class VollyBox extends BasicScene {

  public static inline var DARK_SAND:Int = 0xd3c7a2;
  public static inline var SAND:Int = 0xfff8dc;
  public static inline var PRINTS:Int = 0xf3e9c3;
  public static inline var DIRT:Int = 0xf5deb3;
  public static inline var HIT_DELAY:Float = 0.13333333;
  public static inline var SLOWDOWN_DELAY:Float = 0.1333333;
  public static inline var NET_HEIGHT:Float = 5;

  public var player1:Player;
  public var player2:Player;
  public var ball:Ball;
  public var scoreBoard:ScoreBoard;
  public var field:Field;
  public var net:Net;
  public var sounds:Map<String, Array<Sound>>;
  public var halfVolume:SoundTransform;

  var bg:Sprite;
  var backgroundSprites:Array<Sprite> = [];
  var sortedSprties:Array<Sprite> = [];
  var foregroundSprites:Array<Sprite> = [];
  var hitting:Bool = false;
  var hitTimer:Float = 0;
  var slowdown:Bool = false;
  var slowTimer:Float = 0;

  public function new() {
    super();
    this.drawBackground();

    field = new Field();
    net = new Net(this);
    scoreBoard = new ScoreBoard(this);
    player1 = new Player(1, this);
    player2 = new Player(2, this);
    ball = new Ball(this);
    ball.serving(player1);

    this.init_soundsMap();
  }

  function drawBackground() {
    bg = new Sprite();
    Draw.start(bg.graphics)
      .beginFill(0xf5deb3)
      .drawRect(0, 0, Lib.stage.stageWidth, Lib.stage.stageHeight)
      .endFill();
  }

  override function init_sprites() {
    this.sprites = new DisplayCollection(['background', 'camera', 'foreground', 'hud', 'debug']);
    this.sprites.getLayer('camera').sortBy(
      function (a, b):Int { 
        return a.y == b.y ? 0 : a.y < b.y ? -1 : 1; 
      });
  }

  override function init_colliders() {
    this.colliders = new ShapeBins(Lib.stage.stageWidth, Lib.stage.stageHeight); 
  }

  function init_soundsMap() {
    this.sounds = [
      'ball' => [],
      'event' => [],
      'hit' => [],
      'move' => [],
      'smash' => [],
    ];
    for (i in 1...6) {
      this.pushSound('ball', i);
      this.pushSound('event', i);
      this.pushSound('hit', i);
    }
    this.pushSound('smash', 1);
    this.pushSound('smash', 2);
    // picked the most subtle ones only
    // this.pushSound('move', 3);
    this.pushSound('move', 10);
    this.halfVolume = new SoundTransform(0.5);
  }
  inline function pushSound(name:String, i:Int):Void {
    this.sounds['$name'].push(Assets.getSound('sounds/VolleyBox/$name-$i.ogg'));
  }

  override public function update() {
    for (e in this.entities) {
      e.update();
      for (c in e.colliders) this.colliders.update(c);
    }
    this.update_input();
    this.update_collisionTests();

    // Hit Delay
    if (this.hitting && this.ball.z != 0) {
      this.hitReset();
    }

    if (this.hitting) {
      this.hitTimer += Lib.delta;

      if (this.hitTimer >= HIT_DELAY) {
        this.score();
        this.hitReset();
      }
    }

    if (this.ball.moving && this.ball.z == 0) {
      this.field.drawOnSand(this.ball.collider);
    }

    if (this.ball.inSlowdownRange || this.hitting) {
      if (!this.slowdown) // only try if we aren't already in slowdown mode
        this.update_slowdownRangeCollisionTest(); 
      else {
        this.slowTimer += Lib.delta;
        var t = this.slowTimer > SLOWDOWN_DELAY ? 1 : this.slowTimer / SLOWDOWN_DELAY;
        Lib.gamespeed = Easing.lerp(0.1, 1, t);
      }
    } else {
      this.endSlowdown();
    }

    this.sprites.sortLayer('camera');
  }

  public function ballHitGround() {
    hitting = true;
    this.array_random(this.sounds['ball']).play();
  }

  // adding stuff to the scene on begin

  override public function begin() {
    // background
    this.addSprite(bg, 'background');
    this.addSprite(field, 'background');

    this.addEntity(net);
    this.addEntity(scoreBoard);
    this.addEntity(ball);
    this.addEntity(player1);
    this.addEntity(player2);

    // this.colliders.drawDebug = true;
  }

  override public function end() {
    super.end();
  }


  inline function update_input() {
    var k = Lib.inputs.keyboard;

    // toggle debug
    if (k.pressed(Key.SPACE)) { 
      Lib.debug = !Lib.debug;
    }

    // give player 1 the ball
    if (k.pressed(Key.R) && this.player2.isCpu) {
      ball.serving(player1);
    }
  }

  inline function update_collisionTests() {
    this.colliders.collisionTestAll(resolve_playerCollision, ['player', 'net', 'score']);

    if (this.ball.z < NET_HEIGHT) {
      this.colliders.collisionTest(this.ball.collider, resolve_ballHitsNet, ['ball', 'net']);
    }

    if (this.player1.hitType != HitTypes.NONE && (this.ball.inHitRange || this.player1.hasBall)) {
      this.colliders.collisionTest(this.player1.hitCollider, resolve_playerHitBall, ['ball', 'hit']);
    } 

    if (this.player2.hitType != HitTypes.NONE && (this.ball.inHitRange || this.player2.hasBall)) {
      this.colliders.collisionTest(this.player2.hitCollider, resolve_playerHitBall, ['ball', 'hit']);
    }

    this.collision_playerBounds(this.player1);
    this.collision_playerBounds(this.player2);
  }

  inline function collision_playerBounds(player:Player) {
    var bounds = player.boxCollider.bounds;
    if (bounds.top < 0 && player.vy < 0) player.vy *= -1;
    if (bounds.bottom > Lib.stageHeight && player.vy > 0) player.vy *= -1;
    if (bounds.left < 0 && player.vx < 0) player.vx *= -1;
    if (bounds.right > Lib.stageWidth && player.vx > 0) player.vx *= -1;
  }

  inline function update_slowdownRangeCollisionTest() {
    this.colliders.collisionTestAll(triggerSlowdown, ['player', 'slowdown']);
  }

  function resolve_playerCollision(shape:Shape, data:ShapeCollision) {
    var player;
    if (shape == player1.boxCollider) 
      player = this.player1;
    else if (shape == player2.boxCollider) 
      player = this.player2;
    else
      return;
    // trace('collisionData', data.shape2.tags);

    if (data.separationX != 0) {
      player.x -= data.separationX;
      player.vx *= -1;
      player.x += player.vx * Lib.delta;
      player.vx = 0;
      player.ax = 0;
    }
    else {
      player.y -= data.separationY;
      player.vy *= -1;
      player.y += player.vy * Lib.delta;
      player.vy = 0;
      player.ay = 0;
    }
  }

  function resolve_playerHitBall(shape:Shape, data:ShapeCollision) {
    // trace('player hit ball');
    var dx:Float = this.ball.x;
    var dy:Float = this.ball.y;
    var player = shape == this.player1.hitCollider ? this.player1 : this.player2;

    switch (player.hitType) {

      case (HitTypes.HITTING): 
        if (player.x < this.field.centerX) {
          dx = this.field.centerX + 60;
        } else {
          dx = this.field.centerX - 60;
        }
        dy = this.field.centerY;
        var l = MathUtil.vec_length(player.vx, player.vy);
        dx += player.vx; // * l;
        dy += player.vy; // * l;
        this.ball.hitBall(player, dx, dy);
        this.array_random(this.sounds['hit']).play();

      case (HitTypes.BUMPING):
        dx += Math.random() * 6 - 3;
        dy += Math.random() * 6 - 3;
        this.ball.hitBall(player, dx, dy);
        this.array_random(this.sounds['hit']).play();
    }
    player.hasBall = false;
  }

  // Ball hits net
  function resolve_ballHitsNet(shape:Shape, data:ShapeCollision) {
    // trace('ball hits net');
    this.ball.x -= data.separationX * data.unitVectorX;
    this.ball.vx *= -1; // reflect off of the net
    this.ball.x += this.ball.vx * Lib.delta;
    this.ball.vz /= 5; // reduce fall speed
    if (this.ball.inService) {
      this.ball.serving(null);
    } else {
      this.array_random(this.sounds['ball']).play();
    }
  }

  inline function hitReset() {
    this.hitTimer = 0;
    this.hitting = false;
  }

  inline function score() {
    this.sounds['event'][1].play();
    var side = this.ball.x < this.field.centerX ? 1 : 2;
    switch (side) {
      case 1:
        this.scoreBoard.player2Score += 1;

      case 2:
        this.scoreBoard.player1Score += 1;
    }
  }

  inline function triggerSlowdown(shape, data) {
    this.slowdown = true;
    this.slowTimer = 0;
    Lib.gamespeed = 0.1;
  }

  inline function endSlowdown() {
    this.slowdown = false;
    this.slowTimer = 0;
    Lib.gamespeed = 1;
  }

  public inline function array_random<T>(array:Array<T>):T {
    return array[Std.random(array.length)];
  }

}
