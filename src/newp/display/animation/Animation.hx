package newp.display.animation;

class Animation {

  // Read Only
  public var name (default, null):String;
  public var percentComplete (get, never):Float;
  public var loops :Bool;
  public var reverse :Bool;
  public var frameRate :Int;

  public var onLoop:Animation->Int->Void;
  public var onReverse:Animation->Void;
  public var onComplete:Animation->Void;

  var playing:Bool;
  var inReverse:Bool;
  var loopCount:Int;
  var duration:Float;
  var delta:Float;

  public function new(name:String, loops:Bool = false, reverse:Bool = false, frameRate:Int = 30) {
    this.name = name;
    this.loops = loops;
    this.reverse = reverse;
    this.frameRate = frameRate;

    this.inReverse = this.reverse && !this.loops;
    this.duration = 1/this.frameRate;
    this.loopCount = 0;
    this.playing = false;
    this.delta = 0;
  }

  public function play() :Void { 
    this.playing = true; 
  }

  public function pause() :Void { 
    this.playing = false; 
  }

  public function update():Void {
    if (!this.playing) return;
    this.delta += Lib.delta;
    if (this.delta > this.duration) {
      this.next();
    }
  }

  function next():Void {
    // trace('Animation.next');
    this.delta -= this.duration;

    // Are we at some kind of frame limit
    if ((this.percentComplete > 1 && !this.inReverse) ||
        (this.percentComplete <= 0 && this.inReverse))
    {
      // trace(this.percentComplete);

      // Are we going to flip direction
      if (this.loops && this.reverse && !this.inReverse) {
        this.flip();
        return;
      } 

      // Are we going to loop
      if (this.loops) {
        this.loop();
        return;
      }

      // Otherwise, we're done here...
      this.complete();
    }
  }

  function flip() :Void {
    this.inReverse = !this.inReverse;
    if (this.onReverse != null) this.onReverse(this);
  }

  function loop() :Void {
    // trace('Animation.loop');
    // If we were reversed
    if (this.reverse && this.inReverse) this.inReverse = false;
    this.loopCount++;
    if (this.onLoop != null) this.onLoop(this, this.loopCount);
  }

  function complete() :Void {
    // trace('Animation.complete');
    this.stop();
    if (this.onComplete != null) this.onComplete(this);
  }

  public function stop() :Void {
    this.delta = 0;
    this.loopCount = 0;
    this.playing = false;
  }

  function get_percentComplete():Float { return 0; }

}
