package newp.display.imports;

import newp.display.frames.*;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import haxe.Json;

class TexturePackerImporter {

  public function new() {}

  public function parse(name:String, path:String) :FrameSet {
    var source = openfl.Assets.getBitmapData(path + '.png');
    var json = openfl.Assets.getText(path + '.json');
    var data:TPData = Json.parse(json);
    var tpFrameData = data.frames;
    var frameSet = parseFrameSet(name, tpFrameData, source);

    return frameSet;
  }

  public function praseIntoGroups(name:String, path:String, exp:EReg = null) :FrameGroups {
    var source = openfl.Assets.getBitmapData(path + '.png');
    var json = openfl.Assets.getText(path + '.json');
    var data:TPData = Json.parse(json);
    var tpFrameData = data.frames;
    var frameSet = parseFrameSet(name, tpFrameData, source);
    var groups = parseGroups(tpFrameData, exp);
    var frameGroups = new FrameGroups(frameSet, groups);

    return frameGroups;
  }

  // Internal
  // ========

  function parseFrameSet(name:String, tpFrameData:Array<TPFrameData>, source:BitmapData) :FrameSet {
    var frames:Array<Frame> = [];
    for (tpFrame in tpFrameData) {
      var frame = convertToFrame(tpFrame);
      frames.push(frame);
    }

    return new FrameSet(name, source, frames);
  }

  function convertToFrame(tpFrame:TPFrameData) :Frame {
    var frame:Frame = new Frame(tpFrame.frame.x, tpFrame.frame.y, tpFrame.sourceSize.w, tpFrame.sourceSize.h);
    if (tpFrame.trimmed) {
      frame.setClip(
        tpFrame.spriteSourceSize.x, 
        tpFrame.spriteSourceSize.y, 
        tpFrame.spriteSourceSize.w, 
        tpFrame.spriteSourceSize.h);
    }
    return frame;
  }

  function parseGroups(tpFrameData:Array<TPFrameData>, exp:EReg = null) {
    var map = new Map<String, Array<Int>>();
    var i = 0;
    exp = (exp == null) ? ~// : exp;
    
    for (frame in tpFrameData) {
      exp.match(frame.filename);
      var groupName = exp.matched(0);
      trace(exp.matched);
      if (!map.exists(groupName)) { 
        map.set(groupName, []); 
      }
      var frames = map.get(groupName);
      frames.push(i++);
    }

    trace('groups', map);

    return map;
  }
}

// TexturePacker TypeDef
// =====================

typedef TPData = {
  var frames:Array<TPFrameData>;
  var meta:Dynamic;
}

typedef TPFrameData = {
  var filename:String;
  var frame:TPRect;
  var rotated:Bool;
  var trimmed:Bool;
  var spriteSourceSize:TPRect;
  var sourceSize:TPSize;
}

typedef TPRect = {
  var x:Int;
  var y:Int;
  var w:Int;
  var h:Int;
}

typedef TPSize = {
  var w:Int;
  var h:Int;
}
