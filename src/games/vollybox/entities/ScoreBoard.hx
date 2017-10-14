package games.vollybox.entities;

import games.vollybox.*;

import newp.components.*;
import newp.collision.shapes.Shape;
import newp.utils.Draw;
import newp.Entity;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;


class ScoreBoard extends Entity {

  var HEIGHT:Float = 50;
  var WIDTH:Float = 40;

  public var player1Score(get, set):Int;
  public var player2Score(get, set):Int;

  var p1ScoreSpr:Sprite;
  var p1ScoreMask:Sprite;
  var p1ScoreTF:TextField;
  var p1ScoreShape:Shape;

  var p2ScoreSpr:Sprite;
  var p2ScoreMask:Sprite;
  var p2ScoreTF:TextField;
  var p2ScoreShape:Shape;
  
  var game:VollyBox;
  var field(get, never):Field;

  
  public function new(game:VollyBox) {
    super();
    this.game = game;

    this.makeSprites();
    this.makeTextFields();
    this.makeColliders();

    this.x = field.centerX;
    this.y = field.top - 25;  
  }

  // Init
  // ====

  function makeSprites() {
    var parent = cast(this.body, Sprite);

    this.p1ScoreSpr = new Sprite();
    this.p2ScoreSpr = new Sprite();

    this.p1ScoreSpr.x = -40;
    this.p2ScoreSpr.x = 40;
    
    this.drawScoreCard(this.p1ScoreSpr.graphics);
    this.drawScoreCard(this.p2ScoreSpr.graphics);


    this.p1ScoreMask = new Sprite();
    this.p2ScoreMask = new Sprite();

    this.drawCollisionMask(this.p1ScoreMask.graphics);
    this.drawCollisionMask(this.p2ScoreMask.graphics);

    parent.addChild(this.p1ScoreSpr);
    parent.addChild(this.p2ScoreSpr);

    this.p1ScoreSpr.addChild(p1ScoreMask);
    this.p2ScoreSpr.addChild(p2ScoreMask);

    this.addComponent(new SpriteComponent(parent));
  }

  inline function drawScoreCard(g) {
    Draw.start(g)
      .beginFill(0x555555, 0.1)
      .drawEllipse(-WIDTH/2 - 1, -5, WIDTH+2, 10)
      .endFill()
      .beginFill(VollyBox.SAND)
      .drawRect(-WIDTH/2, -HEIGHT, WIDTH, HEIGHT)
      .endFill()
      .lineStyle(1, VollyBox.DARK_SAND)
      .drawRect(-WIDTH/2, -HEIGHT, WIDTH, HEIGHT);
  }

  function makeTextFields() {
    var format = new TextFormat("Verdana", 34, 0xafafaf, true);

    this.p1ScoreTF = this.createScoreTextField(format);
    this.p1ScoreTF.x = -WIDTH/2;
    this.p1ScoreTF.y = -HEIGHT;
    this.p1ScoreSpr.addChild(this.p1ScoreTF);

    this.p2ScoreTF = this.createScoreTextField(format);
    this.p2ScoreTF.x = -WIDTH/2;
    this.p2ScoreTF.y = -HEIGHT;
    this.p2ScoreSpr.addChild(this.p2ScoreTF);
  }

  inline function createScoreTextField(format:TextFormat):TextField {
    var txt = new TextField();
    txt.defaultTextFormat = format;
    txt.autoSize = TextFieldAutoSize.CENTER;
    txt.selectable = false;
    txt.width = WIDTH;
    txt.text = '${0}';
    return txt;
  }


  function makeColliders() {
    this.p1ScoreShape = new Shape(this.p1ScoreMask);
    this.p2ScoreShape = new Shape(this.p2ScoreMask);
    this.addComponent(new ShapeComponent(this.p1ScoreShape, ['score']));
    this.addComponent(new ShapeComponent(this.p2ScoreShape, ['score']));
  }

  inline function drawCollisionMask(g) {
    Draw.start(g)
      .beginFill(0xff0000, 0)
      .drawRect(-WIDTH/2, -30, WIDTH, 30)
      .endFill();
  }


  inline function get_player1Score():Int { return this._player1Score; }
  inline function set_player1Score(val:Int):Int { 
    this._player1Score = val;
    this.p1ScoreTF.text = '$_player1Score';
    return val; 
  }

  inline function get_player2Score():Int { return this._player2Score; }
  inline function set_player2Score(val:Int):Int { 
    this._player2Score = val;
    this.p2ScoreTF.text = '$_player2Score';
    return val;
  }

  var _player1Score:Int = 0;
  var _player2Score:Int = 0;

  inline function get_field():Field { return this.game.field; }

}
