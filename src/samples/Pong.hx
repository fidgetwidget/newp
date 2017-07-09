package samples;

import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.display.FPS;
import openfl.display.Sprite;
import newp.collision.shapes.*;
import newp.collision.ShapeCollision;
import newp.scenes.BasicScene;
import newp.math.Dice;
import newp.utils.Draw;
import newp.Lib;
import samples.pong.*;

class Pong extends BasicScene {
  
  var field:PlayField;
  var ball:Ball;
  var lPlayer:Player;
  var rPlayer:Player;

  public function new () {
    super();
    this.addFPS();
    this.addPlayField();
    this.addPlayers();
    this.addBall();
    this.resetGame();
  }

  // Methods

  function addFPS() {
    var fps = new FPS(10, 10, 0x555555);
    this.container.addChild(fps);
  } 

  function addPlayField() {
    trace('addPlayField');
    this.field = new PlayField();
    this.container.addChild(this.field.sprite);
    trace('addPlayField --- COMPLETE');
  }

  function addPlayers() {
    trace('addPlayers');
    this.lPlayer = new Player(1);
    this.rPlayer = new Player(2);
    this.addSprite(this.lPlayer.sprite);
    this.addSprite(this.rPlayer.sprite);
    trace('addPlayers --- COMPLETE');
  }

  function addBall() {
    trace('addBall');
    this.ball = new Ball();
    this.addEntity(this.ball);
    // this.addSprite(this.ball.sprite);
    trace('addBall --- COMPLETE');
  }

  function resetGame() {
    this.ball.resetPosition();
    this.ball.startMotion();
  }

  // Update Loop

  public override function update():Void {
    this.update_controllerInput();
    
    this.lPlayer.update();
    this.rPlayer.update();

    for (e in this.entities) {
      e.update();
    }

    this.update_collision();
  } 

  function update_controllerInput() {
    var k = Lib.inputs.keyboard;
    var speed = 10;
    if (k.down(87)) {
      lPlayer.motion.ay = -speed;
    } else if (k.down(83)) {
      lPlayer.motion.ay = speed;
    } else {
      lPlayer.motion.ay = 0;
    }

    if (k.down(38)) {
      rPlayer.motion.ay = -speed;
    } else if (k.down(40)) {
      rPlayer.motion.ay = speed;
    } else {
      rPlayer.motion.ay = 0;
    }
  }


  var data:ShapeCollision = new ShapeCollision();
  function update_collision() {
    // Player Collisions
    if (lPlayer.top < 20 || lPlayer.bottom > Lib.stage.stageHeight - 20) { 
      lPlayer.motion.vy *= -1; 
    }
    if (rPlayer.top < 20 || rPlayer.bottom > Lib.stage.stageHeight - 20) { 
      rPlayer.motion.vy *= -1; 
    }

    // Ball Collisions
    var b = this.ball.collider;
    var walls = this.field.wallColliders;
    var goals = this.field.scoreColliders;

    for (wall in walls) {
      if (b.test(wall, data) != null) {
        this.ball.motion.vy *= -1.01;
      }
    }

    for (goal in goals) {
      if (b.test(goal, data) != null) {
        this.ball.motion.vx *= -1;
      }
    }

    if (b.test(lPlayer.collider, data) != null) {
      ball.motion.vx *= -1;
      ball.motion.vy += lPlayer.motion.vy * 0.2;
    }

    if (b.test(rPlayer.collider, data) != null) {
      ball.motion.vx *= -1;
      ball.motion.vy += rPlayer.motion.vy * 0.2;
    }
  }
  
  
}