package games.vollybox;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import newp.utils.Draw;


class ScoreBoard extends Sprite {

  var player1ScoreSpr:Sprite;
  var player1ScoreTxt:TextField;
  var player2ScoreSpr:Sprite;
  var player2ScoreTxt:TextField;
  
  var field:PlayField;

  public var player1Score(get, set):Int;
  public var player2Score(get, set):Int;

  public function new(field:PlayField) {
    super();
    this.field = field;

    this.player1ScoreSpr = this.makeScoreCard(); 
    this.player1ScoreSpr.x = field.centerX - 60;
    this.player1ScoreSpr.y = field.top - 75;
    this.addChild(this.player1ScoreSpr);

    this.player2ScoreSpr = this.makeScoreCard();
    this.player2ScoreSpr.x = field.centerX + 20;
    this.player2ScoreSpr.y = field.top - 75;
    this.addChild(this.player2ScoreSpr);
    
    var format = new TextFormat("Verdana", 34, 0xafafaf, true);
    this.player1ScoreTxt = this.makeScoreText(format);
    this.player1ScoreTxt.x = 0;
    this.player1ScoreTxt.y = 0;
    this.player1ScoreSpr.addChild(this.player1ScoreTxt);

    this.player2ScoreTxt = this.makeScoreText(format);
    this.player2ScoreTxt.x = 0;
    this.player2ScoreTxt.y = 0;
    this.player2ScoreSpr.addChild(this.player2ScoreTxt);
  }


  inline function makeScoreCard():Sprite {
    var spr = new Sprite();
    Draw.start(spr.graphics)
      .beginFill(0x555555, 0.1)
      .drawEllipse(-2, 45, 43, 10)
      .endFill()
      .beginFill(0xfff8dc)
      .drawRect(0, 0, 40, 50)
      .endFill()
      .lineStyle(1, 0xf5deb3)
      .drawRect(0, 0, 40, 50);
    return spr;
  }

  inline function makeScoreText(format:TextFormat):TextField {
    var txt = new TextField();
    txt.defaultTextFormat = format;
    txt.autoSize = TextFieldAutoSize.CENTER;
    txt.selectable = false;
    txt.width = 40;
    txt.text = '${0}';
    return txt;
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

}
