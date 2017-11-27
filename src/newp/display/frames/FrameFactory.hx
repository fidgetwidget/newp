package newp.display.frames;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.display.Tileset;

class FrameFactory {

  // This way we can re-use the Rectangle for many Frames
  public static function make(source:BitmapData, rect:Rectangle, setBmp:Bool = true) :Frame {
    var x:Int = Math.floor(rect.x);
    var y:Int = Math.floor(rect.y);
    var width:Int = Math.floor(rect.width);
    var height:Int = Math.floor(rect.height);
    var frame = new Frame(x, y, width, height);

    if (setBmp) {
      frame.bmp = new BitmapData(width, height);
      if (FrameFactory._point == null) FrameFactory._point = new Point();
      frame.bmp.copyPixels(source, rect, FrameFactory._point);
    }

    return frame;
  }
  static var _point:Point;

  // Simple TileSet/Spritesheet Converter
  public static function makeFrameSet(
    name:String,        // the framesets name
    source:BitmapData,  // the framesets source image
    frameWidth:Int,     // the width of each frame/tile
    frameHeight:Int,    // the height of each frame/tile
    // Optional args
    marginX:Int = 0,    // space around the source image
    marginY:Int = 0,    // -----------------------------
    spacingX:Int = 0,   // space between each frame/tile
    spacingY:Int = 0,   // -----------------------------
    frameCount:Null<Int> = null,   // max frames to create
    sourceAlpha:BitmapData = null) // alpha image for frameSet
  {
    var frameSet = new FrameSet(name, source, null, sourceAlpha);
    var rect = new Rectangle(0, 0, frameWidth, frameHeight);
    var count = 0;
    if (frameCount == null) frameCount = source.width * source.height; // max support 1px x 1px frames
    // cut out the frames from the source image using the margins and spacing
    var x = marginX;
    var y = marginY;
    while (y < source.height + marginY && count < frameCount) {
      while (x < source.width + marginX && count < frameCount) {
        rect.x = x;
        rect.y = y;
        frameSet.makeFrame(rect, true);
        count++;
        x += frameWidth + spacingX;
      }
      x = marginX;
      y += frameHeight + spacingY;
    }
    return frameSet;
  }

  // Create a Tileset from the FrameSet's rectangles
  public static function frameSetIntoTileSet(source:BitmapData, frameSet:FrameSet) :Tileset {
    var rects:Array<Rectangle> = [];
    for (i in 0...frameSet.frameCount) {
      var frame = frameSet.getFrame(i, false);
      var rect = new Rectangle(frame.x, frame.y, frame.width, frame.height);
      rects.push(rect);
    }
    return new Tileset(source, rects);
  }
  
}
