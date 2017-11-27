package newp.display.animation;

// NOTE: 
//  This doesn't track what the Frame Ids belong to...
//  So you could use the same FrameAnimation for multiple
//  FrameSets if they match up. Like Pallet Swaps.

class FrameAnimation extends Animation {

  public var frameId(get, never):Int;
  public var frameCount(default, null):Int;

  var frames:Array<Int>;
  var current:Int;

  public function new(name:String, frames:Array<Int>, loops:Bool = false, reverse:Bool = false, frameRate:Int = 30) {
    super(name, loops, reverse, frameRate);
    this.frames = frames;
    this.frameCount = this.frames.length;
    this.current = 0;
  }

  public function update() :Void {
    if (!this.playing) return;
    this.delta += Lib.delta;
    if (this.delta > this.duration) {
      this.update_frame();
    }
  }

  override function next() :Void {
    this.current += this.inReverse ? -1 : 1;
  }

  override function flip() :Void {
    this.current = this.frameCount - 2; // because we were just at frameCount - 1
    super.flip();
  }

  override function loop() :Void {
    this.current = 1; // because we were just at 0
    super.loop();
  }

  override public function stop() :Void {
    this.inReverse = this.reverse && !this.loops;
    this.current = this.inReverse ? this.frameCount - 1 : 0;
    super.stop();
  }

  // Properties
  inline function get_frameId():Int { 
    return this.frames[this.current]; 
  }

  override function get_percentComplete():Float { return this.current + 1 / (this.frameCount == 0 ? 1 : this.frameCount); }

}
