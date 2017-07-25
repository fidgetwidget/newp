package games.vollybox;

import newp.collision.response.ShapeCollision;
import newp.collision.collections.ShapeBins;
import newp.display.collection.DisplayCollection;
import newp.scenes.BasicScene;
import newp.math.Utils as MathUtil;
import newp.utils.Draw;
import newp.Lib;
import openfl.display.Sprite;
import openfl.ui.Keyboard as Key;


class VollyBox extends BasicScene {

  public static inline var DARK_SAND:Int = 0xd3c7a2;
  public static inline var SAND:Int = 0xfff8dc;
  public static inline var DIRT:Int = 0xf5deb3;
  public static inline var HIT_DELAY:Float = 0.3333333;

  public var player1:Player;
  public var player2:Player;
  public var ball:Ball;
  public var scoreBoard:ScoreBoard;
  public var playField:PlayField;
  public var net:Net;

  var bg:Sprite;
  var backgroundSprites:Array<Sprite> = [];
  var sortedSprties:Array<Sprite> = [];
  var foregroundSprites:Array<Sprite> = [];
  var hitTimer:Float = 0;
  var hitting:Bool = false;

  public function new() {
    super();
    this.drawBackground();

    playField = new PlayField();
    net = new Net(this);
    scoreBoard = new ScoreBoard(this);
    player1 = new Player(1, this);
    player2 = new Player(2, this);
    ball = new Ball(this);
    ball.serving(player1);
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

    this.sprites.sortLayer('camera');
  }

  public function ballHitGround() {
    hitting = true;
  }

  // adding stuff to the scene on begin

  override public function begin() {
    // background
    this.addSprite(bg, 'background');
    this.addSprite(playField, 'background');

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
    if (k.pressed(Key.R)) {
      ball.serving(player1);
    }
  }

  inline function update_collisionTests() {
    var p1c = this.player1.boxCollider;
    var p2c = this.player2.boxCollider;
    this.colliders.collisionTestAllWithTag(
      ['player', 'net', 'score'], 
      function (shape, data) {
        if (shape == p1c && data.shape2 != p2c) resolve_playerCollision(this.player1, data);
        if (shape == p2c && data.shape2 != p1c) resolve_playerCollision(this.player2, data);
      });
  }

  function resolve_playerCollision(player:Player, collisionData:ShapeCollision) {
    if (collisionData.separationX != 0) {
      var sign = MathUtil.sign(collisionData.separationX);
      player.x -= collisionData.separationX;
      player.vx *= -1;
      player.x += player.vx * Lib.delta;
      player.vx = 0;
      player.ax = 0;
    }
    else {
      var sign = MathUtil.sign(collisionData.separationY);
      player.y -= collisionData.separationY;
      player.vy *= -1;
      player.y += player.vy * Lib.delta;
      player.vy = 0;
      player.ay = 0;
    }
  }


  inline function hitReset() {
    this.hitTimer = 0;
    this.hitting = false;
  }

  inline function score() {
    var side = this.ball.x < this.playField.centerX ? 1 : 2;
    switch (side) {
      case 1:
        this.scoreBoard.player2Score += 1;

      case 2:
        this.scoreBoard.player1Score += 1;
    }
  }

}
