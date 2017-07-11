package games.vollybox;

import openfl.display.Sprite;
import newp.scenes.BasicScene;
import newp.collision.ShapeCollision;
import newp.collision.Collection as ShapeCollection;
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

  var nowServing:Player;

  public function new() {
    super();
    this.drawBackground();

    playField = new PlayField();
    net = new Net(playField);
    scoreBoard = new ScoreBoard(playField);
    player1 = new Player(1, playField);
    player2 = new Player(2, playField);
    ball = new Ball(playField);

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
    this.colliders = new ShapeCollection(Lib.stage.stageWidth, Lib.stage.stageHeight); 
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
  }

  function update_collisionTests() {
    this._player_net_collision(this.player1);
    this._player_net_collision(this.player2);
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
  var collisionData:ShapeCollision = new ShapeCollision();


  override public function begin() {
    super.begin();
    this.addSprite(bg);
    this.addSprite(playField);
    this.addSprite(scoreBoard);
    this.addSprite(net.netBottom);
    this.addSprite(net.shadow);
    this.addEntity(ball);
    this.addEntity(player1);
    this.addEntity(player2);
    this.addSprite(net.net);
    this.addSprite(ball.ball);
  }

  override public function end() {
    super.end();
  }

}
