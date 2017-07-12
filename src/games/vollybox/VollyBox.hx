package games.vollybox;

import openfl.display.Sprite;
import newp.scenes.BasicScene;
import newp.collision.response.ShapeCollision;
import newp.collision.collections.ShapeBins;
import newp.utils.Draw;
import newp.Lib;


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

  var nowServing:Player;

  public function new() {
    super();
    this.drawBackground();

    playField = new PlayField();
    net = new Net(this);
    scoreBoard = new ScoreBoard(this);
    player1 = new Player(1, this);
    player2 = new Player(2, this);
    ball = new Ball(this);

    nowServing = player1;
  }

  function drawBackground() {
    bg = new Sprite();
    Draw.start(bg.graphics)
      .beginFill(0xf5deb3)
      .drawRect(0, 0, Lib.stage.stageWidth, Lib.stage.stageHeight)
      .endFill();
  }

  override function init_colliders() {
    this.colliders = new ShapeBins(Lib.stage.stageWidth, Lib.stage.stageHeight); 
  }

  override public function update() {
    for (e in this.entities) {
      e.update();
    }

    if (this.ball.inService) {
      var side = nowServing.x > playField.centerX ? -1 : 1;
      this.ball.x = nowServing.x + 10 * side;
      this.ball.y = nowServing.y + 4;
    }

    this.update_collisionTests();
    this.update_sort_rendering();
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


  function update_sort_rendering() {
    this.sortedSprties.sort(
      function (a, b):Int { 
        return a.y == b.y ? 0 : a.y < b.y ? -1 : 1; 
      });

    var offset = 0;
    offset = this.setSpriteIndexFor(backgroundSprites, offset);
    offset = this.setSpriteIndexFor(sortedSprties, offset);
    this.setSpriteIndexFor(foregroundSprites, offset);
  }

  inline function setSpriteIndexFor(collection:Array<Sprite>, offset:Int = 0):Int {
    for (i in 0...collection.length) {
      this.setSpriteIndex(collection[i], i+offset);
    }
    return offset + collection.length;
  }

  override public function begin() {
    super.begin();
    // background
    this.addSprite(bg);
    this.addSprite(playField);
    this.addSprite(net.netBottom);
    this.addSprite(net.shadow);

    // sortable
    this.addSprite(scoreBoard);

    this.addEntity(ball);
    this.addEntity(player1);
    this.addEntity(player2);

    // foreground
    this.addSprite(net.net);
    this.addSprite(ball.ball);

    // collections
    this.backgroundSprites.push(bg);
    this.backgroundSprites.push(playField);

    this.sortedSprties.push(scoreBoard);
    this.sortedSprties.push(ball.sprite);
    this.sortedSprties.push(player1.sprite);
    this.sortedSprties.push(player2.sprite);

    this.foregroundSprites.push(net.net);
    this.foregroundSprites.push(ball.ball);

  }

  override public function end() {
    super.end();
  }

}
