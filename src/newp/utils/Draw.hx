package newp.utils;

import openfl.display.Graphics;

// A Drawing helper that makes writing graphics draw functions cleaner
// eg. Draw.start(graphics).lineStyle(1, 0xffffff).moveTo(0, 0).lineTo(100, 100);
class Draw {
  // TODO: impliment the rest of the Graphics features
  
  static var instance:Draw = null;

  public static function start(graphics:Graphics):Draw {
    return Draw.getInstance(graphics).lineStyle(0, 0, 0).endFill();
  }

  static function getInstance(graphics:Graphics):Draw {
    if (Draw.instance == null) {
      Draw.instance = new Draw();
    }
    Draw.instance.g = graphics;
    return Draw.instance;
  }

  var g:Graphics;
  var x:Float;
  var y:Float;

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
    this.x = x; this.y = y;
    g.moveTo(x, y);
    return this;
  }

  public function lineTo(x, y):Draw {
    this.x = x; this.y = y;
    g.lineTo(x, y);
    return this;
  }

  public function drawLine(arr:Array<Float>, ?x:Float, ?y:Float):Draw {
    var ix = x == null ? this.x : x;
    var iy = y == null ? this.y : y;
    var i = 0;
    g.moveTo(ix, iy);
    while (i < arr.length) {
      var dx = arr[i++];
      var dy = arr[i++];
      g.lineTo(ix += dx, iy += dy);
    }
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

  public function drawEllipse(x, y, w, h):Draw {
    g.drawEllipse(x, y, w, h);
    return this;
  }

  public function clear():Draw {
    g.clear();
    return this;
  }

}
