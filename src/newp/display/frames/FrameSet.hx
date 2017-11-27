package newp.display.frames;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

class FrameSet {

  public var name(default, null):String;
  public var frameCount(get, never):Int;

  var source:BitmapData;
  var sourceAlpha:BitmapData;
  var frames:Array<Frame>;

  public function new(name:String, source:BitmapData, frames:Array<Frame> = null, sourceAlpha:BitmapData = null) {
    this.name = name;
    this.source = source;
    this.sourceAlpha = sourceAlpha;
    this.frames = frames == null ? [] : frames;
  }

  public function setSource(source:BitmapData, sourceAlpha:BitmapData = null) :Void {
    this.source = source;
    this.sourceAlpha = sourceAlpha;
    
    for (frame in this.frames) {
      if (frame.hasBitmapData) {
        frame.bmp = null;
      }
    }
  }

  // Frames
  // ======

  public function addFrame(frame:Frame) :Void {
    this.frames.push(frame);
  }

  // If you're making a bunch, use this, and re-use your Rectangle and Point
  public function makeFrame(rect:Rectangle, setBmp:Bool = true) :Frame {
    var frame = FrameFactory.make(this.source, rect, setBmp);
    this.frames.push(frame);
    return frame;
  }

  public function getFrame(index:Int, setBmp:Bool = true) :Frame {
    var frame = this.frames[index];
    if (frame != null && !frame.hasBitmapData && setBmp) {
      this.setFrameBmp(index);
    }
    return frame;
  }

  // Internal
  // ========

  // TODO: support frame transformation (matrix, scale/rotate, etc)
  inline function setFrameBmp(index:Int) :Void {
    var frame       = this.frames[index];
    var bitmapData  = new BitmapData(frame.width, frame.height, true);
    
    this.setRect(frame.x, frame.y, frame.clipWidth, frame.clipHeight);
    this.setPoint(frame.offsetX, frame.offsetY);

    if (sourceAlpha == null) {
      bitmapData.copyPixels(source, _rect, _point);
    } else {
      bitmapData.copyPixels(source, _rect, _point, sourceAlpha, _point, false);
    }

    frame.bmp = bitmapData;
  }

  inline function setRect(x, y, w, h) :Void {
    if (this._rect == null) {
      this._rect = new Rectangle(x, y, w, h);
    } else {
      _rect.x = x;
      _rect.y = y;
      _rect.width = w;
      _rect.height = h;
    }
  }

  inline function setPoint(x, y) :Void {
    if (this._point == null) {
      this._point = new Point(x, y);
    } else {
      _point.x = x;
      _point.y = y;
    }
  }

  var _rect:Rectangle;
  var _point:Point;

  inline function get_frameCount():Int { return this.frames.length; }
  
}
