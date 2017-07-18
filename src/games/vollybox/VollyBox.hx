package games.vollybox;

import newp.collision.response.ShapeCollision;
import newp.collision.collections.ShapeBins;
import newp.display.collection.SpriteCollection;
import newp.scenes.BasicScene;
import newp.math.Utils as MathUtil;
import newp.utils.Draw;
import newp.Lib;
import openfl.display.Sprite;


class VollyBox extends BasicScene {

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
    this.sprites = new SpriteCollection(['background', 'camera', 'foreground', 'hud', 'debug']);
    this.sprites.getLayer('camera').sortBy(
      function (a:Sprite, b:Sprite):Int { 
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

    var k = Lib.inputs.keyboard;
    if (k.pressed(32)) { // Spacebar
      Lib.debug = !Lib.debug;
    }

    this.update_collisionTests();
    this.sprites.sortLayer('camera');
  }

  public function ballHitGround() {
    trace('ball hit ground');
  }

  function update_collisionTests() {
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

}
