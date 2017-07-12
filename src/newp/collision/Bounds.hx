package newp.collision;

import openfl.geom.Rectangle;


class Bounds {

  public static function fromCenterHalfs(centerX:Float, centerY:Float, halfWidth:Float, halfHeight:Float):Bounds {
    return (new Bounds()).setCenterHalfs(centerX, centerY, halfWidth, halfHeight);
  }

  public static function fromExtents(minX:Float, minY:Float, maxX:Float, maxY:Float):Bounds {
    return (new Bounds()).setExtents(minX, minY, maxX, maxY);
  }

  public static function fromRect(x:Float, y:Float, width:Float, height:Float):Bounds {
    return (new Bounds()).setRect(x, y, width, height);
  }

  public static function fromRectangle(rect:Rectangle):Bounds {
    return (new Bounds()).copyFromRectangle(rect);
  }


  public var minX(get, never):Float;
  public var minY(get, never):Float;
  public var maxX(get, never):Float;
  public var maxY(get, never):Float;

  public var top(get, never):Float;
  public var right(get, never):Float;
  public var bottom(get, never):Float;
  public var left(get, never):Float;

  public var centerX(get, never):Float;
  public var centerY(get, never):Float;

  public var width(get, never):Float;
  public var halfWidth(get, never):Float;

  public var height(get, never):Float;
  public var halfHeight(get, never):Float;

  public function new() { }

  public function setCenterHalfs(centerX:Float, centerY:Float, halfWidth:Float, halfHeight:Float):Bounds {
    this.cx = centerX;
    this.cy = centerY;
    this.hw = halfWidth;
    this.hh = halfHeight;
    return this;
  }

  public function setExtents(minX:Float, minY:Float, maxX:Float, maxY:Float):Bounds {
  	this.hw = (maxX - minX) / 2;
    this.hh = (maxY - minY) / 2;
    this.cx = minX + this.hw;
    this.cy = minY + this.hh;
  	return this;
  }

  public function setRect(x:Float, y:Float, width:Float, height:Float):Bounds {
    this.hw = width / 2;
    this.hh = height / 2;
    this.cx = x + this.hw;
    this.cy = y + this.hh;
    return this;
  }

  public function copyFromRectangle(rect:Rectangle):Bounds {
  	return this.setRect(rect.x, rect.y, rect.width, rect.height);
  }

  inline function get_minX():Float        { return this.cx - this.hw; }
  inline function get_minY():Float        { return this.cy - this.hh; }
  inline function get_maxX():Float        { return this.cx + this.hw; }
  inline function get_maxY():Float        { return this.cy + this.hh; }

  inline function get_top():Float         { return this.cy - this.hh; }
  inline function get_right():Float       { return this.cx + this.hw; }
  inline function get_bottom():Float      { return this.cy + this.hh; }
  inline function get_left():Float        { return this.cx - this.hw; }

  inline function get_width():Float       { return this.hw * 2; }
  inline function get_halfWidth():Float   { return this.hw; }
  inline function get_height():Float      { return this.hh * 2; }
  inline function get_halfHeight():Float  { return this.hh; }
  inline function get_centerX():Float     { return this.cx; }
  inline function get_centerY():Float     { return this.cy; }

  var cx:Float = 0;
  var cy:Float = 0;
  var hw:Float = 0;
  var hh:Float = 0;

}
