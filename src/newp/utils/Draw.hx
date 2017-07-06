package newp.utils;

import openfl.display.Graphics;

// TODO: impliment the rest of the Graphics features

class Draw {

  static var instance:Draw = null;

  public static function start(graphics:Graphics):Draw {
    return Draw.getInstance(graphics);
  }

  static function getInstance(graphics:Graphics):Draw {
    if (Draw.instance == null) {
      Draw.instance = new Draw();
    }
    Draw.instance.g = graphics;
    return Draw.instance;
  }

  var g:Graphics;

  function new() { }

  public function lineStyle(thickness:Int, color:Int, alpha:Float = 1):Draw { 
    g.lineStyle(thickness, color, alpha); 
    return this; 
  }

  public function beginFill(color:Int, alpha:Float = 1):Draw {
    g.beginFill(color, alpha);
    return this;
  }

  public function endFill():Draw {
    g.endFill();
    return this;
  }

  public function moveTo(x, y):Draw {
    g.moveTo(x, y);
    return this;
  }

  public function lineTo(x, y):Draw {
    g.lineTo(x, y);
    return this;
  }

  public function drawRect(x, y, w, h):Draw {
    g.drawRect(x, y, w, h);
    return this;
  }

  public function drawCircle(x, y, r):Draw {
    g.drawCircle(x, y, r);
    return this;
  }

  public function clear():Draw {
    g.clear();
    return this;
  }

}
