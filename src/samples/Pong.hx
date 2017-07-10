package samples;

import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.display.FPS;
import openfl.display.Sprite;
import newp.collision.shapes.*;
import newp.collision.Collection as ShapeCollection;
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
  var speed:Float = 180;
  var textField:TextField;

  public function new () {
    super();
    this.addFPS();
    this.addPlayField();
    this.addPlayers();
    this.addBall();
    this.resetGame();
  }

  override function init_colliders() {
    this.colliders = new ShapeCollection(Lib.stage.stageWidth, Lib.stage.stageHeight); 
  }

  // Methods

  function addFPS() {
    var fps = new FPS(10, 10, 0x555555);
    this.container.addChild(fps);

    var format = new TextFormat("Verdana", 14, 0x777777, true);
    this.textField = new TextField();
    this.textField.defaultTextFormat = format;
    this.textField.selectable = false;
    this.textField.x = 10;
    this.textField.y = 30;
    this.container.addChild(this.textField);
  } 

  function addPlayField() {
    this.field = new PlayField();
    this.container.addChild(this.field.sprite);
  }

  function addPlayers() {
    trace('addPlayers');
    this.lPlayer = new Player(1, this.field);
    this.rPlayer = new Player(2, this.field);
    this.addEntity(this.lPlayer);
    this.addEntity(this.rPlayer);
    trace('addPlayers -- COMPLETE');
  }

  function addBall() {
    trace('addBall');
    this.ball = new Ball(this.field);
    this.addEntity(this.ball);
    trace('addBall -- COMPLETE');
  }

  function resetGame() {
    trace('resetGame');
    this.lPlayer.resetPosition();
    this.rPlayer.resetPosition();
    this.ball.resetPosition();
    this.ball.startMotion();
    trace('resetGame -- COMPLETE');
  }

  // Update Loop

  public override function update():Void {
    this.update_controllerInput();

    this.lPlayer.update();
    this.rPlayer.update();

    for (e in this.entities) {
      e.update();
      if (e.collider != null) colliders.updateShape(e.collider);
    }

    this.update_collision();

    this.textField.text = Lib.delta;
  } 

  function update_controllerInput() {
    var k = Lib.inputs.keyboard;
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

    if (k.pressed(82)) {
      ball.resetPosition();
      ball.startMotion();
    }
  }


  var data:ShapeCollision = new ShapeCollision();
  function update_collision() {
    // Player Collisions
    if (lPlayer.top < field.top || lPlayer.bottom > field.bottom) { 
      lPlayer.motion.vy *= -1; 
      if (lPlayer.top < field.top) lPlayer.top = field.top;
      if (lPlayer.bottom > field.bottom) lPlayer.bottom = field.bottom;
    }
    if (rPlayer.top < field.top || rPlayer.bottom > field.bottom) { 
      rPlayer.motion.vy *= -1; 
      if (rPlayer.top < field.top) rPlayer.top = field.top;
      if (rPlayer.bottom > field.bottom) rPlayer.bottom = field.bottom;
    }

    // Ball Collisions
    var b = this.ball.collider;
    var walls = this.field.wallColliders;
    var goals = this.field.scoreColliders;

    for (wall in walls) {
      if (b.test(wall, data) != null) {
        this.ball.y -= data.separationY;
        this.ball.motion.vy *= -1.01;
      }
    }

    for (goal in goals) {
      if (b.test(goal, data) != null) {
        this.ball.x -= data.separationX;
        this.ball.motion.vx *= -1;
      }
    }

    if (b.test(lPlayer.collider, data) != null) {
      ball.x -= data.separationX;
      ball.y -= data.separationX;
      ball.motion.vx *= -1;
      ball.motion.vy += lPlayer.motion.vy * 0.2;
    }

    if (b.test(rPlayer.collider, data) != null) {
      ball.x -= data.separationX;
      ball.y -= data.separationX;
      ball.motion.vx *= -1;
      ball.motion.vy += rPlayer.motion.vy * 0.2;
    }
  }
  
}