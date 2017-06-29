package newp.collision;

import openfl.geom.Rectangle;


class Bounds {

  public static function make(x:Float, y:Float, w:Float, h:Float):Bounds {
    return new Bounds(x, y, x+w, y+h);
  }

  public static function fromRectangle(rect:Rectangle):Bounds {
    return new Bounds(rect.x, rect.y, rect.x+rect.width, rect.y+rect.height);
  }


  public var minX:Float;
  public var minY:Float;
  public var maxX:Float;
  public var maxY:Float;

  public var centerX(get, never):Float;
  public var centerY(get, never):Float;
  public var width(get, never):Float;
  public var halfWidth(get, never):Float;
  public var height(get, never):Float;
  public var halfHeight(get, never):Float;

  public function new(minX:Float = 0, minY:Float = 0, maxX:Float = 0, maxY:Float = 0) {
  	this.minX = minX;
  	this.minY = minY;
  	this.maxX = maxX;
  	this.maxY = maxY;
  }

  public function set(minX:Float, minY:Float, maxX:Float, maxY:Float):Bounds {
  	this.minX = minX;
  	this.minY = minY;
  	this.maxX = maxX;
  	this.maxY = maxY;
  	return this;
  }

  public function copyFromRectangle(rect:Rectangle):Bounds {
  	return this.set(rect.x, rect.y, rect.x+rect.width, rect.y+rect.height);
  }


  inline function get_width():Float { return this.maxX - this.minX; }
  inline function get_halfWidth():Float { return this.width / 2; }
  inline function get_height():Float { return this.maxY - this.minY; }
  inline function get_halfHeight():Float { return this.height / 2; }
  inline function get_centerX():Float { return this.minX + this.halfWidth; }
  inline function get_centerY():Float { return this.minY + this.halfHeight; }

}
