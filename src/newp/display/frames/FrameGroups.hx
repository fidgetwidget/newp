package newp.display.frames;

import openfl.display.BitmapData;
import newp.display.animation.FrameAnimation;

class FrameGroups {

  // Factory
  // =======
  
  public static function make(
    name:String, 
    source:BitmapData, 
    frames:Array<Frame> = null, 
    groups:Map<String, Array<Int>>, 
    sourceAlpha:BitmapData = null) 
  {
    var frameSet = new FrameSet(name, source, frames, sourceAlpha);
    var groups = new FrameGroups(frameSet, groups);

    return groups;
  }

  // Instance
  // ========

  public var frameSet(default, null):FrameSet;
  public var groups(default, null):Map<String,Array<Int>>;

  public function new(frameSet:FrameSet, groups:Map<String, Array<Int>> = null) {
    this.frameSet = frameSet;
    this.groups = groups == null ? new Map() : groups;
  }

  public function setFrameSet(frameSet) :Void {
    this.frameSet = frameSet;
  }

  public function setGroups(groups:Map<String, Array<Int>>) :Void {
    for (name in groups.keys()) {
      var frames = groups[name];
      this.groups.set(name, frames);
    }
  }

  // Groups
  // ======

  public function get(name:String) :Array<Int> {
    if (this.groups.exists(name)) {
      return this.groups[name];
    }
    return null;
  }

  public function set(name:String, frames:Array<Int>) :Void {
    this.groups.set(name, frames);
  }

  public function groupFrameCount(name:String) :Int {
    if (this.groups.exists(name)) {
      return this.groups[name].length;
    }
    return 0;
  }

  // Frames
  // ======

  public function getFrame(name:String, index:Int):Frame {
    var group = this.get(name);
    if (group == null) {
      return null;
    }
    var frameSetIndex = group[index];
    return this.frameSet.getFrame(frameSetIndex, true);
  }

  public function getBitmapData(name:String, index:Int):BitmapData {
    var frame = this.getFrame(name, index);
    if (frame == null) {
      return null;
    }
    return frame.bmp;
  }

  // Factory Helper
  // ==============
  
  public function makeFrameAnimation(
    name:String,
    loop:Bool = false, 
    reverse:Bool = false, 
    frameRate:Int = 30,
    animName:String = null) :FrameAnimation 
  {
    var frames = this.get(name);
    if (frames == null) {
      return null;
    }
    if (animName == null) animName = name;
    var frameAnim = new FrameAnimation(animName, frames, loop, reverse, frameRate);
    return frameAnim;
  }

}
