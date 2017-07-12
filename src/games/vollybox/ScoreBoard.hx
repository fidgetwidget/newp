package games.vollybox;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import newp.collision.shapes.Shape;
import newp.utils.Draw;


class ScoreBoard extends Sprite {

  var HEIGHT:Float = 50;
  var WIDTH:Float = 40;

  var player1ScoreSpr:Sprite;
  var player1ScoreTxt:TextField;
  var player2ScoreSpr:Sprite;
  var player2ScoreTxt:TextField;

  public var player1ScoreCollider:Shape;
  public var player2ScoreCollider:Shape;
  
  var game:VollyBox;
  var field(get, never):PlayField;

  public var player1Score(get, set):Int;
  public var player2Score(get, set):Int;

  public function new(game:VollyBox) {
    super();
    this.game = game;
    this.x = field.centerX;
    this.y = field.top - 25;

    this.player1ScoreSpr = this.makeScoreCard(); 
    this.player1ScoreSpr.x = -40;
    this.addChild(this.player1ScoreSpr);

    this.player2ScoreSpr = this.makeScoreCard();
    this.player2ScoreSpr.x = 40;
    this.addChild(this.player2ScoreSpr);
    
    var format = new TextFormat("Verdana", 34, 0xafafaf, true);
    this.player1ScoreTxt = this.makeScoreText(format);
    this.player1ScoreTxt.x = -WIDTH/2;
    this.player1ScoreTxt.y = -HEIGHT;
    this.player1ScoreSpr.addChild(this.player1ScoreTxt);

    this.player2ScoreTxt = this.makeScoreText(format);
    this.player2ScoreTxt.x = -WIDTH/2;
    this.player2ScoreTxt.y = -HEIGHT;
    this.player2ScoreSpr.addChild(this.player2ScoreTxt);

    this.player1ScoreCollider = this.makeScoreCollider(this.player1ScoreSpr);
    this.player2ScoreCollider = this.makeScoreCollider(this.player2ScoreSpr);
  }


  function makeScoreCard():Sprite {
    var spr = new Sprite();
    Draw.start(spr.graphics)
      .beginFill(0x555555, 0.1)
      .drawEllipse(-WIDTH/2 - 1, -HEIGHT - 5, WIDTH+2, 10)
      .endFill()
      .beginFill(0xfff8dc)
      .drawRect(-WIDTH/2, -HEIGHT, WIDTH, HEIGHT)
      .endFill()
      .lineStyle(1, 0xf5deb3)
      .drawRect(-WIDTH/2, -HEIGHT, WIDTH, HEIGHT);
    return spr;
  }

  function makeScoreText(format:TextFormat):TextField {
    var txt = new TextField();
    txt.defaultTextFormat = format;
    txt.autoSize = TextFieldAutoSize.CENTER;
    txt.selectable = false;
    txt.width = WIDTH;
    txt.text = '${0}';
    return txt;
  }

  function makeScoreCollider(sprite:Sprite):Shape {
    var mask = new Sprite();
    Draw.start(mask.graphics)
      .beginFill(0xffffff, 0)
      .drawRect(-WIDTH/2, -30, WIDTH, 30)
      .endFill();
    sprite.addChild(mask);
    return new Shape(mask);
  }


  inline function get_player1Score():Int { return this._player1Score; }
  inline function set_player1Score(val:Int):Int { 
    this._player1Score = val;
    this.player1ScoreTxt.text = '$_player1Score';
    return val; 
  }

  inline function get_player2Score():Int { return this._player2Score; }
  inline function set_player2Score(val:Int):Int { 
    this._player2Score = val;
    this.player2ScoreTxt.text = '$_player1Score';
    return val;
  }

  var _player1Score:Int = 0;
  var _player2Score:Int = 0;

  inline function get_field():PlayField { return this.game.playField; }

}
