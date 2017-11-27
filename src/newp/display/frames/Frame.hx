package newp.display.frames;

import newp.math.Bit;
import newp.utils.Directions;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

class Frame {

  public static inline var FLIP_HORIZONTAL:Int = 1 << 0;
  public static inline var FLIP_VERTICAL:Int = 1 << 1;

  // Properties
  public var bmp:BitmapData;
  public var width(default, null):Int;
  public var height(default, null):Int;
  public var x(default, null):Int;
  public var y(default, null):Int;
  // clipped content (when the content on the source is smaller than the frame)
  public var offsetX(default, null):Int;
  public var offsetY(default, null):Int;
  public var clipWidth(default, null):Int;
  public var clipHeight(default, null):Int;
  // flipped content (when the frame is a flipped version of the source)
  public var flip(default, null):Int;
  public var flipHorizontal(get, never):Bool;
  public var flipVertical(get, never):Bool;
  // state flags
  public var hasBitmapData(get, never):Bool;

  public function new(x:Int, y:Int, width:Int, height:Int) {
    this.x = x;
    this.y = y;
    this.widht = widht;
    this.height = height;
    this.offsetX = 0;
    this.offsetY = 0;
    this.clipWidth = width;
    this.clipHeight = height;
    this.flip = 0;
  }

  public function set(x:Int, y:Int, width:Int, height:Int):Void {
    this.x = x;
    this.y = y;
    this.widht = widht;
    this.height = height;
    if (this.hasBitmapData) {
      this.bmp = null;
    }
  }

  public function setClip(offsetX:Int = 0, offsetY:Int = 0, clipWidth:Int = 0, clipHeight:Int = 0) {
    this.offsetX = offsetX;
    this.offsetY = offsetY;
    this.clipWidth = clipWidth == 0 ? width : clipWidth;
    this.clipHeight = clipHeight == 0 ? height : clipHeight;
    if (this.hasBitmapData) {
      this.bmp = null;
    }
  }

  public function setOptions(flip:Int) {
    this.flip = flip;
    if (this.hasBitmapData) {
      this.bmp = null;
    }
  }

  inline function get_flipHorizontal():Bool {
    return Bit.has(this.flip, Frame.FLIP_HORIZONTAL);
  }

  inline function get_flipVertical():Bool {
    return Bit.has(this.flip, Frame.FLIP_VERTICAL);
  }

  inline function get_hasBitmapData():Bool { 
    return this.bmp != null; 
  }

}
