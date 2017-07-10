package games.tennis;

import openfl.display.Sprite;
import newp.scenes.BasicScene;
import newp.collision.Collection as ShapeCollection;
import newp.utils.Draw;
import newp.Lib;


class Tennis extends BasicScene {

  public var player1:Player;
  public var player2:Player;

  public var ball:Ball;

  public var scoreBoard:ScoreBoard;
  public var playField:PlayField;

  public function new() {
    super();
    
    playField = new PlayField();
    scoreBoard = new ScoreBoard(playField);
    player1 = new Player(1, playField);
    player2 = new Player(2, playField);
    ball = new Ball(playField);
  }

  override function init_colliders() {
    this.colliders = new ShapeCollection(Lib.stage.stageWidth, Lib.stage.stageHeight); 
  }

  override public function update() {
    for (e in this.entities) {
      e.update();
    }
  }


  override public function begin() {
    super.begin();
    this.addSprite(playField);
    this.addSprite(scoreBoard);
    this.addEntity(player1);
    this.addEntity(player2);
    this.addEntity(ball);
  }

  override public function end() {
    super.end();
    this.removeSprite(playField);
    this.removeSprite(scoreBoard);
    this.removeEntity(player1);
    this.removeEntity(player2);
    this.removeEntity(ball);
  }

}
