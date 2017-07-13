package games.vollybox;

import newp.collision.response.ShapeCollision;
import newp.collision.collections.ShapeBins;
import newp.display.SpriteCollection;
import newp.scenes.BasicScene;
import newp.utils.Draw;
import newp.Lib;
import openfl.display.Sprite;


class VollyBox extends BasicScene {

  var bg:Sprite;

  public var player1:Player;
  public var player2:Player;
  public var ball:Ball;
  public var scoreBoard:ScoreBoard;
  public var playField:PlayField;
  public var net:Net;

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
    }

    this.update_collisionTests();
    this.sprites.sortLayer('camera');
  }


  function update_collisionTests() {
    this._player_net_collision(this.player1);
    this._player_score_collision(this.player1);

    this._player_net_collision(this.player2);
    this._player_score_collision(this.player2);
  }

  

  function _player_net_collision(p:Player) {
    if (this.net.collider.test(p.boxCollider, collisionData, true) != null) {
      if (collisionData.separationX != 0) {
        p.x -= collisionData.separationX;
        p.vx *= -1;
      } else {
        p.y -= collisionData.separationY;
        p.vy *= -1;
      }
    }
  }

  function _player_score_collision(p:Player) {
    var collider = this.scoreBoard.player1ScoreCollider;
    if (collider.test(p.boxCollider, collisionData, true) != null) {
      if (collisionData.separationX != 0) {
        p.x -= collisionData.separationX;
        p.vx *= -1;
      } else {
        p.y -= collisionData.separationY;
        p.vy *= -1;
      }
    }
    collider = this.scoreBoard.player2ScoreCollider;
    if (collider.test(p.boxCollider, collisionData, true) != null) {
      if (collisionData.separationX != 0) {
        p.x -= collisionData.separationX;
        p.vx *= -1;
      } else {
        p.y -= collisionData.separationY;
        p.vy *= -1;
      }
    }
  }

  var collisionData:ShapeCollision = new ShapeCollision();


  // adding stuff to the scene on begin

  override public function begin() {
    super.begin();
    // background
    this.addSprite(bg, 'background');
    this.addSprite(playField, 'background');
    this.addSprite(net.netBottom, 'background');
    this.addSprite(net.shadow, 'background');

    // sortable
    this.addSprite(scoreBoard, 'camera');
    this.addEntity(ball);
    this.addEntity(player1);
    this.addEntity(player2);

    // foreground
    this.addSprite(net.net, 'foreground');
    this.addSprite(ball.ball, 'foreground');
  }

  override public function end() {
    super.end();
  }

}
